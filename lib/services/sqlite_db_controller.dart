import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:path/path.dart' show join;

const String dbName = "TetraStats.db";

class DB {
  Database? _db;
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpen();
    }
    try {
      String dbPath;
      if (kIsWeb) {
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
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocuments();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpen {
      // empty
    }
  }

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
}
