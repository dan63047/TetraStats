import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/tl_match_view.dart' show TlMatchResultView;
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';

String _searchFor = "dan63047";
Future<TetrioPlayer>? me;
final TetrioService teto = TetrioService();
late SharedPreferences prefs;
const allowedHeightForPlayerIdInPixels = 40.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;
final NumberFormat timeInSec = NumberFormat("#,###.###s.");
final NumberFormat f2 = NumberFormat.decimalPatternDigits(decimalDigits: 2);

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
    const Tab(text: "TL Records"),
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
      autocorrect: false,
      enableSuggestions: false,
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
    teto.open();
    _scrollController = ScrollController();
    _tabController = TabController(length: 5, vsync: this);
    _getPreferences()
        .then((value) => changePlayer(prefs.getString("player") ?? "dan63047"));
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

  void changePlayer(String player) {
    setState(() {
      _tabController.animateTo(0, duration: const Duration(milliseconds: 300));
      _searchFor = player;
      me = teto.fetchPlayer(player, false);
    });
  }

  void _justUpdate() {
    setState(() {});
  }

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
                value: "/states",
                child: Text('Show stored data'),
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
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                    child: Text('none case of FutureBuilder',
                        style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 42),
                        textAlign: TextAlign.center));
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              case ConnectionState.active:
                return const Center(
                    child: Text('active case of FutureBuilder',
                        style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 42),
                        textAlign: TextAlign.center));
              case ConnectionState.done:
                //bool bigScreen = MediaQuery.of(context).size.width > 1024;
                if (snapshot.hasData) {
                  if (_searchFor.length > 16)
                    _searchFor = snapshot.data!.username;
                  teto.isPlayerTracking(snapshot.data!.userId).then((value) {
                    if (value) teto.storeState(snapshot.data!);
                  });
                  return NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverToBoxAdapter(
                            child: UserThingy(
                          player: snapshot.data!,
                          showStateTimestamp: false,
                          setState: _justUpdate,
                        )),
                        SliverToBoxAdapter(
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabs: myTabs,
                            onTap: (int tabId) {
                              setState(() {});
                            },
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        TLThingy(
                            tl: snapshot.data!.tlSeason1,
                            userID: snapshot.data!.userId),
                        _TLRecords(userID: snapshot.data!.userId),
                        _RecordThingy(
                            record: (snapshot.data!.sprint.isNotEmpty)
                                ? snapshot.data!.sprint[0]
                                : null),
                        _RecordThingy(
                            record: (snapshot.data!.blitz.isNotEmpty)
                                ? snapshot.data!.blitz[0]
                                : null),
                        _OtherThingy(
                            zen: snapshot.data!.zen, bio: snapshot.data!.bio)
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('${snapshot.error}',
                          style: const TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: 42),
                          textAlign: TextAlign.center));
                }
                break;
              default:
                return const Center(
                    child: Text('default case of FutureBuilder',
                        style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 42),
                        textAlign: TextAlign.center));
            }
            return const Center(
                child: Text('end of FutureBuilder',
                    style: TextStyle(
                        fontFamily: "Eurostile Round Extended", fontSize: 42),
                    textAlign: TextAlign.center));
          },
        ),
      ),
    );
  }
}

class NavDrawer extends StatefulWidget {
  final Function changePlayer;

  const NavDrawer(this.changePlayer, {super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late ScrollController _scrollController;
  String homePlayerNickname = "Checking...";
  @override
  void initState() {
    super.initState();
    _setHomePlayerNickname(prefs.getString("player"));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _setHomePlayerNickname(String? n) async {
    if (n != null) {
      try {
        homePlayerNickname = await teto.getNicknameByID(n);
      } on TetrioPlayerNotExist {
        homePlayerNickname = n;
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
              return const Center(child: Text('none case of StreamBuilder'));
            case ConnectionState.waiting:
            case ConnectionState.active:
              final allPlayers = (snapshot.data != null)
                  ? snapshot.data as Map<String, List<TetrioPlayer>>
                  : <String, List<TetrioPlayer>>{};
              List<String> keys = allPlayers.keys.toList();
              return NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      const SliverToBoxAdapter(
                          child: DrawerHeader(
                              child: Text(
                        'Players you track',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ))),
                      SliverToBoxAdapter(
                        child: ListTile(
                          leading: const Icon(Icons.home),
                          title: Text(homePlayerNickname),
                          onTap: () {
                            widget.changePlayer(
                                prefs.getString("player") ?? "dan63047");
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ];
                  },
                  body: ListView.builder(
                      itemCount: allPlayers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              allPlayers[keys[index]]?.last.username as String),
                          onTap: () {
                            widget.changePlayer(keys[index]);
                            Navigator.of(context).pop();
                          },
                        );
                      }));
            case ConnectionState.done:
              return const Center(child: Text('done case of StreamBuilder'));
          }
        },
      ),
    );
  }
}

