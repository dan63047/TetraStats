import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:go_router/go_router.dart';

late final PackageInfo packageInfo;
late SharedPreferences prefs;
late TetrioService teto;
ThemeData theme = ThemeData(
  fontFamily: 'Eurostile Round',
  colorScheme: const ColorScheme.dark(
    primary: Colors.cyanAccent,
    surface: Color.fromARGB(255, 10, 10, 10),
    secondary: Color(0xFF00838F),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42),
    titleSmall: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9, fontWeight: FontWeight.w200),
    headlineMedium: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36),
    displayLarge: TextStyle(fontSize: 18),
  ),
  cardTheme: const CardTheme(surfaceTintColor: Color.fromARGB(255, 10, 10, 10)),
  drawerTheme: const DrawerThemeData(surfaceTintColor: Color.fromARGB(255, 10, 10, 10)),
  searchBarTheme: const SearchBarThemeData(
    shadowColor: WidgetStatePropertyAll(Colors.black),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(12.0), right: Radius.circular(12.0)))),
    elevation: WidgetStatePropertyAll(8.0)
  ),
  chipTheme: const ChipThemeData(
    side: BorderSide(color: Colors.transparent),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.cyanAccent),
      iconColor: const WidgetStatePropertyAll(Colors.cyanAccent),
      shadowColor: WidgetStatePropertyAll(Colors.cyanAccent.shade200),
    )
  ),
  dividerColor: Color.fromARGB(50, 158, 158, 158),
  dividerTheme: DividerThemeData(color: Color.fromARGB(50, 158, 158, 158)),
  expansionTileTheme: ExpansionTileThemeData(
    expansionAnimationStyle: AnimationStyle(curve: Easing.standard, reverseCurve: Easing.standard),
    expandedAlignment: Alignment.bottomCenter,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(textStyle: TextStyle(fontFamily: "Eurostile Round", fontSize: 18)),
  scaffoldBackgroundColor: Colors.black
);

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (_, __) => const MainView(),
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
  Timer.periodic(const Duration(minutes: 5), (Timer timer) { 
    teto.cacheRoutine();
    developer.log("Cache routine complete, next one in ${DateTime.now().add(const Duration(minutes: 5))}", name: "main");
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

  @override
  void initState() {
    setAccentColor(prefs.getInt("accentColor") != null ? Color(prefs.getInt("accentColor")!) : Colors.cyanAccent);
    super.initState();
  }
  
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