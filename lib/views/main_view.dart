// ignore_for_file: type_literal_in_constant_pattern, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tetra_stats/data_objects/tetra_stats.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show prefs, teto;
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/views/tl_match_view.dart' show TlMatchResultView;
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/recent_sp_games.dart';
import 'package:tetra_stats/widgets/search_box.dart';
import 'package:tetra_stats/widgets/singleplayer_record.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

int _chartsIndex = 0;
bool _gamesPlayedInsteadOfDateAndTime = false;
late ZoomPanBehavior _zoomPanBehavior;
bool _smooth = false;
List _historyShortTitles = ["TR", "Glicko", "RD", "APM", "PPS", "VS", "APP", "DS/S", "DS/P", "APP + DS/P", "VS/APM", "Cheese", "GbE", "wAPP", "Area", "eTR", "±eTR", "Opener", "Plonk", "Inf. DS", "Stride"];
late ScrollController _scrollController;

class MainView extends StatefulWidget {
  final String? player;
  /// The very first view, that user see when he launch this programm.
  /// By default it loads my or defined in preferences user stats, but
  /// if [player] username or id provided, it loads his stats. Also it hides menu drawer and three dots menu.
  const MainView({super.key, this.player});

  @override
  State<MainView> createState() => _MainState();
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

class _MainState extends State<MainView> with TickerProviderStateMixin {
  Future<List> me = Future.delayed(const Duration(seconds: 60), () => [null, null, null, null, null, null]); // I love lists shut up
  TetrioPlayersLeaderboard? everyone;
  PlayerLeaderboardPosition? meAmongEveryone;
  TetraLeagueAlpha? rankAverages;
  double? thatRankCutoff;
  double? nextRankCutoff;
  double? thatRankGlickoCutoff;
  double? nextRankGlickoCutoff;
  String _searchFor = "6098518e3d5155e6ec429cdc"; // who we looking for
  String _titleNickname = "";
    /// Each dropdown menu item contains list of dots for the graph
  List<DropdownMenuItem<List<_HistoryChartSpot>>> chartsData = [];
  //var tableData = <TableRow>[];
  final bodyGlobalKey = GlobalKey();
  bool _showSearchBar = false;
  Timer backgroundUpdate = Timer(const Duration(days: 365), (){});
  bool _TLHistoryWasFetched = false;
  late TabController _tabController;
  late TabController _wideScreenTabController;

  String get title => "Tetra Stats: $_titleNickname";

