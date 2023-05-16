import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
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

class DatabaseAlreadyOpen implements Exception {}
class DatabaseIsNotOpen implements Exception {}
class UnableToGetDocuments implements Exception {}
class CouldNotDeletePlayer implements Exception{}
class TetrioPlayerAlreadyExist implements Exception{}
class TetrioPlayerNotExist implements Exception{}

class TetrioService{
  Database? _db;
  Map<String, List<TetrioPlayer>> _players = {};
  final _tetrioStreamController = StreamController<Map<String, List<TetrioPlayer>>>.broadcast();

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
  }

  Future<void> open() async{
    if (_db != null){
      throw DatabaseAlreadyOpen();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createTetrioUsersTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocuments();
    }
  }

  Future<void> close() async{
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }else{
      await db.close();
      _db = null;
    }
  }

  Future<void> _cachePlayers() async{
    //final allPlayers = await getAllPlayers();
  }

  Future<void> deleteTetrioPlayer({required String id}) async{
    final db = _getDatabaseOrThrow();
    final deletedPlayer = await db.delete(tetrioUsersTable, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if (deletedPlayer != 1){
      throw CouldNotDeletePlayer();
    }
  }

  Future<void> storeUser({required TetrioPlayer tetrioPlayer}) async{
    final db = _getDatabaseOrThrow();
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [tetrioPlayer.userId.toLowerCase()]);
    if(results.isNotEmpty){
      throw TetrioPlayerAlreadyExist();
    }
    final Map<String, String> statesJson = {tetrioPlayer.state.toString(): tetrioPlayer.toJson().toString()};
    db.insert(tetrioUsersTable, {
      idCol: tetrioPlayer.userId,
      nickCol: tetrioPlayer.username,
      statesCol: statesJson
    });
  }

  Future<List<TetrioPlayer>> getUser({required String id}) async{
    final db = _getDatabaseOrThrow();
    List<TetrioPlayer> states = [];
    final results = await db.query(tetrioUsersTable, limit: 1, where: '$idCol = ?', whereArgs: [id.toLowerCase()]);
    if(results.isEmpty){
      throw TetrioPlayerNotExist();
    }else{
      dynamic rawStates = results.first['jsonStates'] as String;
      rawStates = json.decode(rawStates);
      rawStates.forEach((k,v) => states.add(TetrioPlayer.fromJson(v, DateTime.now())));
      return states;
    }
  }
}