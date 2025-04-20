import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:path/path.dart' show join;

const String dbName = "TetraStats.db";

/// Base class for CRUD services. Contains basic functions
class DB {
  Database? _db;

  /// Handles opening of DB and creates tables if they not exist
  Future<void> open() async {
    if (_db != null) {
      // in order to not open DB multiple times
      throw DatabaseAlreadyOpen();
    }
    try {
      String dbPath;
      if (kIsWeb) { // i hate web
        dbPath = dbName;
      } else {
        final docsPath = await getApplicationDocumentsDirectory();
        dbPath = join(docsPath.path, dbName);
      }
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createTetrioUsersTable);
      await db.execute(createTetrioUsersToTrack);
      await db.execute(createTetrioTLRecordsTable);
      await db.execute(createTetrioTLReplayStats);
      await db.execute(createTetrioLeagueTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocuments();
    }
  }

  /// Handles closing of DB
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  /// if we need instance of our DB, it will return it.
  Database getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  /// You can never be too sure. Although we can be 100% sure, that DB is open after executing that function
  Future<void> ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpen {
      // empty
    }
  }

  /// Executes VACUUM command for our DB and returns number of bytes, that was saved with this operation 
  Future<int> compressDB() async{
    await ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    String dbPath;
    if (kIsWeb) {
      dbPath = dbName;
    } else {
      final docsPath = await getApplicationDocumentsDirectory();
      dbPath = join(docsPath.path, dbName);
    }
    var dbFile = File(dbPath);
    var dbStats = await dbFile.stat();
    await db.execute("VACUUM");
    var newDBStats = await dbFile.stat();
    return dbStats.size - newDBStats.size;
  }

  Future<bool> checkImportingDB(File db) async {
    final newDB = await openDatabase(db.path); // TODO: Maybe i should use arguments, that this method provides?
    var usersTable = await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioUsersTable}`);");
    List<String> usersTableRows = [for (Map<String, Object?> row in usersTable) row["name"] as String];
    if (!listEquals(usersTableRows, tetrioUsersTableRows)) return false;
    var usersToTrackTable = await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioUsersToTrackTable}`);");
    List<String> usersToTrackTableRows = [for (Map<String, Object?> row in usersToTrackTable) row["name"] as String];
    if (!listEquals(usersToTrackTableRows, tetrioUsersToTrackTableRows)) return false;
    var leagueMatchesTable = await newDB.rawQuery("PRAGMA table_xinfo(`${tetraLeagueMatchesTable}`);");
    List<String> leagueMatchesTableRows = [for (Map<String, Object?> row in leagueMatchesTable) row["name"] as String];
    if (!listEquals(leagueMatchesTableRows, tetraLeagueMatchesTableRows)) return false;
    var tlReplayStatsTable = await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioTLReplayStatsTable}`);");
    List<String> TLReplayStatsTableRows = [for (Map<String, Object?> row in tlReplayStatsTable) row["name"] as String];
    if (!listEquals(TLReplayStatsTableRows, tetrioTLReplayStatsTableRows)) return false;
    var leagueTable = await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioLeagueTable}`);");
    List<String> leagueTableRows = [for (Map<String, Object?> row in leagueTable) row["name"] as String];
    if (!listEquals(leagueTableRows, tetrioLeagueTableRows)) return false;
    return true;
  }
}
