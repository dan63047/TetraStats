import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:tetra_stats/views/settings_view.dart';
import 'package:tetra_stats/views/tracked_players_view.dart';
import 'package:tetra_stats/views/calc_view.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MaterialApp(
      home: const MainView(),
      routes: {
        "/settings": (context) => const SettingsView(),
        "/compare": (context) => const CompareView(),
        "/states": (context) => const StatesView(),
        "/calc": (context) => const CalcView()
      },
      theme: ThemeData(
          fontFamily: 'Eurostile Round',
          colorScheme: const ColorScheme.dark(primary: Colors.cyanAccent, secondary: Colors.purpleAccent),
          scaffoldBackgroundColor: Colors.black)));
}
