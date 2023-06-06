import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';
import 'package:fl_chart/fl_chart.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String _searchFor = "dan63047";
Future<TetrioPlayer>? me;
DB db = DB();
late TetrioService teto;
late SharedPreferences prefs;
const allowedHeightForPlayerIdInPixels = 40.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  String get title => "Tetra Stats: $_searchFor";

  @override
  State<MainView> createState() => _MainState();
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

Future<TetrioPlayer> fetchTetrioPlayer(String user) async {
  var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['success']) {
      return TetrioPlayer.fromJson(
          jsonDecode(response.body)['data']['user'], DateTime.fromMillisecondsSinceEpoch(jsonDecode(response.body)['cache']['cached_at'], isUtc: true), true);
    } else {
      developer.log("fetchTetrioPlayer User dosen't exist", name: "main_view", error: response.body);
      throw Exception("User doesn't exist");
    }
  } else {
    developer.log("fetchTetrioPlayer Failed to fetch player", name: "main_view", error: response.statusCode);
    throw Exception('Failed to fetch player');
  }
}

class _MainState extends State<MainView> with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    const Tab(text: "Tetra League"),
    const Tab(text: "40 Lines"),
    const Tab(text: "Blitz"),
    const Tab(text: "Other"),
  ];
  bool _searchBoolean = false;
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  Widget _searchTextField() {
    return TextField(
      maxLength: 25,
      decoration: const InputDecoration(counter: Offstage()),
      style: const TextStyle(
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 3.0,
            color: Colors.black,
          ),
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 8.0,
            color: Colors.black,
          ),
        ],
      ),
      onSubmitted: (String value) {
        changePlayer(value);
      },
    );
  }

  @override
  void initState() {
    db.open();
    teto = TetrioService(db);
    _scrollController = ScrollController();
    _tabController = TabController(length: 4, vsync: this);
    _getPreferences().then((value) => changePlayer(prefs.getString("player") ?? "dan63047"));
    super.initState();
    developer.log("Main view initialized", name: "main_view");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
    developer.log("Main view disposed", name: "main_view");
  }

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void changePlayer(String player) {
    setState(() {
      _tabController.animateTo(0, duration: const Duration(milliseconds: 300));
      _searchFor = player;
      me = fetchTetrioPlayer(player);
    });
  }

  // _scrollListener() {
  //   if (fixedScroll) {
  //     _scrollController.jumpTo(0);
  //   }
  // }

  // _smoothScrollToTop() {
  //   _scrollController.animateTo(
  //     0,
  //     duration: const Duration(microseconds: 300),
  //     curve: Curves.ease,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(changePlayer),
      appBar: AppBar(
        title: !_searchBoolean
            ? Text(
                widget.title,
                style: const TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            : _searchTextField(),
        backgroundColor: Colors.black,
        actions: [
          !_searchBoolean
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                  tooltip: "Search player",
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: "Close search",
                ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: "/compare",
                child: Text('Compare'),
              ),
              const PopupMenuItem(
                value: "/states",
                child: Text('States'),
              ),
              const PopupMenuItem(
                value: "/settings",
                child: Text('Settings'),
              ),
            ],
            onSelected: (value) {
              Navigator.pushNamed(context, value);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<TetrioPlayer>(
          future: me,
          builder: (context, snapshot) {
            developer.log("builder ($context): $snapshot", name: "main_view");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (snapshot.hasData) {
              bool bigScreen = MediaQuery.of(context).size.width > 768;
              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(child: _UserThingy(player: snapshot.data!)),
                    SliverToBoxAdapter(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: myTabs,
                        onTap: (int tabId) {
                          setState(() {
                            developer.log("Tab changed to $tabId", name: "main_view");
                          });
                        },
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: (snapshot.data!.tlSeason1.gamesPlayed > 0)
                              ? [
                                  Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                  if (snapshot.data!.tlSeason1.gamesPlayed >= 10)
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceAround,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        snapshot.data!.userId == "5e32fc85ab319c2ab1beb07c"
                                            ? Image.asset(
                                                "res/icons/kagari.png",
                                                height: 128,
                                              )
                                            : Image.asset(
                                                "res/tetrio_tl_alpha_ranks/${snapshot.data!.tlSeason1.rank}.png",
                                                height: 128,
                                              ),
                                        Column(
                                          children: [
                                            Text("${snapshot.data!.tlSeason1.rating.toStringAsFixed(2)} TR",
                                                style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                            Text(
                                              "Top ${(snapshot.data!.tlSeason1.percentile * 100).toStringAsFixed(2)}% (${snapshot.data!.tlSeason1.percentileRank.toUpperCase()}) • Top Rank: ${snapshot.data!.tlSeason1.bestRank.toUpperCase()} • Glicko: ${snapshot.data!.tlSeason1.glicko?.toStringAsFixed(2)}±${snapshot.data!.tlSeason1.rd?.toStringAsFixed(2)}${snapshot.data!.tlSeason1.decaying ? ' • Decaying' : ''}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text("${10 - snapshot.data!.tlSeason1.gamesPlayed} games until being ranked",
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontFamily: "Eurostile Round Extended",
                                                  fontSize: bigScreen ? 42 : 28,
                                                  overflow: TextOverflow.visible,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      spacing: 25,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        if (snapshot.data!.tlSeason1.apm != null)
                                          _StatCellNum(
                                              playerStat: snapshot.data!.tlSeason1.apm!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel: "Attack\nPer Minute"),
                                        if (snapshot.data!.tlSeason1.pps != null)
                                          _StatCellNum(
                                              playerStat: snapshot.data!.tlSeason1.pps!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel: "Pieces\nPer Second"),
                                        if (snapshot.data!.tlSeason1.apm != null)
                                          _StatCellNum(
                                              playerStat: snapshot.data!.tlSeason1.vs!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel: "Versus\nScore"),
                                        if (snapshot.data!.tlSeason1.standing > 0)
                                          _StatCellNum(
                                              playerStat: snapshot.data!.tlSeason1.standing, isScreenBig: bigScreen, playerStatLabel: "Leaderboard\nplacement"),
                                        if (snapshot.data!.tlSeason1.standingLocal > 0)
                                          _StatCellNum(
                                              playerStat: snapshot.data!.tlSeason1.standingLocal,
                                              isScreenBig: bigScreen,
                                              playerStatLabel: "Country LB\nplacement"),
                                        _StatCellNum(
                                            playerStat: snapshot.data!.tlSeason1.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: "Games\nplayed"),
                                        _StatCellNum(playerStat: snapshot.data!.tlSeason1.gamesWon, isScreenBig: bigScreen, playerStatLabel: "Games\nwon"),
                                        _StatCellNum(
                                            playerStat: snapshot.data!.tlSeason1.winrate * 100,
                                            isScreenBig: bigScreen,
                                            fractionDigits: 2,
                                            playerStatLabel: "Winrate\nprecentage"),
                                      ],
                                    ),
                                  ),
                                  if (snapshot.data!.tlSeason1.nerdStats != null)
                                    Column(
                                      children: [
                                        Text("Nerd Stats", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                          child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.center,
                                              spacing: 25,
                                              crossAxisAlignment: WrapCrossAlignment.start,
                                              clipBehavior: Clip.hardEdge,
                                              children: [
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.app,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "Attack\nPer Piece"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.vsapm,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "VS/APM"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.dss,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "Downstack\nPer Second"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.dsp,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "Downstack\nPer Piece"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.appdsp,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "APP + DS/P"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.cheese,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 2,
                                                    playerStatLabel: "Cheese\nIndex"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.gbe,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "Garbage\nEfficiency"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.nyaapp,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "Weighted\nAPP"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!.tlSeason1.nerdStats!.area,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 1,
                                                    playerStatLabel: "Area")
                                              ]),
                                        )
                                      ],
                                    ),
                                  if (snapshot.data!.tlSeason1.estTr != null)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                      child: SizedBox(
                                        width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  "Est. of TR:",
                                                  style: TextStyle(fontSize: 24),
                                                ),
                                                Text(
                                                  snapshot.data!.tlSeason1.estTr!.esttr.toStringAsFixed(2),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            if (snapshot.data!.tlSeason1.rating >= 0)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Accuracy:",
                                                    style: TextStyle(fontSize: 24),
                                                  ),
                                                  Text(
                                                    snapshot.data!.tlSeason1.esttracc!.toStringAsFixed(2),
                                                    style: const TextStyle(fontSize: 24),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (snapshot.data!.tlSeason1.nerdStats != null)
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceAround,
                                      spacing: 25,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                                          child: SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: RadarChart(
                                              RadarChartData(
                                                radarShape: RadarShape.polygon,
                                                tickCount: 4,
                                                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                                                radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                                gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                                tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                                getTitle: (index, angle) {
                                                  switch (index) {
                                                    case 0:
                                                      return RadarChartTitle(
                                                        text: 'APM',
                                                        angle: angle,
                                                      );
                                                    case 1:
                                                      return RadarChartTitle(
                                                        text: 'PPS',
                                                        angle: angle,
                                                      );
                                                    case 2:
                                                      return RadarChartTitle(text: 'VS', angle: angle);
                                                    case 3:
                                                      return RadarChartTitle(text: 'APP', angle: angle + 180);
                                                    case 4:
                                                      return RadarChartTitle(text: 'DS/S', angle: angle + 180);
                                                    case 5:
                                                      return RadarChartTitle(text: 'DS/P', angle: angle + 180);
                                                    case 6:
                                                      return RadarChartTitle(text: 'APP+DS/P', angle: angle + 180);
                                                    case 7:
                                                      return RadarChartTitle(text: 'VS/APM', angle: angle + 180);
                                                    case 8:
                                                      return RadarChartTitle(text: 'Cheese', angle: angle);
                                                    case 9:
                                                      return RadarChartTitle(text: 'Gb Eff.', angle: angle);
                                                    default:
                                                      return const RadarChartTitle(text: '');
                                                  }
                                                },
                                                dataSets: [
                                                  RadarDataSet(
                                                    dataEntries: [
                                                      RadarEntry(value: snapshot.data!.tlSeason1.apm! * 1),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.pps! * 45),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.vs! * 0.444),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.app * 185),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.dss * 175),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.dsp * 450),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.appdsp * 140),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.vsapm * 60),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.cheese * 1.25),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.nerdStats!.gbe * 315),
                                                    ],
                                                  ),
                                                  RadarDataSet(
                                                    fillColor: Colors.transparent,
                                                    borderColor: Colors.transparent,
                                                    dataEntries: [
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                                              swapAnimationCurve: Curves.linear, // Optional
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                                          child: SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: RadarChart(
                                              RadarChartData(
                                                radarShape: RadarShape.polygon,
                                                tickCount: 4,
                                                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                                                radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                                gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                                tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                                getTitle: (index, angle) {
                                                  switch (index) {
                                                    case 0:
                                                      return RadarChartTitle(
                                                        text: 'Opener',
                                                        angle: angle,
                                                      );
                                                    case 1:
                                                      return RadarChartTitle(
                                                        text: 'Stride',
                                                        angle: angle,
                                                      );
                                                    case 2:
                                                      return RadarChartTitle(text: 'Inf Ds', angle: angle + 180);
                                                    case 3:
                                                      return RadarChartTitle(text: 'Plonk', angle: angle);
                                                    default:
                                                      return const RadarChartTitle(text: '');
                                                  }
                                                },
                                                dataSets: [
                                                  RadarDataSet(
                                                    dataEntries: [
                                                      RadarEntry(value: snapshot.data!.tlSeason1.playstyle!.opener),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.playstyle!.stride),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.playstyle!.infds),
                                                      RadarEntry(value: snapshot.data!.tlSeason1.playstyle!.plonk),
                                                    ],
                                                  ),
                                                  RadarDataSet(
                                                    fillColor: Colors.transparent,
                                                    borderColor: Colors.transparent,
                                                    dataEntries: [
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                      const RadarEntry(value: 0),
                                                    ],
                                                  ),
                                                  RadarDataSet(
                                                    fillColor: Colors.transparent,
                                                    borderColor: Colors.transparent,
                                                    dataEntries: [
                                                      const RadarEntry(value: 1),
                                                      const RadarEntry(value: 1),
                                                      const RadarEntry(value: 1),
                                                      const RadarEntry(value: 1),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                                              swapAnimationCurve: Curves.linear, // Optional
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ]
                              : [
                                  Text("That user never played Tetra League",
                                      style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                ],
                        );
                      },
                    ),
                    ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: (snapshot.data!.sprint.isNotEmpty)
                                ? [
                                    Text("40 Lines", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                    Text(snapshot.data!.sprint[0]!.endContext!.finalTime.toString(),
                                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                    if (snapshot.data!.sprint[0]!.rank != null)
                                      _StatCellNum(
                                          playerStat: snapshot.data!.sprint[0]!.rank!, playerStatLabel: "Leaderboard Placement", isScreenBig: bigScreen),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceAround,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        clipBehavior: Clip.hardEdge,
                                        spacing: 25,
                                        children: [
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.piecesPlaced,
                                              playerStatLabel: "Pieces\nPlaced",
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.pps,
                                              playerStatLabel: "Pieces\nPer Second",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.finesse.faults,
                                              playerStatLabel: "Finesse\nFaults",
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.finessePercentage * 100,
                                              playerStatLabel: "Finesse\nPercentage",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.inputs,
                                              playerStatLabel: "Key\nPresses",
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.kpp,
                                              playerStatLabel: "KP Per\nPiece",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.sprint[0]!.endContext!.kps,
                                              playerStatLabel: "KP Per\nSecond",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                      child: SizedBox(
                                        width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("All Clears:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.allClears.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Holds:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.holds.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("T-spins total:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.tSpins.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin zero:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinZeros.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinSingles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinDoubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin triples:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinTriples.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini zero:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinMiniZeros.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinMiniSingles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.tSpinMiniDoubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Line clears:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.lines.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.singles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.doubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Triples:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.triples.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Quads:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.sprint[0]!.endContext!.clears.quads.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    Text("That user never played 40 Lines",
                                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                                  ],
                          );
                        }),
                    ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: (snapshot.data!.blitz.isNotEmpty)
                                ? [
                                    Text("Blitz", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                    Text(snapshot.data!.blitz[0]!.endContext!.score.toString(),
                                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                    if (snapshot.data!.blitz[0]!.rank != null)
                                      _StatCellNum(
                                          playerStat: snapshot.data!.blitz[0]!.rank!, playerStatLabel: "Leaderboard Placement", isScreenBig: bigScreen),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceAround,
                                        crossAxisAlignment: WrapCrossAlignment.start,
                                        clipBehavior: Clip.hardEdge,
                                        spacing: 25,
                                        children: [
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.level, playerStatLabel: "Level", isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.spp,
                                              playerStatLabel: "Score\nPer Piece",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.piecesPlaced,
                                              playerStatLabel: "Pieces\nPlaced",
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.pps,
                                              playerStatLabel: "Pieces\nPer Second",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.finesse.faults,
                                              playerStatLabel: "Finesse\nFaults",
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.finessePercentage * 100,
                                              playerStatLabel: "Finesse\nPercentage",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.inputs, playerStatLabel: "Key\nPresses", isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.kpp,
                                              playerStatLabel: "KP Per\nPiece",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                          _StatCellNum(
                                              playerStat: snapshot.data!.blitz[0]!.endContext!.kps,
                                              playerStatLabel: "KP Per\nSecond",
                                              fractionDigits: 2,
                                              isScreenBig: bigScreen),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                      child: SizedBox(
                                        width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("All Clears:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.allClears.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Holds:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.holds.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("T-spins total:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.tSpins.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin zero:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinZeros.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinSingles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinDoubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin triples:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinTriples.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini zero:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinMiniZeros.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinMiniSingles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - T-spin mini doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.tSpinMiniDoubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Line clears:", style: TextStyle(fontSize: 24)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.lines.toString(),
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Singles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.singles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Doubles:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.doubles.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Triples:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.triples.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(" - Quads:", style: TextStyle(fontSize: 18)),
                                                Text(
                                                  snapshot.data!.blitz[0]!.endContext!.clears.quads.toString(),
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    Text("That user never played Blitz",
                                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                                  ],
                          );
                        }),
                    ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Text("Other info", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              if (snapshot.data!.zen != null)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                                  child: Column(
                                    children: [
                                      Text("Zen", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                      Text("Level ${snapshot.data!.zen!.level}",
                                          style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                      Text(
                                        "Score ${snapshot.data!.zen!.score}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              if (snapshot.data!.bio != null)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                                  child: Column(
                                    children: [
                                      Text("Bio", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                      Text(
                                        snapshot.data!.bio!,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        })
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${snapshot.error}', style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  final Function changePlayer;
  const NavDrawer(this.changePlayer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              child: Text(
            'Players you track',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(prefs.getString("player") ?? "dan63047"),
            onTap: () {
              developer.log("Navigator changed player", name: "main_view");
              changePlayer(prefs.getString("player") ?? "dan63047");
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _StatCellNum extends StatelessWidget {
  const _StatCellNum({required this.playerStat, required this.playerStatLabel, required this.isScreenBig, this.snackBar, this.fractionDigits});

  final num playerStat;
  final String playerStatLabel;
  final bool isScreenBig;
  final String? snackBar;
  final int? fractionDigits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fractionDigits != null ? playerStat.toStringAsFixed(fractionDigits!) : playerStat.floor().toString(),
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            fontSize: isScreenBig ? 32 : 24,
          ),
        ),
        snackBar == null
            ? Text(
                playerStatLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Eurostile Round",
                  fontSize: 16,
                ),
              )
            : TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackBar!)));
                },
                style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Text(
                  playerStatLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Eurostile Round",
                    fontSize: 16,
                  ),
                )),
      ],
    );
  }
}

class _UserThingy extends StatelessWidget {
  final TetrioPlayer player;
  const _UserThingy({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      double bannerHeight = bigScreen ? 240 : 120;
      double pfpHeight = bigScreen ? 64 : 32;
      return Column(
        children: [
          Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (player.bannerRevision != null)
                    Image.network(
                      "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                      fit: BoxFit.cover,
                      height: bannerHeight,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log("Error with building banner image", name: "main_view", error: error, stackTrace: stackTrace);
                        return const Placeholder(
                          color: Colors.black,
                        );
                      },
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, player.bannerRevision != null ? bannerHeight / 1.4 : pfpHeight, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                          ? Image.asset(
                              "res/avatars/tetrio_banned.png",
                              fit: BoxFit.fitHeight,
                              height: 128,
                            )
                          : player.avatarRevision != null
                              ? Image.network("https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                                  fit: BoxFit.fitHeight, height: 128, errorBuilder: (context, error, stackTrace) {
                                  developer.log("Error with building profile picture", name: "main_view", error: error, stackTrace: stackTrace);
                                  return Image.asset(
                                    "res/avatars/tetrio_anon.png",
                                    fit: BoxFit.fitHeight,
                                    height: 128,
                                  );
                                })
                              : Image.asset(
                                  "res/avatars/tetrio_anon.png",
                                  fit: BoxFit.fitHeight,
                                  height: 128,
                                ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(player.username, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    TextButton(
                        child: Text(player.userId, style: const TextStyle(fontFamily: "Eurostile Round Condensed", fontSize: 14)),
                        onPressed: () {
                          copyToClipboard(player.userId);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard!")));
                        }),
                  ],
                ),
              ),
            ],
          ),
          (player.role != "banned")
              ? Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  clipBehavior: Clip.hardEdge, // hard WHAT???
                  children: [
                    _StatCellNum(
                      playerStat: player.level,
                      playerStatLabel: "XP Level",
                      isScreenBig: bigScreen,
                      snackBar: "${player.xp.floor().toString()} XP, ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} % until next level",
                    ),
                    if (player.gameTime >= Duration.zero)
                      _StatCellNum(
                        playerStat: player.gameTime.inHours,
                        playerStatLabel: "Hours\nPlayed",
                        isScreenBig: bigScreen,
                        snackBar: player.gameTime.toString(),
                      ),
                    if (player.gamesPlayed >= 0) _StatCellNum(playerStat: player.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: "Online\nGames"),
                    if (player.gamesWon >= 0) _StatCellNum(playerStat: player.gamesWon, isScreenBig: bigScreen, playerStatLabel: "Games\nWon"),
                    if (player.friendCount > 0) _StatCellNum(playerStat: player.friendCount, isScreenBig: bigScreen, playerStatLabel: "Friends"),
                  ],
                )
              : Text(
                  "BANNED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Eurostile Round Extended",
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontSize: bigScreen ? 60 : 45,
                  ),
                ),
          if (player.badstanding != null && player.badstanding!)
            Text(
              "BAD STANDING",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Eurostile Round Extended",
                fontWeight: FontWeight.w900,
                color: Colors.red,
                fontSize: bigScreen ? 60 : 45,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                    "${player.country != null ? "${player.country?.toUpperCase()} • " : ""}${player.role.capitalize()} account ${player.registrationTime == null ? "that was from very beginning" : 'created ${player.registrationTime}'} • ${player.supporterTier == 0 ? "Not a supporter" : "Supporter tier ${player.supporterTier}"}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Eurostile Round",
                      fontSize: 16,
                    )),
              )
            ],
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.hardEdge,
            children: [
              for (var badge in player.badges)
                IconButton(
                    onPressed: () => showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                badge.label,
                                style: const TextStyle(fontFamily: "Eurostile Round Extended"),
                              ),
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
                                        Text(badge.ts != null ? "Obtained ${badge.ts}" : "That badge was assigned manualy by TETR.IO admins"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
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
                      height: 64,
                      width: 64,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log("Error with building $badge", name: "main_view", error: error, stackTrace: stackTrace);
                        return Image.asset("res/icons/kagari.png", height: 64, width: 64);
                      },
                    ))
            ],
          ),
        ],
      );
    });
  }
}
