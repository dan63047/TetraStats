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
import 'package:go_router/go_router.dart';

late final PackageInfo packageInfo;
late SharedPreferences prefs;
ColorScheme sheme = const ColorScheme.dark(primary: Colors.cyanAccent, secondary: Colors.white);

void setAccentColor(Color color){ // does this thing work??? yes??? no???
  sheme = ColorScheme.dark(primary: color, secondary: Colors.white);
}

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (_, __) => const MainView(),
      routes: [
         GoRoute(
          path: 'settings',
          builder: (_, __) => const SettingsView(),
        ),
        GoRoute(
          path: 'states',
          builder: (_, __) => const TrackedPlayersView(),
        ),
        GoRoute(
          path: 'calc',
          builder: (_, __) => const CalcView(),
        ),
        GoRoute(
          path: 'customization',
          builder: (_, __) => const CustomizationView(),
        ),
      ]
    ),
    GoRoute( // that one intended for Android users, that can open https://ch.tetr.io/u/ links
      path: "/u/:userId",
      builder: (_, __) => MainView(player: __.pathParameters['userId'])
    )
  ],
);

void main() async {
  // Initializing sqflite
  if (kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initializing funny things
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){ // we can't control windows manager in web and mobile 
    await WindowManager.instance.ensureInitialized(); // Initializing windows manager
    windowManager.waitUntilReadyToShow().then((_) async {
     await windowManager.setTitle('Tetra Stats'); // And setting the windows title
    });
  }

  packageInfo = await PackageInfo.fromPlatform();
  prefs = await SharedPreferences.getInstance();

  // Choosing the locale
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
    return MaterialApp.router(
      title: "Tetra Stats", 
      routerConfig: router,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        fontFamily: 'Eurostile Round',
        colorScheme: sheme,
        scaffoldBackgroundColor: Colors.black
      )
    );
  }
}
