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
    await _cachePlayers();
  }

  Stream<Map<String, List<TetrioPlayer>>> get allPlayers => _tetrioStreamController.stream;

  Future<void> _cachePlayers() async {
    final allPlayers = await getAllPlayers();
    _players = allPlayers.toList().first; // ???
    _tetrioStreamController.add(_players);
    developer.log("_cachePlayers: $_players", name: "services/tetrio_crud");
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
    if (!_players[tetrioPlayer.userId]!.last.isSameState(tetrioPlayer)) states.add(tetrioPlayer);
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
      rawStates.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k)), false)));
      _players.removeWhere((key, value) => key == id);
      _players.addEntries({states.last.userId: states}.entries);
      _tetrioStreamController.add(_players);
      return states;
    }
  }

  Future<TetrioPlayer> fetchPlayer(String user, bool addToDB) async {
    var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success']) {
        TetrioPlayer player = TetrioPlayer.fromJson(
            jsonDecode(response.body)['data']['user'], DateTime.fromMillisecondsSinceEpoch(jsonDecode(response.body)['cache']['cached_at'], isUtc: true), true);
        if (addToDB) {
          await ensureDbIsOpen();
          storeState(player);
        }
        return player;
      } else {
        developer.log("fetchTetrioPlayer User dosen't exist", name: "services/tetrio_crud", error: response.body);
        throw Exception("User doesn't exist");
      }
    } else {
      developer.log("fetchTetrioPlayer Failed to fetch player", name: "services/tetrio_crud", error: response.statusCode);
      throw Exception('Failed to fetch player');
    }
  }

  // Future<void> _ensureDbIsOpen() async {
  //   try {
  //     await open();
  //   } on DatabaseAlreadyOpen {
  //     // empty
  //   }
  // }

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
      test.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k)), false)));
      data.addEntries({states.last.userId: states}.entries);
      return data;
    });
  }
}
