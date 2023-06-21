import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';

const String dbName = "TetraStats.db";
const String tetrioUsersTable = "tetrioUsers";
const String tetrioUsersToTrackTable = "tetrioUsersToTrack";
const String tetraLeagueMatchesTable = "tetraLeagueMatches";
const String idCol = "id";
const String nickCol = "nickname";
const String statesCol = "jsonStates";
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

class TetrioService extends DB {
  Map<String, List<TetrioPlayer>> _players = {};
  final Map<String, TetrioPlayer> _playersCache = {};
  final Map<String, Map<String, dynamic>> _recordsCache = {};
  final Map<String, TetraLeagueAlphaStream> _tlStreamsCache = {}; // i'm trying to respect oskware api It should look something like {"cached_until": TetrioPlayer}
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
    _players = allPlayers.toList().first; // ???
    _tetrioStreamController.add(_players);
    developer.log("_loadPlayers: $_players", name: "services/tetrio_crud");
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
    TetrioPlayer player = await getPlayer(id).then((value) => value.last);
    return player.username;
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
    
    var url = Uri.https('ch.tetr.io', 'api/streams/league_userrecent_${userID.toLowerCase().trim()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success']) {
        TetraLeagueAlphaStream stream = TetraLeagueAlphaStream.fromJson(
            jsonDecode(response.body)['data']['records'], userID);
        developer.log("getTLStream: $userID stream retrieved and cached", name: "services/tetrio_crud");
        _tlStreamsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = stream;
        return stream;
      } else {
        developer.log("getTLStream User dosen't exist", name: "services/tetrio_crud", error: response.body);
        throw Exception("User doesn't exist");
      }
    } else {
      developer.log("getTLStream Failed to fetch stream", name: "services/tetrio_crud", error: response.statusCode);
      throw Exception('Failed to fetch player');
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
    
    var url = Uri.https('ch.tetr.io', 'api/users/${userID.toLowerCase().trim()}/records');
    final response = await http.get(url);

    if (response.statusCode == 200) {
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
        developer.log("fetchRecords: $userID stream retrieved and cached", name: "services/tetrio_crud");
        _recordsCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = map;
        return map;
      } else {
        developer.log("fetchRecords User dosen't exist", name: "services/tetrio_crud", error: response.body);
        throw Exception("User doesn't exist");
      }
    } else {
      developer.log("fetchRecords Failed to fetch records", name: "services/tetrio_crud", error: response.statusCode);
      throw Exception('Failed to fetch player');
    }
  }

  Future<void> createPlayer(TetrioPlayer tetrioPlayer) async {
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }
    final Map<String, dynamic> statesJson = {tetrioPlayer.state.millisecondsSinceEpoch.toString(): tetrioPlayer.toJson()};
    db.insert(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)});
    _players.addEntries({
      tetrioPlayer.userId: [tetrioPlayer]
    }.entries);
    _tetrioStreamController.add(_players);
  }

  Future<void> addPlayerToTrack(TetrioPlayer tetrioPlayer) async {
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if (results.isNotEmpty) {
      throw TetrioPlayerAlreadyExist();
    }
    db.insert(tetrioUsersToTrackTable, {idCol: tetrioPlayer.userId});
  }

  Future<bool> isPlayerTracking(String id) async {
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(tetrioUsersToTrackTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (results.isEmpty) {
      return false;
    } else {
      return true;
    }
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
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    try {
      states = await getPlayer(tetrioPlayer.userId);
    } on TetrioPlayerNotExist {
      await createPlayer(tetrioPlayer);
      states = await getPlayer(tetrioPlayer.userId);
    }
    bool test = _players[tetrioPlayer.userId]!.last.isSameState(tetrioPlayer);
    if (test == false) states.add(tetrioPlayer);
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      statesJson.addEntries({e.state.millisecondsSinceEpoch.toString(): e.toJson()}.entries);
    }
    db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  Future<void> deleteState(TetrioPlayer tetrioPlayer) async {
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    states = await getPlayer(tetrioPlayer.userId);
    _players[tetrioPlayer.userId]!.removeWhere((element) => element.state == tetrioPlayer.state);
    states = _players[tetrioPlayer.userId]!;
    final Map<String, dynamic> statesJson = {};
    for (var e in states) {
      statesJson.addEntries({e.state.millisecondsSinceEpoch.toString(): e.toJson()}.entries);
    }
    db.update(tetrioUsersTable, {idCol: tetrioPlayer.userId, nickCol: tetrioPlayer.username, statesCol: jsonEncode(statesJson)},
        where: '$idCol = ?', whereArgs: [tetrioPlayer.userId]);
    _players[tetrioPlayer.userId]!.add(tetrioPlayer);
    _tetrioStreamController.add(_players);
  }

  Future<List<TetrioPlayer>> getPlayer(String id) async {
    ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    List<TetrioPlayer> states = [];
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (results.isEmpty) {
      throw TetrioPlayerNotExist();
    } else {
      dynamic rawStates = results.first['jsonStates'] as String;
      rawStates = json.decode(rawStates);
      rawStates.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k)))));
      _players.removeWhere((key, value) => key == id);
      _players.addEntries({states.last.userId: states}.entries);
      _tetrioStreamController.add(_players);
      return states;
    }
  }

  Future<TetrioPlayer> fetchPlayer(String user) async {
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
    
    var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success']) {
        TetrioPlayer player = TetrioPlayer.fromJson(
            jsonDecode(response.body)['data']['user'], DateTime.fromMillisecondsSinceEpoch(jsonDecode(response.body)['cache']['cached_at'], isUtc: true));
        developer.log("fetchPlayer: $user retrieved and cached", name: "services/tetrio_crud");
        _playersCache[jsonDecode(response.body)['cache']['cached_until'].toString()] = player;
        return player;
      } else {
        developer.log("fetchPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
        throw Exception("User doesn't exist");
      }
    } else {
      developer.log("fetchPlayer Failed to fetch player", name: "services/tetrio_crud", error: response.statusCode);
      throw Exception('Failed to fetch player');
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
      test.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k)))));
      data.addEntries({states.last.userId: states}.entries);
      return data;
    });
  }
}