  @override
  void initState() {
    initDB();
    _scrollController = ScrollController();
    _tabController = TabController(length: 7, vsync: this);
    _wideScreenTabController = TabController(length: 4, vsync: this);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming : true,
      enablePanning: true,
    );
    // We need to show something
    if (widget.player != null){ // if we have user input,
      changePlayer(widget.player!); // it's gonna be user input
    }else{
      _getPreferences() // otherwise, checking for preferences
        .then((value) => changePlayer(prefs.getString("player") ?? "6098518e3d5155e6ec429cdc")); // no preferences - loading me
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
  void changePlayer(String player, {bool fetchHistory = false, bool fetchTLmatches = false}) {
    setState(() {
      _searchFor = player;
      me = fetch(_searchFor, fetchHistory: fetchHistory, fetchTLmatches: fetchTLmatches);
    });
  }

  void initDB() async{
    await teto.open();
  }
  
  /// Retrieves data from 3 different Tetra Channel API endpoints + 1 endpoint from p1nkl0bst3r's API
  /// using [nickOrID] of player.
  /// 
  /// If [fetchHistory] is true, also retrieves players history from p1nkl0bst3r's API. If [fetchTLmatches] is true, also retrieves players old Tetra League
  /// matches from p1nkl0bst3r's API. Returns list which contains [TetrioPlayer], his records, previous states, TL matches, previous TL state,
  /// if player tracked (bool), news entries and topTR.
  /// 
  /// If at least one request to Tetra Channel API fails, whole function will throw an exception.
  Future<List> fetch(String nickOrID, {bool fetchHistory = false, bool fetchTLmatches = false}) async {
    TetrioPlayer me;
    _TLHistoryWasFetched = false;
    backgroundUpdate.cancel();
    
    // If user trying to search with discord id
    if (nickOrID.startsWith("ds:")){
      me = await teto.fetchPlayer(nickOrID.substring(3), isItDiscordID: true); // we trying to get him with that 
    }else{
      me = await teto.fetchPlayer(nickOrID); // Otherwise it's probably a user id or username
    }
    _searchFor = me.userId; // gonna use user id for next requests

    // Change view title and window title if avaliable
    setState((){_titleNickname = me.username;}); 
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) await windowManager.setTitle(title);

    // Requesting Tetra League (alpha), records, news and top TR of player
    late List<dynamic> requests;
    late TetraLeagueAlphaStream tlStream;
    late UserRecords records;
    late News news;
    late SingleplayerStream recent;
    late SingleplayerStream sprint;
    late SingleplayerStream blitz;
    late TetrioPlayerFromLeaderboard? topOne;
    late TopTr? topTR;
    requests = await Future.wait([ // all at once (7 requests to oskware lmao)
      teto.fetchTLStream(_searchFor),
      teto.fetchRecords(_searchFor),
      teto.fetchNews(_searchFor),
      teto.fetchSingleplayerStream(_searchFor, "any_userrecent"),
      teto.fetchSingleplayerStream(_searchFor, "40l_userbest"),
      teto.fetchSingleplayerStream(_searchFor, "blitz_userbest"),
      prefs.getBool("showPositions") != true ? teto.fetchCutoffs() : Future.delayed(Duration.zero, ()=><Map<String, double>>[]),
      (me.tlSeason1.rank != "z" ? me.tlSeason1.rank == "x" : me.tlSeason1.percentileRank == "x") ? teto.fetchTopOneFromTheLeaderboard() : Future.delayed(Duration.zero, ()=>null),
      (me.tlSeason1.gamesPlayed > 9) ? teto.fetchTopTR(_searchFor) : Future.delayed(Duration.zero, () => null) // can retrieve this only if player has TR
    ]);
    tlStream = requests[0] as TetraLeagueAlphaStream;
    records = requests[1] as UserRecords;
    news = requests[2] as News;
    recent = requests[3] as SingleplayerStream;
    sprint = requests[4] as SingleplayerStream;
    blitz = requests[5] as SingleplayerStream;
    topOne = requests[7] as TetrioPlayerFromLeaderboard?;
    topTR = requests[8] as TopTr?; // No TR - no Top TR

    meAmongEveryone = teto.getCachedLeaderboardPositions(me.userId);
    if (prefs.getBool("showPositions") == true){
      // Get tetra League leaderboard
      everyone = teto.getCachedLeaderboard();
      everyone ??= await teto.fetchTLLeaderboard();
      if (meAmongEveryone == null){
        meAmongEveryone = await compute(everyone!.getLeaderboardPosition, me);
        if (meAmongEveryone != null) teto.cacheLeaderboardPositions(me.userId, meAmongEveryone!); 
      }
    }
    Map<String, double>? cutoffs = prefs.getBool("showPositions") == true ? everyone!.cutoffs : (requests[6] as Cutoffs?)?.tr;
    Map<String, double>? cutoffsGlicko = prefs.getBool("showPositions") == true ? everyone!.cutoffsGlicko : (requests[6] as Cutoffs?)?.glicko;
    
    if (me.tlSeason1.gamesPlayed > 9) {
        thatRankCutoff = cutoffs?[me.tlSeason1.rank != "z" ? me.tlSeason1.rank : me.tlSeason1.percentileRank];
        thatRankGlickoCutoff = cutoffsGlicko?[me.tlSeason1.rank != "z" ? me.tlSeason1.rank : me.tlSeason1.percentileRank];
        nextRankCutoff = (me.tlSeason1.rank != "z" ? me.tlSeason1.rank == "x" : me.tlSeason1.percentileRank == "x") ? topOne?.rating??25000 : cutoffs?[ranks.elementAtOrNull(ranks.indexOf(me.tlSeason1.rank != "z" ? me.tlSeason1.rank : me.tlSeason1.percentileRank)+1)];
        nextRankGlickoCutoff = (me.tlSeason1.rank != "z" ? me.tlSeason1.rank == "x" : me.tlSeason1.percentileRank == "x") ? topOne?.glicko??double.infinity : cutoffsGlicko?[ranks.elementAtOrNull(ranks.indexOf(me.tlSeason1.rank != "z" ? me.tlSeason1.rank : me.tlSeason1.percentileRank)+1)];
      }

    if (everyone != null && me.tlSeason1.gamesPlayed > 9) rankAverages = everyone?.averages[me.tlSeason1.percentileRank]?[0];

    // Making list of Tetra League matches
    List<TetraLeagueAlphaRecord> tlMatches = [];
    bool isTracking = await teto.isPlayerTracking(me.userId);
    List<TetrioPlayer> states = [];
    TetraLeagueAlpha? compareWith;
    Set<TetraLeagueAlpha> uniqueTL = {};
    tlMatches = tlStream.records;
    List<TetraLeagueAlphaRecord> storedRecords = await teto.getTLMatchesbyPlayerID(me.userId); // get old matches
    if (isTracking){ // if tracked - save data to local DB
      await teto.storeState(me);
      await teto.saveTLMatchesFromStream(tlStream);
    }

    // building list of TL matches
    if(fetchTLmatches) {
      try{
        List<TetraLeagueAlphaRecord> oldMatches = await teto.fetchAndSaveOldTLmatches(_searchFor);
        storedRecords.addAll(oldMatches);
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.fetchAndSaveOldTLmatchesResult(number: oldMatches.length))));
      }on TetrioHistoryNotExist{
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rTLmatches)));
      }on P1nkl0bst3rForbidden {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rForbidden)));
      }on P1nkl0bst3rInternalProblem {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rinternal)));
      }on P1nkl0bst3rTooManyRequests{
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rTooManyRequests)));
      }finally{
        _TLHistoryWasFetched = true;
      }
    }
    if (storedRecords.isNotEmpty) _TLHistoryWasFetched = true;
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

    // Handling history
    if(fetchHistory){
      try{
        var history = await teto.fetchAndsaveTLHistory(_searchFor); // Retrieve if needed
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.fetchAndsaveTLHistoryResult(number: history.length))));
      }on TetrioHistoryNotExist{
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.noHistorySaved)));
      }on P1nkl0bst3rForbidden {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rForbidden)));
      }on P1nkl0bst3rInternalProblem {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rinternal)));
      }on P1nkl0bst3rTooManyRequests{
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.p1nkl0bst3rTooManyRequests)));
      }
    } 

    states.addAll(await teto.getPlayer(me.userId));
    for (var element in states) { // For graphs I need only unique entries
      if (uniqueTL.isNotEmpty && uniqueTL.last != element.tlSeason1) uniqueTL.add(element.tlSeason1);
      if (uniqueTL.isEmpty) uniqueTL.add(element.tlSeason1);
    }
    // Also i need previous Tetra League State for comparison if avaliable
    if (uniqueTL.length >= 2){
      compareWith = uniqueTL.toList().elementAtOrNull(uniqueTL.length - 2);
      chartsData = <DropdownMenuItem<List<_HistoryChartSpot>>>[ // Dumping charts data into dropdown menu items, while cheking if every entry is valid
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.rating)], child: Text(t.statCellNum.tr)),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.glicko!)], child: const Text("Glicko")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.gamesPlayed > 9) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.rd!)], child: const Text("Rating Deviation")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.apm != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.apm!)], child: Text(t.statCellNum.apm.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.pps != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.pps!)], child: Text(t.statCellNum.pps.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.vs != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.vs!)], child: Text(t.statCellNum.vs.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.app)], child: Text(t.statCellNum.app.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.dss)], child: Text(t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.dsp)], child: Text(t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.appdsp)], child: const Text("APP + DS/P")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.vsapm)], child: const Text("VS/APM")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.cheese)], child: Text(t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.gbe)], child: Text(t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.nyaapp)], child: Text(t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.nerdStats != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.nerdStats!.area)], child: Text(t.statCellNum.area.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.estTr != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.estTr!.esttr)], child: Text(t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.esttracc != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.esttracc!)], child: Text(t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "))),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.playstyle!.opener)], child: const Text("Opener")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.playstyle!.plonk)], child: const Text("Plonk")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.playstyle!.infds)], child: const Text("Inf. DS")),
        DropdownMenuItem(value: [for (var tl in uniqueTL) if (tl.playstyle != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.playstyle!.stride)], child: const Text("Stride")),
      ];
    }else{
      compareWith = null;
      chartsData = [];
    }

    if (prefs.getBool("updateInBG") == true) {
      backgroundUpdate = Timer(me.cachedUntil!.difference(DateTime.now()), () {
        changePlayer(me.userId);
      });
    }

    return [me, records, states, tlMatches, compareWith, isTracking, news, topTR, recent, sprint, blitz, tlMatches.elementAtOrNull(0)?.timestamp];
  }

  /// Triggers widgets rebuild
  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 1024;
    return Scaffold(
      drawer: widget.player == null ? NavDrawer(changePlayer) : null, // Side menu hidden if player provided
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.2, // 20% of left side of the screen used of Drawer gesture
      appBar: AppBar(
        title: _showSearchBar ? SearchBox(onSubmit: changePlayer, bigScreen: MediaQuery.of(context).size.width > 768) : Text(title, style: const TextStyle(shadows: textShadow)), 
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
                value: "TLmatches",
                child: Text(t.fetchAndSaveOldTLmatches),
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
                case "TLmatches":
                  changePlayer(_searchFor, fetchTLmatches: true);
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
                if (snapshot.hasData) {
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
                      scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false, physics: const AlwaysScrollableScrollPhysics()),
                      controller: _scrollController,
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
                              controller: bigScreen ? _wideScreenTabController : _tabController,
                              padding: const EdgeInsets.all(0.0),
                              isScrollable: true,
                              tabs: bigScreen ? [
                                Tab(text: t.tetraLeague,),
                                Tab(text: t.history),
                                Tab(text: "${t.sprint} & ${t.blitz}"),
                                Tab(text: t.other),
                              ] : [
                                Tab(text: t.tetraLeague),
                                Tab(text: t.tlRecords),
                                Tab(text: t.history),
                                Tab(text: t.sprint),
                                Tab(text: t.blitz),
                                Tab(text: t.recentRuns),
                                Tab(text: t.other),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: bigScreen ? _wideScreenTabController : _tabController,
                        children: bigScreen ? [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Container(
                              width: MediaQuery.of(context).size.width-450,
                              constraints: const BoxConstraints(maxWidth: 1024),
                              child: TLThingy(
                                tl: snapshot.data![0].tlSeason1,
                                userID: snapshot.data![0].userId,
                                states: snapshot.data![2],
                                topTR: snapshot.data![7]?.tr,
                                lastMatchPlayed: snapshot.data![11],
                                bot: snapshot.data![0].role == "bot",
                                guest: snapshot.data![0].role == "anon",
                                thatRankCutoff: thatRankCutoff,
                                thatRankCutoffGlicko: thatRankGlickoCutoff,
                                thatRankTarget: snapshot.data![0].tlSeason1.rank != "z" ? rankTargets[snapshot.data![0].tlSeason1.rank] : null,
                                nextRankCutoff: nextRankCutoff,
                                nextRankCutoffGlicko: nextRankGlickoCutoff,
                                nextRankTarget: (snapshot.data![0].tlSeason1.rank != "z" && snapshot.data![0].tlSeason1.rank != "x") ? rankTargets[ranks.elementAtOrNull(ranks.indexOf(snapshot.data![0].tlSeason1.rank)+1)] : null,
                                averages: rankAverages,
                                lbPositions: meAmongEveryone
                              ),
                            ),
                            SizedBox(
                              width: 450,
                              child: _TLRecords(userID: snapshot.data![0].userId, changePlayer: changePlayer, data: snapshot.data![3], wasActiveInTL: snapshot.data![0].tlSeason1.gamesPlayed > 0, oldMathcesHere: _TLHistoryWasFetched, separateScrollController: true,)
                            ),
                          ],),
                          _History(chartsData: chartsData, changePlayer: changePlayer, userID: _searchFor, update: _justUpdate, wasActiveInTL: snapshot.data![0].tlSeason1.gamesPlayed > 0),
                          _TwoRecordsThingy(sprint: snapshot.data![1].sprint, blitz: snapshot.data![1].blitz, rank: snapshot.data![0].tlSeason1.percentileRank, recent: snapshot.data![8], sprintStream: snapshot.data![9], blitzStream: snapshot.data![10]),
                          _OtherThingy(zen: snapshot.data![1].zen, bio: snapshot.data![0].bio, distinguishment: snapshot.data![0].distinguishment, newsletter: snapshot.data![6],)
                        ] : [
                          TLThingy(
                            tl: snapshot.data![0].tlSeason1,
                            userID: snapshot.data![0].userId,
                            states: snapshot.data![2],
                            topTR: snapshot.data![7]?.tr,
                            bot: snapshot.data![0].role == "bot",
                            guest: snapshot.data![0].role == "anon",
                            thatRankCutoff: thatRankCutoff,
                            thatRankCutoffGlicko: thatRankGlickoCutoff,
                            thatRankTarget: snapshot.data![0].tlSeason1.rank != "z" ? rankTargets[snapshot.data![0].tlSeason1.rank] : null,
                            nextRankCutoff: nextRankCutoff,
                            nextRankCutoffGlicko: nextRankGlickoCutoff,
                            nextRankTarget: (snapshot.data![0].tlSeason1.rank != "z" && snapshot.data![0].tlSeason1.rank != "x") ? rankTargets[ranks.elementAtOrNull(ranks.indexOf(snapshot.data![0].tlSeason1.rank)+1)] : null,
                            averages: rankAverages,
                            lbPositions: meAmongEveryone
                          ),
                          _TLRecords(userID: snapshot.data![0].userId, changePlayer: changePlayer, data: snapshot.data![3], wasActiveInTL: snapshot.data![0].tlSeason1.gamesPlayed > 0, oldMathcesHere: _TLHistoryWasFetched),
                          _History(chartsData: chartsData, changePlayer: changePlayer, userID: _searchFor, update: _justUpdate, wasActiveInTL: snapshot.data![0].tlSeason1.gamesPlayed > 0),
                          SingleplayerRecord(record: snapshot.data![1].sprint, rank: snapshot.data![0].tlSeason1.percentileRank, stream: snapshot.data![9]),
                          SingleplayerRecord(record: snapshot.data![1].blitz, rank: snapshot.data![0].tlSeason1.percentileRank, stream: snapshot.data![10]),
                          _RecentSingleplayersThingy(snapshot.data![8]),
                          _OtherThingy(zen: snapshot.data![1].zen, bio: snapshot.data![0].bio, distinguishment: snapshot.data![0].distinguishment, newsletter: snapshot.data![6])
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  String errText = "";
                  String? subText;
                  switch (snapshot.error.runtimeType){
                    case TetrioPlayerNotExist:
                    errText = t.errors.noSuchUser;
                    subText = t.errors.noSuchUserSub;
                    break;
                    case TetrioDiscordNotExist:
                    errText = t.errors.discordNotAssigned;
                    subText = t.errors.discordNotAssignedSub;
                    case ConnectionIssue:
                    var err = snapshot.error as ConnectionIssue;
                    errText = t.errors.connection(code: err.code, message: err.message);
                    break;
                    case TetrioForbidden:
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
                    errText = snapshot.error.toString();
                  }
                  return Center(child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errText, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        if (subText != null) Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(subText, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 18), textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  );
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
                  ? snapshot.data as Map<String, String>
                  : <String, String>{};
              allPlayers.remove(prefs.getString("player") ?? "6098518e3d5155e6ec429cdc"); // player from the home button will be delisted
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
                            widget.changePlayer(prefs.getString("player") ?? "6098518e3d5155e6ec429cdc"); // changes player on main view to the one from preferences
                            Navigator.of(context).pop(); // and then NavDrawer closes itself.
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile( // Leaderboard button
                          leading: const Icon(Icons.leaderboard),
                          title: Text(t.tlLeaderboard),
                          onTap: () {
                            context.go("/leaderboard");
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile( // Rank averages button
                          leading: const Icon(Icons.compress),
                          title: Text(t.rankAveragesViewTitle),
                          onTap: () {
                            context.go("/LBvalues");
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile( // Rank averages button
                          leading: const Icon(Icons.bar_chart),
                          title: Text(t.sprintAndBlitsViewTitle),
                          onTap: () {
                            context.go("/sprintAndBlitzAverages");
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
                          title: Text(allPlayers[keys[i]]??keys[i]), // Takes last known username from list of states
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
  final Function changePlayer;
  final List<TetraLeagueAlphaRecord> data;
  final bool wasActiveInTL;
  final bool oldMathcesHere;
  final bool separateScrollController;

  /// Widget, that displays Tetra League records.
  /// Accepts list of TL records ([data]) and [userID] of player from the view
  const _TLRecords({required this.userID, required this.changePlayer, required this.data, required this.wasActiveInTL, required this.oldMathcesHere, this.separateScrollController = false});

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
      controller: separateScrollController ? ScrollController() : null,
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

        var accentColor = data[index].endContext.firstWhere((element) => element.userId == userID).success ? Colors.green : Colors.red;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0, 0.05],
            colors: [accentColor, Colors.transparent]
          )
        ),
        child: ListTile(
          leading: Text("${data[index].endContext.firstWhere((element) => element.userId == userID).points} : ${data[index].endContext.firstWhere((element) => element.userId != userID).points}",
          style: bigScreen ? const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, shadows: textShadow) : const TextStyle(fontSize: 28, shadows: textShadow)),
          title: Text("vs. ${data[index].endContext.firstWhere((element) => element.userId != userID).username}"),
          subtitle: Text(timestamp(data[index].timestamp), style: const TextStyle(color: Colors.grey)),
          trailing: TrailingStats(
            data[index].endContext.firstWhere((element) => element.userId == userID).secondary,
            data[index].endContext.firstWhere((element) => element.userId == userID).tertiary,
            data[index].endContext.firstWhere((element) => element.userId == userID).extra,
            data[index].endContext.firstWhere((element) => element.userId != userID).secondary,
            data[index].endContext.firstWhere((element) => element.userId != userID).tertiary,
            data[index].endContext.firstWhere((element) => element.userId != userID).extra
            ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: data[index], initPlayerId: userID))),
        ),
      );
    });
  }
}

