// ignore_for_file: type_literal_in_constant_pattern

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tetra_stats/data_objects/tetra_stats.dart';
import 'package:tetra_stats/data_objects/tetrio_multiplayer_replay.dart';
import 'package:tetra_stats/main.dart' show packageInfo;
import 'package:flutter/foundation.dart';
import 'package:tetra_stats/services/custom_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:csv/csv.dart';

const String dbName = "TetraStats.db";
const String tetrioUsersTable = "tetrioUsers";
const String tetrioUsersToTrackTable = "tetrioUsersToTrack";
const String tetraLeagueMatchesTable = "tetrioAlphaLeagueMathces";
const String tetrioTLReplayStatsTable = "tetrioTLReplayStats";
const String tetrioLeagueTable = "tetrioLeague";
const String idCol = "id";
const String replayID = "replayId";
const String nickCol = "nickname";
const String timestamp = "timestamp";
const String endContext1 = "endContext1";
const String endContext2 = "endContext2";
const String statesCol = "jsonStates";
const String player1id = "player1id";
const String player2id = "player2id";
/// Table, that store players data, their stats at some moments of time
const String createTetrioUsersTable = '''
        CREATE TABLE IF NOT EXISTS "tetrioUsers" (
          "id"	TEXT UNIQUE,
          "nickname"	TEXT,
          "jsonStates"	TEXT,
          PRIMARY KEY("id")
        );''';
/// Table, that store ids of players we need keep track of
const String createTetrioUsersToTrack = '''
        CREATE TABLE IF NOT EXISTS "tetrioUsersToTrack" (
          "id"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("ID")
        )
''';
/// Table of Tetra League matches. Each match corresponds with their own players and end contexts
const String createTetrioTLRecordsTable = '''
        CREATE TABLE IF NOT EXISTS "tetrioAlphaLeagueMathces" (
          "id"	TEXT NOT NULL UNIQUE,
          "replayId"	TEXT,
          "player1id"	TEXT,
          "player2id"	TEXT,
          "timestamp"	TEXT,
          "endContext1"	TEXT,
          "endContext2"	TEXT,
          PRIMARY KEY("id")
        )
''';
/// Table, that contains results of replay analysis in order to not analyze it more, than one time.
const String createTetrioTLReplayStats = '''
        CREATE TABLE IF NOT EXISTS "tetrioTLReplayStats" (
          "id"	TEXT NOT NULL,
          "data"	TEXT NOT NULL,
          "freyhoe"	TEXT,
          PRIMARY KEY("id")
        )
''';
const String createTetrioLeagueTable = '''
        CREATE TABLE IF NOT EXISTS "tetrioLeague" (
          "id"	TEXT NOT NULL,
          "gamesplayed"	INTEGER NOT NULL DEFAULT 0,
          "gameswon"	INTEGER NOT NULL DEFAULT 0,
          "tr"	REAL,
          "glicko"	REAL,
          "rd"	REAL,
          "gxe"	REAL,
          "rank"	TEXT NOT NULL DEFAULT 'z',
          "bestrank"	TEXT NOT NULL DEFAULT 'z',
          "apm"	REAL,
          "pps"	REAL,
          "vs"	REAL,
          "decaying"	INTEGER NOT NULL DEFAULT 0,
          "standing"	INTEGER NOT NULL DEFAULT -1,
          "standing_local"	INTEGER NOT NULL DEFAULT -1,
          "percentile"	REAL NOT NULL,
          "prev_rank"	TEXT,
          "prev_at"	INTEGER NOT NULL DEFAULT -1,
          "next_rank"	TEXT,
          "next_at"	INTEGER NOT NULL DEFAULT -1,
          "percentile_rank"	TEXT NOT NULL DEFAULT 'z',
          "season"	INTEGER NOT NULL DEFAULT 1,
	        PRIMARY KEY("id")
        )
''';

class CacheController {
  late Map<String, dynamic> _cache;
  late Map<String, String> _nicknames;

  CacheController.init(){
    _cache = {};
    _nicknames = {};
  }

  String _getObjectId(dynamic object){
    switch (object.runtimeType){
      case TetrioPlayer:
        object as TetrioPlayer;
        _nicknames[object.username] = object.userId;
        return object.userId;
      case TetrioPlayersLeaderboard:
        return object.runtimeType.toString()+object.type;
      case Cutoffs:
        return object.runtimeType.toString();
      case TetrioPlayerFromLeaderboard: // i may be a little stupid
        return "${object.runtimeType}topone";
      case SingleplayerStream:
        return object.type+object.userId;
      default:
        return object.runtimeType.toString()+object.id;
    }
  }

  void store(dynamic object, int cachedUntil) async {
    String key = _getObjectId(object) + cachedUntil.toString();
    _cache[key] = object;
  }

