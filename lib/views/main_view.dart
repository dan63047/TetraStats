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
final TetrioService teto = TetrioService();
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
    //teto = TetrioService();
    teto.open();
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
    //db.close();
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
      me = teto.fetchPlayer(player, false);
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
                value: "/calc",
                child: Text('Stats Calculator'),
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
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                    child: Text('none case of FutureBuilder',
                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              case ConnectionState.active:
                return Center(
                    child: Text('active case of FutureBuilder',
                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
              case ConnectionState.done:
                bool bigScreen = MediaQuery.of(context).size.width > 1024;
                if (snapshot.hasData) {
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
                        _TLThingy(tl: snapshot.data!.tlSeason1, userID: snapshot.data!.userId),
                        _RecordThingy(record: (snapshot.data!.sprint.isNotEmpty) ? snapshot.data!.sprint[0] : null),
                        _RecordThingy(record: (snapshot.data!.blitz.isNotEmpty) ? snapshot.data!.blitz[0] : null),
                        _OtherThingy(zen: snapshot.data!.zen, bio: snapshot.data!.bio)
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('${snapshot.error}', style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
                }
                break;
              default:
                return Center(
                    child: Text('default case of FutureBuilder',
                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
            }
            return Center(
                child: Text('end of FutureBuilder', style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
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
          StreamBuilder(
            stream: teto.allPlayers,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text('none case of StreamBuilder'));
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(child: Text('${snapshot.data}'));
                case ConnectionState.done:
                  return Center(child: Text('done case of StreamBuilder'));
              }
            },
          )
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
                    "${player.country != null ? "${player.country?.toUpperCase()} • " : ""}${player.role.capitalize()} account ${player.registrationTime == null ? "that was from very beginning" : 'created ${player.registrationTime}'}${player.botmaster != null ? " by ${player.botmaster}" : ""} • ${player.supporterTier == 0 ? "Not a supporter" : "Supporter tier ${player.supporterTier}"}",
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

class _TLThingy extends StatelessWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  const _TLThingy({Key? key, required this.tl, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: (tl.gamesPlayed > 0)
                ? [
                    Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (tl.gamesPlayed >= 10)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          userID == "5e32fc85ab319c2ab1beb07c" // he love her so much, you can't even imagine
                              ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
                              : Image.asset("res/tetrio_tl_alpha_ranks/${tl.rank}.png", height: 128),
                          Column(
                            children: [
                              Text("${tl.rating.toStringAsFixed(2)} TR",
                                  style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              Text(
                                "Top ${(tl.percentile * 100).toStringAsFixed(2)}% (${tl.percentileRank.toUpperCase()}) • Top Rank: ${tl.bestRank.toUpperCase()} • Glicko: ${tl.glicko?.toStringAsFixed(2)}±${tl.rd?.toStringAsFixed(2)}${tl.decaying ? ' • Decaying' : ''}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Text("${10 - tl.gamesPlayed} games until being ranked",
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: bigScreen ? 42 : 28,
                            overflow: TextOverflow.visible,
                          )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          if (tl.apm != null)
                            _StatCellNum(playerStat: tl.apm!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Attack\nPer Minute"),
                          if (tl.pps != null)
                            _StatCellNum(playerStat: tl.pps!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Pieces\nPer Second"),
                          if (tl.apm != null) _StatCellNum(playerStat: tl.vs!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Versus\nScore"),
                          if (tl.standing > 0) _StatCellNum(playerStat: tl.standing, isScreenBig: bigScreen, playerStatLabel: "Leaderboard\nplacement"),
                          if (tl.standingLocal > 0)
                            _StatCellNum(playerStat: tl.standingLocal, isScreenBig: bigScreen, playerStatLabel: "Country LB\nplacement"),
                          _StatCellNum(playerStat: tl.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: "Games\nplayed"),
                          _StatCellNum(playerStat: tl.gamesWon, isScreenBig: bigScreen, playerStatLabel: "Games\nwon"),
                          _StatCellNum(playerStat: tl.winrate * 100, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Winrate\nprecentage"),
                        ],
                      ),
                    ),
                    if (tl.nerdStats != null)
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
                                  _StatCellNum(playerStat: tl.nerdStats!.app, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Attack\nPer Piece"),
                                  _StatCellNum(playerStat: tl.nerdStats!.vsapm, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "VS/APM"),
                                  _StatCellNum(
                                      playerStat: tl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Second"),
                                  _StatCellNum(
                                      playerStat: tl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Piece"),
                                  _StatCellNum(playerStat: tl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "APP + DS/P"),
                                  _StatCellNum(playerStat: tl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Cheese\nIndex"),
                                  _StatCellNum(
                                      playerStat: tl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Garbage\nEfficiency"),
                                  _StatCellNum(playerStat: tl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Weighted\nAPP"),
                                  _StatCellNum(playerStat: tl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: "Area")
                                ]),
                          )
                        ],
                      ),
                    if (tl.estTr != null)
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
                                    tl.estTr!.esttr.toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              if (tl.rating >= 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Accuracy:",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      tl.esttracc!.toStringAsFixed(2),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (tl.nerdStats != null)
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
                                        RadarEntry(value: tl.apm! * 1),
                                        RadarEntry(value: tl.pps! * 45),
                                        RadarEntry(value: tl.vs! * 0.444),
                                        RadarEntry(value: tl.nerdStats!.app * 185),
                                        RadarEntry(value: tl.nerdStats!.dss * 175),
                                        RadarEntry(value: tl.nerdStats!.dsp * 450),
                                        RadarEntry(value: tl.nerdStats!.appdsp * 140),
                                        RadarEntry(value: tl.nerdStats!.vsapm * 60),
                                        RadarEntry(value: tl.nerdStats!.cheese * 1.25),
                                        RadarEntry(value: tl.nerdStats!.gbe * 315),
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
                                        RadarEntry(value: tl.playstyle!.opener),
                                        RadarEntry(value: tl.playstyle!.stride),
                                        RadarEntry(value: tl.playstyle!.infds),
                                        RadarEntry(value: tl.playstyle!.plonk),
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
                    Text("That user never played Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                  ],
          );
        },
      );
    });
  }
}

class _RecordThingy extends StatelessWidget {
  final RecordSingle? record;
  const _RecordThingy({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: (record != null)
                  ? [
                      if (record!.stream.contains("40l"))
                        Text("40 Lines", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                      else if (record!.stream.contains("blitz"))
                        Text("Blitz", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      if (record!.stream.contains("40l"))
                        Text(record!.endContext!.finalTime.toString(), style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                      else if (record!.stream.contains("blitz"))
                        Text(record!.endContext!.score.toString(), style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      if (record!.rank != null) _StatCellNum(playerStat: record!.rank!, playerStatLabel: "Leaderboard Placement", isScreenBig: bigScreen),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceAround,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          clipBehavior: Clip.hardEdge,
                          spacing: 25,
                          children: [
                            if (record!.stream.contains("blitz"))
                              _StatCellNum(playerStat: record!.endContext!.level, playerStatLabel: "Level", isScreenBig: bigScreen),
                            if (record!.stream.contains("blitz"))
                              _StatCellNum(playerStat: record!.endContext!.spp, playerStatLabel: "Score\nPer Piece", fractionDigits: 2, isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.piecesPlaced, playerStatLabel: "Pieces\nPlaced", isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.pps, playerStatLabel: "Pieces\nPer Second", fractionDigits: 2, isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.finesse.faults, playerStatLabel: "Finesse\nFaults", isScreenBig: bigScreen),
                            _StatCellNum(
                                playerStat: record!.endContext!.finessePercentage * 100,
                                playerStatLabel: "Finesse\nPercentage",
                                fractionDigits: 2,
                                isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.inputs, playerStatLabel: "Key\nPresses", isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.kpp, playerStatLabel: "KP Per\nPiece", fractionDigits: 2, isScreenBig: bigScreen),
                            _StatCellNum(playerStat: record!.endContext!.kps, playerStatLabel: "KP Per\nSecond", fractionDigits: 2, isScreenBig: bigScreen),
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
                                    record!.endContext!.clears.allClears.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Holds:", style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.holds.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("T-spins total:", style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.tSpins.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin zero:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinZeros.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin singles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinSingles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin doubles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinDoubles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin triples:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinTriples.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini zero:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniZeros.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini singles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniSingles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini doubles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniDoubles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Line clears:", style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.lines.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Singles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.singles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Doubles:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.doubles.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Triples:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.triples.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Quads:", style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.quads.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  : [Text("No record", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))],
            );
          });
    });
  }
}

class _OtherThingy extends StatelessWidget {
  final TetrioZen? zen;
  final String? bio;
  const _OtherThingy({Key? key, required this.zen, required this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Text("Other info", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
              if (zen != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                  child: Column(
                    children: [
                      Text("Zen", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      Text("Level ${zen!.level}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      Text(
                        "Score ${zen!.score}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              if (bio != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text("Bio", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      Text(bio!, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
            ],
          );
        },
      );
    });
  }
}
