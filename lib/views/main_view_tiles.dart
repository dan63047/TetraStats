import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/badge.dart';
import 'package:tetra_stats/data_objects/beta_record.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/distinguishment.dart';
import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/news.dart';
import 'package:tetra_stats/data_objects/news_entry.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/filesizes_converter.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/destination_calculator.dart';
import 'package:tetra_stats/views/destination_cutoffs.dart';
import 'package:tetra_stats/views/destination_graphs.dart';
import 'package:tetra_stats/views/destination_home.dart';
import 'package:tetra_stats/views/destination_leaderboards.dart';
import 'package:tetra_stats/views/destination_saved_data.dart';
import 'package:tetra_stats/views/tl_match_view.dart';
import 'package:tetra_stats/views/compare_view_tiles.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/tl_progress_bar.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

// TODO: Refactor it

var fDiff = NumberFormat("+#,###.####;-#,###.####");
late Future<FetchResults> _data;
late Future<News> _newsData;

Future<FetchResults> getData(String searchFor) async {
    TetrioPlayer player;
    try{
      if (searchFor.startsWith("ds:")){
        player = await teto.fetchPlayer(searchFor.substring(3), isItDiscordID: true); // we trying to get him with that 
      }else{
        player = await teto.fetchPlayer(searchFor); // Otherwise it's probably a user id or username
      }
    }on TetrioPlayerNotExist{
      return FetchResults(false, null, [], null, null, null, false, TetrioPlayerNotExist());
    }
    late Summaries summaries;
    late Cutoffs cutoffs;
    late CutoffsTetrio averages;
    try {
      List<dynamic> requests = await Future.wait([
        teto.fetchSummaries(player.userId),
        teto.fetchCutoffsBeanserver(),
        teto.fetchCutoffsTetrio()
      ]);

      summaries = requests[0];
      cutoffs = requests.elementAtOrNull(1);
      averages = requests.elementAtOrNull(2);
    } on Exception catch (e) {
      return FetchResults(false, null, [], null, null, null, false, e);
    }
    List<TetraLeague> states = await teto.getStates(player.userId, season: currentSeason);

    bool isTracking = await teto.isPlayerTracking(player.userId);
    if (isTracking){ // if tracked - save data to local DB
      await teto.storeState(summaries.league);
    }

    return FetchResults(true, player, states, summaries, cutoffs, averages, isTracking, null);
  }

class MainView extends StatefulWidget {
  final String? player;
  /// The very first view, that user see when he launch this programm.
  /// By default it loads my or defined in preferences user stats, but
  /// if [player] username or id provided, it loads his stats. Also it hides menu drawer and three dots menu.
  const MainView({super.key, this.player});

  @override
  State<MainView> createState() => _MainState();
}

enum Page {home, leaderboards, leagueAverages, calculator, settings}
enum Cards {overview, tetraLeague, quickPlay, sprint, blitz}
enum CardMod {info, records, ex, exRecords}
Map<Cards, String> cardsTitles = {
  Cards.overview: "Overview",
  Cards.tetraLeague: t.tetraLeague,
  Cards.quickPlay: t.quickPlay,
  //Cards.quickPlayExpert: "${t.quickPlay} ${t.expert}",
  Cards.sprint: t.sprint,
  Cards.blitz: t.blitz,
  //Cards.other: t.other
};

late ScrollController controller;

class _MainState extends State<MainView> with TickerProviderStateMixin {
  int destination = 0;
  String _searchFor = "6098518e3d5155e6ec429cdc";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    teto.open();
    controller = ScrollController();
    changePlayer(_searchFor);
    super.initState();
  }

  void changePlayer(String player) {
    setState(() {
      _searchFor = player;
      _data = getData(_searchFor);
      _newsData = teto.fetchNews(_searchFor);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  NavigationRailDestination getDestinationButton(IconData icon, String title){
    return NavigationRailDestination(
      icon: Tooltip(
        message: title,
        child: Icon(icon)
      ),
      selectedIcon: Icon(icon),
      label: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SearchDrawer(changePlayer: changePlayer, controller: _searchController),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              child: NavigationRail(
                leading: FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(Icons.search),
                    ),
                trailing: IconButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                destinations: [
                  getDestinationButton(Icons.home, "Home"),
                  getDestinationButton(Icons.data_thresholding_outlined, "Graphs"),
                  getDestinationButton(Icons.leaderboard, "Leaderboards"),
                  getDestinationButton(Icons.compress, "Cutoffs"),
                  getDestinationButton(Icons.calculate, "Calc"),
                  getDestinationButton(Icons.info_outline, "Information"),
                  getDestinationButton(Icons.storage, "Saved Data"),
                  getDestinationButton(Icons.settings, "Settings"),
                ],
                selectedIndex: destination,
                onDestinationSelected: (value) {
                  setState(() {
                    destination = value;
                  });
                },
                ),
                duration: Durations.long4,
                tween: Tween<double>(begin: 0, end: 1),
                curve: Easing.standard,
                builder: (context, value, child) {
                  return Container(
                    transform: Matrix4.translationValues(-80+value*80, 0, 0),
                    child: Opacity(opacity: value, child: child),
                  );
                },
            ),
            Expanded(
              child: switch (destination){
                0 => DestinationHome(searchFor: _searchFor, constraints: constraints, dataFuture: _data, newsFuture: _newsData),
                1 => DestinationGraphs(searchFor: _searchFor, constraints: constraints),
                2 => DestinationLeaderboards(constraints: constraints),
                3 => DestinationCutoffs(constraints: constraints),
                4 => DestinationCalculator(constraints: constraints),
                6 => DestinationSavedData(constraints: constraints),
                7 => DestinationSettings(constraints: constraints),
                _ => Text("Unknown destination $destination")
              },
            )
          ]);
        },
      ));
  }
}

class DestinationSettings extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationSettings({super.key, required this.constraints});

  @override
  State<DestinationSettings> createState() => _DestinationSettings();
}

enum SettingsCardMod{
  general("General"),
  customization("Custonization"),
  database("Local database");

  const SettingsCardMod(this.title);

  final String title;
}

const EdgeInsets descriptionPadding = EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0);

class _DestinationSettings extends State<DestinationSettings> with SingleTickerProviderStateMixin {
  SettingsCardMod mod = SettingsCardMod.general;
  List<DropdownMenuItem<AppLocale>> locales = <DropdownMenuItem<AppLocale>>[];
  String defaultNickname = "Checking...";
  String defaultID = "";
  late bool oskKagariGimmick;
  late bool sheetbotRadarGraphs;
  late int ratingMode;
  late int timestampMode;
  late bool showPositions;
  late bool showAverages;
  late bool updateInBG;
  final TextEditingController _playertext = TextEditingController();
  late AnimationController _defaultNicknameAnimController;
  late Animation _goodDefaultNicknameAnim;
  late Animation _badDefaultNicknameAnim;
  late Animation _defaultNicknameAnim = _goodDefaultNicknameAnim;
  double helperTextOpacity = 0;
  String helperText = "Press Enter to submit";

  @override
  void initState() {
    // if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
    //   windowManager.getTitle().then((value) => oldWindowTitle = value);
    //   windowManager.setTitle("Tetra Stats: ${t.settings}");
    // }
    _defaultNicknameAnimController = AnimationController(
      value: 1.0,
      duration: Durations.extralong4,
      vsync: this,
    );
    _goodDefaultNicknameAnim = new ColorTween(
      begin: Colors.greenAccent,
      end: Colors.grey,
    ).animate(new CurvedAnimation(
      parent: _defaultNicknameAnimController,
      curve: Easing.emphasizedAccelerate,
      //reverseCurve: Cubic(0,.99,.99,1.01)
    ))..addStatusListener((status) {
      if (status.index == 3) setState((){helperText = "Press Enter to submit"; helperTextOpacity = 0;});
    });
    _badDefaultNicknameAnim = new ColorTween(
      begin: Colors.redAccent,
      end: Colors.grey,
    ).animate(new CurvedAnimation(
      parent: _defaultNicknameAnimController,
      curve: Easing.emphasizedAccelerate,
      //reverseCurve: Cubic(0,.99,.99,1.01)
    ))..addStatusListener((status) {
      if (status.index == 3) setState((){helperText = "Press Enter to submit"; helperTextOpacity = 0;});
    });
    _getPreferences();
    super.initState();
  }

