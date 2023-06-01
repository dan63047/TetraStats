import 'package:flutter/material.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MaterialApp(
    home: MainView(),
    theme: ThemeData(
        fontFamily: 'Eurostile Round',
        colorScheme: ColorScheme.dark(),
        scaffoldBackgroundColor: Colors.black),
  ));
}
