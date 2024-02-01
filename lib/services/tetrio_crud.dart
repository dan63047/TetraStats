import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
const String idCol = "id";
const String replayID = "replayId";
const String nickCol = "nickname";
const String timestamp = "timestamp";
const String endContext1 = "endContext1";
const String endContext2 = "endContext2";
const String statesCol = "jsonStates";
const String player1id = "player1id";
const String player2id = "player2id";
/// Table, that store players data, their stats and some moments of time
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

class TetrioService extends DB {
  Map<String, List<TetrioPlayer>> _players = {};

  // I'm trying to send as less requests, as possible, so i'm caching the results of those requests.
  // Usually those maps looks like this: {"cached_until_unix_milliseconds": Object}
  final Map<String, TetrioPlayer> _playersCache = {};
  final Map<String, Map<String, dynamic>> _recordsCache = {};
  final Map<String, dynamic> _replaysCache = {}; // the only one is different: {"replayID": [replayString, replayBytes]}
  final Map<String, TetrioPlayersLeaderboard> _leaderboardsCache = {};
  final Map<String, List<News>> _newsCache = {};
  final Map<String, Map<String, double?>> _topTRcache = {};
  final Map<String, TetraLeagueAlphaStream> _tlStreamsCache = {};
  /// Thing, that sends every request to the API endpoints
  final client = kDebugMode ? UserAgentClient("Kagari-chan loves osk (Tetra Stats dev build)", http.Client()) : UserAgentClient("Tetra Stats v${packageInfo.version} (dm @dan63047 if someone abuse that software)", http.Client());
  /// We should have only one instanse of this service
  static final TetrioService _shared = TetrioService._sharedInstance();
  factory TetrioService() => _shared;
  late final StreamController<Map<String, List<TetrioPlayer>>> _tetrioStreamController;
  TetrioService._sharedInstance() {
    _tetrioStreamController = StreamController<Map<String, List<TetrioPlayer>>>.broadcast(onListen: () {
      _tetrioStreamController.sink.add(_players);
    });
  }

  @override
  Future<void> open() async {
    await super.open();
    await _loadPlayers();
  }

  Stream<Map<String, List<TetrioPlayer>>> get allPlayers => _tetrioStreamController.stream;

  /// Loading and sending to the stream everyone.
  Future<void> _loadPlayers() async {
    final allPlayers = await getAllPlayers();
    try{
      _players = allPlayers.toList().first; // ???
    }catch (e){
      developer.log("_loadPlayers: allPlayers.toList().first did oopsie", name: "services/tetrio_crud", error: e);
      _players = {};
    }
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
  }