  @override
  void dispose(){
    // if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void _getPreferences() {
    showPositions = prefs.getBool("showPositions") ?? false;
    showAverages = prefs.getBool("showAverages") ?? true;
    updateInBG = prefs.getBool("updateInBG") ?? false;
    oskKagariGimmick = prefs.getBool("oskKagariGimmick") ?? true;
    sheetbotRadarGraphs = prefs.getBool("sheetbotRadarGraphs")?? false;
    ratingMode = prefs.getInt("ratingMode") ?? 0;
    timestampMode = prefs.getInt("timestampMode") ?? 0;
    _setDefaultNickname(prefs.getString("player")??"").then((v){setState((){});});
    defaultID = prefs.getString("playerID")??"";
  }

  Future<bool> _setDefaultNickname(String n) async {
    if (n.isNotEmpty) {
      try {
        if (n.length > 16){
          defaultNickname = await teto.getNicknameByID(n);
          await prefs.setString('playerID', n);
        }else{
          TetrioPlayer player = await teto.fetchPlayer(n);
          defaultNickname = player.username;
          await prefs.setString('playerID', player.userId);
        }
        await prefs.setString('player', defaultNickname);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      defaultNickname = "dan63";
      await prefs.setString('player', "dan63");
      await prefs.setString('playerID', "6098518e3d5155e6ec429cdc");
      return true;
    }
    //setState(() {});
  }

  Widget getGeneralSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text(SettingsCardMod.general.title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          )),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Your account in TETR.IO", style: Theme.of(context).textTheme.displayLarge),
                trailing: SizedBox(width: 150.0, child: AnimatedBuilder(
                  animation: _defaultNicknameAnim,
                  builder: (context, child) {
                    return Focus(
                      onFocusChange: (value) {
                        setState((){helperTextOpacity = ((value || helperText != "Press Enter to submit")) ? 1 : 0;});
                      },
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: defaultNickname,
                          helper: AnimatedOpacity(
                            opacity: helperTextOpacity,
                            duration: Durations.long1,
                            curve: Easing.standardDecelerate,
                            child: Text(helperText, style: TextStyle(color: _defaultNicknameAnim.value, height: 0.2))
                          ),
                        ),
                        onSubmitted: (value) {
                          helperText = "Checking...";
                          _setDefaultNickname(value).then((v) {
                            _defaultNicknameAnim = v ? _goodDefaultNicknameAnim : _badDefaultNicknameAnim;
                            _defaultNicknameAnimController.forward(from: 0);
                            setState((){ helperText = v ? "Done!" : "Fuck";});
                          });
                        },
                      ),
                    );
                  },
                )),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("Stats of that player will be loaded initially right after launching this app. By default it loads my (dan63) stats. To change that, enter your nickname here."),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Language", style: Theme.of(context).textTheme.displayLarge),
                trailing: DropdownButton(
                  items: locales,
                  value: LocaleSettings.currentLocale,
                  onChanged: (value){
                    LocaleSettings.setLocale(value!);
                    if(value.languageCode == Platform.localeName.substring(0, 2)){
                      prefs.remove('locale');
                    }else{
                      prefs.setString('locale', value.languageCode);
                    }
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("Tetra Stats was translated on ${locales.length} languages. By default, app will pick your system one or English, if locale of your system isn't avaliable."),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Update data in the background", style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: updateInBG, onChanged: (bool value){
                prefs.setBool("updateInBG", value);
                setState(() {
                  updateInBG = value;
                });
                })
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("If on, Tetra Stats will attempt to retrieve new info once cache expires. Usually that happen every 5 minutes"),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Compare TL stats with rank averages", style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: showAverages, onChanged: (bool value){
                  prefs.setBool("showAverages", value);
                  setState(() {
                    showAverages = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("If on, Tetra Stats will provide additional metrics, which allow you to compare yourself with average player on your rank. The way you'll see it — stats will be highlited with corresponding color, hover over them with cursor for more info."),
              )
            ],
          ),
        ),
        Card(
          surfaceTintColor: Colors.redAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Show position on leaderboard by stats", style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: showPositions, onChanged: (bool value){
                  prefs.setBool("showPositions", value);
                  setState(() {
                    showPositions = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("This can take some time (and traffic) to load, but will allow you to see your position on the leaderboard, sorted by a stat"),
              )
            ],
          ),
        )
      ]
    );
  }

  Widget getCustomizationSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text(SettingsCardMod.customization.title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          )),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Accent color", style: Theme.of(context).textTheme.displayLarge),
                trailing: ColorIndicator(HSVColor.fromColor(Theme.of(context).colorScheme.primary), width: 25, height: 25),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("That color is seen across this app and usually highlites interactive UI elements."),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Timestamps format", style: Theme.of(context).textTheme.displayLarge),
                trailing:  DropdownButton(
                  value: timestampMode,
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(value: 0, child: Text(t.timestampsAbsoluteGMT)),
                    DropdownMenuItem(value: 1, child: Text(t.timestampsAbsoluteLocalTime)),
                    DropdownMenuItem(value: 2, child: Text(t.timestampsRelative))
                  ],
                  onChanged: (dynamic value){
                    prefs.setInt("timestampMode", value);
                    setState(() {
                      timestampMode = value;
                    });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("You can choose, in which way timestamps shows time. By default, they show time in GMT timezone, formatted according to chosen locale, example: ${DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms().format(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19))}."),
              ),
              Padding(
                padding: descriptionPadding,
                child: Text("There is also:\n• Locale formatted in your timezone: ${DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms().format(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19).toLocal())}\n• Relative timestamp: ${relativeDateTime(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19))}"),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Sheetbot-like behavior for radar graphs", style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: sheetbotRadarGraphs, onChanged: (bool value){
                  prefs.setBool("sheetbotRadarGraphs", value);
                  setState(() {
                    sheetbotRadarGraphs = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("Altough it was considered by me, that the way graphs work in SheetBot is not very correct, some people were confused to see, that -0.5 stride dosen't look the way it looks on SheetBot graph. Hence, he we are: if this toggle is on, points on the graphs can appear on the opposite half of the graph if value is negative."),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Osk-Kagari gimmick", style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: oskKagariGimmick, onChanged: (bool value){
                  prefs.setBool("oskKagariGimmick", value);
                  setState(() {
                    oskKagariGimmick = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text("If on, instead of osk's rank, :kagari: will be rendered."),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getDatabaseSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Column(
            children: [
              Text(SettingsCardMod.database.title, style: Theme.of(context).textTheme.titleLarge),
              Divider(),
              FutureBuilder<(int, int, int)>(future: teto.getDatabaseData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData){
                        return RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
                            children: [
                              TextSpan(text: "${bytesToSize(snapshot.data!.$1)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: "of data stored\n"),
                              TextSpan(text: "${intf.format(snapshot.data!.$2)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: "Tetra League records saved\n"),
                              TextSpan(text: "${intf.format(snapshot.data!.$3)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: "Tetra League playerstates saved"),
                            ]
                          )
                        );
                      }
                      if (snapshot.hasError){ return FutureError(snapshot); }
                    }
                  return Text("huh?");
                }
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (){teto.removeDuplicatesFromTLMatches().then((_) => setState((){}));},
                      icon: const Icon(Icons.build),
                      label: Text("Fix"),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0)))))
                    )
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (){teto.compressDB().then((_) => setState((){}));},
                      icon: const Icon(Icons.compress),
                      label: Text("Compress"),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)))))
                    )
                  )
                ],
                )
            ],
          )),
        ),
        Card(
          child: ListTile(
            title: Text("Export Database", style: Theme.of(context).textTheme.displayLarge),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("Import Database", style: Theme.of(context).textTheme.displayLarge),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    if (locales.isEmpty) for (var v in AppLocale.values){
      locales.add(DropdownMenuItem<AppLocale>(
        value: v, child: Text(t.locales[v.languageTag]!)));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 450,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text("Settings", style: Theme.of(context).textTheme.headlineMedium),
                    Spacer()
                  ],
                ),
              ),
              for (SettingsCardMod m in SettingsCardMod.values) Card(
                child: ListTile(
                  title: Text(m.title),
                  trailing: Icon(Icons.arrow_right, color: mod == m ? Colors.white : Colors.grey),
                  onTap: () {
                    setState(() {
                      mod = m;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: widget.constraints.maxWidth - 450 - 80,
          child: SingleChildScrollView(
            child: switch (mod){
              SettingsCardMod.general => getGeneralSettings(),
              SettingsCardMod.customization => getCustomizationSettings(),
              SettingsCardMod.database => getDatabaseSettings(),
            },
          )
        )
      ],
    );
  }
}