  dynamic get(String id, Type datatype){
    if (_cache.isEmpty) return null;
    MapEntry<String, dynamic>? objectEntry;
    try{
      switch (datatype){
        case TetrioPlayer:
          objectEntry = id.length <= 16 ? _cache.entries.firstWhere((element) => element.key.startsWith(_nicknames[id]??"huh?")) : _cache.entries.firstWhere((element) => element.key.startsWith(id));
          if (id.length <= 16) id = _nicknames[id]??"huh?";
          break;
        case SingleplayerStream:
          objectEntry = _cache.entries.firstWhere((element) => element.key.startsWith(id));
        default:
          objectEntry = _cache.entries.firstWhere((element) => element.key.startsWith(datatype.toString()+id));
          id = datatype.toString()+id;
          break;
      }
    } on StateError{
      return null;
    }     
    if (int.parse(objectEntry.key.substring(id.length)) <= DateTime.now().millisecondsSinceEpoch){
      _cache.remove(objectEntry.key);
      return null;
    }else{
      return objectEntry.value;
    }
  }

  void removeOld() async {
    _cache.removeWhere((key, value) => int.parse(key.substring(_getObjectId(value).length)) <= DateTime.now().millisecondsSinceEpoch);
  }

  void reset(){
    _cache.clear();
  }
}

class TetrioService extends DB {
  final Map<String, String> _players = {};
  final _cache = CacheController.init(); // I'm trying to send as less requests, as possible, so i'm caching the results of those requests.
  final Map<String, PlayerLeaderboardPosition> _lbPositions = {}; // separate one because attached to the leaderboard
  /// Thing, that sends every request to the API endpoints
  final client = kDebugMode ? UserAgentClient("Kagari-chan loves osk (Tetra Stats dev build)", http.Client()) : UserAgentClient("Tetra Stats v${packageInfo.version} (dm @dan63047 if someone abuse that software)", http.Client());
  /// We should have only one instanse of this service
  static final TetrioService _shared = TetrioService._sharedInstance();
  factory TetrioService() => _shared;
  late final StreamController<Map<String, String>> _tetrioStreamController;
  TetrioService._sharedInstance() {
    _tetrioStreamController = StreamController<Map<String, String>>.broadcast(onListen: () {
      _tetrioStreamController.sink.add(_players);
    });
  }

  @override
  Future<void> open() async {
    await super.open();
    await _loadPlayers();
  }

  Stream<Map<String, String>> get allPlayers => _tetrioStreamController.stream;

  /// Loading and sending to the stream everyone.
  Future<void> _loadPlayers() async {
    final allPlayers = await getAllPlayerToTrack();
    for (var element in allPlayers) {
      _players[element] = await getNicknameByID(element);
    }
    developer.log("_loadPlayers: $_players", name: "services/tetrio_crud");
    _tetrioStreamController.add(_players);
  }

  /// Removes player entry from tetrioUsersTable with given [id].
  /// Can throw an error is player with this id is not exist
  Future<void> deletePlayer(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final deletedPlayer = await db.delete(tetrioUsersTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (deletedPlayer != 1) {
      throw CouldNotDeletePlayer();
    } else {
      _players.removeWhere((key, value) => key == id);
      _tetrioStreamController.add(_players);
    }
    await db.delete(tetrioLeagueTable, where: "id LIKE ?", whereArgs: ["$id%"]);
  }

  /// Gets nickname from database or requests it from API if missing.
  /// Throws an exception if user not exist or request failed.
  Future<String> getNicknameByID(String id) async {
    if (id.length <= 16) return id; // nicknames can be up to 16 symbols in length, that's how i'm differentiate nickname from ids
    try{
      await ensureDbIsOpen();
      final db = getDatabaseOrThrow();
      var request = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
      return request.first[nickCol] as String;
    } catch (e){
      return await fetchPlayer(id).then((value) => value.username);
    }
  }

  /// Puts results of replay analysis into a tetrioTLReplayStatsTable
  Future<void> saveReplayStats(ReplayData replay) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    db.insert(tetrioTLReplayStatsTable, {idCol: replay.id, "data": jsonEncode(replay.toJson())});
  }

  void cacheLeaderboardPositions(String userID, PlayerLeaderboardPosition positions){
    _lbPositions[userID] = positions;
  }

  PlayerLeaderboardPosition? getCachedLeaderboardPositions(String userID){
    return _lbPositions[userID];
  }

  void cacheRoutine(){
    _cache.removeOld();
  }

