import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
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
late Future<TetrioPlayer> me;
DB db = DB();
TetrioService teto = TetrioService();
const allowedHeightForPlayerIdInPixels = 40.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;

enum ThreeDotsItems { compare, states, settings }

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  String get title => "Tetra Stats: $_searchFor";

  @override
  State<MainView> createState() => _MyHomePageState();
}

Future<TetrioPlayer> fetchTetrioPlayer(String user) async {
  var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase().trim()}');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['success']
        ? TetrioPlayer.fromJson(
            jsonDecode(response.body)['data']['user'],
            DateTime.fromMillisecondsSinceEpoch(
                jsonDecode(response.body)['cache']['cached_at'],
                isUtc: true))
        : throw Exception("User doesn't exist");
  } else {
    throw Exception('Failed to fetch player');
  }
}

class _MyHomePageState extends State<MainView>
    with SingleTickerProviderStateMixin {
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
      decoration: InputDecoration(counter: Offstage()),
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
      onSubmitted: (String value) => setState(() {
        me = fetchTetrioPlayer(value);
        _searchFor = value;
      }),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);
    //_tabController.addListener(_smoothScrollToTop);
    me = fetchTetrioPlayer("dan63047");
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
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
                      //add
                      _searchBoolean = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                  tooltip: "Search player",
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      //add
                      _searchBoolean = false;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: "Close search",
                ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ThreeDotsItems>>[
              const PopupMenuItem<ThreeDotsItems>(
                value: ThreeDotsItems.compare,
                child: Text('Compare'),
              ),
              const PopupMenuItem<ThreeDotsItems>(
                value: ThreeDotsItems.states,
                child: Text('States'),
              ),
              const PopupMenuItem<ThreeDotsItems>(
                value: ThreeDotsItems.settings,
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<TetrioPlayer>(
          future: me,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool bigScreen = MediaQuery.of(context).size.width > 768;
              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                        child: _UserThingy(player: snapshot.data!)),
                    SliverToBoxAdapter(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabs: myTabs,
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
                                  Text("Tetra League",
                                      style: TextStyle(
                                          fontFamily:
                                              "Eurostile Round Extended",
                                          fontSize: bigScreen ? 42 : 28)),
                                  if (snapshot.data!.tlSeason1.gamesPlayed >=
                                      10)
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceAround,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        Image.asset(
                                          "res/tetrio_tl_alpha_ranks/${snapshot.data!.tlSeason1.rank}.png",
                                          height: 128,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                "${snapshot.data!.tlSeason1.rating.toStringAsFixed(2)} TR",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Eurostile Round Extended",
                                                    fontSize:
                                                        bigScreen ? 42 : 28)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                "${10 - snapshot.data!.tlSeason1.gamesPlayed} games until being ranked",
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "Eurostile Round Extended",
                                                  fontSize: bigScreen ? 42 : 28,
                                                  overflow:
                                                      TextOverflow.visible,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      spacing: 25,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        if (snapshot.data!.tlSeason1.apm !=
                                            null)
                                          _StatCellNum(
                                              playerStat:
                                                  snapshot.data!.tlSeason1.apm!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel:
                                                  "Attack\nPer Minute"),
                                        if (snapshot.data!.tlSeason1.pps !=
                                            null)
                                          _StatCellNum(
                                              playerStat:
                                                  snapshot.data!.tlSeason1.pps!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel:
                                                  "Pieces\nPer Second"),
                                        if (snapshot.data!.tlSeason1.apm !=
                                            null)
                                          _StatCellNum(
                                              playerStat:
                                                  snapshot.data!.tlSeason1.vs!,
                                              isScreenBig: bigScreen,
                                              fractionDigits: 2,
                                              playerStatLabel: "Versus\nScore"),
                                        if (snapshot.data!.tlSeason1.standing >
                                            0)
                                          _StatCellNum(
                                              playerStat: snapshot
                                                  .data!.tlSeason1.standing,
                                              isScreenBig: bigScreen,
                                              playerStatLabel:
                                                  "Leaderboard\nplacement"),
                                        if (snapshot
                                                .data!.tlSeason1.standingLocal >
                                            0)
                                          _StatCellNum(
                                              playerStat: snapshot.data!
                                                  .tlSeason1.standingLocal,
                                              isScreenBig: bigScreen,
                                              playerStatLabel:
                                                  "Country LB\nplacement"),
                                        _StatCellNum(
                                            playerStat: snapshot
                                                .data!.tlSeason1.gamesPlayed,
                                            isScreenBig: bigScreen,
                                            playerStatLabel: "Games\nplayed"),
                                        _StatCellNum(
                                            playerStat: snapshot
                                                .data!.tlSeason1.gamesWon,
                                            isScreenBig: bigScreen,
                                            playerStatLabel: "Games\nwon"),
                                        _StatCellNum(
                                            playerStat: snapshot
                                                    .data!.tlSeason1.winrate *
                                                100,
                                            isScreenBig: bigScreen,
                                            fractionDigits: 2,
                                            playerStatLabel:
                                                "Winrate\nprecentage"),
                                      ],
                                    ),
                                  ),
                                  if (snapshot.data!.tlSeason1.apm != null &&
                                      snapshot.data!.tlSeason1.pps != null &&
                                      snapshot.data!.tlSeason1.apm != null)
                                    Column(
                                      children: [
                                        Text("Nerd Stats",
                                            style: TextStyle(
                                                fontFamily:
                                                    "Eurostile Round Extended",
                                                fontSize: bigScreen ? 42 : 28)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 16, 0, 48),
                                          child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.center,
                                              spacing: 25,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              clipBehavior: Clip.hardEdge,
                                              children: [
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.app!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "Attack\nPer Piece"),
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.vsapm!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel: "VS/APM"),
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.dss!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "Downstack\nPer Second"),
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.dsp!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "Downstack\nPer Piece"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!
                                                        .tlSeason1.appdsp!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "APP + DS/P"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!
                                                        .tlSeason1.cheese!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 2,
                                                    playerStatLabel:
                                                        "Cheese\nIndex"),
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.gbe!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "Garbage\nEfficiency"),
                                                _StatCellNum(
                                                    playerStat: snapshot.data!
                                                        .tlSeason1.nyaapp!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 3,
                                                    playerStatLabel:
                                                        "Weighted\nAPP"),
                                                _StatCellNum(
                                                    playerStat: snapshot
                                                        .data!.tlSeason1.area!,
                                                    isScreenBig: bigScreen,
                                                    fractionDigits: 1,
                                                    playerStatLabel: "Area")
                                              ]),
                                        )
                                      ],
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                    child: SizedBox(
                                      width: bigScreen
                                          ? MediaQuery.of(context).size.width *
                                              0.4
                                          : MediaQuery.of(context).size.width *
                                              0.85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Est. of TR:",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              Text(
                                                snapshot.data!.tlSeason1.esttr!
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Accuracy of TR Est.:",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              Text(
                                                (snapshot.data!.tlSeason1
                                                        .esttracc!)
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                    fontSize: 24),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 48),
                                    child: SizedBox(
                                      height: 300,
                                      child: RadarChart(
                                        RadarChartData(
                                          getTitle: (index, angle) {
                                            bool relativeAngleMode = true;
                                            double angleValue = 0;
                                            final usedAngle = relativeAngleMode
                                                ? angle + angleValue
                                                : angleValue;
                                            switch (index) {
                                              case 0:
                                                return RadarChartTitle(
                                                  text: 'APM',
                                                  angle: usedAngle,
                                                );
                                              case 1:
                                                return RadarChartTitle(
                                                  text: 'PPS',
                                                  angle: usedAngle,
                                                );
                                              case 2:
                                                return RadarChartTitle(
                                                    text: 'VS',
                                                    angle: usedAngle);
                                              case 3:
                                                return RadarChartTitle(
                                                    text: 'APP',
                                                    angle: usedAngle);
                                              case 4:
                                                return RadarChartTitle(
                                                    text: 'DS/S',
                                                    angle: usedAngle);
                                              case 5:
                                                return RadarChartTitle(
                                                    text: 'DS/P',
                                                    angle: usedAngle);
                                              case 6:
                                                return RadarChartTitle(
                                                    text: 'APP+DS/P',
                                                    angle: usedAngle);
                                              case 7:
                                                return RadarChartTitle(
                                                    text: 'VS/APM',
                                                    angle: usedAngle);
                                              case 8:
                                                return RadarChartTitle(
                                                    text: 'Cheese',
                                                    angle: usedAngle);
                                              case 9:
                                                return RadarChartTitle(
                                                    text: 'Gb Eff.',
                                                    angle: usedAngle);
                                              default:
                                                return const RadarChartTitle(
                                                    text: '');
                                            }
                                          },
                                          dataSets: [
                                            RadarDataSet(
                                              dataEntries: [
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.apm! *
                                                        1),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.pps! *
                                                        45),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.vs! *
                                                        0.444),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.app! *
                                                        185),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.dss! *
                                                        175),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.dsp! *
                                                        450),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                        .tlSeason1.appdsp!),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                        .tlSeason1.vsapm!),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                        .tlSeason1.cheese!),
                                                RadarEntry(
                                                    value: snapshot.data!
                                                            .tlSeason1.gbe! *
                                                        315),
                                              ],
                                            )
                                          ],
                                        ),
                                        swapAnimationDuration: const Duration(
                                            milliseconds: 150), // Optional
                                        swapAnimationCurve:
                                            Curves.linear, // Optional
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  Text("That user never played Tetra League",
                                      style: TextStyle(
                                          fontFamily:
                                              "Eurostile Round Extended",
                                          fontSize: bigScreen ? 42 : 28)),
                                ],
                        );
                      },
                    ),
                    Column(
                      children: (snapshot.data!.sprint.isNotEmpty)
                          ? []
                          : [
                              Text("That user never played 40 Lines",
                                  style: TextStyle(
                                      fontFamily: "Eurostile Round Extended",
                                      fontSize: bigScreen ? 42 : 28))
                            ],
                    ),
                    Container(
                      child: Text("Blitz",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                    ),
                    Container(
                      child: Text("Other info",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${snapshot.error}',
                      style: const TextStyle(
                          fontFamily: "Eurostile Round Extended",
                          fontSize: 42)));
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              child: Text(
            'Side menu',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}

class _StatCellNum extends StatelessWidget {
  const _StatCellNum(
      {required this.playerStat,
      required this.playerStatLabel,
      required this.isScreenBig,
      this.snackBar,
      this.fractionDigits});

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
          fractionDigits != null
              ? playerStat.toStringAsFixed(fractionDigits!)
              : playerStat.floor().toString(),
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(snackBar!)));
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
  _UserThingy({Key? key, required this.player}) : super(key: key);

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
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        player.bannerRevision != null
                            ? bannerHeight / 1.4
                            : pfpHeight,
                        0,
                        0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                          ? Image.asset(
                              "res/avatars/tetrio_banned.png",
                              fit: BoxFit.fitHeight,
                              height: 128,
                            )
                          : Image.network(
                              "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                              fit: BoxFit.fitHeight,
                              height: 128,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "res/avatars/tetrio_anon.png",
                                fit: BoxFit.fitHeight,
                                height: 128,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(player.username,
                        style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: bigScreen ? 42 : 28)),
                    Text(
                      player.userId,
                      style: const TextStyle(
                          fontFamily: "Eurostile Round Condensed",
                          fontSize: 14),
                    ),
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
                      snackBar:
                          "${player.xp.floor().toString()} XP, ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} % until next level",
                    ),
                    if (player.gameTime >= Duration.zero)
                      _StatCellNum(
                        playerStat: player.gameTime.inHours,
                        playerStatLabel: "Hours\nPlayed",
                        isScreenBig: bigScreen,
                        snackBar: player.gameTime.toString(),
                      ),
                    if (player.gamesPlayed >= 0)
                      _StatCellNum(
                          playerStat: player.gamesPlayed,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Online\nGames"),
                    if (player.gamesWon >= 0)
                      _StatCellNum(
                          playerStat: player.gamesWon,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Games\nWon"),
                    if (player.friendCount > 0)
                      _StatCellNum(
                          playerStat: player.friendCount,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Friends"),
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
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                badge.label,
                                style: const TextStyle(
                                    fontFamily: "Eurostile Round Extended"),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 25,
                                      children: [
                                        Image.asset(
                                            "res/tetrio_badges/${badge.badgeId}.png"),
                                        Text(badge.ts != null
                                            ? "Obtained ${badge.ts}"
                                            : "That badge was assigned manualy by TETR.IO admins"),
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
                    ))
            ],
          ),
        ],
      );
    });
  }
}
