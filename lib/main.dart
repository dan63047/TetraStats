import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/views/customization_view.dart';
import 'package:tetra_stats/views/ranks_averages_view.dart';
import 'package:tetra_stats/views/sprint_and_blitz_averages.dart';
import 'package:tetra_stats/views/tl_leaderboard_view.dart';
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
late TetrioService teto;
ThemeData theme = ThemeData(fontFamily: 'Eurostile Round', colorScheme: const ColorScheme.dark(primary: Colors.cyanAccent, secondary: Colors.white), scaffoldBackgroundColor: Colors.black);

// Future<dynamic> computeIsolate(Future Function() function) async {
//   final receivePort = ReceivePort();
//   var rootToken = RootIsolateToken.instance!;
//   await Isolate.spawn<_IsolateData>(
//     _isolateEntry,
//     _IsolateData(
//       token: rootToken,
//       function: function,
//       answerPort: receivePort.sendPort,
//     ),
//   );
//   return await receivePort.first;
// }

// void _isolateEntry(_IsolateData isolateData) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
//   final answer = await isolateData.function();
//   isolateData.answerPort.send(answer);
// }

// class _IsolateData {
//   final RootIsolateToken token;
//   final Function function;
//   final SendPort answerPort;

//   _IsolateData({
//     required this.token,
//     required this.function,
//     required this.answerPort,
//   });
// }

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
          routes: [
            GoRoute(
              path: 'customization',
              builder: (_, __) => const CustomizationView(),
            ),
          ]
        ),
        GoRoute(
          path: "leaderboard",
          builder: (_, __) => const TLLeaderboardView(),
          routes: [
            GoRoute(
              path: "LBvalues",
              builder: (_, __) => const RankAveragesView(),
            ),
          ]
        ),
        GoRoute(
          path: "LBvalues",
          builder: (_, __) => const RankAveragesView(),
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
          path: 'sprintAndBlitzAverages',
          builder: (_, __) => const SprintAndBlitzView(),
        )
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
  teto = TetrioService();

  // Choosing the locale
  String? locale = prefs.getString("locale");
  if (locale == null){
    LocaleSettings.useDeviceLocale();
  }else{
    LocaleSettings.setLocaleRaw(locale);
  }

  // I dont want to store old cache
  Timer.periodic(Duration(minutes: 5), (Timer timer) { 
    teto.cacheRoutine();
    developer.log("Cache routine complete, next one in ${DateTime.now().add(Duration(minutes: 5))}", name: "main");
    // if (prefs.getBool("updateInBG") == true) teto.fetchTracked(); // TODO: Somehow avoid doing that in main isolate
  });
  
  runApp(TranslationProvider(
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  
  void setAccentColor(Color color){ // does this thing work??? yes??? no??? 
    setState(() {
      theme = theme.copyWith(colorScheme: theme.colorScheme.copyWith(primary: color));
    });
  }

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
      theme: theme
    );
  }
}