class NewsThingy extends StatelessWidget{
  final News news;

  const NewsThingy(this.news, {super.key});

  ListTile getNewsTile(NewsEntry news){
    Map<String, String> gametypes = {
      "40l": t.sprint,
      "blitz": t.blitz,
      "5mblast": "5,000,000 Blast",
      "zenith": "Quick Play",
      "zenithex": "Quick Play Expert",
    };

    // Individuly handle each entry type
    switch (news.type) {
      case "leaderboard":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.leaderboardStart,
              children: [
                TextSpan(text: "№${news.data["rank"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.leaderboardMiddle),
                TextSpan(text: "№${gametypes[news.data["gametype"]]}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
        );
      case "personalbest":
      return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.personalbest,
              children: [
                TextSpan(text: "${gametypes[news.data["gametype"]]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.personalbestMiddle),
                TextSpan(text: switch (news.data["gametype"]){
                  "blitz" => NumberFormat.decimalPattern().format(news.data["result"]),
                  "40l" => get40lTime((news.data["result"]*1000).floor()),
                  "5mblast" => get40lTime((news.data["result"]*1000).floor()),
                  "zenith" => "${f2.format(news.data["result"])} m.",
                  "zenithex" => "${f2.format(news.data["result"])} m.",
                  _ => "unknown"
                },
                style: const TextStyle(fontWeight: FontWeight.bold)
                ),
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/improvement-local.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "badge":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.badgeStart,
              children: [
                TextSpan(text: "${news.data["label"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.badgeEnd)
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/tetrio_badges/${news.data["type"]}.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "rankup":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.rankupStart,
              children: [
                TextSpan(text: t.newsParts.rankupMiddle(r: news.data["rank"].toString().toUpperCase()), style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: t.newsParts.rankupEnd)
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/tetrio_tl_alpha_ranks/${news.data["rank"]}.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "supporter":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.supporterStart,
              children: [
                TextSpan(text: t.newsParts.tetoSupporter, style: const TextStyle(fontWeight: FontWeight.bold))
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/supporter-tag.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      case "supporter_gift":
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Eurostile Round', fontSize: 16, color: Colors.white),
              text: t.newsParts.supporterGiftStart,
              children: [
                TextSpan(text: t.newsParts.tetoSupporter, style: const TextStyle(fontWeight: FontWeight.bold))
              ]
            )
          ),
          subtitle: Text(timestamp(news.timestamp)),
          leading: Image.asset(
            "res/icons/supporter-tag.png",
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("res/icons/kagari.png", height: 64, width: 64);
            },
          ),
        );
      default: // if type is unknown
      return ListTile(
        title: Text(t.newsParts.unknownNews(type: news.type)),
        subtitle: Text(timestamp(news.timestamp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(), 
                Text(t.news, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                const Spacer()
              ]
            ),
            if (news.news.isEmpty) const Center(child: Text("Empty list"))
            else for (NewsEntry entry in news.news) getNewsTile(entry)
          ],
        ),
      ),
    );
  }

}

class DistinguishmentThingy extends StatelessWidget{
  final Distinguishment distinguishment;

  const DistinguishmentThingy(this.distinguishment, {super.key});

  List<InlineSpan> getDistinguishmentTitle(String? text) {
    // TWC champions don't have header in their distinguishments
    if (distinguishment.type == "twc") return [const TextSpan(text: "TETR.IO World Champion", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellowAccent))];
    // In case if it missing for some other reason, return this 
    if (text == null) return [const TextSpan(text: "Header is missing", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent))];
    
    // Handling placeholders for logos
    var exploded = text.split(" "); // wtf PHP reference?
    List<InlineSpan> result = [];
    for (String shit in exploded){
      switch (shit) { // if %% thingy was found, insert svg of icon
        case "%osk%":
          result.add(WidgetSpan(child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset("res/icons/osk.svg", height: 28),
          )));
          break;
        case "%tetrio%":
          result.add(WidgetSpan(child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset("res/icons/tetrio-logo.svg", height: 28),
          )));
          break;
        default: // if not, insert text span
          result.add(TextSpan(text: " $shit", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)));
      }
    }
    return result;
  }

  /// Distinguishment title is barely predictable thing.
  /// Receives [text], which is footer and returns sets of widgets for RichText widget
  String getDistinguishmentSubtitle(String? text){
    // TWC champions don't have footer in their distinguishments
    if (distinguishment.type == "twc") return "${distinguishment.detail} TETR.IO World Championship";
    // In case if it missing for some other reason, return this 
    if (text == null) return "Footer is missing";
    // If everything ok, return as it is
    return text;
  }
  
  Color getCardTint(String type, String detail){
    switch(type){
      case "staff":
        switch(detail){
          case "founder": return const Color(0xAAFD82D4);
          case "kagarin": return const Color(0xAAFF0060);
          case "team": return const Color(0xAAFACC2E);
          case "team-minor": return const Color(0xAAF5BD45);
          case "administrator": return const Color(0xAAFF4E8A);
          case "globalmod": return const Color(0xAAE878FF);
          case "communitymod": return const Color(0xAA4E68FB);
          case "alumni": return const Color(0xAA6057DB);
          default: return theme.colorScheme.surface;
        }
      case "champion":
        switch (detail){
          case "blitz":
          case "40l": return const Color(0xAACCF5F6);
          case "league": return const Color(0xAAFFDB31);
        }
      case "twc": return const Color(0xAAFFDB31);
      default: return theme.colorScheme.surface;
    }
    return theme.colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: getCardTint(distinguishment.type, distinguishment.detail??"null"),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(t.distinguishment, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
              const Spacer()
            ],
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: getDistinguishmentTitle(distinguishment.header),
            ),
          ),
          Text(getDistinguishmentSubtitle(distinguishment.footer), style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class FakeDistinguishmentThingy extends StatelessWidget{
  final bool banned;
  final bool badStanding;
  final bool bot;
  final String? botMaintainers;

  FakeDistinguishmentThingy({super.key, this.banned = false, this.badStanding = false, this.bot = false, this.botMaintainers});

  Color getCardTint(){
    if (banned) return Colors.red;
    if (badStanding) return Colors.redAccent;
    if (bot) return const Color.fromARGB(255, 60, 93, 55);
    return theme.colorScheme.surface;
  }

  InlineSpan getDistinguishmentTitle() {
    String text = "";
    if (banned) text = "banned";
    if (badStanding) text = "bad standing";
    if (bot) text = "bot account";
    return TextSpan(text: text.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white));
  }

  String getDistinguishmentSubtitle(){
    if (banned) return "Bans are placed when TETR.IO rules or terms of service are broken";
    if (badStanding) return "One or more recent bans on record";
    if (bot) return "Operated by $botMaintainers";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: getCardTint(),
      child: Container(
        decoration: banned ? const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Color.fromARGB(171, 244, 67, 54), Color.fromARGB(171, 244, 67, 54)],
            stops: [0.1, 0.9, 0.01],
            tileMode: TileMode.mirror,
            begin: Alignment.topLeft,
            end: AlignmentDirectional(-0.95, -0.95)
          )
        ) : null,
        child: Column(
          children: [
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [getDistinguishmentTitle()],
                ),
              ),
            ),
            Text(getDistinguishmentSubtitle(), style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  
}

class BadgesThingy extends StatelessWidget{
  final List<Badge> badges;

