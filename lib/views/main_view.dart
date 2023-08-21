import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/tl_leaderboard_view.dart' show TLLeaderboardView;
import 'package:tetra_stats/views/tl_match_view.dart' show TlMatchResultView;
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';

Future<List> me = Future.delayed(const Duration(seconds: 60), () => [null, null, null, null, null, null]);
String _searchFor = "6098518e3d5155e6ec429cdc";
String _titleNickname = "dan63047";
final TetrioService teto = TetrioService();
late SharedPreferences prefs;
var chartsData = <DropdownMenuItem<List<FlSpot>>>[];
List chartsShortTitles = ["TR", "Glicko", "RD", "APM", "PPS", "VS", "APP", "DS/S", "DS/P", "APP + DS/P", "VS/APM", "Cheese", "GbE", "wAPP", "Area", "eTR", "±eTR"];
int chartsIndex = 0; 
const allowedHeightForPlayerIdInPixels = 40.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;
final NumberFormat timeInSec = NumberFormat("#,###.###s.");
final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
final NumberFormat f4 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 4);
final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

class MainView extends StatefulWidget {
  final String? player;
  const MainView({Key? key, this.player}) : super(key: key);

  String get title => "Tetra Stats: $_titleNickname";

  @override
  State<MainView> createState() => _MainState();
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

class _MainState extends State<MainView> with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
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
    initDB();
    _scrollController = ScrollController();
    _tabController = TabController(length: 6, vsync: this);
    if (widget.player != null){
      changePlayer(widget.player!);
    }else{
      _getPreferences()
        .then((value) => changePlayer(prefs.getString("player") ?? "dan63047"));
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

  void changePlayer(String player, {bool fetchHistory = false}) {
    setState(() {
      _searchFor = player;
      me = fetch(_searchFor, fetchHistory: fetchHistory);
    });
  }

  void initDB() async{
    await teto.open();
  }

  Future<List> fetch(String nickOrID, {bool fetchHistory = false}) async {
    TetrioPlayer me;
    if (nickOrID.startsWith("ds:")){
      me = await teto.fetchPlayer(nickOrID.substring(3), isItDiscordID: true);
    }else{
      me = await teto.fetchPlayer(nickOrID);
    }
    _searchFor = me.userId;
    setState((){_titleNickname = me.username;});
    var tlStream = await teto.getTLStream(me.userId);
    List<TetraLeagueAlphaRecord> tlMatches = [];
    bool isTracking = await teto.isPlayerTracking(me.userId);
    List<TetrioPlayer> states = [];
    TetraLeagueAlpha? compareWith;
    var uniqueTL = <dynamic>{};
    if (isTracking){
      await teto.storeState(me);
      await teto.saveTLMatchesFromStream(await teto.getTLStream(me.userId));
    tlMatches.addAll(await teto.getTLMatchesbyPlayerID(me.userId));
    for (var match in tlStream.records) {
      if (!tlMatches.contains(match)) tlMatches.add(match);
    }
    tlMatches.sort((a, b) {
      if(a.timestamp.isBefore(b.timestamp)) return 1;
      if(a.timestamp.isAtSameMomentAs(b.timestamp)) return 0;
      if(a.timestamp.isAfter(b.timestamp)) return -1;
      return 0;
      });
    } else{
      tlMatches = tlStream.records;
    }
    if(fetchHistory) await teto.fetchAndsaveTLHistory(_searchFor);
    states.addAll(await teto.getPlayer(me.userId));
    for (var element in states) {
        if (uniqueTL.isNotEmpty && uniqueTL.last != element.tlSeason1) uniqueTL.add(element.tlSeason1);
        if (uniqueTL.isEmpty) uniqueTL.add(element.tlSeason1);
        }
        try{
          compareWith = uniqueTL.toList()[uniqueTL.length - 2];
        }on RangeError {
          compareWith = null;
        }
      chartsData = <DropdownMenuItem<List<FlSpot>>>[
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
    ];
    Map<String, dynamic> records = await teto.fetchRecords(me.userId);
    return [me, records, states, tlMatches, compareWith, isTracking];
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      drawer: widget.player == null ? NavDrawer(changePlayer) : null,
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
        actions: widget.player == null ? [ 
          !_searchBoolean
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                  tooltip: t.openSearch,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: t.closeSearch,
                ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: "refresh",
                child: Text(t.refresh),
              ),
              PopupMenuItem(
                value: "test",
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
              if (value == "refresh") {changePlayer(_searchFor);
              return;}
              if (value == "test"){changePlayer(_searchFor, fetchHistory: true);
              return;}
              Navigator.pushNamed(context, value);
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
                          TLThingy(
                              tl: snapshot.data![0].tlSeason1,
                              userID: snapshot.data![0].userId,
                              oldTl: snapshot.data![4]),
                          _TLRecords(userID: snapshot.data![0].userId, data: snapshot.data![3]),
                          _History(states: snapshot.data![2], update: _justUpdate),
                          _RecordThingy(
                              record: (snapshot.data![1]['sprint'].isNotEmpty)
                                  ? snapshot.data![1]['sprint'][0]
                                  : null),
                          _RecordThingy(
                              record: (snapshot.data![1]['blitz'].isNotEmpty)
                                  ? snapshot.data![1]['blitz'][0]
                                  : null),
                          _OtherThingy(
                              zen: snapshot.data![1]['zen'], bio: snapshot.data![0].bio, distinguishment: snapshot.data![0].distinguishment,)
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
                    case SocketException: // cant catch
                    var err = snapshot.error as SocketException;
                    errText = t.errors.socketException(host: err.address!.host, message: err.osError!.message);
                    break;
                    default:
                    errText = snapshot.error.toString();
                  }
                  return Center(
                      child: Text(errText,
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
                        child: ListTile(
                          leading: const Icon(Icons.home),
                          title: Text(homePlayerNickname),
                          onTap: () {
                            widget.changePlayer(
                                prefs.getString("player") ?? "dan63047");
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: ListTile(
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
                      const SliverToBoxAdapter(child: Divider())
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
  final List<TetraLeagueAlphaRecord> data;

  const _TLRecords({required this.userID, required this.data});

  @override
  Widget build(BuildContext context) {
      return ListView( // TODO: Redo using ListView.builder()
        physics: const AlwaysScrollableScrollPhysics(),
        children: (data.isNotEmpty)
            ? [for (var value in data) ListTile(
              leading: Text("${value.endContext.firstWhere((element) => element.userId == userID).points} : ${value.endContext.firstWhere((element) => element.userId != userID).points}",
              style: const TextStyle(
                fontFamily: "Eurostile Round Extended",
                fontSize: 28,)),
              title: Text("vs. ${value.endContext.firstWhere((element) => element.userId != userID).username}"),
              subtitle: Text(dateFormat.format(value.timestamp)),
              trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).secondary)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).secondary)} APM", style: const TextStyle(height: 1.1)),
                Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).tertiary)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).tertiary)} PPS", style: const TextStyle(height: 1.1)),
                Text("${f2.format(value.endContext.firstWhere((element) => element.userId == userID).extra)} : ${f2.format(value.endContext.firstWhere((element) => element.userId != userID).extra)} VS", style: const TextStyle(height: 1.1)),
              ]),
              onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TlMatchResultView(record: value, initPlayerId: userID),
                    ),
                  );},
            )]
            : [Center(child: Text(t.noRecords, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))],
      );
  }
}

