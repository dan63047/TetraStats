import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:path/path.dart' show join;

const String dbName = "TetraStats.db";

/// Base class for CRUD services. Contains basic functions
class DB {
  Database? _db;

  /// Current version of the DB schema
  static const int dbSchemaVersion = 1;

  /// Handles opening of DB, runs pending migrations and creates tables if they not exist
  Future<void> open() async {
    if (_db != null) {
      // in order to not open DB multiple times
      throw DatabaseAlreadyOpen();
    }
    try {
      String dbPath;
      if (kIsWeb) {
        // i hate web
        dbPath = dbName;
      } else {
        final docsPath = await getApplicationDocumentsDirectory();
        dbPath = join(docsPath.path, dbName);
      }
      final db = await openDatabase(dbPath);
      _db = db;
      await _migrate(db);
      await db.execute(createTetrioUsersTable);
      await db.execute(createTetrioUsersToTrack);
      await db.execute(createTetrioTLRecordsTable);
      await db.execute(createTetrioTLReplayStats);
      await db.execute(createTetrioLeagueTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocuments();
    }
  }

  /// Runs pending schema migrations, tracked by the `user_version` pragma.
  Future<void> _migrate(Database db) async {
    final version =
        (await db.rawQuery("PRAGMA user_version")).first["user_version"] as int;
    if (version < 1) {
      await _migrateToV1(db);
    }
    if (version < dbSchemaVersion) {
      await db.execute("PRAGMA user_version = $dbSchemaVersion");
    }
  }

  /// v1: adds the [tsCol] column to [tetrioLeagueTable] and strips the
  /// hex timestamp suffix from "id", which now stores only the user id.
  Future<void> _migrateToV1(Database db) async {
    // fresh databases have no table to migrate, and a table that already
    // has [tsCol] means a previous run finished but didn't bump user_version
    final oldCols =
        await db.rawQuery("PRAGMA table_info(${tetrioLeagueTable})");
    if (oldCols.isEmpty) return;
    if (oldCols.any((col) => col["name"] == tsCol)) return;
    const newTable = "tetrioLeague_new";
    final batch = db.batch();
    // cleans up a half-finished previous run
    batch.execute('DROP TABLE IF EXISTS "$newTable"');
    batch.execute('''
        CREATE TABLE "$newTable" (
          "id"	TEXT NOT NULL,
          "ts"	INTEGER NOT NULL DEFAULT 0,
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
          PRIMARY KEY("id", "ts")
        )''');
    final oldRows = await db.query(tetrioLeagueTable);
    for (final row in oldRows) {
      final fullId = row["id"] as String;
      int ts = 0;
      if (fullId.length > 24) {
        try {
          ts = int.parse(fullId.substring(24), radix: 16);
        } on FormatException {
          // unparseable timestamp suffix, leave ts = 0
        }
      }
      final newRow = Map<String, dynamic>.from(row);
      newRow["id"] = fullId.length >= 24 ? fullId.substring(0, 24) : fullId;
      newRow["ts"] = ts;
      batch.insert(newTable, newRow);
    }
    batch.execute('DROP TABLE "$tetrioLeagueTable"');
    batch.execute('ALTER TABLE "$newTable" RENAME TO "$tetrioLeagueTable"');
    await batch.commit();
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
  Future<int> compressDB() async {
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

  /// Returns true if the file is a backup of our DB. Accepts both the
  /// current schema and the pre-v1 one, which gets migrated on import.
  Future<bool> checkImportingDB(File db) async {
    try {
      final newDB = await openDatabase(db.path);
      try {
        var usersTable =
            await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioUsersTable}`);");
        List<String> usersTableRows = [
          for (Map<String, Object?> row in usersTable) row["name"] as String
        ];
        if (!listEquals(usersTableRows, tetrioUsersTableRows)) return false;
        var usersToTrackTable = await newDB
            .rawQuery("PRAGMA table_xinfo(`${tetrioUsersToTrackTable}`);");
        List<String> usersToTrackTableRows = [
          for (Map<String, Object?> row in usersToTrackTable)
            row["name"] as String
        ];
        if (!listEquals(usersToTrackTableRows, tetrioUsersToTrackTableRows))
          return false;
        var leagueMatchesTable = await newDB
            .rawQuery("PRAGMA table_xinfo(`${tetraLeagueMatchesTable}`);");
        List<String> leagueMatchesTableRows = [
          for (Map<String, Object?> row in leagueMatchesTable)
            row["name"] as String
        ];
        if (!listEquals(leagueMatchesTableRows, tetraLeagueMatchesTableRows))
          return false;
        var tlReplayStatsTable = await newDB
            .rawQuery("PRAGMA table_xinfo(`${tetrioTLReplayStatsTable}`);");
        List<String> TLReplayStatsTableRows = [
          for (Map<String, Object?> row in tlReplayStatsTable)
            row["name"] as String
        ];
        if (!listEquals(TLReplayStatsTableRows, tetrioTLReplayStatsTableRows))
          return false;
        var leagueTable =
            await newDB.rawQuery("PRAGMA table_xinfo(`${tetrioLeagueTable}`);");
        List<String> leagueTableRows = [
          for (Map<String, Object?> row in leagueTable) row["name"] as String
        ];
        // old backups don't have the [tsCol] column yet, they get migrated on import
        if (!listEquals(leagueTableRows, tetrioLeagueTableRows) &&
            !listEquals(leagueTableRows, tetrioLeagueTableRowsV0)) return false;
        return true;
      } finally {
        await newDB.close();
      }
    } catch (_) {
      // not a valid sqlite file
      return false;
    }
  }

  /// Imports a backup file: closes the current DB, copies the backup to a
  /// temporary file, runs pending migrations on the copy (so old backups
  /// without the [tsCol] column get upgraded) and swaps it in as the app's DB.
  Future<void> importBackup(File newDB) async {
    if (kIsWeb) throw UnsupportedError("importBackup is not supported on web");
    await close();
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, dbName);
    final tmp = File(join(docsPath.path, "$dbName.tmp"));
    try {
      await newDB.copy(tmp.path);
      final tmpDB = await openDatabase(tmp.path);
      try {
        await _migrate(tmpDB);
      } finally {
        await tmpDB.close();
      }
      final bytes = await tmp.readAsBytes();
      await File(dbPath).writeAsBytes(bytes);
    } finally {
      if (await tmp.exists()) await tmp.delete();
    }
    await open();
  }
}