  const BadgesThingy({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Row(
              children: [
                const Text("Badges", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                const Spacer(),
                Text(intf.format(badges.length))
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var badge in badges)
                IconButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(badge.label, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 25,
                                children: [
                                  Image.asset("res/tetrio_badges/${badge.badgeId}.png"),
                                  Text(badge.ts != null
                                      ? t.obtainDate(date: timestamp(badge.ts!))
                                      : t.assignedManualy),
                                ],
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(t.popupActions.ok),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    ),
                    tooltip: badge.label,
                    icon: Image.asset(
                      "res/tetrio_badges/${badge.badgeId}.png",
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBadge&badge=${badge.badgeId}" : "https://tetr.io/res/badges/${badge.badgeId}.png",
                          height: 32,
                          errorBuilder:(context, error, stackTrace) {
                            return Image.asset("res/icons/kagari.png", height: 32, width: 32);
                          }
                        ); 
                      },
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NewUserThingy extends StatefulWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final bool initIsTracking;
  final Function setState;
  
  const NewUserThingy({super.key, required this.player, required this.initIsTracking, required this.showStateTimestamp, required this.setState});

  @override
  State<NewUserThingy> createState() => _NewUserThingyState();
}

class _NewUserThingyState extends State<NewUserThingy> with SingleTickerProviderStateMixin {
  late AnimationController _addToTrackAnimController;
  late Animation _addToTrackAnim;

  @override
  void initState(){
    _addToTrackAnimController = AnimationController(
      value: widget.initIsTracking ? 1.0 : 0.0,
      duration: Durations.extralong4,
      vsync: this,
    );
    _addToTrackAnim = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: _addToTrackAnimController,
      curve: Cubic(.15,-0.40,.86,-0.39),
      reverseCurve: Cubic(0,.99,.99,1.01)
    ));
    
    super.initState();
  }

  @override
  void dispose() {
    _addToTrackAnimController.dispose();
    super.dispose();
  }

  Color roleColor(String role){
    switch (role){
      case "sysop":
        return const Color.fromARGB(255, 23, 165, 133);
      case "admin":
        return const Color.fromARGB(255, 255, 78, 138);
      case "mod":
        return const Color.fromARGB(255, 204, 128, 242);
      case "halfmod":
        return const Color.fromARGB(255, 95, 118, 254);
      case "bot":
        return const Color.fromARGB(255, 60, 93, 55);
      case "banned":
        return const Color.fromARGB(255, 248, 28, 28);
      default:
        return Colors.white10;
    }
  }

  String fontStyle(int length){
    if (length < 10) return "Eurostile Round Extended";
    else if (length < 13) return "Eurostile Round";
    else return "Eurostile Round Condensed";
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      double pfpHeight = 128;
      int xpTableID = 0;

      while (widget.player.xp > xpTableScuffed.values.toList()[xpTableID]) {
        xpTableID++;
      }

      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 960),
                height: widget.player.bannerRevision != null ? 218.0 : 138.0,
                child: Stack(
                //clipBehavior: Clip.none,
                children: [
                  // TODO: osk banner can cause memory leak
                  if (widget.player.bannerRevision != null) FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${widget.player.userId}&rv=${widget.player.bannerRevision}" : "https://tetr.io/user-content/banners/${widget.player.userId}.jpg?rv=${widget.player.bannerRevision}",
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    height: 120,
                    fadeInCurve: Easing.standard, fadeInDuration: Durations.long4
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 90.0 : 10.0,
                    left: 16.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: widget.player.role == "banned"
                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                        : widget.player.avatarRevision != null
                          ? FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${widget.player.userId}&rv=${widget.player.avatarRevision}" : "https://tetr.io/user-content/avatars/${widget.player.userId}.jpg?rv=${widget.player.avatarRevision}",
                            fit: BoxFit.fitHeight, height: 128, placeholder: kTransparentImage, fadeInCurve: Easing.emphasizedDecelerate, fadeInDuration: Durations.long4)
                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                    )
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 120.0 : 40.0,
                    left: 160.0,
                    child: Tooltip(
                      message: "${widget.player.userId}\n(Click to copy user ID)",
                      child: RichText(text: TextSpan(text: widget.player.username, style: TextStyle(
                          fontFamily: fontStyle(widget.player.username.length),
                          fontSize: 28,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                            copyToClipboard(widget.player.userId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copiedToClipboard)));
                          }
                        )
                      ) 
                    ),
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 160.0 : 80.0,
                    left: 160.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Chip(label: Text(widget.player.role.toUpperCase(), style: const TextStyle(shadows: textShadow),), padding: const EdgeInsets.all(0.0), color: WidgetStatePropertyAll(roleColor(widget.player.role))),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontFamily: "Eurostile Round"),
                            children:
                            [
                            if (widget.player.friendCount > 0) const WidgetSpan(child: Icon(Icons.person), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (widget.player.friendCount > 0) TextSpan(text: "${intf.format(widget.player.friendCount)} "),
                            if (widget.player.supporterTier > 0) WidgetSpan(child: Icon(widget.player.supporterTier > 1 ? Icons.star : Icons.star_border, color: widget.player.supporterTier > 1 ? Colors.yellowAccent : Colors.white), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (widget.player.supporterTier > 0) TextSpan(text: widget.player.supporterTier.toString(), style: TextStyle(color: widget.player.supporterTier > 1 ? Colors.yellowAccent : Colors.white)),
                            ] 
                          ) 
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 193.0 : 113.0,
                    left: 160.0,
                    child: SizedBox(
                      width: 270,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: "Eurostile Round"),
                          children: [
                            if (widget.player.country != null) TextSpan(text: "${t.countries[widget.player.country]} • "),
                            TextSpan(text: timestamp(widget.player.registrationTime), style: const TextStyle(color: Colors.grey))
                          ]
                        )
                      ),
                    )
                  ),
                  Positioned(
                    top: widget.player.bannerRevision != null ? 126.0 : 46.0,
                    right: 16.0,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        style: const TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          TextSpan(text: "Level ${(widget.player.level.isNegative || widget.player.level.isNaN) ? "---" : intf.format(widget.player.level.floor())}", style: TextStyle(decoration: (widget.player.level.isNegative || widget.player.level.isNaN) ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: (widget.player.level.isNegative || widget.player.level.isNaN) ? Colors.grey : Colors.white), recognizer: (widget.player.level.isNegative || widget.player.level.isNaN) ? null : TapGestureRecognizer()?..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Level ${intf.format(widget.player.level.floor())}", textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2).format(widget.player.xp)} XP",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontWeight: FontWeight.bold)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: SfLinearGauge(
                                        minimum: 0,
                                        maximum: 1,
                                        interval: 1, 
                                        ranges: [
                                          LinearGaugeRange(startValue: 0, endValue: widget.player.level - widget.player.level.floor(), color: Colors.cyanAccent),
                                          LinearGaugeRange(startValue: 0, endValue: (widget.player.xp / xpTableScuffed.values.toList()[xpTableID]), color: Colors.redAccent, position: LinearElementPosition.cross)
                                          ],
                                        showTicks: true,
                                        showLabels: false
                                        ),
                                    ),
                                    Text("${t.statCellNum.xpProgress}: ${((widget.player.level - widget.player.level.floor()) * 100).toStringAsFixed(2)} %"),
                                    Text("${t.statCellNum.xpFrom0ToLevel(n: xpTableScuffed.keys.toList()[xpTableID])}: ${((widget.player.xp / xpTableScuffed.values.toList()[xpTableID]) * 100).toStringAsFixed(2)} % (${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(xpTableScuffed.values.toList()[xpTableID] - widget.player.xp)} ${t.statCellNum.xpLeft})")
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }),
                          const TextSpan(text:"\n"),
                          TextSpan(text: widget.player.gameTime.isNegative ? "-h --m" : playtime(widget.player.gameTime), style: TextStyle(color: widget.player.gameTime.isNegative ? Colors.grey : Colors.white, decoration: widget.player.gameTime.isNegative ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted), recognizer: !widget.player.gameTime.isNegative ? (TapGestureRecognizer()..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(t.exactGametime, textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${intf.format(widget.player.gameTime.inDays)}d ${nonsecs.format(widget.player.gameTime.inHours%24)}h ${nonsecs.format(widget.player.gameTime.inMinutes%60)}m ${nonsecs.format(widget.player.gameTime.inSeconds%60)}s ${nonsecs3.format(widget.player.gameTime.inMilliseconds%1000)}ms ${nonsecs3.format(widget.player.gameTime.inMicroseconds%1000)}μs",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 24)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("It's ${f4.format(widget.player.gameTime.inSeconds/31536000)} years,"),
                                    ),
                                    Text("${f4.format(widget.player.gameTime.inSeconds/2628000)} monts,"),
                                    Text("${f4.format(widget.player.gameTime.inSeconds/3600)} hours,"),
                                    Text("${f2.format(widget.player.gameTime.inMilliseconds/60000)} minutes,"),
                                    Text("${intf.format(widget.player.gameTime.inSeconds)} seconds"),
                                    ]
                                    ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {Navigator.of(context).pop();}
                                  )  
                                ]
                              )
                            );
                          }) : null),
                          const TextSpan(text:"\n"),
                          TextSpan(text: widget.player.gamesWon > -1 ? intf.format(widget.player.gamesWon) : "---", style: TextStyle(color: widget.player.gamesWon > -1 ? Colors.white : Colors.grey)),
                          TextSpan(text: "/${widget.player.gamesPlayed > -1 ? intf.format(widget.player.gamesPlayed) : "---"}", style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
                        ]
                      )
                    )
                  )
                ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _addToTrackAnim,
                    builder: (context, child) {
                      double firstButtonPosition = 0+(_addToTrackAnim.value as double)*25;
                      double secondButtonPosition = -25+(_addToTrackAnim.value as double)*25;
                      double firstButtonOpacity = 1-(_addToTrackAnim.value as double)*2;
                      double secondButtonOpacity = _addToTrackAnim.value*2-1;
                      return ElevatedButton.icon(
                      onPressed: (){
                        _addToTrackAnimController.value == 1 ? teto.deletePlayerToTrack(widget.player.userId) : teto.addPlayerToTrack(widget.player); 
                        _addToTrackAnim.isCompleted ? _addToTrackAnimController.reverse() : _addToTrackAnimController.forward();
                      },
                      icon: _addToTrackAnim.value < 0.5 ? Opacity(
                        opacity: min(1, firstButtonOpacity),
                        child: Transform.translate(
                          offset: Offset(0, _addToTrackAnim.status == AnimationStatus.forward ? firstButtonPosition*4 : firstButtonPosition),
                          child: Transform.rotate(
                            angle:_addToTrackAnim.status == AnimationStatus.forward ? (_addToTrackAnim.value as double)*2 : 0,
                            child: const Icon(Icons.person_add),
                          ),
                        ),
                      ) : Container(
                        transform: Matrix4.translationValues(secondButtonPosition*5, -secondButtonPosition*25, 0),
                        child: Opacity(
                          opacity: max(0, min(1, secondButtonOpacity)),
                          child: Transform.rotate(
                            angle:_addToTrackAnim.status == AnimationStatus.reverse ? (1-_addToTrackAnim.value as double)*-20 : 0,
                            child: const Icon(Icons.person_remove)
                          )
                        )
                      ),
                      label: _addToTrackAnim.value < 0.5 ? Container(
                        transform: Matrix4.translationValues(0, firstButtonPosition, 0),
                        child: Opacity(
                          opacity: max(min(1, firstButtonOpacity), 0),
                          child: Text(_addToTrackAnimController.isAnimating && _addToTrackAnim.status == AnimationStatus.forward ? "Done!" : "Track")
                        )
                      ) : Container(
                        transform: Matrix4.translationValues(0, secondButtonPosition, 0),
                        child: Opacity(
                          opacity: max(0, min(1, secondButtonOpacity)),
                          child: Text(_addToTrackAnimController.isAnimating && _addToTrackAnim.status == AnimationStatus.reverse ? "Done!             " : "Stop tracking")
                        )
                      ),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))))));
                    },
                  )),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CompareView(widget.player),
                      ),
                      );
                    },
                    icon: const Icon(Icons.balance),
                    label: Text(t.compare),
                    style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)))))
                  )
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

