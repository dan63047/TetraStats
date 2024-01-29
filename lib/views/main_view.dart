// ignore_for_file: type_literal_in_constant_pattern

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/main.dart' show prefs;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/ranks_averages_view.dart' show RankAveragesView;
import 'package:tetra_stats/views/tl_leaderboard_view.dart' show TLLeaderboardView;
import 'package:tetra_stats/views/tl_match_view.dart' show TlMatchResultView;
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

Future<List> me = Future.delayed(const Duration(seconds: 60), () => [null, null, null, null, null, null]); // I love lists shut up
String _searchFor = "6098518e3d5155e6ec429cdc"; // who we looking for
String _titleNickname = "dan63047";
final TetrioService teto = TetrioService(); // thing, that manadge our local DB
/// Each dropdown menu item contains list of dots for the graph
var chartsData = <DropdownMenuItem<List<FlSpot>>>[];
int _chartsIndex = 0;
List _historyShortTitles = ["TR", "Glicko", "RD", "APM", "PPS", "VS", "APP", "DS/S", "DS/P", "APP + DS/P", "VS/APM", "Cheese", "GbE", "wAPP", "Area", "eTR", "±eTR", "Opener", "Plonk", "Inf. DS", "Stride"];
late ScrollController _scrollController;
final NumberFormat _timeInSec = NumberFormat("#,###.###s.");
final NumberFormat secs = NumberFormat("00.###");
final NumberFormat _f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
final NumberFormat _f4 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 4);
final DateFormat _dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
final List<Shadow> textShadow = <Shadow>[ // man i love this shadow
  const Shadow(offset: Offset(0.0, 0.0), blurRadius: 3.0, color: Colors.black),
  const Shadow(offset: Offset(0.0, 0.0), blurRadius: 8.0, color: Colors.black),
];


class MainView extends StatefulWidget {
  final String? player;
  /// The very first view, that user see when he launch this programm.
  /// By default it loads my or defined in preferences user stats, but
  /// if [player] username or id provided, it loads his stats. Also it hides menu drawer and three dots menu.
  const MainView({super.key, this.player});

  String get title => "Tetra Stats: $_titleNickname";

  @override
  State<MainView> createState() => _MainState();
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

/// Takes number of [microseconds] and returns readable 40 lines time
String get40lTime(int microseconds){
  return microseconds > 60000000 ? "${(microseconds/1000000/60).floor()}:${(secs.format(microseconds /1000000 % 60))}" : _timeInSec.format(microseconds / 1000000);
  }

class _MainState extends State<MainView> with TickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  bool _showSearchBar = false;
  late TabController _tabController;
  late bool fixedScroll;

  Widget _searchTextField() {
    return TextField(
      maxLength: 25,
      autocorrect: false,
      enableSuggestions: false,
      decoration: const InputDecoration(counter: Offstage()),
      style: TextStyle(shadows: textShadow),
      onSubmitted: (String value) {
        changePlayer(value);
      },
    );
  }

