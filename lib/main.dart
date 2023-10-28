import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/views/customization_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/settings_view.dart';
import 'package:tetra_stats/views/tracked_players_view.dart';
import 'package:tetra_stats/views/calc_view.dart';

late final PackageInfo packageInfo;
late SharedPreferences prefs;
ColorScheme sheme = ColorScheme.dark(primary: Colors.cyanAccent, secondary: Colors.white);

void setAccentColor(Color color){
    sheme = ColorScheme.dark(primary: color, secondary: Colors.white);
}

void main() async {
  if (kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
     await windowManager.setTitle('Tetra Stats');
    });
  }
  packageInfo = await PackageInfo.fromPlatform();
  prefs = await SharedPreferences.getInstance();
  String? locale = prefs.getString("locale");
  if (locale == null){
    LocaleSettings.useDeviceLocale();
  }else{
    LocaleSettings.setLocaleRaw(locale);
  }
  runApp(TranslationProvider(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Tetra Stats", 
        home: const MainView(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
        ),
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routes: {"/settings": (context) => const SettingsView(), "/states": (context) => const TrackedPlayersView(), "/calc": (context) => const CalcView(), "/customization": (context) => const CustomizationView()},
        theme: ThemeData(
            fontFamily: 'Eurostile Round',
            colorScheme: sheme,
            scaffoldBackgroundColor: Colors.black
            )
          );
  }
}