class SearchDrawer extends StatefulWidget{
  final Function changePlayer;
  final TextEditingController controller;
  const SearchDrawer({super.key, required this.changePlayer, required this.controller});

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer>  {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: teto.allPlayers,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
            case ConnectionState.active:
            final allPlayers = (snapshot.data != null)
                ? snapshot.data as Map<String, String>
                : <String, String>{};
            allPlayers.remove(prefs.getString("playerID") ?? "6098518e3d5155e6ec429cdc"); // player from the home button will be delisted
            List<String> keys = allPlayers.keys.toList();
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool value){
                return [
                  SliverToBoxAdapter(
                    child: SearchBar(
                      controller: widget.controller,
                      hintText: "Hello",
                      hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
                      trailing: [
                        IconButton(onPressed: (){setState(() {
                          widget.changePlayer(widget.controller.value.text);
                          Navigator.of(context).pop();
                        });}, icon: const Icon(Icons.search))
                      ],
                      onSubmitted: (value) {
                        setState(() {
                          widget.changePlayer(value);
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                    title: Text(prefs.getString("player") ?? "dan63"),
                    onTap: () {
                      widget.changePlayer(prefs.getString("playerID") ?? "6098518e3d5155e6ec429cdc");
                      Navigator.of(context).pop();
                    },
                  ),
                  )
                ];
              },
              body: ListView.builder( // Builds list of tracked players.
              itemCount: allPlayers.length,
              itemBuilder: (context, index) {
                var i = allPlayers.length-1-index; // Last players in this map are most recent ones, they are gonna be shown at the top.
                return ListTile(
                  title: Text(allPlayers[keys[i]]??keys[i]), // Takes last known username from list of states
                  onTap: () {
                    widget.changePlayer(keys[i]); // changes to chosen player
                    Navigator.of(context).pop(); // and closes itself.
                  },
                );
              })
            );
          }
        }
      )
    );
  }
}

class TetraLeagueThingy extends StatelessWidget{
  final TetraLeague league;
  final TetraLeague? toCompare;
  final Cutoffs? cutoffs;
  final CutoffTetrio? averages;