  @override
  void initState() {
    initDB();
    _scrollController = ScrollController();
    _tabController = TabController(length: 6, vsync: this);
    
    // We need to show something
    if (widget.player != null){ // if we have user input,
      changePlayer(widget.player!); // it's gonna be user input
    }else{
      _getPreferences() // otherwise, checking for preferences
        .then((value) => changePlayer(prefs.getString("player") ?? "dan63047")); // no preferences - loading me
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// That function initiate search of data about [player]. If [fetchHistory] is true,
  /// also attempting to retrieve players history. Can trow an Exception if fails
  void changePlayer(String player, {bool fetchHistory = false}) {
    setState(() {
      _searchFor = player;
      me = fetch(_searchFor, fetchHistory: fetchHistory);
    });
  }

  void initDB() async{
    await teto.open();
  }
  
  /// Retrieves data from 3 different Tetra Channel API endpoints + 1 endpoint from p1nkl0bst3r's API
  /// using [nickOrID] of player. If [fetchHistory] is true, also retrieves players history from p1nkl0bst3r's API.
  /// 
  /// Returns list which contains players object, his TL records, previous states, TL matches, previos TL state, if player tracked (bool), news entries and topTR.
  /// 
  /// If at least one request to some endpoint fails, whole function will throw an exception.
  /// TODO: Change this behavior
  Future<List> fetch(String nickOrID, {bool fetchHistory = false}) async {
    TetrioPlayer me;
    
    // If user trying to search with discord id
    if (nickOrID.startsWith("ds:")){
      me = await teto.fetchPlayer(nickOrID.substring(3), isItDiscordID: true); // we trying to get him with that 
    }else{
      me = await teto.fetchPlayer(nickOrID); // Otherwise it's probably a user id or username
    }
    _searchFor = me.userId; // gonna use user id for next requests

    // Change view title and window title if avaliable
    setState((){_titleNickname = me.username;}); 
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) await windowManager.setTitle(widget.title);

    // Requesting Tetra League (alpha), records, news and top TR of player
    late List<dynamic> requests;
    late TetraLeagueAlphaStream tlStream;
    late Map<String, dynamic> records;
    late List<News> news;
    late double? topTR;
    requests = await Future.wait([ // all at once
      teto.getTLStream(_searchFor),
      teto.fetchRecords(_searchFor),
      teto.fetchNews(_searchFor),
      if (me.tlSeason1.gamesPlayed > 9) teto.fetchTopTR(_searchFor) // can retrieve this only if player has TR
    ]);
    tlStream = requests[0] as TetraLeagueAlphaStream;
    records = requests[1] as Map<String, dynamic>;
    news = requests[2] as List<News>;
    topTR = requests.elementAtOrNull(3) as double?; // No TR - no Top TR

    // Making list of Tetra League matches
    List<TetraLeagueAlphaRecord> tlMatches = [];
    bool isTracking = await teto.isPlayerTracking(me.userId);
    List<TetrioPlayer> states = [];
    TetraLeagueAlpha? compareWith;
    Set<TetraLeagueAlpha> uniqueTL = {};
    tlMatches = tlStream.records;
    if (isTracking){ // if tracked - save data to local DB
      await teto.storeState(me);
      await teto.saveTLMatchesFromStream(tlStream);
    var storedRecords = await teto.getTLMatchesbyPlayerID(me.userId); // get old matches
    for (var match in storedRecords) {
      // add stored match to list only if it missing from retrived ones
      if (!tlMatches.contains(match)) tlMatches.add(match);
    }
    tlMatches.sort((a, b) { // Newest matches gonna be shown at the top of the list
      if(a.timestamp.isBefore(b.timestamp)) return 1;
      if(a.timestamp.isAtSameMomentAs(b.timestamp)) return 0;
      if(a.timestamp.isAfter(b.timestamp)) return -1;
      return 0;
      });
    }

    // Handling history
    if(fetchHistory) await teto.fetchAndsaveTLHistory(_searchFor); // Retrieve if needed
    states.addAll(await teto.getPlayer(me.userId));
    for (var element in states) { // For graphs I need only unique entries
      if (uniqueTL.isNotEmpty && uniqueTL.last != element.tlSeason1) uniqueTL.add(element.tlSeason1);
      if (uniqueTL.isEmpty) uniqueTL.add(element.tlSeason1);
    }
    // Also i need previous Tetra League State for comparison if avaliable
    compareWith = uniqueTL.length >= 2 ? uniqueTL.toList().elementAtOrNull(uniqueTL.length - 2) : null; 

    chartsData = <DropdownMenuItem<List<FlSpot>>>[ // Dumping charts data into dropdown menu items, while cheking if every entry is valid
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.rating)], child: Text(t.statCellNum.tr)),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.glicko!)], child: const Text("Glicko")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.rd!)], child: const Text("Rating Deviation")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.apm != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.apm!)], child: Text(t.statCellNum.apm.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.pps != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.pps!)], child: Text(t.statCellNum.pps.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.vs != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.vs!)], child: Text(t.statCellNum.vs.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.app)], child: Text(t.statCellNum.app.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.dss)], child: Text(t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.dsp)], child: Text(t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.appdsp)], child: const Text("APP + DS/P")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.vsapm)], child: const Text("VS/APM")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.cheese)], child: Text(t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.gbe)], child: Text(t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.nyaapp)], child: Text(t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.nerdStats!.area)], child: Text(t.statCellNum.area.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.estTr != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.estTr!.esttr)], child: Text(t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.esttracc != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.esttracc!)], child: Text(t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "))),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.playstyle!.opener)], child: const Text("Opener")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.playstyle!.plonk)], child: const Text("Plonk")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.playstyle!.infds)], child: const Text("Inf. DS")),
      DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) FlSpot(tl.timestamp.millisecondsSinceEpoch.toDouble(), tl.playstyle!.stride)], child: const Text("Stride")),
    ];
    return [me, records, states, tlMatches, compareWith, isTracking, news, topTR];
  }

  /// Triggers widgets rebuild
  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      drawer: widget.player == null ? NavDrawer(changePlayer) : null, // Side menu hidden if player provided
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2, // 20% of left side of the screen used of Drawer gesture
      appBar: AppBar(
        title: _showSearchBar ? _searchTextField() : Text(widget.title, style: TextStyle(shadows: textShadow)), 
        backgroundColor: Colors.black,
        actions: widget.player == null ? [ // search bar and PopupMenuButton hidden if player provided TODO: Subject to change
          _showSearchBar
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchBar = false;
                  });
                },
                icon: const Icon(Icons.clear),
                tooltip: t.closeSearch,
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _showSearchBar = true;
                  });
                },
                icon: const Icon(Icons.search),
                tooltip: t.openSearch,
              ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: "refresh",
                child: Text(t.refresh),
              ),
              PopupMenuItem(
                value: "history",
                child: Text(t.fetchAndsaveTLHistory),
              ),
              PopupMenuItem(
                value: "/states",
                child: Text(t.showStoredData),
              ),
              PopupMenuItem(
                value: "/calc",
                child: Text(t.statsCalc),
              ),
              PopupMenuItem(
                value: "/settings",
                child: Text(t.settings),
              ),
            ],
            onSelected: (value) {
              switch (value){
                case "refresh":
                  changePlayer(_searchFor);
                  break;
                case "history":
                  changePlayer(_searchFor, fetchHistory: true);
                  break;
                default:
                  context.go(value);
              }
            },
          ),
        ] : null,
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: me,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              case ConnectionState.done:
                //bool bigScreen = MediaQuery.of(context).size.width > 1024;
                if (snapshot.hasData) {
                  List<dynamic> sprintRuns = snapshot.data![1]['sprint'];
                  List<dynamic> blitzRuns = snapshot.data![1]['blitz'];
                  return RefreshIndicator(
                    onRefresh: () {
                      return Future(() => changePlayer(snapshot.data![0].userId));
                    },
                    notificationPredicate: (notification) {
                      // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
                      if (!kIsWeb && (notification is OverscrollNotification || Platform.isIOS)) {
                        return notification.depth == 2;
                      }
                      return notification.depth == 0;
                    },
                    child: NestedScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(
                              child: UserThingy(
                            player: snapshot.data![0],
                            showStateTimestamp: false,
                            setState: _justUpdate,
                          )),
                          SliverToBoxAdapter(
                            child: TabBar(
                              controller: _tabController,
                              padding: const EdgeInsets.all(0.0),
                              isScrollable: true,
                              tabs: [
                                Tab(text: t.tetraLeague),
                                Tab(text: t.tlRecords),
                                Tab(text: t.history),
                                Tab(text: t.sprint),
                                Tab(text: t.blitz),
                                Tab(text: t.other),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          TLThingy(tl: snapshot.data![0].tlSeason1, userID: snapshot.data![0].userId, states: snapshot.data![2], topTR: snapshot.data![7], bot: snapshot.data![0].role == "bot", guest: snapshot.data![0].role == "anon"),
                          _TLRecords(userID: snapshot.data![0].userId, data: snapshot.data![3]),
                          _History(states: snapshot.data![2], update: _justUpdate),
                          _RecordThingy(record: sprintRuns.elementAtOrNull(0)),
                          _RecordThingy(record: blitzRuns.elementAtOrNull(0)),
                          _OtherThingy(zen: snapshot.data![1]['zen'], bio: snapshot.data![0].bio, distinguishment: snapshot.data![0].distinguishment, newsletter: snapshot.data![6],)
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  String errText = "";
                  switch (snapshot.error.runtimeType){
                    case TetrioPlayerNotExist:
                    errText = t.errors.noSuchUser;
                    break;
                    case ConnectionIssue:
                    var err = snapshot.error as ConnectionIssue;
                    errText = t.errors.connection(code: err.code, message: err.message);
                    break;
                    case P1nkl0bst3rForbidden:
                    errText = t.errors.p1nkl0bst3rForbidden;
                    break;
                    case P1nkl0bst3rTooManyRequests:
                    errText = t.errors.p1nkl0bst3rTooManyRequests;
                    break;
                    case P1nkl0bst3rInternalProblem:
                    errText = kIsWeb ? t.errors.p1nkl0bst3rinternalWebVersion : t.errors.p1nkl0bst3rinternal;
                    break;
                    case TetrioHistoryNotExist:
                    errText = t.errors.history;
                    break;
                    case TetrioForbidden:
                    errText = t.errors.forbidden;
                    break;
                    case TetrioTooManyRequests:
                    errText = t.errors.tooManyRequests;
                    break;
                    case TetrioOskwareBridgeProblem:
                    errText = t.errors.oskwareBridge;
                    break;
                    case TetrioInternalProblem:
                    errText = kIsWeb ? t.errors.internalWebVersion : t.errors.internal;
                    break;
                    case ClientException:
                    errText = t.errors.clientException;
                    break;
                    default:
                    errText = snapshot.error.toString();
                  }
                  return Center(child: Text(errText, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center));
                }
                break;
            }
            return const Center(child: Text('default case of FutureBuilder', style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
          },
        ),
      ),
    );
  }
}