class _History extends StatelessWidget{
  final List<DropdownMenuItem<List<_HistoryChartSpot>>> chartsData;
  final String userID;
  final Function update;
  final Function changePlayer;
  final bool wasActiveInTL;

  /// Widget, that can show history of some stat of the player on the graph.
  /// Requires player [states], which is list of states and function [update], which rebuild widgets
  const _History({required this.chartsData, required this.userID, required this.changePlayer, required this.update, required this.wasActiveInTL});
  
  @override
  Widget build(BuildContext context) {
    if (chartsData.isEmpty) {
      return Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.noHistorySaved, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
          if (wasActiveInTL) Text(t.errors.actionSuggestion),
          if (wasActiveInTL) TextButton(onPressed: (){changePlayer(userID, fetchHistory: true);}, child: Text(t.fetchAndsaveTLHistory))
        ],
      ));
    }
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    //List<_HistoryChartSpot> selectedGraph = _gamesPlayedInsteadOfDateAndTime ? chartsDataGamesPlayed[_chartsIndex].value! : chartsData[_chartsIndex].value!;
    List<_HistoryChartSpot> selectedGraph = chartsData[_chartsIndex].value!;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(padding: EdgeInsets.all(8.0), child: Text("X:", style: TextStyle(fontSize: 22))),
                    DropdownButton(
                      items: const [DropdownMenuItem(value: false, child: Text("Date & Time")), DropdownMenuItem(value: true, child: Text("Games Played"))],
                      value: _gamesPlayedInsteadOfDateAndTime,
                      onChanged: (value) {
                        _gamesPlayedInsteadOfDateAndTime = value!;
                        update();
                      }
                    ),
                    ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(padding: EdgeInsets.all(8.0), child: Text("Y:", style: TextStyle(fontSize: 22))),
                    DropdownButton(
                      items: chartsData,
                      value: chartsData[_chartsIndex].value,
                      onChanged: (value) {
                        _chartsIndex = chartsData.indexWhere((element) => element.value == value);
                        update();
                      }
                    ),
                  ],
                ),
                if (selectedGraph.length > 300) Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(value: _smooth,
                      checkColor: Colors.black,
                      onChanged: ((value) {
                        _smooth = value!;
                        update();
                      })),
                      Text(t.smooth, style: const TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
                IconButton(onPressed: () => _zoomPanBehavior.reset(), icon: const Icon(Icons.refresh), alignment: Alignment.center,)
              ],
            ),
            if(chartsData[_chartsIndex].value!.length > 1) _HistoryChartThigy(data: selectedGraph, smooth: _smooth, yAxisTitle: _historyShortTitles[_chartsIndex], bigScreen: bigScreen, leftSpace: bigScreen? 80 : 45, yFormat: bigScreen? f2 : NumberFormat.compact(), xFormat: NumberFormat.compact())
            else if (chartsData[_chartsIndex].value!.length <= 1) Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
                if (wasActiveInTL) Text(t.errors.actionSuggestion),
                if (wasActiveInTL) TextButton(onPressed: (){changePlayer(userID, fetchHistory: true);}, child: Text(t.fetchAndsaveTLHistory))
              ],
            ))
          ],
        ),
    );
  }
}