class _TLRecords extends StatelessWidget {
  final String userID;

  const _TLRecords({required this.userID});

  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
          future: teto.getTLStream(userID),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28));
                } else {
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    children: (snapshot.data!.records!.isNotEmpty)
                        ? [for (var value in snapshot.data!.records!) ListTile(
                          leading: Text("${value.endContext.firstWhere((element) => element.userId == userID).points} : ${value.endContext.firstWhere((element) => element.userId != userID).points}",
                          style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28,)),
                          title: Text("vs. ${value.endContext.firstWhere((element) => element.userId != userID).username}"),
                          subtitle: Text(dateFormat.format(value.timestamp!)),
                          trailing: Column(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).secondary)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).secondary)} APM", style: TextStyle(height: 1.1)),
                            Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).tertiary)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).tertiary)} PPS", style: TextStyle(height: 1.1)),
                            Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).extra)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).extra)} VS", style: TextStyle(height: 1.1)),
                          ]),
                          onTap: (){Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TlMatchResultView(record: value, initPlayerId: userID),
                                ),
                              );},
                        )]
                        : [const Text("No records",style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28))],
                  );
                }
            }
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
                        Text("40 Lines",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28))
                      else if (record!.stream.contains("blitz"))
                        Text("Blitz",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                      if (record!.stream.contains("40l"))
                        Text(
                            timeInSec.format(
                                record!.endContext!.finalTime.inMicroseconds /
                                    1000000),
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28))
                      else if (record!.stream.contains("blitz"))
                        Text(
                            NumberFormat.decimalPattern()
                                .format(record!.endContext!.score),
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                      if (record!.rank != null)
                        StatCellNum(
                            playerStat: record!.rank!,
                            playerStatLabel: "Leaderboard Placement",
                            isScreenBig: bigScreen),
                      Text("Obtained ${dateFormat.format(record!.timestamp!)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Eurostile Round",
                            fontSize: 16,
                          )),
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
                              StatCellNum(
                                  playerStat: record!.endContext!.level,
                                  playerStatLabel: "Level",
                                  isScreenBig: bigScreen),
                            if (record!.stream.contains("blitz"))
                              StatCellNum(
                                  playerStat: record!.endContext!.spp,
                                  playerStatLabel: "Score\nPer Piece",
                                  fractionDigits: 2,
                                  isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.piecesPlaced,
                                playerStatLabel: "Pieces\nPlaced",
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.pps,
                                playerStatLabel: "Pieces\nPer Second",
                                fractionDigits: 2,
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.finesse.faults,
                                playerStatLabel: "Finesse\nFaults",
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat:
                                    record!.endContext!.finessePercentage * 100,
                                playerStatLabel: "Finesse\nPercentage",
                                fractionDigits: 2,
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.inputs,
                                playerStatLabel: "Key\nPresses",
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.kpp,
                                playerStatLabel: "KP Per\nPiece",
                                fractionDigits: 2,
                                isScreenBig: bigScreen),
                            StatCellNum(
                                playerStat: record!.endContext!.kps,
                                playerStatLabel: "KP Per\nSecond",
                                fractionDigits: 2,
                                isScreenBig: bigScreen),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                        child: SizedBox(
                          width: bigScreen
                              ? MediaQuery.of(context).size.width * 0.4
                              : MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("All Clears:",
                                      style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.clears.allClears
                                        .toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Holds:",
                                      style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.holds.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("T-spins total:",
                                      style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.tSpins.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin zero:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinZeros
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin singles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinSingles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin doubles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinDoubles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin triples:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinTriples
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini zero:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniZeros
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini singles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniSingles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - T-spin mini doubles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.tSpinMiniDoubles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Line clears:",
                                      style: TextStyle(fontSize: 24)),
                                  Text(
                                    record!.endContext!.lines.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Singles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.singles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Doubles:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.doubles
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Triples:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    record!.endContext!.clears.triples
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(" - Quads:",
                                      style: TextStyle(fontSize: 18)),
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
                  : [
                      Text("No record",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28))
                    ],
            );
          });
    });
  }
}

class _OtherThingy extends StatelessWidget {
  final TetrioZen? zen;
  final String? bio;
  const _OtherThingy({Key? key, required this.zen, required this.bio})
      : super(key: key);

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
              Text("Other info",
                  style: TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      fontSize: bigScreen ? 42 : 28)),
              if (zen != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                  child: Column(
                    children: [
                      Text("Zen",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                      Text(
                          "Level ${NumberFormat.decimalPattern().format(zen!.level)}",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                      Text(
                          "Score ${NumberFormat.decimalPattern().format(zen!.score)}",
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              if (bio != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text("Bio",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
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
