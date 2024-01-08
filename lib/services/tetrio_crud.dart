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
const String createTetrioUsersTable = '''
        CREATE TABLE IF NOT EXISTS "tetrioUsers" (
          "id"	TEXT UNIQUE,
          "nickname"	TEXT,
          "jsonStates"	TEXT,
          PRIMARY KEY("id")
        );''';
const String createTetrioUsersToTrack = '''
        CREATE TABLE IF NOT EXISTS "tetrioUsersToTrack" (
          "id"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("ID")
        )
''';
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

const String createTetrioTLReplayStats = '''
        CREATE TABLE IF NOT EXISTS "tetrioTLReplayStats" (
          "id"	TEXT NOT NULL,
          "data"	TEXT NOT NULL,
          PRIMARY KEY("id")
        )
''';

class TetrioService extends DB {
  Map<String, List<TetrioPlayer>> _players = {};
  final Map<String, TetrioPlayer> _playersCache = {};
  final Map<String, Map<String, dynamic>> _recordsCache = {};
  final Map<String, dynamic> _replaysCache = {};
  final Map<String, TetrioPlayersLeaderboard> _leaderboardsCache = {};
  final Map<String, List<News>> _newsCache = {};
  final Map<String, Map<String, double?>> _topTRcache = {};
  final Map<String, TetraLeagueAlphaStream> _tlStreamsCache = {}; // i'm trying to respect oskware api It should look something like {"cached_until": TetrioPlayer}
  //final client = UserAgentClient("Tetra Stats v${packageInfo.version} (dm @dan63047 if someone abuse that software)", http.Client());
  final client = UserAgentClient("Kagari-chan loves osk (Tetra Stats dev build)", http.Client());
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

  Future<String> getNicknameByID(String id) async {
    if (id.length <= 16) return id;
    try{
      return await getPlayer(id).then((value) => value.last.username);
    } catch (e){
      return await fetchPlayer(id).then((value) => value.username);
    }
  }