class _History extends StatelessWidget{
  final List<TetrioPlayer> states;
  final Function update;
  const _History({required this.states, required this.update});
  
  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return ListView(physics: const ClampingScrollPhysics(),
    children: states.isNotEmpty ? [
      Column(
        children: [
          DropdownButton(
                items: chartsData,
                value: chartsData[chartsIndex].value,
                onChanged: (value) {
                  chartsIndex = chartsData.indexWhere((element) => element.value == value);
                  update();
                }
              ),
          if(chartsData[chartsIndex].value!.length > 1) _HistoryChartThigy(data: chartsData[chartsIndex].value!, title: "ss", yAxisTitle: chartsShortTitles[chartsIndex], bigScreen: bigScreen, leftSpace: bigScreen? 80 : 45, yFormat: bigScreen? f2 : NumberFormat.compact(),)
          else Center(child: Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))
        ],
      ),
    ] : [Center(child: Text(t.noHistorySaved, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))]);
  }
}

class _HistoryChartThigy extends StatelessWidget{
  final List<FlSpot> data;
  final String title;
  final String yAxisTitle;
  final bool bigScreen;
  final double leftSpace;
  final NumberFormat yFormat;
  const _HistoryChartThigy({required this.data, required this.title, required this.yAxisTitle, required this.bigScreen, required this.leftSpace, required this.yFormat});
  
