import 'dart:async';
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
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createTetrioUsersTable);
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

  Future<void> _ensureDbIsOpen(DB udb) async {
    try {
      await udb.open();
    } on DatabaseAlreadyOpen {
      // empty
    }
  }
}