class _HistoryChartSpot{
  final DateTime timestamp;
  final int gamesPlayed;
  final String rank;
  final double stat;
  const _HistoryChartSpot(this.timestamp, this.gamesPlayed, this.rank, this.stat);
}

class _HistoryChartThigy extends StatefulWidget{
  final List<_HistoryChartSpot> data;
  final bool smooth;
  final String yAxisTitle;
  final bool bigScreen;
  final double leftSpace;
  final NumberFormat yFormat;
  final NumberFormat? xFormat;
  
  /// Implements graph for the _History widget. Requires [data] which is a list of dots for the graph. [yAxisTitle] used to keep track of changes.
  /// [bigScreen] tells if screen wide enough, [leftSpace] sets size, reserved for titles on the left from the graph and [yFormat] sets number format
  /// for left titles
  const _HistoryChartThigy({required this.data, required this.smooth, required this.yAxisTitle, required this.bigScreen, required this.leftSpace, required this.yFormat, this.xFormat});

  @override
  State<_HistoryChartThigy> createState() => _HistoryChartThigyState();
}

class _HistoryChartThigyState extends State<_HistoryChartThigy> {
  late String previousAxisTitle;
  late bool previousGamesPlayedInsteadOfDateAndTime;
  late TooltipBehavior _tooltipBehavior;
  