  Future<void> saveReplayStats(ReplayData replay) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    db.insert(tetrioTLReplayStatsTable, {idCol: replay.id, "data": jsonEncode(replay.toJson())});
  }

  Future<List<dynamic>> szyGetReplay(String replayID) async {
    try{
      var cached = _replaysCache.entries.firstWhere((element) => element.key == replayID);
      return cached.value;
    }catch (e){
      // actually going to obtain
    }
    Uri url = Uri.https('inoue.szy.lol', '/api/replay/$replayID');
    var downloadPath = await getDownloadsDirectory();
    downloadPath ??= Platform.isAndroid ? Directory("/storage/emulated/0/Download") : await getApplicationDocumentsDirectory();
    var replayFile = File("${downloadPath.path}/$replayID.ttrm");
    if (replayFile.existsSync()) return [replayFile.readAsStringSync(), replayFile.readAsBytesSync()];
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          developer.log("szyDownload: Replay downloaded", name: "services/tetrio_crud", error: response.statusCode);
          _replaysCache[replayID] = [response.body, response.bodyBytes];
          return [response.body, response.bodyBytes];
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
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  Future<String> saveReplay(String replayID) async {
    var downloadPath = await getDownloadsDirectory();
    downloadPath ??= Platform.isAndroid ? Directory("/storage/emulated/0/Download") : await getApplicationDocumentsDirectory();
    var replayFile = File("${downloadPath.path}/$replayID.ttrm");
    if (replayFile.existsSync()) throw TetrioReplayAlreadyExist();
    var replay = await szyGetReplay(replayID);
    await replayFile.writeAsBytes(replay[1]);
    return replayFile.path;
  }

  Future<ReplayData> analyzeReplay(String replayID) async{
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioTLReplayStatsTable, where: '$idCol = ?', whereArgs: [replayID]);
    if (results.isNotEmpty) return ReplayData.fromJson(jsonDecode(results.first["data"].toString())); 
    Map<String, dynamic> toAnalyze = jsonDecode((await szyGetReplay(replayID))[0]);
    ReplayData data = ReplayData.fromJson(toAnalyze);
    saveReplayStats(data);
    return data;
  }

  Future<double?> fetchTopTR(String id) async {
    try{
      var cached = _topTRcache.entries.firstWhere((element) => element.value.keys.first == id);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("fetchTopTR: Top TR retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value.values.first;
    }else{
      _topTRcache.remove(cached.key);
      developer.log("fetchTopTR: Top TR expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("fetchTopTR: Trying to retrieve Top TR", name: "services/tetrio_crud");
    }

    Uri url;
    if (kIsWeb) {
      url = Uri.https('ts.dan63.by', 'oskware_bridge.php', {"endpoint": "PeakTR", "user": id});
    } else {
      url = Uri.https('api.p1nkl0bst3r.xyz', 'toptr/$id');
    }
    try{
      final response = await client.get(url);

      switch (response.statusCode) {
        case 200:
          _topTRcache[(DateTime.now().millisecondsSinceEpoch + 300000).toString()] = {id: double.tryParse(response.body)};
          return double.tryParse(response.body);
        case 404:
          developer.log("fetchTopTR: Probably, player doesn't have top TR", name: "services/tetrio_crud", error: response.statusCode);
          _topTRcache[(DateTime.now().millisecondsSinceEpoch + 300000).toString()] = {id: null};
          return null;
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
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

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
          List<List<dynamic>> csv = const CsvToListConverter().convert(response.body)..removeAt(0);
          List<TetrioPlayer> history = [];
          String nick = await getNicknameByID(id);
          for (List<dynamic> entry in csv){
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
              tlSeason1: TetraLeagueAlpha(timestamp: DateTime.parse(entry[9]), apm: entry[6] != '' ? entry[6] : null, pps: entry[7] != '' ? entry[7] : null, vs: entry[8] != '' ? entry[8] : null, glicko: entry[4], rd: noTrRd, gamesPlayed: entry[1], gamesWon: entry[2], bestRank: "z", decaying: false, rating: entry[3], rank: entry[5], percentileRank: entry[5], percentile: rankCutoffs[entry[5]]!, standing: -1, standingLocal: -1, nextAt: -1, prevAt: -1),
              sprint: [],
              blitz: []
              );
              history.add(state);
          }
          await ensureDbIsOpen();
          final db = getDatabaseOrThrow();
          late List<TetrioPlayer> states;
          try{
            states = _players[id]!;
          }catch(e){
            var player = await fetchPlayer(id);
            await createPlayer(player);
            states = _players[id]!;
          }
          states.insertAll(0, history.reversed);
          final Map<String, dynamic> statesJson = {};
          for (var e in states) {
            statesJson.addEntries({(e.state.millisecondsSinceEpoch ~/ 1000).toString(): e.toJson()}.entries);
          }
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
          if (rawJson['success']) {
            TetrioPlayersLeaderboard leaderboard = TetrioPlayersLeaderboard.fromJson(rawJson['data']['users'], "league", DateTime.fromMillisecondsSinceEpoch(rawJson['cache']['cached_at']));
            developer.log("fetchTLLeaderboard: Leaderboard retrieved and cached", name: "services/tetrio_crud");
            _leaderboardsCache[rawJson['cache']['cached_until'].toString()] = leaderboard;
            return leaderboard;
          } else {
            developer.log("fetchTLLeaderboard: Bruh", name: "services/tetrio_crud", error: rawJson);
            throw Exception("Failed to get leaderboard (problems on the tetr.io side)");
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
          if (payload['success']) {
            List<News> news = [for (var entry in payload['data']['news']) News.fromJson(entry)];
            developer.log("fetchNews: $userID news retrieved and cached", name: "services/tetrio_crud");
            _newsCache[payload['cache']['cached_until'].toString()] = news;
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

  Future<TetraLeagueAlphaStream> getTLStream(String userID) async {
    try{
      var cached = _tlStreamsCache.entries.firstWhere((element) => element.value.userId == userID);
    if (DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true).isAfter(DateTime.now())){
      developer.log("getTLStream: Stream $userID retrieved from cache, that expires ${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)}", name: "services/tetrio_crud");
      return cached.value;
    }else{
      _tlStreamsCache.remove(cached.key);
      developer.log("getTLStream: Cached stream $userID expired (${DateTime.fromMillisecondsSinceEpoch(int.parse(cached.key.toString()), isUtc: true)})", name: "services/tetrio_crud");
    }
    }catch(e){
      developer.log("getTLStream: Trying to retrieve stream $userID", name: "services/tetrio_crud");
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
            developer.log("getTLStream: $userID stream retrieved and cached", name: "services/tetrio_crud");
            _tlStreamsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = stream;
            return stream;
          } else {
            developer.log("getTLStream User dosen't exist", name: "services/tetrio_crud", error: response.body);
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
          developer.log("getTLStream Failed to fetch stream", name: "services/tetrio_crud", error: response.statusCode);
          throw ConnectionIssue(response.statusCode, response.reasonPhrase??"No reason");
      }
    } on http.ClientException catch (e, s) {
      developer.log("$e, $s");
      throw http.ClientException(e.message, e.uri);
    }
  }

  Future<void> saveTLMatchesFromStream(TetraLeagueAlphaStream stream) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    for (TetraLeagueAlphaRecord match in stream.records) {
       final results = await db.query(tetraLeagueMatchesTable, where: '$replayID = ?', whereArgs: [match.replayId]);
    if (results.isNotEmpty) continue;
    db.insert(tetraLeagueMatchesTable, {idCol: match.ownId, replayID: match.replayId, timestamp: match.timestamp.toString(), player1id: match.endContext.first.userId, player2id: match.endContext.last.userId, endContext1: jsonEncode(match.endContext.first.toJson()), endContext2: jsonEncode(match.endContext.last.toJson())});
    }
  }

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

  Future<List<TetraLeagueAlphaRecord>> getTLMatchesbyPlayerID(String playerID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<TetraLeagueAlphaRecord> matches = [];
    final results = await db.query(tetraLeagueMatchesTable, where: '($player1id = ?) OR ($player2id = ?)', whereArgs: [playerID, playerID]);
    for (var match in results){
      matches.add(TetraLeagueAlphaRecord(ownId: match[idCol].toString(), replayId: match[replayID].toString(), timestamp: DateTime.parse(match[timestamp].toString()), endContext:[EndContextMulti.fromJson(jsonDecode(match[endContext1].toString())), EndContextMulti.fromJson(jsonDecode(match[endContext2].toString()))], replayAvalable: false));
    }
    return matches;
  }

  Future<void> deleteTLMatch(String matchID) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.delete(tetraLeagueMatchesTable, where: '$idCol = ?', whereArgs: [matchID]);
    if (results != 1) {
      throw CouldNotDeleteMatch();
    }
  }

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
                  ? [RecordSingle.fromJson(jsonRecords['data']['records']['40l']['record'], jsonRecords['data']['records']['40l']['rank'])]
                  : [];
              var blitz = jsonRecords['data']['records']['blitz']['record'] != null
                  ? [RecordSingle.fromJson(jsonRecords['data']['records']['blitz']['record'], jsonRecords['data']['records']['blitz']['rank'])]
                  : [];
              var zen = TetrioZen.fromJson(jsonRecords['data']['zen']);
            Map<String, dynamic> map = {"user": userID.toLowerCase().trim(), "sprint": sprint, "blitz": blitz, "zen": zen};
            developer.log("fetchRecords: $userID records retrieved and cached", name: "services/tetrio_crud");
            _recordsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = map;
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

  Future<void> createPlayer(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }
    final Map<String, dynamic> statesJson = {(tetrioPlayer.state.millisecondsSinceEpoch ~/ 1000).toString(): tetrioPlayer.toJson()};
    db.insert(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)});
    _players.addEntries({
      tetrioPlayer.userId: [tetrioPlayer]
    }.entries);
    _tetrioStreamController.add(_players);
  }

  Future<void> addPlayerToTrack(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }
    db.insert(tetrioUsersToTrackTable, {idCol: tetrioPlayer.userId});
  }

  Future<bool> isPlayerTracking(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    return results.isNotEmpty;
  }

  Future<Iterable<String>> getAllPlayerToTrack() async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final players = await db.query(tetrioUsersToTrackTable);
    developer.log("getAllPlayerToTrack: $players", name: "services/tetrio_crud");
    return players.map((noteRow) => noteRow["id"].toString());
  }

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

  Future<void> storeState(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    try {
      states = _players[tetrioPlayer.userId]!;
    } catch (e) {
      await createPlayer(tetrioPlayer);
      states = await getPlayer(tetrioPlayer.userId);
    }
    bool test = _players[tetrioPlayer.userId]!.last.isSameState(tetrioPlayer);
    if (test == false) states.add(tetrioPlayer);
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      statesJson.addEntries({(e.state.millisecondsSinceEpoch ~/ 1000).toString(): e.toJson()}.entries);
    }
    await db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  Future<void> deleteState(TetrioPlayer tetrioPlayer) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    states = await getPlayer(tetrioPlayer.userId);
    _players[tetrioPlayer.userId]!.removeWhere((element) => element.state == tetrioPlayer.state);
    states = _players[tetrioPlayer.userId]!;
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      statesJson.addEntries({e.state.millisecondsSinceEpoch.toString(): e.toJson()}.entries);
    }
    await db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  Future<List<TetrioPlayer>> getPlayer(String id) async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<TetrioPlayer> states = [];
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (results.isEmpty) {
      return states;
    } else {
      dynamic rawStates = results.first['jsonStates'] as String;
      rawStates = json.decode(rawStates);
      rawStates.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k) * 1000), id, results.first[nickCol] as String)));
      _players.removeWhere((key, value) => key == id);
      _players.addEntries({states.last.userId: states}.entries);
      _tetrioStreamController.add(_players);
      return states;
    }
  }

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
              user = json['data']['user']['_id'];
            } else {
              developer.log("fetchPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
              throw TetrioPlayerNotExist();
            }
            break;
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
            TetrioPlayer player = TetrioPlayer.fromJson(json['data']['user'], DateTime.fromMillisecondsSinceEpoch(json['cache']['cached_at'], isUtc: true), json['data']['user']['_id'], json['data']['user']['username']);
            developer.log("fetchPlayer: $user retrieved and cached", name: "services/tetrio_crud");
            _playersCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = player;
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

  Future<Iterable<Map<String, List<TetrioPlayer>>>> getAllPlayers() async {
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final players = await db.query(tetrioUsersTable);
    Map<String, List<TetrioPlayer>> data = {};
    //developer.log("getAllPlayers: $players", name: "services/tetrio_crud");
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