  /// Downloads replay from inoue (szy API). Requiers [replayID]. If request have
  /// different from 200 statusCode, it will throw an excepction. Returns list, that contains same replay
  /// as string and as binary.
  Future<RawReplay> szyGetReplay(String replayID) async {
    // Trying to get it from cache first
    RawReplay? cached = _cache.get(replayID, RawReplay);
    if (cached != null) return cached;

    // If failed, trying to obtain replay from download directory
    if (!kIsWeb){ // can't obtain download directory on web
      var downloadPath = await getDownloadsDirectory();
      downloadPath ??= Platform.isAndroid ? Directory("/storage/emulated/0/Download") : await getApplicationDocumentsDirectory();
      var replayFile = File("${downloadPath.path}/$replayID.ttrm");
      if (replayFile.existsSync()) return RawReplay(replayID, replayFile.readAsBytesSync(), replayFile.readAsStringSync());
    }

    // If failed, actually trying to retrieve
    Uri url;
    if (kIsWeb) { // Web version sends every request through my php script at the same domain, where Tetra Stats located because of CORS
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioReplay", "replayid": replayID});
    } else { // Actually going to hit inoue
      url = Uri.https('inoue.szy.lol', '/api/replay/$replayID');
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          developer.log("szyDownload: Replay $replayID downloaded", name: "services/tetrio_crud");
          RawReplay replay = RawReplay(replayID, response.bodyBytes, response.body);
          DateTime now = DateTime.now();
          _cache.store(replay, now.millisecondsSinceEpoch + 3600000);
          return replay;
        // if not 200 - throw a unique for each code exception  
        case 404:
          throw SzyNotFound();
        case 403:
          throw SzyForbidden();
        case 429:
          throw SzyTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw SzyInternalProblem();
        default:
          developer.log("szyDownload: Failed to download a replay $replayID", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) { // If local http client fails
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri); // just assuming, that our end user don't have acess to the internet
    }
  }

  /// Saves replay with given [replayID] to Download or Documents directory as [replayID].ttrm. Throws an exception,
  /// if file with name [replayID].ttrm exist, if it fails to get replay or unable to save replay
  Future<String> saveReplay(String replayID) async {
    var downloadPath = await getDownloadsDirectory();
    downloadPath ??= Platform.isAndroid ? Directory("/storage/emulated/0/Download") : await getApplicationDocumentsDirectory();
    var replayFile = File("${downloadPath.path}/$replayID.ttrm");
    if (replayFile.existsSync()) throw TetrioReplayAlreadyExist();
    RawReplay replay = await szyGetReplay(replayID);
    await replayFile.writeAsBytes(replay.asBytes);
    return replayFile.path;
  }

  /// Gets replay with given [replayID] and returns some stats about it. If [isAvailable] is false
  /// or unable to get replay, it will throw an exception
  Future<ReplayData> analyzeReplay(String replayID, bool isAvailable) async{
    // trying retirieve existing stats from DB first
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioTLReplayStatsTable, where: '$idCol = ?', whereArgs: [replayID]);
    if (results.isNotEmpty) return ReplayData.fromJson(jsonDecode(results.first["data"].toString())); // if success
    if (!isAvailable) throw ReplayNotAvalable(); // if replay too old

