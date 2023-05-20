import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:path/path.dart' show join;

const String dbName = "TetraStats.db";
const String tetrioUsersTable = "settings";
const String userTetrioId = "userTetrioId";
const String createSettingsTable = '''
        CREATE TABLE IF NOT EXISTS "settings" (
          "userTetrioId"	TEXT
        )''';

class SettingsService {}