  const TetraLeagueThingy({super.key, required this.league, this.toCompare, this.cutoffs, this.averages});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      //surfaceTintColor: rankColors[league.rank],
      child: Column(
        children: [
          TLRatingThingy(userID: "w", tlData: league, oldTl: toCompare, showPositions: true),
          TLProgress(
            tlData: league,
            previousRankTRcutoff: cutoffs != null ? cutoffs!.tr[league.rank != "z" ? league.rank : league.percentileRank] : null,
            nextRankTRcutoff: cutoffs != null ? (league.rank != "z" ? league.rank == "x+" : league.percentileRank == "x+") ? 25000 : cutoffs!.tr[ranks.elementAtOrNull(ranks.indexOf(league.rank != "z" ? league.rank : league.percentileRank)+1)] : null,
            previousRankTRcutoffTarget: league.rank != "z" ? rankTargets[league.rank] : null,
            nextRankTRcutoffTarget: (league.rank != "z" && league.rank != "x+") ? rankTargets[ranks.elementAtOrNull(ranks.indexOf(league.rank)+1)] : null,
            previousGlickoCutoff: cutoffs != null ? cutoffs!.glicko[league.rank != "z" ? league.rank : league.percentileRank] : null,
            nextRankGlickoCutoff: cutoffs != null ? (league.rank != "z" ? league.rank == "x+" : league.percentileRank == "x+") ? 25000 : cutoffs!.glicko[ranks.elementAtOrNull(ranks.indexOf(league.rank != "z" ? league.rank : league.percentileRank)+1)] : null,
          ),
          Row(
            // spacing: 25.0,
            // alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        Text(f2.format(league.apm??0.00), textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.apm != null ? getStatColor(league.apm!, averages?.apm, true) : null)),
                        Text(" APM", style: TextStyle(fontSize: 21, color: league.apm != null ? getStatColor(league.apm!, averages?.apm, true) : null)),
                        if (toCompare != null) Text(" (${comparef2.format(league.apm!-toCompare!.apm!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.apm!-toCompare!.apm!)))
                      ]),
                      TableRow(children: [
                        Text(f2.format(league.pps??0.00), textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.pps != null ? getStatColor(league.pps!, averages?.pps, true) : null)),
                        Text(" PPS", style: TextStyle(fontSize: 21, color: league.pps != null ? getStatColor(league.pps!, averages?.pps, true) : null)),
                        if (toCompare != null) Text(" (${comparef2.format(league.pps!-toCompare!.pps!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.pps!-toCompare!.pps!)))
                      ]),
                      TableRow(children: [
                        Text(f2.format(league.vs??0.00), textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.vs != null ? getStatColor(league.vs!, averages?.vs, true) : null)),
                        Text(" VS", style: TextStyle(fontSize: 21, color: league.vs != null ? getStatColor(league.vs!, averages?.vs, true) : null)),
                        if (toCompare != null) Text(" (${comparef2.format(league.vs!-toCompare!.vs!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.vs!-toCompare!.vs!)))
                      ])
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 128.0,
                width: 128.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: SfRadialGauge(
                    backgroundColor: Colors.black,
                    axes: [
                      RadialAxis(
                        minimum: 0.0,
                        maximum: 1.0,
                        radiusFactor: 1.01,
                        showTicks: true,
                        showLabels: false,
                        interval: 0.25,
                        minorTicksPerInterval: 0,
                        ranges:[
                          GaugeRange(startValue: 0, endValue: league.winrate, color: theme.colorScheme.primary)
                        ],
                        annotations: [
                          GaugeAnnotation(widget: Container(child:
                          Text(percentage.format(league.winrate), textAlign: TextAlign.center, style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                          angle: 90,positionFactor: 0.1
                          ),
                          GaugeAnnotation(widget: Container(child:
                          Text(t.statCellNum.winrate, textAlign: TextAlign.center)),
                          angle: 270,positionFactor: 0.4
                          ),
                          if (toCompare != null) GaugeAnnotation(widget: Container(child:
                          Text(comparef2.format((league.winrate-toCompare!.winrate)*100), textAlign: TextAlign.center, style: TextStyle(color: getDifferenceColor(league.winrate-toCompare!.winrate)))),
                          angle: 90,positionFactor: 0.45
                          )
                        ],
                      )
                    ]
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        //Text("APM: ", style: TextStyle(fontSize: 21)),
                        Text(intf.format(league.gamesPlayed), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" Games", style: TextStyle(fontSize: 21)),
                        if (toCompare != null) Text(" (${comparef2.format(league.gamesPlayed-toCompare!.gamesPlayed)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey))
                      ]),
                      TableRow(children: [
                        //Text("PPS: ", style: TextStyle(fontSize: 21)),
                        Text(intf.format(league.gamesWon), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" Won", style: TextStyle(fontSize: 21)),
                        if (toCompare != null) Text(" (${comparef2.format(league.gamesWon-toCompare!.gamesWon)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey))
                      ]),
                      TableRow(children: [
                        //Text("VS: ", style: TextStyle(fontSize: 21)),
                        Tooltip(child: Text("${league.gxe.isNegative ? "---" : f3.format(league.gxe)}", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.standingLocal.isNegative ? Colors.grey : Colors.white)), message: "${f2.format(league.s1tr)}",),
                        Text(" GLIXARE", style: TextStyle(fontSize: 21, color: league.standingLocal.isNegative ? Colors.grey : Colors.white)),
                        if (toCompare != null) Text(" (${comparef.format(league.gxe-toCompare!.gxe)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.standingLocal-toCompare!.standingLocal)))
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NerdStatsThingy extends StatelessWidget{
  final NerdStats nerdStats;
  final NerdStats? oldNerdStats;
  final CutoffTetrio? averages;

  const NerdStatsThingy({super.key, required this.nerdStats, this.oldNerdStats, this.averages});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 256.0,
                  width: 256.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: SfRadialGauge(
                      backgroundColor: Colors.black,
                      axes: [
                        RadialAxis(
                          startAngle: 200,
                          endAngle: 340,
                          minimum: 0.0,
                          maximum: 1.0,
                          radiusFactor: 1.01,
                          showTicks: true,
                          showLabels: false,
                          interval: 0.1,
                          //labelsPosition: ElementsPosition.outside,
                          ranges:[
                            GaugeRange(startValue: 0, endValue: nerdStats.app, color: theme.colorScheme.primary)
                          ],
                          annotations: [
                            GaugeAnnotation(widget: Container(child:
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(fontFamily: "Eurostile Round"),
                                children: [
                                  const TextSpan(text: "APP\n"),
                                  TextSpan(text: f3.format(nerdStats.app), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.app, averages?.nerdStats?.app, true))),
                                  if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.app - oldNerdStats!.app)}", style: TextStyle(color: getDifferenceColor(nerdStats.app - oldNerdStats!.app))),
                                ]
                            ))),
                            angle: 270,positionFactor: 0.5
                            ),
                          ],
                        ),
                        RadialAxis(
                          startAngle: 20,
                          endAngle: 160,
                          isInversed: true,
                          minimum: 1.8,
                          maximum: 2.4,
                          radiusFactor: 1.01,
                          showTicks: true,
                          showLabels: false,
                          interval: 0.1,
                          //labelsPosition: ElementsPosition.outside,
                          ranges:[
                            GaugeRange(startValue: 0, endValue: nerdStats.vsapm, color: theme.colorScheme.primary)
                          ],
                          annotations: [
                            GaugeAnnotation(widget: Container(child:
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(fontFamily: "Eurostile Round"),
                                children: [
                                  const TextSpan(text: "VS/APM\n"),
                                  TextSpan(text: f3.format(nerdStats.vsapm), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.vsapm, averages?.nerdStats?.vsapm, true))),
                                  if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.vsapm - oldNerdStats!.vsapm)}", style: TextStyle(color: getDifferenceColor(nerdStats.vsapm - oldNerdStats!.vsapm))),
                                ]
                            ))),
                            angle: 90,positionFactor: 0.5
                            )
                          ],
                        )
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    runAlignment: WrapAlignment.start,
                    children: [
                      GaugetThingy(value: nerdStats.dss, oldValue: oldNerdStats?.dss, min: 0, max: 1.0, tickInterval: .2, label: "DS/S", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.dss),
                      GaugetThingy(value: nerdStats.dsp, oldValue: oldNerdStats?.dsp, min: 0, max: 1.0, tickInterval: .2, label: "DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.dsp),
                      GaugetThingy(value: nerdStats.appdsp, oldValue: oldNerdStats?.appdsp, min: 0, max: 1.2, tickInterval: .2, label: "APP+DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.appdsp),
                      GaugetThingy(value: nerdStats.cheese, oldValue: oldNerdStats?.cheese, min: -80, max: 80, tickInterval: 40, label: "Cheese", sideSize: 128.0, fractionDigits: 2, moreIsBetter: false),
                      GaugetThingy(value: nerdStats.gbe, oldValue: oldNerdStats?.gbe, min: 0, max: 1.0, tickInterval: .2, label: "GbE", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.gbe),
                      GaugetThingy(value: nerdStats.nyaapp, oldValue: oldNerdStats?.nyaapp, min: 0, max: 1.2, tickInterval: .2, label: "wAPP", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.nyaapp),
                      GaugetThingy(value: nerdStats.area, oldValue: oldNerdStats?.area, min: 0, max: 1000, tickInterval: 100, label: "Area", sideSize: 128.0, fractionDigits: 1, moreIsBetter: true, avgValue: averages?.nerdStats?.area),
                    ],
                  ),
                )
              ]
            ),
          ),
        ],
      )
    );
  } 
}

class EstTrThingy extends StatelessWidget{
  final EstTr estTr;

  const EstTrThingy({super.key, required this.estTr});
  
  @override
  Widget build(BuildContext context) {
    return const Card(
      //child: ,
    );
  }
}

class GraphsThingy extends StatelessWidget{
  final double apm;
  final double pps;
  final double vs;
  final NerdStats nerdStats;
  final Playstyle playstyle;

  const GraphsThingy({super.key, required this.nerdStats, required this.playstyle, required this.apm, required this.pps, required this.vs});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: Graphs(apm, pps, vs, nerdStats, playstyle)),
      ),
    );
  }
  
}