class NavDrawer extends StatefulWidget {
  final Function changePlayer;

  /// Thing, that shows from the left side of the view.
  /// Requires [changePlayer] function in order to be able to change players on main view
  const NavDrawer(this.changePlayer, {super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String homePlayerNickname = "Checking...";
  @override
  void initState() {
    super.initState();
    _setHomePlayerNickname(prefs.getString("player"));
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Sets username for home button in NavDrawer.
  /// Accepts [id] or username. If it's not provided, sets my nickname.
  /// Otherwise, sets username or [id] if failed to find
  Future<void> _setHomePlayerNickname(String? id) async {
    if (id != null) {
      try {
        homePlayerNickname = await teto.getNicknameByID(id);
      } on TetrioPlayerNotExist {
        homePlayerNickname = id;
      }
    } else {
      homePlayerNickname = "dan63047";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: teto.allPlayers,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              final allPlayers = (snapshot.data != null)
                  ? snapshot.data as Map<String, List<TetrioPlayer>>
                  : <String, List<TetrioPlayer>>{};
              List<String> keys = allPlayers.keys.toList();
              return NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(
                          child: DrawerHeader(
                              child: Text(t.playersYouTrack, style: const TextStyle(color: Colors.white, fontSize: 25),
                      ))),
                      SliverToBoxAdapter(
                        child: ListTile( // Home button
                          leading: const Icon(Icons.home),
                          title: Text(homePlayerNickname),
                          onTap: () {
                            widget.changePlayer(prefs.getString("player") ?? "dan63047"); // changes player on main view to the one from preferences
                            Navigator.of(context).pop(); // and then NavDrawer closes itself.
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile( // Leaderboard button
                          leading: const Icon(Icons.leaderboard),
                          title: Text(t.tlLeaderboard),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TLLeaderboardView(),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile( // Rank averages button
                          leading: const Icon(Icons.compress),
                          title: Text(t.rankAveragesViewTitle),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RankAveragesView(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(child: Divider())
                    ];
                  },
                  body: ListView.builder( // Builds list of tracked players.
                      itemCount: allPlayers.length,
                      itemBuilder: (context, index) {
                        var i = allPlayers.length-1-index; // Last players in this map are most recent ones, they are gonna be shown at the top.
                        return ListTile(
                          title: Text(allPlayers[keys[i]]?.last.username as String), // Takes last known username from list of states
                          onTap: () {
                            widget.changePlayer(keys[i]); // changes to chosen player
                            Navigator.of(context).pop(); // and closes itself.
                          },
                        );
                      }));
            case ConnectionState.done:
              return const Center(child: Text('done case of StreamBuilder')); // what if that thing breaks?
          }
        },
      ),
    );
  }
}

class _TLRecords extends StatelessWidget {
  final String userID;
  final List<TetraLeagueAlphaRecord> data;

  /// Widget, that displays Tetra League records.
  /// Accepts list of TL records ([data]) and [userID] of player from the view
  const _TLRecords({required this.userID, required this.data});

  @override
  Widget build(BuildContext context) {
      bool bigScreen = MediaQuery.of(context).size.width > 768;
      return ListView( // TODO: Redo using ListView.builder()
        physics: const AlwaysScrollableScrollPhysics(),
        children: (data.isNotEmpty)
            ? [for (var value in data) ListTile(
              leading: Text("${value.endContext.firstWhere((element) => element.userId == userID).points} : ${value.endContext.firstWhere((element) => element.userId != userID).points}",
              style: bigScreen ? const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28) :
              const TextStyle(fontSize: 28)),
              title: Text("vs. ${value.endContext.firstWhere((element) => element.userId != userID).username}"),
              subtitle: Text(_dateFormat.format(value.timestamp)),
              trailing: Table(defaultColumnWidth: const IntrinsicColumnWidth(),
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              columnWidths: const {
                0: FixedColumnWidth(50),
                2: FixedColumnWidth(50),
              },
                children: [
                TableRow(children: [Text(_f2.format(value.endContext.firstWhere((element) => element.userId == userID).secondary), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(_f2.format(value.endContext.firstWhere((element) => element.userId != userID).secondary), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" APM", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
                TableRow(children: [Text(_f2.format(value.endContext.firstWhere((element) => element.userId == userID).tertiary), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(_f2.format(value.endContext.firstWhere((element) => element.userId != userID).tertiary), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" PPS", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
                TableRow(children: [Text(_f2.format(value.endContext.firstWhere((element) => element.userId == userID).extra), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(_f2.format(value.endContext.firstWhere((element) => element.userId != userID).extra), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" VS", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
              ],),
              onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TlMatchResultView(record: value, initPlayerId: userID),
                    ),
                  );},
            )]
            : [Center(child: Text(t.noRecords, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)))],
      );
  }
}

class _History extends StatelessWidget{
  final List<TetrioPlayer> states;
  final Function update;

  /// Widget, that can show history of some stat of the player on the graph.
  /// Requires player [states], which is list of states and function [update], which rebuild widgets
  const _History({required this.states, required this.update});
  
  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return states.isNotEmpty ? 
      Column(
        children: [
          DropdownButton(
                items: chartsData,
                value: chartsData[_chartsIndex].value,
                onChanged: (value) {
                  _chartsIndex = chartsData.indexWhere((element) => element.value == value);
                  update();
                }
              ),
          if(chartsData[_chartsIndex].value!.length > 1) _HistoryChartThigy(data: chartsData[_chartsIndex].value!, yAxisTitle: _historyShortTitles[_chartsIndex], bigScreen: bigScreen, leftSpace: bigScreen? 80 : 45, yFormat: bigScreen? _f2 : NumberFormat.compact(),)
          else Center(child: Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)))
        ],
      )
     : Center(child: Text(t.noHistorySaved, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)));
  }
}

class _HistoryChartThigy extends StatefulWidget{
  final List<FlSpot> data;
  final String yAxisTitle;
  final bool bigScreen;
  final double leftSpace;
  final NumberFormat yFormat;
  
  /// Implements graph for the _History widget. Requires [data] which is a list of dots for the graph. [yAxisTitle] used to keep track of changes.
  /// [bigScreen] tells if screen wide enough, [leftSpace] sets size, reserved for titles on the left from the graph and [yFormat] sets numer format
  /// for left titles
  const _HistoryChartThigy({required this.data, required this.yAxisTitle, required this.bigScreen, required this.leftSpace, required this.yFormat});

  @override
  State<_HistoryChartThigy> createState() => _HistoryChartThigyState();
}

class _HistoryChartThigyState extends State<_HistoryChartThigy> {
  late String previousAxisTitle;
  late double minX;
  late double maxX;
  late double minY;
  late double actualMinY;
  late double maxY;
  late double actualMaxY;
  late double xScale;
  late double yScale;
  String headerTooltip = t.pseudoTooltipHeaderInit;
  String footerTooltip = t.pseudoTooltipFooterInit;
  int hoveredPointId = -1;
  double scaleFactor = 5e2;
  double dragFactor = 7e2;

  @override
  void initState(){
    super.initState();
    minX = widget.data.first.x;
    maxX = widget.data.last.x;
    setMinMaxY();
    previousAxisTitle = widget.yAxisTitle;
    actualMaxY = maxY;
    actualMinY = minY;
    recalculateScales();
  }

  @override
  void dispose(){
    super.dispose();
    actualMinY = 0;
    minY = 0;
}

  /// Calculates and assignes maximum and minimum values in list of dots
  void setMinMaxY(){
    actualMinY = widget.data.reduce((value, element){
      num n = min(value.y, element.y);
      if (value.y == n) {
        return value;
      } else {
        return element;
      }
    }).y;
    actualMaxY = widget.data.reduce((value, element){
      num n = max(value.y, element.y);
      if (value.y == n) {
        return value;
      } else {
        return element;
      }
    }).y;
    minY = actualMinY;
    maxY = actualMaxY;
  }

  /// Calculates and assignes scales, which is difference between maximum and minimum visible axis value
  void recalculateScales(){
    xScale = maxX - minX;
    yScale = maxY - minY;
  }

  /// Accepts [dragUpdDet] and changes minX, maxX, minY, maxY based on that
  void dragHandler(DragUpdateDetails dragUpdDet){
    setState(() {
      // Changing min and max values according to drag delta and considering scales
      minX -= (xScale / dragFactor) * dragUpdDet.delta.dx;
      maxX -= (xScale / dragFactor) * dragUpdDet.delta.dx;
      minY += (yScale / dragFactor) * dragUpdDet.delta.dy;
      maxY += (yScale / dragFactor) * dragUpdDet.delta.dy;

      // If values are out of bounds - putting them back
      if (minX < widget.data.first.x) {
        minX = widget.data.first.x;
        maxX = widget.data.first.x + xScale;
      }
      if (maxX > widget.data.last.x) {
        maxX = widget.data.last.x;
        minX = maxX - xScale;
      }
      if(minY < actualMinY){
        minY = actualMinY;
        maxY = actualMinY + yScale;
      }
      if(maxY > actualMaxY){
        maxY = actualMaxY;
        minY = actualMaxY - yScale;
      }
    });
  }

  /// Accepts scale [details] and changes minX, maxX, minY, maxY in a way to change xScale and yScale.
  /// [graphKey] required for sizes calculations, as well, as [graphStartX] and [graphEndX].
  /// Not used yet, because GestureDetector works like shit
  void scaleHandler(ScaleUpdateDetails details, GlobalKey<State<StatefulWidget>> graphKey, double graphStartX, double graphEndX){
    RenderBox graphBox = graphKey.currentContext?.findRenderObject() as RenderBox;

    // calculating relative position of scale gesture
    Offset graphPosition = graphBox.localToGlobal(Offset.zero);
    // 0 - very left position of graph; 1 - very right position of graph
    double gesturePosRelativeX = (details.focalPoint.dx - graphStartX) / (graphEndX - graphStartX);
    // 0 - very top position of graph; 1 - very bottom position of graph
    double gesturePosRelativeY = (details.focalPoint.dy - graphPosition.dy) / (graphBox.size.height - 30); // size - bottom titles height

    double newMinX, newMaxX, newMinY, newMaxY; // calcutating new values based on gesture and considering scales
    newMinX = minX - (xScale / scaleFactor) * (details.horizontalScale-1) * gesturePosRelativeX;
    newMaxX = maxX + (xScale / scaleFactor) * (details.horizontalScale-1) * (1-gesturePosRelativeX);
    newMinY = minY - (yScale / scaleFactor) * (details.horizontalScale-1) * (1-gesturePosRelativeY);
    newMaxY = maxY + (yScale / scaleFactor) * (details.horizontalScale-1) * gesturePosRelativeY;

    // cancel changes if minimum is more, than maximun 
    if ((newMaxX - newMinX).isNegative) return; 
    if ((newMaxY - newMinY).isNegative) return;

    // apply changes if everything ok + can't go past boundaries
    setState(() {
      minX = max(newMinX, widget.data.first.x);
      maxX = min(newMaxX, widget.data.last.x);
      minY = max(newMinY, actualMinY);
      maxY = min(newMaxY, actualMaxY);
      recalculateScales();
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey graphKey = GlobalKey();
    double xInterval = widget.bigScreen ? max(1, xScale / 6) : max(1, xScale / 3); // how far away xTitles should be between each other
    EdgeInsets padding = widget.bigScreen ? const EdgeInsets.fromLTRB(40, 30, 40, 30) : const EdgeInsets.fromLTRB(0, 40, 16, 48);
    double graphStartX = padding.left+widget.leftSpace;
    double graphEndX = MediaQuery.sizeOf(context).width - padding.right;
    if (previousAxisTitle != widget.yAxisTitle) {
      setMinMaxY();
      recalculateScales();
      previousAxisTitle = widget.yAxisTitle;
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 104,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          RenderBox graphBox = graphKey.currentContext?.findRenderObject() as RenderBox;

          // calculating relative position of pointer
          Offset graphPosition = graphBox.localToGlobal(Offset.zero); 
          // 0 - very left position of graph; 1 - very right position of graph
          double scrollPosRelativeX = (signal.position.dx - graphStartX) / (graphEndX - graphStartX);
          // 0 - very top position of graph; 1 - very bottom position of graph
          double scrollPosRelativeY = (signal.position.dy - graphPosition.dy) / (graphBox.size.height - 30); // size - bottom titles height

          double newMinX, newMaxX, newMinY, newMaxY; // calcutating new values based on pointer position and considering scales
          newMinX = minX - (xScale / scaleFactor) * signal.scrollDelta.dy * scrollPosRelativeX;
          newMaxX = maxX + (xScale / scaleFactor) * signal.scrollDelta.dy * (1-scrollPosRelativeX);
          newMinY = minY - (yScale / scaleFactor) * signal.scrollDelta.dy * (1-scrollPosRelativeY);
          newMaxY = maxY + (yScale / scaleFactor) * signal.scrollDelta.dy * scrollPosRelativeY; 

          // cancel changes if minimum is more, than maximun 
          if ((newMaxX - newMinX).isNegative) return;
          if ((newMaxY - newMinY).isNegative) return;

          // apply changes if everything ok + can't go past boundaries
          setState(() {
            minX = max(newMinX, widget.data.first.x);
            maxX = min(newMaxX, widget.data.last.x);
            minY = max(newMinY, actualMinY);
            maxY = min(newMaxY, actualMaxY);
            recalculateScales();
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent - signal.scrollDelta.dy); // TODO: find a better way to stop scrolling in NestedScrollView
          });
        }
      },
        child:
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: () {
              setState(() {
                minX = widget.data.first.x;
                maxX = widget.data.last.x;
                minY = actualMinY;
                maxY = actualMaxY;
                recalculateScales();
              });
            },
            // TODO: onScaleUpdate:(details) => scaleHandler(details, graphKey, graphStartX, graphEndX),
            // TODO: Figure out wtf is going on with gestures
            // TODO: Somehow highlight touched spot (handleBuiltInTouches breaks getTooltipItems and getTouchedSpotIndicator)
            child: Padding( padding: padding,
            child: Stack(
              children: [
                LineChart(
                  key: graphKey,
                  LineChartData(
                    lineBarsData: [LineChartBarData(spots: widget.data)],
                    clipData: const FlClipData.all(),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(verticalInterval: xInterval),
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    titlesData: FlTitlesData(topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(interval: xInterval, showTitles: true, reservedSize: 30, getTitlesWidget: (double value, TitleMeta meta){
                      return value != meta.min && value != meta.max ? SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).format(DateTime.fromMillisecondsSinceEpoch(value.floor()))),
                      ) : Container();
                    })),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: widget.leftSpace, getTitlesWidget: (double value, TitleMeta meta){
                      return value != meta.min && value != meta.max ? SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(widget.yFormat.format(value)),
                      ) : Container();
                    }))),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: false,
                      touchCallback:(touchEvent, touchResponse) {
                        if (touchEvent is FlPanUpdateEvent){
                            dragHandler(touchEvent.details);
                            return;
                          }
                        if (touchEvent is FlPointerHoverEvent){
                          setState(() {
                          if (touchResponse?.lineBarSpots?.first == null) {
                            hoveredPointId = -1; // not hovering over any point
                          } else {
                            hoveredPointId = touchResponse!.lineBarSpots!.first.spotIndex;
                            headerTooltip = "${_f4.format(touchResponse.lineBarSpots!.first.y)} ${widget.yAxisTitle}";
                            footerTooltip = _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(touchResponse.lineBarSpots!.first.x.floor()));
                          }
                          });
                        }
                        if (touchEvent is FlPointerExitEvent){
                          setState(() {hoveredPointId = -1;});
                        }
                      },
                      )
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: widget.leftSpace),
                    child: Column(
                      children: [
                        AnimatedDefaultTextStyle(style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 24, color: Color.fromARGB(hoveredPointId == -1 ? 100 : 255, 255, 255, 255), shadows: hoveredPointId != -1 ? textShadow : null), duration: Durations.medium1, curve: Curves.elasticInOut, child: Text(headerTooltip)),
                        AnimatedDefaultTextStyle(style: TextStyle(fontFamily: "Eurostile Round", color: Color.fromARGB(hoveredPointId == -1 ? 100 : 255, 255, 255, 255), shadows: hoveredPointId != -1 ? textShadow : null), duration: Durations.medium1, curve: Curves.elasticInOut, child: Text(footerTooltip)),
                      ],
                    ),
                  )
              ],
            ),
            ),
          ),
      )
    );
  }
}