  @override
  void initState(){
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      color: Colors.black,
      borderColor: Colors.white,
      enable: true,
      animationDuration: 0,
      builder: (dynamic data, dynamic point, dynamic series,
        int pointIndex, int seriesIndex) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${f4.format(data.stat)} ${widget.yAxisTitle}",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
                  ),
                ),
                Text(_gamesPlayedInsteadOfDateAndTime ? t.gamesPlayed(games: t.games(n: data.gamesPlayed)) : timestamp(data.timestamp))
              ],
            ),
          );
      }
    );
    previousAxisTitle = widget.yAxisTitle;
    previousGamesPlayedInsteadOfDateAndTime = _gamesPlayedInsteadOfDateAndTime;
  }

  @override
  void dispose(){
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    if ((previousAxisTitle != widget.yAxisTitle) || (previousGamesPlayedInsteadOfDateAndTime != _gamesPlayedInsteadOfDateAndTime)) {
      previousAxisTitle = widget.yAxisTitle;
      previousGamesPlayedInsteadOfDateAndTime = _gamesPlayedInsteadOfDateAndTime;
      setState((){});
    }
    EdgeInsets padding = widget.bigScreen ? const EdgeInsets.fromLTRB(40, 30, 40, 30) : const EdgeInsets.fromLTRB(0, 40, 16, 48);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 104,
      child: Padding( padding: padding,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {      
          setState(() {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent - signal.scrollDelta.dy); // TODO: find a better way to stop scrolling in NestedScrollView
          });
        }
      },
        child: SfCartesianChart(
          tooltipBehavior: _tooltipBehavior,
          zoomPanBehavior: _zoomPanBehavior,
          primaryXAxis: _gamesPlayedInsteadOfDateAndTime ? const NumericAxis() : const DateTimeAxis(),
          primaryYAxis: const NumericAxis(
            rangePadding: ChartRangePadding.additional,
          ),
          margin: const EdgeInsets.all(0),
          series: <CartesianSeries>[
            if (_gamesPlayedInsteadOfDateAndTime) StepLineSeries<_HistoryChartSpot, int>(
              enableTooltip: true,
              dataSource: widget.data,
              animationDuration: 0,
              opacity: _smooth ? 0 : 1,
              xValueMapper: (_HistoryChartSpot data, _) => data.gamesPlayed,
              yValueMapper: (_HistoryChartSpot data, _) => data.stat,
              color: Theme.of(context).colorScheme.primary,
              trendlines:<Trendline>[
                Trendline(
                  isVisible: _smooth,
                  period: (widget.data.length/175).floor(),
                  type: TrendlineType.movingAverage,
                  color: Theme.of(context).colorScheme.primary)
              ],
            )
            else StepLineSeries<_HistoryChartSpot, DateTime>(
              enableTooltip: true,
              dataSource: widget.data,
              animationDuration: 0,
              opacity: _smooth ? 0 : 1,
              xValueMapper: (_HistoryChartSpot data, _) => data.timestamp,
              yValueMapper: (_HistoryChartSpot data, _) => data.stat,
              color: Theme.of(context).colorScheme.primary,
              trendlines:<Trendline>[
                Trendline(
                  isVisible: _smooth,
                  period: (widget.data.length/175).floor(),
                  type: TrendlineType.movingAverage,
                  color: Theme.of(context).colorScheme.primary)
              ],
            ),
          ],
        ),
      ),
      )
    );
  }
}

