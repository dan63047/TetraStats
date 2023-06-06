import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
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
    _players = allPlayers.first;
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
    final db = udb.getDatabaseOrThrow();
    List<TetrioPlayer> states = await getPlayer(id: tetrioPlayer.userId, udb: udb);
    states.add(tetrioPlayer);
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
      var test = json.decode(row['jsonStates'] as String);
      List<TetrioPlayer> states = [];
      test.forEach((k, v) => states.add(TetrioPlayer.fromJson(v, DateTime.fromMillisecondsSinceEpoch(int.parse(k)), false)));
      data.addEntries({states.last.userId: states}.entries);
      return data;
    });
  }
}