class _RecordThingy extends StatelessWidget {
  final RecordSingle? record;

  /// Widget that displays data from [record]
  const _RecordThingy({required this.record});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: (record != null) ? [
                // show mode title
                if (record!.stream.contains("40l")) Text(t.sprint, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                else if (record!.stream.contains("blitz")) Text(t.blitz, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                
                // show main metric
                if (record!.stream.contains("40l")) Text(get40lTime(record!.endContext!.finalTime.inMicroseconds), style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                else if (record!.stream.contains("blitz")) Text(NumberFormat.decimalPattern().format(record!.endContext!.score), style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                
                // Show rank if presented
                if (record!.rank != null) StatCellNum(playerStat: record!.rank!, playerStatLabel: "Leaderboard Placement", isScreenBig: bigScreen, higherIsBetter: false),
                
                // Show when this record was obtained
                Text(t.obtainDate(date: _dateFormat.format(record!.timestamp!)), textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 16)),
                
                // Show metrics
                Padding(padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceAround,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    clipBehavior: Clip.hardEdge,
                    spacing: 25,
                    children: [
                      if (record!.stream.contains("blitz")) StatCellNum(playerStat: record!.endContext!.level, playerStatLabel: t.statCellNum.level, isScreenBig: bigScreen, higherIsBetter: true),
                      if (record!.stream.contains("blitz")) StatCellNum(playerStat: record!.endContext!.spp, playerStatLabel: t.statCellNum.spp, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true),
                      StatCellNum(playerStat: record!.endContext!.piecesPlaced, playerStatLabel: t.statCellNum.pieces, isScreenBig: bigScreen, higherIsBetter: true),
                      StatCellNum(playerStat: record!.endContext!.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true),
                      if (record!.endContext!.finesse != null) StatCellNum(playerStat: record!.endContext!.finesse!.faults, playerStatLabel: t.statCellNum.finesseFaults, isScreenBig: bigScreen, higherIsBetter: false),
                      if (record!.endContext!.finesse != null) StatCellNum(playerStat: record!.endContext!.finessePercentage * 100, playerStatLabel: t.statCellNum.finessePercentage, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true),
                      StatCellNum(playerStat: record!.endContext!.inputs, playerStatLabel: t.statCellNum.keys, isScreenBig: bigScreen, higherIsBetter: false),
                      StatCellNum(playerStat: record!.endContext!.kpp, playerStatLabel: t.statCellNum.kpp, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: false),
                      StatCellNum(playerStat: record!.endContext!.kps, playerStatLabel: t.statCellNum.kps, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true,),
                    ],
                  ),
                ),

                // List of actions
                Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                  child: SizedBox(width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${t.numOfGameActions.pc}:", style: const TextStyle(fontSize: 24)),
                            Text(record!.endContext!.clears.allClears.toString(), style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${t.numOfGameActions.hold}:", style: const TextStyle(fontSize: 24)),
                            Text(record!.endContext!.holds.toString(), style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${t.numOfGameActions.tspinsTotal}:", style: const TextStyle(fontSize: 24)),
                            Text(record!.endContext!.tSpins.toString(), style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin zero:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinZeros.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin singles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinSingles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin doubles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinDoubles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin triples:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinTriples.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin mini zero:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinMiniZeros.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin mini singles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinMiniSingles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - T-spin mini doubles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.tSpinMiniDoubles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${t.numOfGameActions.lineClears}:", style: const TextStyle(fontSize: 24)),
                            Text(record!.endContext!.lines.toString(), style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - Singles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.singles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - Doubles:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.doubles.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - Triples:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.triples.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(" - Quads:", style: TextStyle(fontSize: 18)),
                            Text(record!.endContext!.clears.quads.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : [ // If no record, show this
                Text(t.noRecord, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28))
              ],
            );
          });
    });
  }
}

class _OtherThingy extends StatelessWidget {
  final TetrioZen? zen;
  final String? bio;
  final Distinguishment? distinguishment;
  final List<News>? newsletter;

  /// Widget, that shows players [distinguishment], [bio], [zen] and [newsletter]
  const _OtherThingy({required this.zen, required this.bio, required this.distinguishment, this.newsletter});

  /// Distinguishment title is not very predictable thing.
  /// Receives [text], which is header and returns sets of widgets for RichText widget
  List<InlineSpan> getDistinguishmentTitle(String? text) {
    // TWC champions don't have header in their distinguishments
    if (distinguishment?.type == "twc") return [const TextSpan(text: "TETR.IO World Champion", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellowAccent))];
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
    if (distinguishment?.type == "twc") return "${distinguishment?.detail} TETR.IO World Championship";
    // In case if it missing for some other reason, return this 
    if (text == null) return "Footer is missing";
    // If everything ok, return as it is
    return text;
  }

  /// Handles [news] entry and returns widget that contains this entry
  ListTile getNewsTile(News news){
    Map<String, String> gametypes = {
      "40l": t.sprint,
      "blitz": t.blitz,
      "5mblast": "5,000,000 Blast"
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
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
                TextSpan(text: news.data["gametype"] == "blitz" ? NumberFormat.decimalPattern().format(news.data["result"]) : get40lTime((news.data["result"]*1000).floor()), style: const TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
          subtitle: Text(_dateFormat.format(news.timestamp)),
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
        subtitle: Text(_dateFormat.format(news.timestamp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: newsletter!.length+1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? Column(
            children: [
              if (distinguishment != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text(t.distinguishment, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28), textAlign: TextAlign.center),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: getDistinguishmentTitle(distinguishment?.header),
                        ),
                      ),
                      Text(getDistinguishmentSubtitle(distinguishment?.footer), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              if (bio != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 48),
                  child: Column(
                    children: [
                      Text(t.bio, style: TextStyle(fontFamily: "Eurostile Round Extended",fontSize: bigScreen ? 42 : 28)),
                      MarkdownBody(data: bio!, styleSheet: MarkdownStyleSheet(textScaleFactor: 1.5, textAlign: WrapAlignment.center)) // Text(bio!, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              if (zen != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text(t.zen, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      Text("${t.statCellNum.level} ${NumberFormat.decimalPattern().format(zen!.level)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Text("${t.statCellNum.score} ${NumberFormat.decimalPattern().format(zen!.score)}", style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              if (newsletter != null && newsletter!.isNotEmpty)
                Text(t.news, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
            ],
          ) : getNewsTile(newsletter![index-1]);          
        },
      );
    });
  }
}