class _TwoRecordsThingy extends StatelessWidget {
  final RecordSingle? sprint;
  final RecordSingle? blitz;
  final SingleplayerStream recent;
  final SingleplayerStream sprintStream;
  final SingleplayerStream blitzStream;
  final String? rank;

  const _TwoRecordsThingy({required this.sprint, required this.blitz, this.rank, required this.recent, required this.sprintStream, required this.blitzStream});

  Color getColorOfRank(int rank){
    if (rank == 1) return Colors.yellowAccent;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown[400]!;
    if (rank <= 9) return Colors.blueAccent;
    if (rank <= 99) return Colors.greenAccent;
    return Colors.grey;
  }
  
  @override
  Widget build(BuildContext context) {
    late MapEntry closestAverageBlitz;
    late bool blitzBetterThanClosestAverage;
    bool? blitzBetterThanRankAverage = (rank != null && rank != "z" && blitz != null) ? blitz!.endContext.score > blitzAverages[rank]! : null;
    late MapEntry closestAverageSprint;
    late bool sprintBetterThanClosestAverage;
    bool? sprintBetterThanRankAverage = (rank != null && rank != "z" && sprint != null) ? sprint!.endContext.finalTime < sprintAverages[rank]! : null;
    if (sprint != null) {
      closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-sprint!.endContext.finalTime).abs() < (b -sprint!.endContext.finalTime).abs() ? a : b));
      sprintBetterThanClosestAverage = sprint!.endContext.finalTime < closestAverageSprint.value;
    }
    if (blitz != null){
      closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-blitz!.endContext.score).abs() < (b -blitz!.endContext.score).abs() ? a : b));
      blitzBetterThanClosestAverage = blitz!.endContext.score > closestAverageBlitz.value;
    }
    return SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.only(right: 8.0),
                  child: sprint != null ? Image.asset("res/tetrio_tl_alpha_ranks/${closestAverageSprint.key}.png", height: 96) : Image.asset("res/tetrio_tl_alpha_ranks/z.png", height: 96)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(t.sprint, style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
                    RichText(text: TextSpan(
                        text: sprint != null ? get40lTime(sprint!.endContext.finalTime.inMicroseconds) : "---",
                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: sprint != null ? Colors.white : Colors.grey),
                        //children: [TextSpan(text: get40lTime(record!.endContext.finalTime.inMicroseconds), style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                        ),
                      ),
                    if (sprint != null) RichText(text: TextSpan(
                      text: "",
                      style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                      children: [
                        if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: readableTimeDifference(sprint!.endContext.finalTime, sprintAverages[rank]!), verdict: sprintBetterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                          color: sprintBetterThanRankAverage??false ? Colors.greenAccent : Colors.redAccent
                        ))
                        else TextSpan(text: "${t.verdictGeneral(n: readableTimeDifference(sprint!.endContext.finalTime, closestAverageSprint.value), verdict: sprintBetterThanClosestAverage ? t.verdictBetter : t.verdictWorse, rank: closestAverageSprint.key.toUpperCase())}\n", style: TextStyle(
                          color: sprintBetterThanClosestAverage ? Colors.greenAccent : Colors.redAccent
                        )),
                        if (sprint!.rank != null) TextSpan(text: "№${sprint!.rank}", style: TextStyle(color: getColorOfRank(sprint!.rank!))),
                        if (sprint!.rank != null) const TextSpan(text: " • "),
                        TextSpan(text: timestamp(sprint!.timestamp)),
                      ]
                      ),
                    ),
                  ],),
                ],
              ),
              if (sprint != null) Wrap(
                  //mainAxisSize: MainAxisSize.max,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 20,
                  children: [
                    StatCellNum(playerStat: sprint!.endContext.piecesPlaced, playerStatLabel: t.statCellNum.pieces, isScreenBig: true, higherIsBetter: true, smallDecimal: false),
                    StatCellNum(playerStat: sprint!.endContext.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: true, higherIsBetter: true, smallDecimal: false),
                    StatCellNum(playerStat: sprint!.endContext.kpp, playerStatLabel: t.statCellNum.kpp, fractionDigits: 2, isScreenBig: true, higherIsBetter: true, smallDecimal: false),
                  ],
              ),
              if (sprint != null) FinesseThingy(sprint?.endContext.finesse, sprint?.endContext.finessePercentage),
              if (sprint != null) LineclearsThingy(sprint!.endContext.clears, sprint!.endContext.lines, sprint!.endContext.holds, sprint!.endContext.tSpins),
              if (sprint != null) Text("${sprint!.endContext.inputs} KP • ${f2.format(sprint!.endContext.kps)} KPS"),
              if (sprint != null) Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 20,
                  children: [
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://tetr.io/#r:${sprint!.replayId}"));}, child: Text(t.openSPreplay)),
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://inoue.szy.lol/api/replay/${sprint!.replayId}"));}, child: Text(t.downloadSPreplay)),
                  ],
                ),
              if (sprintStream.records.length > 1) SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 1; i < sprintStream.records.length; i++) ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: sprintStream.records[i]))),
                    leading: Text("#${i+1}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9) ),
                    title: Text(get40lTime(sprintStream.records[i].endContext.finalTime.inMicroseconds),
                    style: const TextStyle(fontSize: 18)),
                    subtitle: Text(timestamp(sprintStream.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                    trailing: SpTrailingStats(sprintStream.records[i].endContext)
                  )
                    ],
                ),
              )
            ]
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Text(t.blitz, style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
                  RichText(
                    text: TextSpan(
                      text: "",
                      style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
                      children: [
                        TextSpan(text: blitz != null ? NumberFormat.decimalPattern().format(blitz!.endContext.score) : "---"),
                        //WidgetSpan(child: Image.asset("res/icons/kagari.png", height: 48))
                      ]
                      ),
                    ),
                  if (blitz != null) RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                    text: "",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                    children: [
                      if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: readableIntDifference(blitz!.endContext.score, blitzAverages[rank]!), verdict: blitzBetterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                        color: blitzBetterThanRankAverage??false ? Colors.greenAccent : Colors.redAccent
                      ))
                      else TextSpan(text: "${t.verdictGeneral(n: readableIntDifference(blitz!.endContext.score, closestAverageBlitz.value), verdict: blitzBetterThanClosestAverage ? t.verdictBetter : t.verdictWorse, rank: closestAverageBlitz.key.toUpperCase())}\n", style: TextStyle(
                        color: blitzBetterThanClosestAverage ? Colors.greenAccent : Colors.redAccent
                      )),
                      TextSpan(text: timestamp(blitz!.timestamp)),
                      if (blitz!.rank != null)  const TextSpan(text: " • "),
                      if (blitz!.rank != null)  TextSpan(text: "№${blitz!.rank}", style: TextStyle(color: getColorOfRank(blitz!.rank!))),
                    ]
                    ),
                  ),
                ],),
                Padding(padding: const EdgeInsets.only(left: 8.0),
                child: blitz != null ? Image.asset("res/tetrio_tl_alpha_ranks/${closestAverageBlitz.key}.png", height: 96) : Image.asset("res/tetrio_tl_alpha_ranks/z.png", height: 96)), 
              ],
            ),
            if (blitz != null) Wrap(
                //mainAxisSize: MainAxisSize.max,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 20,
                children: [
                  StatCellNum(playerStat: blitz!.endContext.level, playerStatLabel: t.statCellNum.level, isScreenBig: true, higherIsBetter: true, smallDecimal: false),
                  StatCellNum(playerStat: blitz!.endContext.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: true, higherIsBetter: true, smallDecimal: false),
                  StatCellNum(playerStat: blitz!.endContext.spp, playerStatLabel: t.statCellNum.spp, fractionDigits: 2, isScreenBig: true, higherIsBetter: true)
                ],
            ),
            if (blitz != null) FinesseThingy(blitz?.endContext.finesse, blitz?.endContext.finessePercentage),
            if (blitz != null) LineclearsThingy(blitz!.endContext.clears, blitz!.endContext.lines, blitz!.endContext.holds, blitz!.endContext.tSpins),
            if (blitz != null) Text("${blitz!.endContext.piecesPlaced} P • ${blitz!.endContext.inputs} KP • ${f2.format(blitz!.endContext.kpp)} KPP • ${f2.format(blitz!.endContext.kps)} KPS"),
            if (blitz != null) Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 20,
                  children: [
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://tetr.io/#r:${blitz!.replayId}"));}, child: Text(t.openSPreplay)),
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://inoue.szy.lol/api/replay/${blitz!.replayId}"));}, child: Text(t.downloadSPreplay)),
                  ],
                ),
            if (blitzStream.records.length > 1) SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 1; i < blitzStream.records.length; i++) ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: blitzStream.records[i]))),
                        leading: Text("#${i+1}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9) ),
                        title: Text("${NumberFormat.decimalPattern().format(blitzStream.records[i].endContext.score)} points",
                        style: const TextStyle(fontSize: 18)),
                        subtitle: Text(timestamp(blitzStream.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                        trailing: SpTrailingStats(blitzStream.records[i].endContext)
                      )
                    ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 400,
            child: RecentSingleplayerGames(recent: recent),
          )
        ]),
    ));
  }
}