class GaugetThingy extends StatelessWidget{
  final double value;
  final double min;
  final double max;
  final double? oldValue;
  final double? avgValue;
  final bool moreIsBetter;
  final double tickInterval;
  final String label;
  final double sideSize;
  final int fractionDigits;

  GaugetThingy({super.key, required this.value, required this.min, required this.max, this.oldValue, this.avgValue, required this.tickInterval, required this.label, required this.sideSize, required this.fractionDigits, required this.moreIsBetter});

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits);
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: SizedBox(
        height: sideSize,
        width: sideSize,
        child: SfRadialGauge(
          backgroundColor: Colors.black,
          axes: [
            RadialAxis(
              radiusFactor: 1.01,
              minimum: min,
              maximum: max,
              showTicks: true,
              showLabels: false,
              interval: tickInterval,
              //labelsPosition: ElementsPosition.outside,
              ranges:[
                GaugeRange(startValue: 0, endValue: value, color: theme.colorScheme.primary)
              ],
              annotations: [
                GaugeAnnotation(widget: Container(child:
                Text(f.format(value), textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: getStatColor(value, avgValue, moreIsBetter)))),
                angle: 90,positionFactor: 0.10
                ),
                GaugeAnnotation(widget: Container(child:
                Text(label, textAlign: TextAlign.center, style: const TextStyle(height: .9))),
                angle: 270,positionFactor: 0.4
                ),
                if (oldValue != null) GaugeAnnotation(widget: Container(child:
                Text(comparef2.format(value-oldValue!), textAlign: TextAlign.center, style: TextStyle(color: getDifferenceColor(moreIsBetter ? value-oldValue! : oldValue!-value)))),
                angle: 90,positionFactor: 0.45
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}

class ZenithThingy extends StatelessWidget{
  final RecordSingle? zenith;

  const ZenithThingy({super.key, required this.zenith});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: zenith != null ? "${f2.format(zenith!.stats.zenith!.altitude)} m" : "--- m",
                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: zenith != null ? Colors.white : Colors.grey),
                      ),
                    ),
                    if (zenith != null) RichText(
                      text: TextSpan(
                        text: "",
                        style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                        children: [
                          if (zenith!.rank != -1) TextSpan(text: "№ ${intf.format(zenith!.rank)}", style: TextStyle(color: getColorOfRank(zenith!.rank))),
                          if (zenith!.rank != -1) const TextSpan(text: " • "),
                          if (zenith!.countryRank != -1) TextSpan(text: "№ ${intf.format(zenith!.countryRank)} local", style: TextStyle(color: getColorOfRank(zenith!.countryRank))),
                          if (zenith!.countryRank != -1) const TextSpan(text: " • "),
                          TextSpan(text: timestamp(zenith!.timestamp)),
                        ]
                      ),
                    ),
                  ],
                ),
                if (zenith != null && (zenith!.extras as ZenithExtras).mods.isNotEmpty) Container(width: 16.0),
                if (zenith != null && (zenith!.extras as ZenithExtras).mods.isNotEmpty) for (String mod in (zenith!.extras as ZenithExtras).mods) Image.asset("res/icons/${mod}.png", height: 64.0) 
              ],
            ),
            if (zenith != null) Row(
              children: [
                Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        const Text("APM: ", style: TextStyle(fontSize: 21)),
                        Text(f2.format(zenith!.aggregateStats.apm), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      ]),
                      TableRow(children: [
                        const Text("PPS: ", style: TextStyle(fontSize: 21)),
                        Text(f2.format(zenith!.aggregateStats.pps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      ]),
                      TableRow(children: [
                        const Text("VS: ", style: TextStyle(fontSize: 21)),
                        Text(f2.format(zenith!.aggregateStats.vs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      ])
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        Text(intf.format(zenith!.stats.kills), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" KO's", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        Text(f2.format(zenith!.stats.cps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" CPS", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        Text(f2.format(zenith!.stats.zenith!.peakrank), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" Peak CPS", style: TextStyle(fontSize: 21))
                      ])
                    ],
                  ),
                ),
              ),
              ],
            )
          ]
        ),
      )
    );
  }
  
}

class TLRecords extends StatelessWidget {
  final String userID;
  final Function changePlayer;
  final List<BetaRecord> data;
  final bool wasActiveInTL;
  final bool oldMathcesHere;

  /// Widget, that displays Tetra League records.
  /// Accepts list of TL records ([data]) and [userID] of player from the view
  const TLRecords({required this.userID, required this.changePlayer, required this.data, required this.wasActiveInTL, required this.oldMathcesHere});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t.noRecords, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
        if (wasActiveInTL) Text(t.errors.actionSuggestion),
        if (wasActiveInTL) TextButton(onPressed: (){changePlayer(userID, fetchTLmatches: true);}, child: Text(t.fetchAndSaveOldTLmatches))
      ],
    ));
    }
    bool bigScreen = MediaQuery.of(context).size.width >= 768;
    int length = data.length;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      //controller: separateScrollController ? ScrollController() : null,
      itemCount: oldMathcesHere ? length : length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == length) {
          return Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.noOldRecords(n: length), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
            if (wasActiveInTL) Text(t.errors.actionSuggestion),
            if (wasActiveInTL) TextButton(onPressed: (){changePlayer(userID, fetchTLmatches: true);}, child: Text(t.fetchAndSaveOldTLmatches))
          ],
        ));
        }

        var accentColor = data[index].results.leaderboard.firstWhere((element) => element.id == userID).wins > data[index].results.leaderboard.firstWhere((element) => element.id != userID).wins ? Colors.green : Colors.red;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0, 0.05],
            colors: [accentColor, Colors.transparent]
          )
        ),
        child: ListTile(
          leading: Text("${data[index].results.leaderboard.firstWhere((element) => element.id == userID).wins} : ${data[index].results.leaderboard.firstWhere((element) => element.id != userID).wins}",
          style: bigScreen ? const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, shadows: textShadow) : const TextStyle(fontSize: 28, shadows: textShadow)),
          title: Text("vs. ${data[index].results.leaderboard.firstWhere((element) => element.id != userID).username}"),
          subtitle: Text(timestamp(data[index].ts), style: const TextStyle(color: Colors.grey)),
          trailing: TrailingStats(
            data[index].results.leaderboard.firstWhere((element) => element.id == userID).stats.apm,
            data[index].results.leaderboard.firstWhere((element) => element.id == userID).stats.pps,
            data[index].results.leaderboard.firstWhere((element) => element.id == userID).stats.vs,
            data[index].results.leaderboard.firstWhere((element) => element.id != userID).stats.apm,
            data[index].results.leaderboard.firstWhere((element) => element.id != userID).stats.pps,
            data[index].results.leaderboard.firstWhere((element) => element.id != userID).stats.vs,
            ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: data[index], initPlayerId: userID))) //Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: data[index], initPlayerId: userID))),
        ),
      );
    });
  }
}

class TLRatingThingy extends StatelessWidget{
  final String userID;
  final TetraLeague tlData;
  final TetraLeague? oldTl;
  final double? topTR;
  final bool? showPositions;
  final DateTime? lastMatchPlayed;

  const TLRatingThingy({super.key, required this.userID, required this.tlData, this.oldTl, this.topTR, this.lastMatchPlayed, this.showPositions});