  @override
  Widget build(BuildContext context) {    
    double xInterval = bigScreen ? max(1, (data.last.x - data.first.x) / 6) : max(1, (data.last.x - data.first.x) / 3);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 100,
      child: Stack(
        children: [
          Padding( padding: bigScreen ? const EdgeInsets.fromLTRB(40, 40, 40, 48) : const EdgeInsets.fromLTRB(0, 40, 16, 48) ,
          child: LineChart(
            LineChartData(
              lineBarsData: [LineChartBarData(spots: data)],
              borderData: FlBorderData(show: false),
              gridData: FlGridData(verticalInterval: xInterval),
              titlesData: FlTitlesData(topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(interval: xInterval, showTitles: true, reservedSize: 30, getTitlesWidget: (double value, TitleMeta meta){
                return value != meta.min && value != meta.max ? SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).format(DateTime.fromMillisecondsSinceEpoch(value.floor()))),
                ) : Container();
              })),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: leftSpace, getTitlesWidget: (double value, TitleMeta meta){
                return value != meta.min && value != meta.max ? SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(yFormat.format(value)),
                ) : Container();
              }))),
              lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData( fitInsideHorizontally: true, fitInsideVertically: true, getTooltipItems: (touchedSpots) {
                return [for (var v in touchedSpots) LineTooltipItem("${f4.format(v.y)} $yAxisTitle \n", const TextStyle(), children: [TextSpan(text: dateFormat.format(DateTime.fromMillisecondsSinceEpoch(v.x.floor())))])];
              },))
              )
            ),
          ),
        ],
      )
    );
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
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: (record != null)
                  ? [
                      if (record!.stream.contains("40l"))
                        Text(t.sprint,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28))
                      else if (record!.stream.contains("blitz"))
                        Text(t.blitz,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                      if (record!.stream.contains("40l"))
                        if (record!.endContext!.finalTime.inMicroseconds > 60000000) Text(
                          "${(record!.endContext!.finalTime.inMicroseconds/1000000/60).floor()}:${(f2.format(record!.endContext!.finalTime.inMicroseconds /1000000 % 60))}",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28))
                        else Text(
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
                            isScreenBig: bigScreen,
                            higherIsBetter: false),
                      Text(t.obtainDate(date: dateFormat.format(record!.timestamp!)),
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
                                  playerStatLabel: t.statCellNum.level,
                                  isScreenBig: bigScreen,
                                  higherIsBetter: true,),
                            if (record!.stream.contains("blitz"))
                              StatCellNum(
                                  playerStat: record!.endContext!.spp,
                                  playerStatLabel: t.statCellNum.spp,
                                  fractionDigits: 2,
                                  isScreenBig: bigScreen,
                                  higherIsBetter: true,),
                            StatCellNum(
                                playerStat: record!.endContext!.piecesPlaced,
                                playerStatLabel: t.statCellNum.pieces,
                                isScreenBig: bigScreen,
                                  higherIsBetter: true,),
                            StatCellNum(
                                playerStat: record!.endContext!.pps,
                                playerStatLabel: t.statCellNum.pps,
                                fractionDigits: 2,
                                isScreenBig: bigScreen,
                                  higherIsBetter: true,),
                            StatCellNum(
                                playerStat: record!.endContext!.finesse.faults,
                                playerStatLabel: t.statCellNum.finesseFaults,
                                isScreenBig: bigScreen,
                                  higherIsBetter: false,),
                            StatCellNum(
                                playerStat:
                                    record!.endContext!.finessePercentage * 100,
                                playerStatLabel: t.statCellNum.finessePercentage,
                                fractionDigits: 2,
                                isScreenBig: bigScreen,
                                  higherIsBetter: true,),
                            StatCellNum(
                                playerStat: record!.endContext!.inputs,
                                playerStatLabel: t.statCellNum.keys,
                                isScreenBig: bigScreen,
                                  higherIsBetter: false,),
                            StatCellNum(
                                playerStat: record!.endContext!.kpp,
                                playerStatLabel: t.statCellNum.kpp,
                                fractionDigits: 2,
                                isScreenBig: bigScreen,
                                  higherIsBetter: false,),
                            StatCellNum(
                                playerStat: record!.endContext!.kps,
                                playerStatLabel: t.statCellNum.kps,
                                fractionDigits: 2,
                                isScreenBig: bigScreen,
                                  higherIsBetter: true,),
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
                                  Text("${t.numOfGameActions.pc}:",
                                      style: const TextStyle(fontSize: 24)),
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
                                  Text("${t.numOfGameActions.hold}:",
                                      style: const TextStyle(fontSize: 24)),
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
                                  Text("${t.numOfGameActions.tspinsTotal}:",
                                      style: const TextStyle(fontSize: 24)),
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
                                  Text("${t.numOfGameActions.lineClears}:",
                                      style: const TextStyle(fontSize: 24)),
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
                      Text(t.noRecord, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28))
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
  const _OtherThingy({Key? key, required this.zen, required this.bio, required this.distinguishment})
      : super(key: key);

  List<InlineSpan> getDistinguishmentSetOfWidgets(String text) {
    var exploded = text.split(" ");
    List<InlineSpan> result = [];
    for (String shit in exploded){
      switch (shit) {
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
        default:
          result.add(TextSpan(text: " $shit", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (distinguishment != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text(t.distinguishment, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: getDistinguishmentSetOfWidgets(distinguishment!.header!),
                        ),
                      ),
                      Text(distinguishment!.footer!, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              if (bio != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                  child: Column(
                    children: [
                      Text(t.bio, style: TextStyle(fontFamily: "Eurostile Round Extended",fontSize: bigScreen ? 42 : 28)),
                      Text(bio!, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              if (zen != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      Text(t.zen, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      Text("${t.statCellNum.level} ${NumberFormat.decimalPattern().format(zen!.level)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Text("${t.statCellNum.score} ${NumberFormat.decimalPattern().format(zen!.score)}", style: const TextStyle(fontSize: 18)),
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