  /// Gets nickname from database or requests it from API if missing.
  /// Throws an exception if user not exist or request failed.
  Future<String> getNicknameByID(String id) async {
    if (id.length <= 16) return id; // nicknames can be up to 16 symbols in length, that's how i'm differentiate nickname from ids
    try{
      return await getPlayer(id).then((value) => value.last.username);
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

  /// Downloads replay from inoue (szy API). Requiers [replayID]. If request have
  /// different from 200 statusCode, it will throw an excepction. Returns list, that contains same replay
  /// as string and as binary.
  Future<List<dynamic>> szyGetReplay(String replayID) async {
    try{ // read from cache
      var cached = _replaysCache.entries.firstWhere((element) => element.key == replayID);
      return cached.value;
    }catch (e){
      // actually going to obtain
    }

    Uri url;
    if (kIsWeb) { // Web version sends every request through my php script at the same domain, where Tetra Stats located because of CORS
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioReplay", "replayid": replayID});
    } else { // Actually going to hit inoue
      url = Uri.https('inoue.szy.lol', '/api/replay/$replayID');
    }

    // Trying to obtain replay from download directory first
    if (!kIsWeb){ // can't obtain download directory on web
      var downloadPath = await getDownloadsDirectory();
      downloadPath ??= Platform.isAndroid ? Directory("/storage/emulated/0/Download") : await getApplicationDocumentsDirectory();
      var replayFile = File("${downloadPath.path}/$replayID.ttrm");
      if (replayFile.existsSync()) return [replayFile.readAsStringSync(), replayFile.readAsBytesSync()];
    }

    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          developer.log("szyDownload: Replay downloaded", name: "services/tetrio_crud", error: response.statusCode);
          _replaysCache[replayID] = [response.body, response.bodyBytes]; // Puts results into the cache 
          return [response.body, response.bodyBytes];
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
          developer.log("szyDownload: Failed to download a replay", name: "services/tetrio_crud", error: response.statusCode);
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
    var replay = await szyGetReplay(replayID);
    await replayFile.writeAsBytes(replay[1]);
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
    String replay = (await szyGetReplay(replayID))[0];
    Map<String, dynamic> toAnalyze = jsonDecode(replay);
    ReplayData data = ReplayData.fromJson(toAnalyze);
    saveReplayStats(data); // saving to DB for later
    return data;
  }

  /// Gets and returns Top TR for a player with given [id]. May return null if player top tr is unknown
  /// or api is unavaliable (404). May throw an exception, if something else happens.
  Future<double?> fetchTopTR(String id) async {
    try{ // read from cache
      var cached = _topTRcache.entries.firstWhere((element) => element.value.keys.first == id);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){ // if not expired
      developer.log("fetchTopTR: Top TR retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value.values.first;
    }else{ // if cache expired
      _topTRcache.remove(cached.key);
      developer.log("fetchTopTR: Top TR expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){ // actually going to obtain
      developer.log("fetchTopTR: Trying to retrieve Top TR", name: "services/tetrio_crud");
    }

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
          _topTRcache[(DateTime.now().millisecondsSinceEpoch + 300000).toString()] = {id: double.tryParse(response.body)};
          return double.tryParse(response.body);
        case 404: // not found - return null
          developer.log("fetchTopTR: Probably, player doesn't have top TR", name: "services/tetrio_crud", error: response.statusCode);
          _topTRcache[(DateTime.now().millisecondsSinceEpoch + 300000).toString()] = {id: null};
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
          throw P1nkl0bst3rInternalProblem();
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

  /// Retrieves Tetra League history from p1nkl0bst3r api for a player with given [id]. Returns a list of states
  /// (state = instance of [TetrioPlayer] at some point of time). Can throw an exception if fails to retrieve data.
  Future<List<TetrioPlayer>> fetchAndsaveTLHistory(String id) async {
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
          // that one api returns csv instead of json
          List<List<dynamic>> csv = const CsvToListConverter().convert(response.body)..removeAt(0);
          List<TetrioPlayer> history = [];
          // doesn't return nickname, need to retrieve it separately
          String nick = await getNicknameByID(id);
          for (List<dynamic> entry in csv){ // each entry is one state
            TetrioPlayer state = TetrioPlayer(
              userId: id,
              username: nick,
              role: "p1nkl0bst3r",
              state: DateTime.parse(entry[9]),
              badges: [],
              friendCount: -1,
              gamesPlayed: -1,
              gamesWon: -1,
              gameTime: const Duration(seconds: -1),
              xp: -1,
              supporterTier: 0,
              verified: false,
              connections: null,
              tlSeason1: TetraLeagueAlpha(
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
                rating: entry[3],
                rank: entry[5],
                percentileRank: entry[5],
                percentile: rankCutoffs[entry[5]]!,
                standing: -1,
                standingLocal: -1,
                nextAt: -1,
                prevAt: -1
              ),
              sprint: [],
              blitz: []
              );
              history.add(state);
          }

          // trying to dump it to local DB
          await ensureDbIsOpen();
          final db = getDatabaseOrThrow();
          late List<TetrioPlayer> states;
          try{
            // checking if tetra stats aware about that player TODO: is it necessary?
            states = _players[id]!;
          }catch(e){
            // if somehow not - create it
            var player = await fetchPlayer(id);
            await createPlayer(player);
            states = _players[id]!;
          }
          states.insertAll(0, history.reversed);
          final Map<String, dynamic> statesJson = {};
          for (var e in states) { // making one big json out of this list
            statesJson.addEntries({(e.state.millisecondsSinceEpoch ~/ 1000).toString(): e.toJson()}.entries);
          }
          // and putting it to local DB
          await db.update(tetrioUsersTable, {idCol: id, nickCol: nick, statesCol: jsonEncode(statesJson)}, where: '$idCol = ?', whereArgs: [id]);
          _tetrioStreamController.add(_players);
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

  /// Retrieves full Tetra League leaderboard from Tetra Channel api. Returns a leaderboard object. Throws an exception if fails to retrieve.
  Future<TetrioPlayersLeaderboard> fetchTLLeaderboard() async {
    try{
      var cached = _leaderboardsCache.entries.firstWhere((element) => element.value.type == "league");
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchTLLeaderboard: Leaderboard retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _leaderboardsCache.remove(cached.key);
      developer.log("fetchTLLeaderboard: Leaderboard expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchTLLeaderboard: Trying to retrieve leaderboard", name: "services/tetrio_crud");
    }
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "TLLeaderboard"});
    } else {
      url = Uri.https('ch.tetr.io', 'api/users/lists/league/all');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          var rawJson = jsonDecode(response.body);
          if (rawJson['success']) { // if api confirmed that everything ok
            TetrioPlayersLeaderboard leaderboard = TetrioPlayersLeaderboard.fromJson(rawJson['data']['users'], "league", DateTime.fromMillisecondsSinceEpoch(rawJson['cache']['cached_at']));
            developer.log("fetchTLLeaderboard: Leaderboard retrieved and cached", name: "services/tetrio_crud");
            _leaderboardsCache[rawJson['cache']['cached_until'].toString()] = leaderboard;
            return leaderboard;
          } else { // idk how to hit that one
            developer.log("fetchTLLeaderboard: Bruh", name: "services/tetrio_crud", error: rawJson);
            throw Exception("Failed to get leaderboard (problems on the tetr.io side)"); // will it be on tetr.io side?
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
          developer.log("fetchTLLeaderboard: Failed to fetch leaderboard", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Retrieves and returns 100 latest news entries from Tetra Channel api for given [userID]. Throws an exception if fails to retrieve.
  Future<List<News>> fetchNews(String userID) async{
    try{
      var cached = _newsCache.entries.firstWhere((element) => element.value[0].stream == "user_$userID");
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchNews: News for $userID retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _newsCache.remove(cached.key);
      developer.log("fetchNews: Cached news for $userID expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchNews: Trying to retrieve news for $userID", name: "services/tetrio_crud");
    }
    
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
            List<News> news = [for (var entry in payload['data']['news']) News.fromJson(entry)];
            _newsCache[payload['cache']['cached_until'].toString()] = news;
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
  Future<TetraLeagueAlphaStream> fetchTLStream(String userID) async {
    try{
      var cached = _tlStreamsCache.entries.firstWhere((element) => element.value.userId == userID);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchTLStream: Stream $userID retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _tlStreamsCache.remove(cached.key);
      developer.log("fetchTLStream: Cached stream $userID expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchTLStream: Trying to retrieve stream $userID", name: "services/tetrio_crud");
    }
    
    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "tetrioUserTL", "user": userID.toLowerCase().trim()});
    } else {
      url = Uri.https('ch.tetr.io', 'api/streams/league_userrecent_${userID.toLowerCase().trim()}');
    }
    try {
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          if (jsonDecode(response.body)['success']) {
            TetraLeagueAlphaStream stream = TetraLeagueAlphaStream.fromJson(jsonDecode(response.body)['data']['records'], userID);
            _tlStreamsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = stream;
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

  /// Retrieves Blitz, 40 Lines and Zen records for a given [playerID] from Tetra Channel api. Returns Map, which contains user id (`user`),
  /// Blitz (`blitz`) and 40 Lines (`sprint`) record objects and Zen object (`zen`). Throws an exception if fails to retrieve.
  Future<Map<String, dynamic>> fetchRecords(String userID) async {
    try{
      var cached = _recordsCache.entries.firstWhere((element) => element.value['user'] == userID);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchRecords: $userID records retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _recordsCache.remove(cached.key);
      developer.log("fetchRecords: $userID records expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchRecords: Trying to retrieve $userID records", name: "services/tetrio_crud");
    }
    
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
                  ? RecordSingle.fromJson(jsonRecords['data']['records']['40l']['record'], jsonRecords['data']['records']['40l']['rank'])
                  : null;
              var blitz = jsonRecords['data']['records']['blitz']['record'] != null
                  ? RecordSingle.fromJson(jsonRecords['data']['records']['blitz']['record'], jsonRecords['data']['records']['blitz']['rank'])
                  : null;
              var zen = TetrioZen.fromJson(jsonRecords['data']['zen']);
            Map<String, dynamic> map = {"user": userID.toLowerCase().trim(), "sprint": sprint, "blitz": blitz, "zen": zen};
            _recordsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = map;
            developer.log("fetchRecords: $userID records retrieved and cached", name: "services/tetrio_crud");
            return map;
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
    _players.addEntries({
      tetrioPlayer.userId: [tetrioPlayer]
    }.entries);
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
    db.insert(tetrioUsersToTrackTable, {idCol: tetrioPlayer.userId});
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
    developer.log("getAllPlayerToTrack: $players", name: "services/tetrio_crud");
    return players.map((noteRow) => noteRow["id"].toString());
  }

  /// Removes user with given [id] from the [tetrioUsersToTrackTable] of database.
  Future<void> deletePlayerToTrack(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final deletedPlayer = await db.delete(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (deletedPlayer != 1) {
      throw CouldNotDeletePlayer();
    } else {
      // _players.removeWhere((key, value) => key == id);
      // _tetrioStreamController.add(_players);
    }
  }

  /// Saves state (which is [tetrioPlayer]) to the local database.
  Future<void> storeState(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    try { // retrieveing previous states
      states = _players[tetrioPlayer.userId]!;
    } catch (e) { // nothing found - player not exist - create them
      await createPlayer(tetrioPlayer);
      states = await getPlayer(tetrioPlayer.userId);
    }

    // we not going to add state, that is same, as the previous
    bool test = _players[tetrioPlayer.userId]!.last.isSameState(tetrioPlayer);
    if (test == false) states.add(tetrioPlayer);

    // Making map of the states
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      // Saving in format: {"unix_seconds": json_of_state}
      statesJson.addEntries({(e.state.millisecondsSinceEpoch ~/ 1000).toString(): e.toJson()}.entries);
    }
    // Rewrite our database
    await db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  /// Remove state (which is [tetrioPlayer]) from the local database
  Future<void> deleteState(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    // removing state from map that contain every state of each user
    _players[tetrioPlayer.userId]!.removeWhere((element) => element.state == tetrioPlayer.state);
    states = _players[tetrioPlayer.userId]!;

    // Making map of the states (without deleted one)
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      statesJson.addEntries({(e.state.millisecondsSinceEpoch ~/ 1000).toString(): e.toJson()}.entries);
    }
    // Rewriting database entry with new json
    await db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  /// Returns list of all states of player with given [id] from database. Can return empty list if player
  /// was not found.
  Future<List<TetrioPlayer>> getPlayer(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<TetrioPlayer> states = [];
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (results.isEmpty) {
      return states; // it empty
    } else {
      dynamic rawStates = results.first['jsonStates'] as String;
      rawStates = json.decode(rawStates);
      // recreating objects of states
      rawStates.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k) * 1000), id, results.first[nickCol] as String)));
      // updating the stream
      _players.removeWhere((key, value) => key == id);
      _players.addEntries({states.last.userId: states}.entries);
      _tetrioStreamController.add(_players);
      return states;
    }
  }

  /// Retrieves general stats of [user] (nickname or id) from Tetra Channel api. Returns [TetrioPlayer] object of this user.
  /// If [isItDiscordID] is true, function expects [user] to be a discord user id. Throws an exception if fails to retrieve.
  Future<TetrioPlayer> fetchPlayer(String user, {bool isItDiscordID = false}) async {
    try{
      var cached = _playersCache.entries.firstWhere((element) => element.value.userId == user || element.value.username == user);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchPlayer: User $user retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _playersCache.remove(cached.key);
      developer.log("fetchPlayer: Cached user $user expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchPlayer: Trying to retrieve $user", name: "services/tetrio_crud");
    }

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
              throw TetrioPlayerNotExist();
            }
            break;
          // more exceptions to god of exceptions
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
            TetrioPlayer player = TetrioPlayer.fromJson(json['data']['user'], DateTime.fromMillisecondsSinceEpoch(json['cache']['cached_at'], isUtc: true), json['data']['user']['_id'], json['data']['user']['username']);
            _playersCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = player;
            developer.log("fetchPlayer: $user retrieved and cached", name: "services/tetrio_crud");
            return player;
          } else {
            developer.log("fetchPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
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
          developer.log("fetchPlayer Failed to fetch player", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    }on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  /// Basucally, retrieves whole [tetrioUsersTable] and do stupud things idk
  /// Returns god knows what. TODO: Rewrite this shit
  Future<Iterable<Map<String, List<TetrioPlayer>>>> getAllPlayers() async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final players = await db.query(tetrioUsersTable);
    Map<String, List<TetrioPlayer>> data = {};
    return players.map((row) {
      // what the fuck am i doing here?
      var test = json.decode(row['jsonStates'] as String);
      List<TetrioPlayer> states = [];
      test.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k) * 1000), row[idCol] as String, row[nickCol] as String)));
      data.addEntries({states.last.userId: states}.entries);
      return data;
    });
  }
}