    // otherwise, actually going to download a replay and analyze it
    String replay = (await szyGetReplay(replayID)).asString;
    Map<String, dynamic> toAnalyze = jsonDecode(replay);
    ReplayData data = ReplayData.fromJson(toAnalyze);
    saveReplayStats(data); // saving to DB for later
    return data;
  }

  /// Retrieves avaliable Tetra League matches from Tetra Channel api. Returns stream object (fake stream).
  /// Throws an exception if fails to retrieve.
  Future<SingleplayerStream> fetchStream(String userID, String stream) async {
    SingleplayerStream? cached = _cache.get(stream+userID, SingleplayerStream);
    if (cached != null) return cached;
    
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "singleplayerStream", "user": userID.toLowerCase().trim(), "stream": stream});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/${userID.toLowerCase().trim()}/records/$stream');
    }
    try {
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          if (jsonDecode(response.body)['success']) {
            SingleplayerStream records = SingleplayerStream.fromJson(jsonDecode(response.body)['data']['entries'], userID, stream);
            _cache.store(records, jsonDecode(response.body)['cache']['cached_until']);
            developer.log("fetchSingleplayerStream: $stream $userID stream retrieved and cached", name: "services/tetrio_crud");
            return records;
          } else {
            developer.log("fetchSingleplayerStream: User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchSingleplayerStream: Failed to fetch stream $stream $userID", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Gets and returns Top TR for a player with given [id]. May return null if player top tr is unknown
  /// or api is unavaliable (404). May throw an exception, if something else happens.
  Future<TopTr?> fetchTopTR(String id) async {
    // Trying to get it from cache first
    TopTr? cached = _cache.get(id, TopTr);
    if (cached != null) return cached;

    Uri url;
    if (kIsWeb) { // Web version sends every request through my php script at the same domain, where Tetra Stats located because of CORS
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "PeakTR", "user": id});
    } else { // Actually going to hit p1nkl0bst3r api
      url = Uri.https('api.p1nkl0bst3r.xyz', 'toptr/$id');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200: // ok - return the value
          TopTr result = TopTr(id, double.tryParse(response.body));
          _cache.store(result, DateTime.now().millisecondsSinceEpoch + 300000);
          return result;
        case 404: // not found - return null
          TopTr result = TopTr(id, null);
          developer.log("fetchTopTR: Probably, player doesn't have top TR", name: "services/tetrio_crud", error: response.statusCode);
          _cache.store(result, DateTime.now().millisecondsSinceEpoch + 300000);
          return result;
        // if not 200 or 404 - throw a unique for each code exception  
        case 403:
          throw P1nkl0bst3rForbidden();
        case 429:
          throw P1nkl0bst3rTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          TopTr result = TopTr(id, null);
          developer.log("fetchTopTR: API returned ${response.statusCode}", name: "services/tetrio_crud", error: response.statusCode);
          //_cache.store(result, DateTime.now().millisecondsSinceEpoch + 300000);
          return result;
        default:
          developer.log("fetchTopTR: Failed to fetch top TR", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) { // If local http client fails
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri); // just assuming, that our end user don't have acess to the internet
    }
  }

  // Sidenote: as you can see, fetch functions looks and works pretty much same way, as described above,
  // so i'm going to document only unique differences between them

  Future<CutoffsTetrio?> fetchCutoffsTetrio() async {
    CutoffsTetrio? cached = _cache.get("league_ranks", CutoffsTetrio);
    if (cached != null) return cached;

    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "cutoffs"});
    } else {
      url = Uri.https('ch.tetr.io', 'api/labs/league_ranks');
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> rawData = jsonDecode(response.body);
          CutoffsTetrio result = CutoffsTetrio.fromJson(rawData['data']);
          _cache.store(result, rawData["cache"]["cached_until"]);
          return result;
        case 404:
          developer.log("fetchCutoffsTetrio: Cutoffs are gone", name: "services/tetrio_crud", error: response.statusCode);
          return null;
        // if not 200 or 404 - throw a unique for each code exception  
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          developer.log("fetchCutoffsTetrio: Cutoffs are unavalable (${response.statusCode})", name: "services/tetrio_crud", error: response.statusCode);
          return null;
        default:
          developer.log("fetchCutoffsTetrio: Failed to fetch top Cutoffs", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) { // If local http client fails
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri); // just assuming, that our end user don't have acess to the internet
    }
  }

  Future<Cutoffs?> fetchCutoffsBeanserver() async {
    Cutoffs? cached = _cache.get("", Cutoffs);
    if (cached != null) return cached;

    Uri url = Uri.https('ts.dan63.by', 'beanserver_blaster/cutoffs.json');

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> rawData = jsonDecode(response.body);
          Map<String, dynamic> data = rawData["data"] as Map<String, dynamic>;
          Cutoffs result = Cutoffs(DateTime.fromMillisecondsSinceEpoch(rawData["created"]), {}, {}, {});
          for (String rank in data.keys){
            result.tr[rank] = data[rank]["tr"];
            result.glicko[rank] = data[rank]["glicko"];
            result.gxe[rank] = data[rank]["gxe"];
          }
          _cache.store(result, rawData["cache_until"]);
          return result;
        case 404:
          developer.log("fetchCutoffsBeanserver: Cutoffs are gone", name: "services/tetrio_crud", error: response.statusCode);
          return null;
        // if not 200 or 404 - throw a unique for each code exception  
        case 403:
          throw P1nkl0bst3rForbidden();
        case 429:
          throw P1nkl0bst3rTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          developer.log("fetchCutoffsBeanserver: Cutoffs are unavalable (${response.statusCode})", name: "services/tetrio_crud", error: response.statusCode);
          return null;
        default:
          developer.log("fetchCutoffsBeanserver: Failed to fetch top Cutoffs", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) { // If local http client fails
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri); // just assuming, that our end user don't have acess to the internet
    }
  }

  Future<TetrioPlayerFromLeaderboard> fetchTopOneFromTheLeaderboard() async {
    TetrioPlayerFromLeaderboard? cached = _cache.get("topone", TetrioPlayerFromLeaderboard);
    if (cached != null) return cached;

    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "TLTopOne"});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/by/league', {"after": "25000:0:0", "limit": "1"});
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          var rawJson = jsonDecode(response.body);
          TetrioPlayerFromLeaderboard result = TetrioPlayerFromLeaderboard.fromJson(rawJson["data"]["entries"][0], DateTime.fromMillisecondsSinceEpoch(rawJson["cache"]["cached_at"]));
          _cache.store(result, rawJson["cache"]["cached_until"]);
          return result;
        case 404:
          throw TetrioPlayerNotExist();
        // if not 200 or 404 - throw a unique for each code exception  
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw P1nkl0bst3rInternalProblem();
        default:
          developer.log("fetchTopOneFromTheLeaderboard: Failed to fetch top one", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) { // If local http client fails
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri); // just assuming, that our end user don't have acess to the internet
    }
  }

  /// Retrieves Tetra League history from p1nkl0bst3r api for a player with given [id]. Returns a list of states
  /// (state = instance of [TetrioPlayer] at some point of time). Can throw an exception if fails to retrieve data.
  Future<List<TetraLeague>> fetchAndsaveTLHistory(String id) async { 
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "TLHistory", "user": id});
    } else {
      url = Uri.https('api.p1nkl0bst3r.xyz', 'tlhist/$id');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          await ensureDbIsOpen();
          final db = getDatabaseOrThrow();
          // that one api returns csv instead of json
          List<List<dynamic>> csv = const CsvToListConverter().convert(response.body)..removeAt(0);
          List<TetraLeague> history = [];
          Batch batch = db.batch();
          for (List<dynamic> entry in csv){ // each entry is one state
            TetraLeague state = TetraLeague(
                id: id, 
                timestamp: DateTime.parse(entry[9]),
                apm: entry[6] != '' ? entry[6] : null,
                pps: entry[7] != '' ? entry[7] : null,
                vs: entry[8] != '' ? entry[8] : null,
                glicko: entry[4],
                rd: noTrRd,
                gamesPlayed: entry[1],
                gamesWon: entry[2],
                bestRank: "z",
                decaying: false,
                tr: entry[3],
                gxe: -1,
                rank: entry[5],
                percentileRank: entry[5],
                percentile: rankCutoffs[entry[5]]!,
                standing: -1,
                standingLocal: -1,
                nextAt: -1,
                prevAt: -1,
                season: 1
              );
              history.add(state);
              batch.insert(tetrioLeagueTable, state.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
          batch.commit();
          return history;
        case 404:
          developer.log("fetchTLHistory: Probably, history doesn't exist", name: "services/tetrio_crud", error: response.statusCode);
          throw TetrioHistoryNotExist();
        case 403:
          throw P1nkl0bst3rForbidden();
        case 429:
          throw P1nkl0bst3rTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw P1nkl0bst3rInternalProblem();
        default:
          developer.log("fetchTLHistory: Failed to fetch history", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Docs later
  Future<TetraLeagueAlphaStream> fetchAndSaveOldTLmatches(String userID) async {
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "TLMatches", "user": userID});
    } else {
      url = Uri.https('api.p1nkl0bst3r.xyz', 'tlmatches/$userID', {"before": "0", "count": "9000"});
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          TetraLeagueAlphaStream stream = TetraLeagueAlphaStream.fromJson(jsonDecode(response.body)['data']['records'], userID);
          saveTLMatchesFromStream(stream);
          return stream;
        case 404:
          developer.log("fetchAndSaveOldTLmatches: Probably, history doesn't exist", name: "services/tetrio_crud", error: response.statusCode);
          throw TetrioHistoryNotExist();
        case 403:
          throw P1nkl0bst3rForbidden();
        case 429:
          throw P1nkl0bst3rTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw P1nkl0bst3rInternalProblem();
        default:
          developer.log("fetchAndSaveOldTLmatches: Failed to fetch history", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Retrieves full Tetra League leaderboard from Tetra Channel api. Returns a leaderboard object. Throws an exception if fails to retrieve.
  Future<TetrioPlayersLeaderboard> fetchTLLeaderboard() async {
    TetrioPlayersLeaderboard? cached = _cache.get("league", TetrioPlayersLeaderboard);
    if (cached != null) return cached;

    Uri url = Uri.https('ts.dan63.by', 'beanserver_blaster/leaderboard.json');

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          _lbPositions.clear();
          var rawJson = jsonDecode(response.body);
          TetrioPlayersLeaderboard leaderboard = TetrioPlayersLeaderboard.fromJson(rawJson['data'], "league", DateTime.fromMillisecondsSinceEpoch(rawJson['created']));
          developer.log("fetchTLLeaderboard: Leaderboard retrieved and cached", name: "services/tetrio_crud");
          _cache.store(leaderboard, rawJson['cache_until']);
          return leaderboard;
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchTLLeaderboard: Failed to fetch leaderboard", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  // Stream<TetrioPlayersLeaderboard> fetchFullLeaderboard() async* {
  //   late double after;
  //   int lbLength = 100;
  //   TetrioPlayersLeaderboard leaderboard = await fetchTLLeaderboard();
  //   after = leaderboard.leaderboard.last.tr;
  //   while (lbLength == 100){
  //     TetrioPlayersLeaderboard pseudoLb = await fetchTLLeaderboard(after: after);
  //     leaderboard.addPlayers(pseudoLb.leaderboard);
  //     lbLength = pseudoLb.leaderboard.length;
  //     after = pseudoLb.leaderboard.last.tr;
  //     yield leaderboard;
  //   }
  // }

  // i want to know progress, so i trying to figure out this thing:
  // Stream<TetrioPlayersLeaderboard> fetchTLLeaderboardAsStream() async {
  //   TetrioPlayersLeaderboard? cached = _cache.get("league", TetrioPlayersLeaderboard);
  //   if (cached != null) return cached;
     
  //   Uri url;
  //   if (kIsWeb) {
  //     url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "TLLeaderboard"});
  //   } else {
  //     url = Uri.https('ch.tetr.io', 'api/users/lists/league/all');
  //   }

  //   Stream<TetrioPlayersLeaderboard> stream = http.StreamedRequest("GET", url);
  // }

  TetrioPlayersLeaderboard? getCachedLeaderboard(){
    return _cache.get("league", TetrioPlayersLeaderboard);
  }

  /// Retrieves and returns 100 latest news entries from Tetra Channel api for given [userID]. Throws an exception if fails to retrieve.
  Future<News> fetchNews(String userID) async{
    News? cached = _cache.get("user_$userID", News);
    if (cached != null) return cached;
    
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioNews", "user": userID.toLowerCase().trim(), "limit": "100"});
    } else {
      url = Uri.https('ch.tetr.io', 'api/news/user_${userID.toLowerCase().trim()}', {"limit": "100"});
    }
    try {
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          var payload = jsonDecode(response.body);
          if (payload['success']) { // if api confirmed that everything ok
            News news = News.fromJson(payload['data'], userID);
            _cache.store(news, payload['cache']['cached_until']);
            developer.log("fetchNews: $userID news retrieved and cached", name: "services/tetrio_crud");
            return news;
          } else {
            developer.log("fetchNews: User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchNews: Failed to fetch stream", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Retrieves avaliable Tetra League matches from Tetra Channel api. Returns stream object (fake stream).
  /// Throws an exception if fails to retrieve.
  Future<TetraLeagueBetaStream> fetchTLStream(String userID) async {
    TetraLeagueBetaStream? cached = _cache.get(userID, TetraLeagueBetaStream);
    if (cached != null) return cached;
    
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioUserTL", "user": userID.toLowerCase().trim()});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/${userID.toLowerCase().trim()}/records/league/recent');
    }
    try {
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          if (jsonDecode(response.body)['success']) {
            TetraLeagueBetaStream stream = TetraLeagueBetaStream.fromJson(jsonDecode(response.body)['data']['entries'], userID);
            _cache.store(stream, jsonDecode(response.body)['cache']['cached_until']);
            developer.log("fetchTLStream: $userID stream retrieved and cached", name: "services/tetrio_crud");
            return stream;
          } else {
            developer.log("fetchTLStream User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchTLStream Failed to fetch stream", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Saves Tetra League Matches from [stream] to the local DB.
  Future<void> saveTLMatchesFromStream(TetraLeagueAlphaStream stream) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    for (TetraLeagueAlphaRecord match in stream.records) { // putting then one by one
       final results = await db.query(tetraLeagueMatchesTable, where: '$replayID = ?', whereArgs: [match.replayId]);
    if (results.isNotEmpty) continue; // if match alreay exist - skip
    db.insert(tetraLeagueMatchesTable, {
      idCol: match.ownId,
      replayID: match.replayId,
      timestamp: match.timestamp.toString(),
      player1id: match.endContext.first.userId,
      player2id: match.endContext.last.userId,
      endContext1: jsonEncode(match.endContext.first.toJson()),
      endContext2: jsonEncode(match.endContext.last.toJson())
    });
    }
  }

  /// Deletes duplicate entries of Tetra League matches from local DB.
  Future<void> removeDuplicatesFromTLMatches() async{
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    await db.execute("""
      DELETE FROM $tetraLeagueMatchesTable 
      WHERE 
        $idCol IN (
        SELECT 
          $idCol 
        FROM (
          SELECT 
            $idCol,
            ROW_NUMBER() OVER (
              PARTITION BY $replayID
              ORDER BY $replayID) AS row_num
          FROM $tetraLeagueMatchesTable    
        ) t
          WHERE row_num > 1
      );
    """);
  }

  /// Gets and returns a list of matches from local DB for a given [playerID].
  Future<List<TetraLeagueAlphaRecord>> getTLMatchesbyPlayerID(String playerID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<TetraLeagueAlphaRecord> matches = [];
    final results = await db.query(tetraLeagueMatchesTable, where: '($player1id = ?) OR ($player2id = ?)', whereArgs: [playerID, playerID]);
    for (var match in results){
      matches.add(TetraLeagueAlphaRecord(
        ownId: match[idCol].toString(),
        replayId: match[replayID].toString(),
        timestamp: DateTime.parse(match[timestamp].toString()),
        endContext:[
          EndContextMulti.fromJson(jsonDecode(match[endContext1].toString())),
          EndContextMulti.fromJson(jsonDecode(match[endContext2].toString()))
        ],
        replayAvalable: false
      ));
    }
    return matches;
  }

  /// Gets and returns an amount of stored Tetra League mathes between [ourPlayerID] and [enemyPlayerID].
  Future<int> getNumberOfTLMatchesBetweenPlayers(String ourPlayerID, String enemyPlayerID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.rawQuery("SELECT COUNT(*) from tetrioAlphaLeagueMathces WHERE (player1id = $ourPlayerID AND player2id = $enemyPlayerID) OR (player1id = $enemyPlayerID AND player2id = $ourPlayerID)");
    return results.first.values.first as int;
  }

  /// Deletes match and stats of that match with given [matchID] from local DB. Throws an exception if fails.
  Future<void> deleteTLMatch(String matchID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final rID = (await db.query(tetraLeagueMatchesTable, where: '$idCol = ?', whereArgs: [matchID])).first[replayID];
    final results = await db.delete(tetraLeagueMatchesTable, where: '$idCol = ?', whereArgs: [matchID]);
    if (results != 1) {
      throw CouldNotDeleteMatch();
    }
    await db.delete(tetrioTLReplayStatsTable, where: '$idCol = ?', whereArgs: [rID]);
  }

  /// Retrieves Blitz, 40 Lines and Zen records for a given [userID] from Tetra Channel api. Returns `UserRecords`.
  /// Throws an exception if fails to retrieve.
  Future<UserRecords> fetchRecords(String userID) async {
    UserRecords? cached = _cache.get(userID, UserRecords);
    if (cached != null) return cached;
    
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioUserRecords", "user": userID.toLowerCase().trim()});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/${userID.toLowerCase().trim()}/records');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          if (jsonDecode(response.body)['success']) {
            Map jsonRecords = jsonDecode(response.body);
              var sprint = jsonRecords['data']['records']['40l']['record'] != null
                  ? RecordSingle.fromJson(jsonRecords['data']['records']['40l']['record'], jsonRecords['data']['records']['40l']['rank'], jsonRecords['data']['records']['40l']['rank_local'])
                  : null;
              var blitz = jsonRecords['data']['records']['blitz']['record'] != null
                  ? RecordSingle.fromJson(jsonRecords['data']['records']['blitz']['record'], jsonRecords['data']['records']['blitz']['rank'], jsonRecords['data']['records']['blitz']['rank_local'])
                  : null;
              var zen = TetrioZen.fromJson(jsonRecords['data']['zen']);
            UserRecords result = UserRecords(userID, sprint, blitz, zen);
            _cache.store(result, jsonDecode(response.body)['cache']['cached_until']);
            developer.log("fetchRecords: $userID records retrieved and cached", name: "services/tetrio_crud");
            return result;
          } else {
            developer.log("fetchRecords User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchRecords Failed to fetch records", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  Future<Summaries> fetchSummaries(String id) async {
    Summaries? cached = _cache.get(id, Summaries);
    if (cached != null) return cached;

    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "Summaries", "id": id});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/$id/summaries');
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          if (jsonDecode(response.body)['success']) {
            developer.log("fetchSummaries: $id summaries retrieved and cached", name: "services/tetrio_crud");
            Summaries summaries = Summaries.fromJson(jsonDecode(response.body)['data'], id);
            _cache.store(summaries, jsonDecode(response.body)['cache']['cached_until']);
            return summaries;
          } else {
            developer.log("fetchSummaries: User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchRecords Failed to fetch records", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Creates an entry in local DB for [tetrioPlayer]. Throws an exception if that player already here.
  Future<void> createPlayer(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();

    // checking if its already here
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }

    // converting to json and store
    final Map<String, dynamic> statesJson = {(tetrioPlayer.state.millisecondsSinceEpoch ~/ 1000).toString(): tetrioPlayer.toJson()};
    db.insert(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)});
    _players.addEntries({tetrioPlayer.userId: tetrioPlayer.username}.entries);
    _tetrioStreamController.add(_players);
  }

  /// Adds user id of [tetrioPlayer] to the [tetrioUsersToTrackTable] of database.
  Future<void> addPlayerToTrack(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }
    await db.insert(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username}, conflictAlgorithm: ConflictAlgorithm.replace);
    db.insert(tetrioUsersToTrackTable, {idCol: tetrioPlayer.userId});
    _players[tetrioPlayer.userId] = tetrioPlayer.username;
    _tetrioStreamController.add(_players);
  }

  /// Returns bool, which tells whether is given [id] is in [tetrioUsersToTrackTable].
  Future<bool> isPlayerTracking(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    return results.isNotEmpty;
  }

  /// Returns Iterable with user ids of players who is tracked.
  Future<Iterable<String>> getAllPlayerToTrack() async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final players = await db.query(tetrioUsersToTrackTable);
    return players.map((noteRow) => noteRow["id"].toString());
  }

  /// Removes user with given [id] from the [tetrioUsersToTrackTable] of database.
  Future<void> deletePlayerToTrack(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final deletedPlayer = await db.delete(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    await db.delete(tetrioUsersTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (deletedPlayer != 1) {
      throw CouldNotDeletePlayer();
    } else {
       _players.removeWhere((key, value) => key == id);
      _tetrioStreamController.add(_players);
    }
  }

  Future<List<TetraLeague>> getStates(String userID, {int? season}) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<Map> query = await db.query(tetrioLeagueTable, where: season != null ? '"id" LIKE ? AND "season" = ?' : '"id" LIKE ?', whereArgs: season != null ? ["${userID}%", season] : ["${userID}%"], orderBy: '"id" ASC');
    return [for (var entry in query) TetraLeague.fromJson(entry as Map<String, dynamic>, DateTime.fromMillisecondsSinceEpoch(int.parse(entry["id"].substring(24), radix: 16)), entry["season"], entry["id"].substring(0, 24))];
  }

  /// Saves state (which is [TetraLeague]) to the local database.
  Future<void> storeState(TetraLeague league) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<Map> test = await db.query(tetrioLeagueTable, where: '"id" LIKE ? AND "gamesplayed" = ? AND "rd" = ?', whereArgs: ["${league.id}%", league.gamesPlayed, league.rd]);
    if (test.isEmpty) {
      await db.insert(tetrioLeagueTable, league.toJson());
    }
  }

  /// Remove state, which has [dbID] from the local database
  /// ([dbid] is a concatenation of player id and UINX milliseconds in hex)
  Future<void> deleteState(String dbID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    int result = await db.delete(tetrioLeagueTable, where: "id = ?", whereArgs: [dbID]);
    if (result == 0) throw Exception("Failed to remove a row $dbID - it's probably not exist");
  }

  /// Retrieves general stats of [user] (nickname or id) from Tetra Channel api. Returns [TetrioPlayer] object of this user.
  /// If [isItDiscordID] is true, function expects [user] to be a discord user id. Throws an exception if fails to retrieve.
  Future<TetrioPlayer> fetchPlayer(String user, {bool isItDiscordID = false}) async {
    TetrioPlayer? cached = _cache.get(user, TetrioPlayer);
    if (cached != null) return cached;

    if (isItDiscordID){
      // trying to find player with given discord id
      Uri dUrl;
      if (kIsWeb) {
        dUrl = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioUserByDiscordID", "user": user.toLowerCase().trim()});
      } else {
        dUrl = Uri.https('ch.tetr.io', 'api/users/search/${user.toLowerCase().trim()}');
      }
      try{
        final response = await client.get(dUrl);

        switch (response.statusCode) {
          case 200:
            var json = jsonDecode(response.body);
            if (json['success'] && json['data'] != null) {
              // success - rewrite user with tetrio user id and going to obtain data about him
              user = json['data']['user']['_id'];
            } else { // fail - throw an exception
              developer.log("fetchPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
              throw TetrioDiscordNotExist();
            }
            break;
          // more exceptions to god of exceptions
          case 403:
            throw TetrioForbidden();
          case 404:
            throw TetrioPlayerNotExist();
          case 429:
            throw TetrioTooManyRequests();
          case 418:
            throw TetrioOskwareBridgeProblem();
          case 500:
          case 502:
          case 503:
          case 504:
            throw TetrioInternalProblem();
          default:
            developer.log("fetchPlayer Failed to fetch player", name: "services/tetrio_crud", error: response.statusCode);
            throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
        }
      } on http.ClientException catch (e, s) {
        developer.log("$e, $s");
        throw http.ClientException(e.message, e.uri);
      }
    }
    
    // finally going to obtain
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioUser", "user": user.toLowerCase().trim()});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          var json = jsonDecode(response.body);
          if (json['success']) {
            // parse and count stats
            TetrioPlayer player = TetrioPlayer.fromJson(json['data'], DateTime.fromMillisecondsSinceEpoch(json['cache']['cached_at'], isUtc: true), json['data']['_id'], json['data']['username'], DateTime.fromMillisecondsSinceEpoch(json['cache']['cached_until'], isUtc: true));
            _cache.store(player, json['cache']['cached_until']);
            developer.log("fetchPlayer: $user retrieved and cached", name: "services/tetrio_crud");
            return player;
          } else {
            developer.log("fetchPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
            throw TetrioPlayerNotExist();
          }
        case 403:
          throw TetrioForbidden();
        case 404:
          throw TetrioPlayerNotExist();
        case 429:
          throw TetrioTooManyRequests();
        case 418:
          throw TetrioOskwareBridgeProblem();
        case 500:
        case 502:
        case 503:
        case 504:
          throw TetrioInternalProblem();
        default:
          developer.log("fetchPlayer Failed to fetch player", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    }on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Retrieves whole [tetrioUsersTable] and returns Map {id: nickname} of everyone in database
  Future<Map<String, String>> getAllPlayers() async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final players = await db.query(tetrioUsersTable);
    Map<String, String> data = {};
    for (var entry in players){
      data[entry[idCol] as String] = entry[nickCol] as String;
    }
    return data;
  }

  // Future<void> fetchTracked() async {
  //   for (String userID in (await getAllPlayerToTrack())) { 
  //     TetrioPlayer player = await fetchPlayer(userID);
  //     storeState(player);
  //     sleep(Durations.extralong4);
  //     TetraLeagueBetaStream matches = await fetchTLStream(userID);
  //     saveTLMatchesFromStream(matches);
  //     sleep(Durations.extralong4);
  //   }
  // }
}
