import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
// import 'package:path/path.dart' show join;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';

const String dbName = "TetraStats.db";
const String tetrioUsersTable = "tetrioUsers";
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

class TetrioService {
  Map<String, List<TetrioPlayer>> _players = {};
  final _tetrioStreamController = StreamController<Map<String, List<TetrioPlayer>>>.broadcast();

  TetrioService(DB udb) {
    _cachePlayers(udb);
  }

  Future<void> _cachePlayers(DB udb) async {
    final allPlayers = await getAllPlayers(udb: udb);
    _players = allPlayers.toList().first; // ???
    _tetrioStreamController.add(_players);
    developer.log("_cachePlayers: $_players", name: "services/tetrio_crud");
  }

  Future<void> deletePlayer({required String id, required DB udb}) async {
    final db = udb.getDatabaseOrThrow();
    final deletedPlayer = await db.delete(tetrioUsersTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (deletedPlayer != 1) {
      throw CouldNotDeletePlayer();
    } else {
      _players.removeWhere((key, value) => key == id);
      _tetrioStreamController.add(_players);
    }
  }

  // Future <List<TetrioPlayer>> getOrCreatePlayer({required String id}) async {
  //   try{
  //     final player = await getPlayer(id: id);
  //     return player;
  //   } on TetrioPlayerNotExist{

  //     final player = await createPlayer(tetrioPlayer: tetrioPlayer)
  //   }
  // }

  Future<void> createPlayer({required TetrioPlayer tetrioPlayer, required DB udb}) async {
    _ensureDbIsOpen(udb);
    final db = udb.getDatabaseOrThrow();
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

  Future<void> storeState(TetrioPlayer tetrioPlayer, DB udb) async {
    _ensureDbIsOpen(udb);
    final db = udb.getDatabaseOrThrow();
    late List<TetrioPlayer> states;
    try {
      states = await getPlayer(id: tetrioPlayer.userId, udb: udb);
    } on TetrioPlayerNotExist {
      await createPlayer(tetrioPlayer: tetrioPlayer, udb: udb);
      states = await getPlayer(id: tetrioPlayer.userId, udb: udb);
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

  Future<List<TetrioPlayer>> getPlayer({required String id, required DB udb}) async {
    _ensureDbIsOpen(udb);
    final db = udb.getDatabaseOrThrow();
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

  Future<TetrioPlayer> fetchPlayer(String user, DB udb, bool addToDB) async {
    var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success']) {
        TetrioPlayer player = TetrioPlayer.fromJson(
            jsonDecode(response.body)['data']['user'], DateTime.fromMillisecondsSinceEpoch(jsonDecode(response.body)['cache']['cached_at'], isUtc: true), true);
        if (addToDB) {
          _ensureDbIsOpen(udb);
          storeState(player, udb);
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

  Future<void> _ensureDbIsOpen(DB udb) async {
    try {
      await udb.open();
    } on DatabaseAlreadyOpen {
      // empty
    }
  }

  Future<Iterable<Map<String, List<TetrioPlayer>>>> getAllPlayers({required DB udb}) async {
    await _ensureDbIsOpen(udb);
    final db = udb.getDatabaseOrThrow();
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
