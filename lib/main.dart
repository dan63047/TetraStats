import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/settings_view.dart';
import 'package:tetra_stats/views/tracked_players_view.dart';
import 'package:tetra_stats/views/calc_view.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  String? locale = prefs.getString("locale");
  if (locale == null){
    LocaleSettings.useDeviceLocale();
  }else{
    LocaleSettings.setLocaleRaw(locale);
  }
  runApp(TranslationProvider(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const MainView(),
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routes: {"/settings": (context) => const SettingsView(), "/states": (context) => const TrackedPlayersView(), "/calc": (context) => const CalcView()},
        theme: ThemeData(
            fontFamily: 'Eurostile Round',
            colorScheme: const ColorScheme.dark(primary: Colors.cyanAccent, secondary: Colors.white),
            scaffoldBackgroundColor: Colors.black
            )
          );
  }
}