  @override
  Widget build(BuildContext context) {
    bool oskKagariGimmick = prefs.getBool("oskKagariGimmick")??true;
    bool bigScreen = MediaQuery.of(context).size.width >= 768;
    String decimalSeparator = f4.symbols.DECIMAL_SEP;
    List<String> formatedTR = f4.format(tlData.tr).split(decimalSeparator);
    List<String> formatedGlicko = tlData.glicko != null ? f4.format(tlData.glicko).split(decimalSeparator) : ["---","--"];
    List<String> formatedPercentile = f4.format(tlData.percentile * 100).split(decimalSeparator);
    //DateTime now = DateTime.now();
    //bool beforeS1end = now.isBefore(seasonEnd);
    //int daysLeft = seasonEnd.difference(now).inDays;
    //int safeRD = min(100, (100 + ((tlData.rd! >= 100 && tlData.decaying) ? 7 : max(0, 7 - (lastMatchPlayed != null ? now.difference(lastMatchPlayed!).inDays : 7))) - daysLeft).toInt());
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        (userID == "5e32fc85ab319c2ab1beb07c" && oskKagariGimmick) // he love her so much, you can't even imagine
            ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
            : Image.asset("res/tetrio_tl_alpha_ranks/${tlData.rank}.png", height: 128),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20, color: Colors.white, height: 0.9),
                children: (tlData.gamesPlayed > 9) ? switch(prefs.getInt("ratingMode")){
                  1 => [
                    TextSpan(text: formatedGlicko[0], style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (formatedGlicko.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedGlicko[1]),
                    TextSpan(text: " Glicko", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                  ],
                  2 => [
                    TextSpan(text: "${t.top} ${formatedPercentile[0]}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (formatedPercentile.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedPercentile[1]),
                    TextSpan(text: " %", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                  ],
                  _ => [
                  TextSpan(text: formatedTR[0], style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                  if (formatedTR.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedTR[1]),
                  TextSpan(text: " TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                ],
                } : [TextSpan(text: "---\n", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28, color: Colors.grey)), TextSpan(text: t.gamesUntilRanked(left: 10-tlData.gamesPlayed), style: const TextStyle(color: Colors.grey, fontSize: 14)),]
              )
            ),
            if (oldTl != null) RichText(
              textAlign: TextAlign.center,
              softWrap: true,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: switch(prefs.getInt("ratingMode")){
                    1 => "${fDiff.format(tlData.glicko! - oldTl!.glicko!)} Glicko",
                    2 => "${fDiff.format(tlData.percentile * 100 - oldTl!.percentile * 100)} %",
                    _ => "${fDiff.format(tlData.tr - oldTl!.tr)} TR"
                  },
                  style: TextStyle(
                      color: getDifferenceColor(switch(prefs.getInt("ratingMode")){
                      1 => tlData.glicko! - oldTl!.glicko!,
                      2 => tlData.percentile - oldTl!.percentile,
                      _ => tlData.tr - oldTl!.tr
                    })
                    ),
                  ),
                  const TextSpan(text: " • ", style: TextStyle(color: Colors.grey)),
                  TextSpan(text: switch(prefs.getInt("ratingMode")){
                    1 => "${fDiff.format(tlData.tr - oldTl!.tr)} TR",
                    _ => "${fDiff.format(tlData.glicko! - oldTl!.glicko!)} Glicko"
                  },
                  style: TextStyle(
                      color: getDifferenceColor(switch(prefs.getInt("ratingMode")){
                      1 => tlData.tr - oldTl!.tr,
                      _ => tlData.glicko! - oldTl!.glicko!
                    })
                    ),
                  ),
                  const TextSpan(text: " • ", style: TextStyle(color: Colors.grey)),
                  TextSpan(
                    text: "${fDiff.format(tlData.rd! - oldTl!.rd!)} RD",
                    style: TextStyle(color: getDifferenceColor(oldTl!.rd! - tlData.rd!))
                  )
                ],
              ),
            ),
            if (tlData.gamesPlayed > 9) Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: prefs.getInt("ratingMode") == 2 ? "${f2.format(tlData.tr)} TR  • % ${t.rank}: ${tlData.percentileRank.toUpperCase()}" : "${t.top} ${f2.format(tlData.percentile * 100)}% (${tlData.percentileRank.toUpperCase()})"),
                      if (tlData.bestRank != "z") const TextSpan(text: " • "),
                      if (tlData.bestRank != "z") TextSpan(text: "${t.topRank}: ${tlData.bestRank.toUpperCase()}"),
                      if (topTR != null) TextSpan(text: " (${f2.format(topTR)} TR)"),
                      TextSpan(text: " • ${prefs.getInt("ratingMode") == 1 ? "${f2.format(tlData.tr)} TR • RD: " : "Glicko: ${tlData.glicko != null ? f2.format(tlData.glicko) : "---"}±"}"),
                      TextSpan(text: f2.format(tlData.rd!), style: tlData.decaying ? TextStyle(color: tlData.rd! > 98 ? Colors.red : Colors.yellow) : null),
                      if (tlData.decaying) WidgetSpan(child: Icon(Icons.trending_up, color: tlData.rd! > 98 ? Colors.red : Colors.yellow,), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                      //if (beforeS1end) tlData.rd! <= safeRD ? TextSpan(text: " (Safe)", style: TextStyle(color: Colors.greenAccent)) : TextSpan(text: " (> ${safeRD} RD !!!)", style: TextStyle(color: Colors.redAccent))
                    ],
                  ),
                ),
              ],
            ),
            if (showPositions == true) RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
              text: "",
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
              children: [
                if (tlData.standing != -1) TextSpan(text: "№ ${intf.format(tlData.standing)}", style: TextStyle(color: getColorOfRank(tlData.standing))),
                if (tlData.standing != -1 || tlData.standingLocal != -1) const TextSpan(text: " • "),
                if (tlData.standingLocal != -1) TextSpan(text: "№ ${intf.format(tlData.standingLocal)} local", style: TextStyle(color: getColorOfRank(tlData.standingLocal))),
                if (tlData.standing != -1 && tlData.standingLocal != -1) const TextSpan(text: " • "),
                TextSpan(text: timestamp(tlData.timestamp)),
              ]
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FutureError extends StatelessWidget{
  final AsyncSnapshot snapshot;

  FutureError(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Durations.medium3,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Easing.standard,
      builder: (context, value, child) {
        return Container(
          transform: Matrix4.translationValues(0, 50-value*50, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Icon(Icons.error_outline, size: 128.0, color: Colors.red, shadows: [
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 30.0, color: Colors.red),
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 80.0, color: Colors.red),
          ]),
          Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(snapshot.stackTrace.toString(), textAlign: TextAlign.left, style: TextStyle(fontFamily: "Monospace")),
          ),
          Spacer()
        ],
      ),
    );
  }
}

class ErrorThingy extends StatelessWidget{
  final FetchResults? data;
  final String? eText;

  ErrorThingy({this.data, this.eText});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.error_outline;
    String errText = eText??"";
    String? subText;
    if (data?.exception != null) switch (data!.exception!.runtimeType){
      case TetrioPlayerNotExist:
      icon = Icons.search_off;
      errText = t.errors.noSuchUser;
      subText = t.errors.noSuchUserSub;
      break;
      case TetrioDiscordNotExist:
      icon = Icons.search_off;
      errText = t.errors.discordNotAssigned;
      subText = t.errors.discordNotAssignedSub;
      case ConnectionIssue:
      var err = data!.exception as ConnectionIssue;
      errText = t.errors.connection(code: err.code, message: err.message);
      break;
      case TetrioForbidden:
      icon = Icons.remove_circle;
      errText = t.errors.forbidden;
      subText = t.errors.forbiddenSub(nickname: 'osk');
      break;
      case TetrioTooManyRequests:
      errText = t.errors.tooManyRequests;
      subText = t.errors.tooManyRequestsSub;
      break;
      case TetrioOskwareBridgeProblem:
      errText = t.errors.oskwareBridge;
      subText = t.errors.oskwareBridgeSub;
      break;
      case TetrioInternalProblem:
      errText = kIsWeb ? t.errors.internalWebVersion : t.errors.internal;
      subText = kIsWeb ? t.errors.internalWebVersionSub : t.errors.internalSub;
      break;
      case ClientException:
      errText = t.errors.clientException;
      break;
      default:
      errText = data!.exception.toString();
    }
    return TweenAnimationBuilder(
      duration: Durations.medium3,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Easing.standard,
      builder: (context, value, child) {
        return Container(
          transform: Matrix4.translationValues(0, 50-value*50, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Icon(icon, size: 128.0, color: Colors.red, shadows: [
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 30.0, color: Colors.red),
            Shadow(offset: Offset(0.0, 0.0), blurRadius: 80.0, color: Colors.red),
          ]),
          Text(errText, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          if (subText != null) Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(subText, textAlign: TextAlign.center),
          ),
          Spacer()
        ],
      ),
    );
  }
}