class _RecentSingleplayersThingy extends StatelessWidget {
  final SingleplayerStream recent;

  const _RecentSingleplayersThingy(this.recent);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RecentSingleplayerGames(recent: recent, hideTitle: true)
    );
  }

}

class _OtherThingy extends StatelessWidget {
  final TetrioZen? zen;
  final String? bio;
  final Distinguishment? distinguishment;
  final News? newsletter;

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
  ListTile getNewsTile(NewsEntry news){
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
                TextSpan(text: news.data["gametype"] == "blitz" ? NumberFormat.decimalPattern().format(news.data["result"]) : get40lTime((news.data["result"]*1000).floor()), style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget getShit(BuildContext context, bool bigScreen, bool showNewsTitle){
    return Column(
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
        if (newsletter != null && newsletter!.news.isNotEmpty && showNewsTitle)
          Text(t.news, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      if (constraints.maxWidth >= 1024){
        return Row(
          children: [
            SizedBox(width: 450, child: getShit(context, true, false)),
            SizedBox(width: constraints.maxWidth - 450, child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: newsletter!.news.length+1,
              itemBuilder: (BuildContext context, int index) {
                return index == 0 ? Center(child: Text(t.news, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42))) : getNewsTile(newsletter!.news[index-1]);
              }
            ))
          ]
        );
      }
      else {
        return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: newsletter!.news.length+1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? getShit(context, bigScreen, true) : getNewsTile(newsletter!.news[index-1]);          
        },
      );
      }
    });
  }
}
