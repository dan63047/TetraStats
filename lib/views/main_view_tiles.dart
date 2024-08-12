import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/tl_match_view.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/tl_progress_bar.dart';
import 'package:tetra_stats/widgets/tl_rating_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';

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
enum CardMod {info, recent, top, ex, exRecent, exTop}
Map<Cards, String> cardsTitles = {
  Cards.overview: "Overview",
  Cards.tetraLeague: t.tetraLeague,
  Cards.quickPlay: t.quickPlay,
  //Cards.quickPlayExpert: "${t.quickPlay} ${t.expert}",
  Cards.sprint: t.sprint,
  Cards.blitz: t.blitz,
  //Cards.other: t.other
};

TetrioPlayer testPlayer = TetrioPlayer(
  userId: "6098518e3d5155e6ec429cdc",
  username: "dan63",
  registrationTime: DateTime(2002, 2, 25, 9, 30, 01),
  avatarRevision: 1704835194288,
  bannerRevision: 1661462402700,
  role: "user",
  country: "BY",
  state: DateTime(1970),
  badges: [
    Badge(badgeId: "kod_founder", label: "Убил оска", ts: DateTime(2023, 6, 27, 18, 51, 49)),
    Badge(badgeId: "kod_by_founder", label: "Убит оском", ts: DateTime(2023, 6, 27, 18, 51, 51)),
    Badge(badgeId: "5mblast_1", label: "5M Blast Winner"),
    Badge(badgeId: "20tsd", label: "20 TSD"),
    Badge(badgeId: "allclear", label: "10PC's"),
    Badge(badgeId: "100player", label: "Won some shit"),
    Badge(badgeId: "founder", label: "osk"),
    Badge(badgeId: "early-supporter", label: "Sus"),
    Badge(badgeId: "bugbounty", label: "Break some ribbons"),
    Badge(badgeId: "infdev", label: "Closed player")
  ],
  friendCount: 69,
  gamesPlayed: 13747,
  gamesWon: 6523,
  gameTime: const Duration(days: 79, minutes: 28, seconds: 23, microseconds: 637591),
  xp: 1415239,
  supporterTier: 2,
  verified: true,
  connections: null,
  tlSeason1: TetraLeagueAlpha(
    timestamp: DateTime(1970),
    gamesPlayed: 28,
    gamesWon: 15,
    bestRank: "x",
    decaying: false,
    rating: 23500.6194,
    glicko: 3847.2134,
    rd: 61.95383,
    apm: 62.48,
    pps: 1.85,
    vs: 134.32,
    rank: "x",
    percentileRank: "x",
    percentile: 0.00,
    standing: 1,
    standingLocal: 1,
    nextAt: 1,
    prevAt: 500
  ),
  //distinguishment: Distinguishment(type: "twc", detail: "2023"),
  bio: "кровбер не в палку, без последнего тспина - 32 атаки. кровбер не в палку, без первого тсм и последнего тспина - 30 атаки. кровбер в палку с б2б - 38 атаки.(5 б2б)(не знаю от чего зависит) кровбер в палку с б2б - 36 атаки.(5 б2б)(не знаю от чего зависит)"
);
News testNews = News("6098518e3d5155e6ec429cdc", [
  NewsEntry(type: "personalbest", data: {"gametype": "40l", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 01)),
  NewsEntry(type: "personalbest", data: {"gametype": "blitz", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 02)),
  NewsEntry(type: "personalbest", data: {"gametype": "5mblast", "result": 23.232}, timestamp: DateTime(2002, 2, 25, 10, 30, 03)),
]);
late ScrollController controller;

class _MainState extends State<MainView> with TickerProviderStateMixin {
  int destination = 0;
  String _searchFor = "6098518e3d5155e6ec429cdc";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    teto.open();
    controller = ScrollController();
    super.initState();
  }

  void changePlayer(String player) {
    setState(() {
      _searchFor = player;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SearchDrawer(changePlayer: changePlayer, controller: _searchController),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
          children: [
            NavigationRail(
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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.data_thresholding_outlined),
                  selectedIcon: Icon(Icons.data_thresholding_outlined),
                  label: Text('Graphs'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.leaderboard),
                  selectedIcon: Icon(Icons.leaderboard),
                  label: Text('Leaderboards'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.compress),
                  selectedIcon: Icon(Icons.compress),
                  label: Text('Cutoffs'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calculate),
                  selectedIcon: Icon(Icons.calculate),
                  label: Text('Calc'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.storage),
                  selectedIcon: Icon(Icons.storage),
                  label: Text('Saved Data'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                )
              ],
              selectedIndex: destination,
              onDestinationSelected: (value) {
                setState(() {
                  destination = value;
                });
              },
              ),
            switch (destination){
              0 => DestinationHome(searchFor: _searchFor, constraints: constraints),
              1 => DestinationGraphs(searchFor: _searchFor, constraints: constraints),
              2 => DestinationLeaderboards(constraints: constraints),
              _ => Text("Unknown destination $destination")
            }
          ]);
        },
      ));
  }
}

class DestinationLeaderboards extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationLeaderboards({super.key, required this.constraints});

  @override
  State<DestinationLeaderboards> createState() => _DestinationLeaderboardsState();
}

class _DestinationLeaderboardsState extends State<DestinationLeaderboards> {
  Cards rightCard = Cards.tetraLeague;
  Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  final List<String> leaderboards = ["Tetra League", "Quick Play", "Quick Play Expert"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 350.0,
          height: widget.constraints.maxHeight,
          child: Column(
            children: [
              const Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text("Leaderboards", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36)),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboards.length,
                  itemBuilder: (BuildContext context, int index) { 
                    return Card(
                      surfaceTintColor: theme.colorScheme.primary,
                      child: ListTile(
                        title: Text(leaderboards[index]),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: widget.constraints.maxWidth - 350 - 88,
          child: const Card(
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
        ],
      );
  }
}

class DestinationGraphs extends StatefulWidget{
  final String searchFor;
  //final Function setState;
  final BoxConstraints constraints;

  const DestinationGraphs({super.key, required this.searchFor, required this.constraints});

  @override
  State<DestinationGraphs> createState() => _DestinationGraphsState();
}

class _DestinationGraphsState extends State<DestinationGraphs> {
  Cards rightCard = Cards.tetraLeague;
  bool fetchData = false;
  bool _gamesPlayedInsteadOfDateAndTime = false;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  String yAxisTitle = "";
  bool _smooth = false;
  final List _historyShortTitles = ["TR", "Glicko", "RD", "APM", "PPS", "VS", "APP", "DS/S", "DS/P", "APP + DS/P", "VS/APM", "Cheese", "GbE", "wAPP", "Area", "eTR", "±eTR", "Opener", "Plonk", "Inf. DS", "Stride"];
  int _chartsIndex = 0;
  late List<DropdownMenuItem<List<_HistoryChartSpot>>> chartsData;
  Duration postSeasonLeft = seasonStart.difference(DateTime.now());

  @override
  void initState(){
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
                    "${f4.format(data.stat)} $yAxisTitle",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
                  ),
                ),
                Text(_gamesPlayedInsteadOfDateAndTime ? t.gamesPlayed(games: t.games(n: data.gamesPlayed)) : timestamp(data.timestamp))
              ],
            ),
          );
      }
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming : true,
      enablePanning: true,
    );
    super.initState();
  }

  Future<List<DropdownMenuItem<List<_HistoryChartSpot>>>> getChartsData(bool fetchHistory) async {
    List<TetrioPlayer> states = [];
    Set<TetraLeagueAlpha> uniqueTL = {};

    if(fetchHistory){
      try{
        var history = await teto.fetchAndsaveTLHistory(widget.searchFor);
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

    states.addAll(await teto.getPlayer(widget.searchFor));
    for (var element in states) {
      if (element.tlSeason1 != null && uniqueTL.isNotEmpty && uniqueTL.last != element.tlSeason1) uniqueTL.add(element.tlSeason1!);
      if (uniqueTL.isEmpty) uniqueTL.add(element.tlSeason1!);
    }

    if (uniqueTL.length >= 2){
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
      chartsData = [];
    }

    fetchData = false;

    return chartsData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropdownMenuItem<List<_HistoryChartSpot>>>>(
      future: getChartsData(fetchData),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasData){
              List<_HistoryChartSpot> selectedGraph = snapshot.data![_chartsIndex].value!;
              yAxisTitle = _historyShortTitles[_chartsIndex];
              return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Wrap(
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
                                  setState(() {
                                    _gamesPlayedInsteadOfDateAndTime = value!;
                                  });
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
                                  setState(() {
                                    _chartsIndex = chartsData.indexWhere((element) => element.value == value);
                                  });
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
                                  setState(() {
                                    _smooth = value!;
                                  });
                                })),
                                Text(t.smooth, style: const TextStyle(color: Colors.white, fontSize: 22))
                            ],
                          ),
                          IconButton(onPressed: () => _zoomPanBehavior.reset(), icon: const Icon(Icons.refresh), alignment: Alignment.center,)
                        ],
                      ),
                    ),
                    if(chartsData[_chartsIndex].value!.length > 1) Card(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 88,
                        height: MediaQuery.of(context).size.height - 60,
                        child: Padding( padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
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
                              dataSource: chartsData[_chartsIndex].value!,
                              animationDuration: 0,
                              opacity: _smooth ? 0 : 1,
                              xValueMapper: (_HistoryChartSpot data, _) => data.gamesPlayed,
                              yValueMapper: (_HistoryChartSpot data, _) => data.stat,
                              color: Theme.of(context).colorScheme.primary,
                              trendlines:<Trendline>[
                                Trendline(
                                  isVisible: _smooth,
                                  period: (chartsData[_chartsIndex].value!.length/175).floor(),
                                  type: TrendlineType.movingAverage,
                                  color: Theme.of(context).colorScheme.primary)
                              ],
                            )
                            else StepLineSeries<_HistoryChartSpot, DateTime>(
                              enableTooltip: true,
                              dataSource: chartsData[_chartsIndex].value!,
                              animationDuration: 0,
                              opacity: _smooth ? 0 : 1,
                              xValueMapper: (_HistoryChartSpot data, _) => data.timestamp,
                              yValueMapper: (_HistoryChartSpot data, _) => data.stat,
                              color: Theme.of(context).colorScheme.primary,
                              trendlines:<Trendline>[
                                Trendline(
                                  isVisible: _smooth,
                                  period: (chartsData[_chartsIndex].value!.length/175).floor(),
                                  type: TrendlineType.movingAverage,
                                  color: Theme.of(context).colorScheme.primary)
                              ],
                            ),
                          ],
                        ),
                        )
                      ),
                    )
                    else if (chartsData[_chartsIndex].value!.length <= 1) Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
                        Text(t.errors.actionSuggestion),
                        TextButton(onPressed: (){setState(() {
                          fetchData = true;
                        });}, child: Text(t.fetchAndsaveTLHistory))
                      ],
                    ))
                  ],
                ),
            );
          }
          if (snapshot.hasError){
            return Center(child: 
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.error != null ? snapshot.error.toString() : "lol", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(snapshot.stackTrace != null ? snapshot.stackTrace.toString() : "lol", textAlign: TextAlign.center),
                  ),
                ],
              )
            );
          }
        }
        return const Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("lol", style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
        ],
      ));
      },
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

class DestinationHome extends StatefulWidget{
  final String searchFor;
  //final Function setState;
  final BoxConstraints constraints;

  const DestinationHome({super.key, required this.searchFor, required this.constraints});

  @override
  State<DestinationHome> createState() => _DestinationHomeState();
}

class _DestinationHomeState extends State<DestinationHome> {
  Cards rightCard = Cards.tetraLeague;
  CardMod cardMod = CardMod.info;
  Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  late Map<Cards, List<ButtonSegment<CardMod>>> modeButtons;
  late MapEntry closestAverageBlitz;
  late bool blitzBetterThanClosestAverage;
  late MapEntry closestAverageSprint;
  late bool sprintBetterThanClosestAverage;
  bool? sprintBetterThanRankAverage;
  bool? blitzBetterThanRankAverage;

  Widget getOverviewCard(Summaries summaries){
    return const Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Overview", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Title"),
                    Spacer(),
                    Text("Value"),
                  ],
                )
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget getTetraLeagueCard(TetraLeagueAlpha data){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.tetraLeague, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        TetraLeagueThingy(league: testPlayer.tlSeason1!),
        Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              const Spacer()
            ],
          ),
        ),
        NerdStatsThingy(nerdStats: testPlayer.tlSeason1!.nerdStats!),
        GraphsThingy(nerdStats: testPlayer.tlSeason1!.nerdStats!, playstyle: testPlayer.tlSeason1!.playstyle!, apm: testPlayer.tlSeason1!.apm!, pps: testPlayer.tlSeason1!.pps!, vs: testPlayer.tlSeason1!.vs!)
      ],
    );
  }

  Widget getRecentTLrecords(String searchFor, BoxConstraints constraints){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.recent, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: FutureBuilder<TetraLeagueBetaStream>(
            future: teto.fetchTLStream(searchFor),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData){
                  return SizedBox(height: constraints.maxHeight, child: _TLRecords(userID: searchFor, changePlayer: (){}, data: snapshot.data!.records, wasActiveInTL: snapshot.data!.records.isNotEmpty, oldMathcesHere: false));
                }
                if (snapshot.hasError){
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.errors.noSuchUser, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(t.errors.noSuchUserSub, textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  );
                }
              }
            return Text("what?");
            },
          ),
        ),
      ],
    );
  }

  Widget getZenithCard(RecordSingle? record){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.quickPlay, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  Text("Leaderboard reset in ${countdown(postSeasonLeft)}", textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        ZenithThingy(zenith: record),
        if (record != null) Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              const Spacer()
            ],
          ),
        ),
        if (record != null) NerdStatsThingy(nerdStats: record.aggregateStats.nerdStats),
        if (record != null) GraphsThingy(nerdStats: record.aggregateStats.nerdStats, playstyle: record.aggregateStats.playstyle, apm: record.aggregateStats.apm, pps: record.aggregateStats.pps, vs: record.aggregateStats.vs)
      ],
    );
  }

  Widget getRecordCard(RecordSingle? record, bool? betterThanRankAverage, MapEntry? closestAverage, bool? betterThanClosestAverage, String? rank){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(switch(record!.gamemode){
                    "40l" => t.sprint,
                    "blitz" => t.blitz,
                    "5mblast" => "5,000,000 Blast",
                    _ => record.gamemode
                  }, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42))
                ],
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (closestAverage != null) Padding(padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage.key}.png", height: 96)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  RichText(text: TextSpan(
                      text: switch(record.gamemode){
                        "40l" => get40lTime(record.stats.finalTime.inMicroseconds),
                        "blitz" => NumberFormat.decimalPattern().format(record.stats.score),
                        "5mblast" => get40lTime(record.stats.finalTime.inMicroseconds),
                        _ => record.stats.score.toString()
                      },
                      style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  RichText(text: TextSpan(
                    text: "",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                    children: [
                      if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                        "40l" => readableTimeDifference(record.stats.finalTime, sprintAverages[rank]!),
                        "blitz" => readableIntDifference(record.stats.score, blitzAverages[rank]!),
                        _ => record.stats.score.toString()
                      }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank.toUpperCase())}\n", style: TextStyle(
                        color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                      ))
                      else if ((rank == null || rank == "z") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                        "40l" => readableTimeDifference(record.stats.finalTime, closestAverage.value),
                        "blitz" => readableIntDifference(record.stats.score, closestAverage.value),
                        _ => record.stats.score.toString()
                      }, verdict: sprintBetterThanClosestAverage ? t.verdictBetter : t.verdictWorse, rank: closestAverageSprint.key.toUpperCase())}\n", style: TextStyle(
                        color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                      )),
                      if (record.rank != -1) TextSpan(text: "№ ${intf.format(record.rank)}", style: TextStyle(color: getColorOfRank(record.rank))),
                      if (record.rank != -1) const TextSpan(text: " • "),
                      if (record.countryRank != -1) TextSpan(text: "№ ${intf.format(record.countryRank)} local", style: TextStyle(color: getColorOfRank(record.countryRank))),
                      if (record.countryRank != -1) const TextSpan(text: " • "),
                      TextSpan(text: timestamp(record.timestamp)),
                    ]
                    ),
                  ),
                ],),
                Spacer(),
                  Table(
                      defaultColumnWidth:const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => record.stats.piecesPlaced.toString(),
                            "blitz" => record.stats.level.toString(),
                            "5mblast" => NumberFormat.decimalPattern().format(record.stats.spp),
                            _ => "What if "
                          }, textAlign: TextAlign.right, style: TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " Pieces",
                            "blitz" => " Level",
                            "5mblast" => " SPP",
                            _ => " i wanted to"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(f2.format(record.stats.pps), textAlign: TextAlign.right, style: TextStyle(fontSize: 21)),
                          Text(" PPS", textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => f2.format(record.stats.kpp),
                            "blitz" => f2.format(record.stats.spp),
                            "5mblast" => record.stats.piecesPlaced.toString(),
                            _ => "but god said"
                          }, textAlign: TextAlign.right, style: TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " KPP",
                            "blitz" => " SPP",
                            "5mblast" => " Pieces",
                            _ => " no"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ])
                      ],
                    ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  @override
  initState(){
    // bool? blitzBetterThanRankAverage = (rank != null && rank != "z") ? record!.stats.score > blitzAverages[rank]! : null;
    // bool? sprintBetterThanRankAverage = (rank != null && rank != "z") ? record!.stats.finalTime < sprintAverages[rank]! : null;
    // if (record!.gamemode == "40l") {
    //   closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-record!.stats.finalTime).abs() < (b -record!.stats.finalTime).abs() ? a : b));
    //   sprintBetterThanClosestAverage = record!.stats.finalTime < closestAverageSprint.value;
    // }else if (record!.gamemode == "blitz"){
    //   closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-record!.stats.score).abs() < (b -record!.stats.score).abs() ? a : b));
    //   blitzBetterThanClosestAverage = record!.stats.score > closestAverageBlitz.value;
    // }
    modeButtons = {
      Cards.overview: [
        const ButtonSegment<CardMod>(
          value: CardMod.info,
          label: Text('General'),
        ),
      ],
      Cards.tetraLeague: [
          const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('Standing'),
            ),
          const ButtonSegment<CardMod>(
              value: CardMod.recent,
              label: Text('Recent Matches'),
            ),
        ],
      Cards.quickPlay: [
        const ButtonSegment<CardMod>(
            value: CardMod.info,
            label: Text('Normal'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.recent,
            label: Text('Recent Normal'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.top,
            label: Text('Top Normal'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.ex,
            label: Text('Expert'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.exRecent,
            label: Text('Recent Expert'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.exTop,
            label: Text('Top Expert'),
        ),
      ],
      Cards.blitz: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.recent,
            label: Text('Recent'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.top,
            label: Text('Top'),
        ),
      ],
      Cards.sprint: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.recent,
            label: Text('Recent'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.top,
            label: Text('Top'),
        ),
      ]
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 450.0,
          child: FutureBuilder<TetrioPlayer>(future: teto.fetchPlayer(widget.searchFor), builder:(context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData){
                  return Column(
                    children: [
                      NewUserThingy(player: snapshot.data!, showStateTimestamp: false, setState: setState),
                      if (snapshot.data!.badges.isNotEmpty) BadgesThingy(badges: snapshot.data!.badges),
                      if (snapshot.data!.distinguishment != null) DistinguishmentThingy(snapshot.data!.distinguishment!),
                      if (snapshot.data!.role == "bot") FakeDistinguishmentThingy(bot: true, botMaintainers: snapshot.data!.botmaster),
                      if (snapshot.data!.role == "banned") FakeDistinguishmentThingy(banned: true)
                      else if (snapshot.data!.badstanding == true) FakeDistinguishmentThingy(badStanding: true),
                      if (snapshot.data!.bio != null) Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(), 
                                Text(t.bio, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                const Spacer()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: MarkdownBody(data: snapshot.data!.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center)),
                            )
                          ],
                        ),
                      ),
                        //if (testNews != null && testNews!.news.isNotEmpty)
                      Expanded(
                        child: FutureBuilder<News>(
                          future: teto.fetchNews(widget.searchFor),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState){
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                return const Card(child: Center(child: CircularProgressIndicator()));
                              case ConnectionState.done:
                                if (snapshot.hasData){
                                  return NewsThingy(snapshot.data!);
                                }else if (snapshot.hasError){
                                  return Card(child: Column(children: [
                                    Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                    Text(snapshot.stackTrace.toString())
                                  ]
                                ));
                              }
                            }
                            return const Text("what?");
                          }
                        ),
                      )
                      ],
                    );
                }
                if (snapshot.hasError){
                  if (snapshot.error.runtimeType == TetrioPlayerNotExist) {
                    return Card(
                      child: Center(child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(t.errors.noSuchUser, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(t.errors.noSuchUserSub, textAlign: TextAlign.center),
                            ),
                          ],
                        )
                      ),
                    );
                  } 
                  return Center(child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snapshot.error != null ? snapshot.error.toString() : "lol", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(snapshot.stackTrace != null ? snapshot.stackTrace.toString() : "lol", textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  );
                }
                return Text("huh?");
            }
          },
        )),
        SizedBox(
          width: widget.constraints.maxWidth - 450 - 80,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: widget.constraints.maxHeight - 64,
                child: SingleChildScrollView(
                  child: FutureBuilder<Summaries>(
                    future: teto.fetchSummaries(widget.searchFor),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState){
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasData){
                            blitzBetterThanRankAverage = (snapshot.data!.league.rank != "z" && snapshot.data!.blitz != null) ? snapshot.data!.blitz!.stats.score > blitzAverages[snapshot.data!.league.rank]! : null;
                            sprintBetterThanRankAverage = (snapshot.data!.league.rank != "z" && snapshot.data!.sprint != null) ? snapshot.data!.sprint!.stats.finalTime < sprintAverages[snapshot.data!.league.rank]! : null;
                             if (snapshot.data!.sprint != null) {
                              closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-snapshot.data!.sprint!.stats.finalTime).abs() < (b -snapshot.data!.sprint!.stats.finalTime).abs() ? a : b));
                              sprintBetterThanClosestAverage = snapshot.data!.sprint!.stats.finalTime < closestAverageSprint.value;
                            }
                            if (snapshot.data!.blitz != null){
                              closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-snapshot.data!.blitz!.stats.score).abs() < (b -snapshot.data!.blitz!.stats.score).abs() ? a : b));
                              blitzBetterThanClosestAverage = snapshot.data!.blitz!.stats.score > closestAverageBlitz.value;
                            }
                            return switch (rightCard){
                              Cards.overview => getOverviewCard(snapshot.data!),
                              Cards.tetraLeague => switch (cardMod){
                                CardMod.info => getTetraLeagueCard(snapshot.data!.league),
                                CardMod.recent => getRecentTLrecords(widget.searchFor, widget.constraints),
                                _ => Center(child: Text("huh?"))
                              },
                              Cards.quickPlay => getZenithCard(cardMod == CardMod.ex ? snapshot.data?.zenithEx : snapshot.data?.zenith),
                              Cards.sprint => getRecordCard(snapshot.data?.sprint, sprintBetterThanRankAverage, closestAverageSprint, sprintBetterThanClosestAverage, snapshot.data!.league.rank),
                              Cards.blitz => getRecordCard(snapshot.data?.blitz, blitzBetterThanRankAverage, closestAverageBlitz, blitzBetterThanClosestAverage, snapshot.data!.league.rank),
                            };
                          }
                          if (snapshot.hasError){
                            return Center(child: 
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(snapshot.error != null ? snapshot.error.toString() : "lol", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(snapshot.stackTrace != null ? snapshot.stackTrace.toString() : "lol", textAlign: TextAlign.center),
                                  ),
                                ],
                              )
                            );
                          }
                        return const Text("lol");
                      }
                    }
                  ),
                ),
              ),
              if (modeButtons[rightCard]!.length > 1) SegmentedButton<CardMod>(
                showSelectedIcon: false,
                selected: <CardMod>{cardMod},
                segments: modeButtons[rightCard]!,
                onSelectionChanged: (p0) {
                  setState(() {
                    cardMod = p0.first;
                  });
                },
              ),
              SegmentedButton<Cards>(
                showSelectedIcon: false,
                segments: <ButtonSegment<Cards>>[
                  const ButtonSegment<Cards>(
                      value: Cards.overview,
                      //label: Text('Overview'),
                      icon: Icon(Icons.calendar_view_day)),
                  ButtonSegment<Cards>(
                      value: Cards.tetraLeague,
                      //label: Text('Tetra League'),
                      icon: SvgPicture.asset("res/icons/league.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                  ButtonSegment<Cards>(
                      value: Cards.quickPlay,
                      //label: Text('Quick Play'),
                      icon: SvgPicture.asset("res/icons/qp.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                  ButtonSegment<Cards>(
                      value: Cards.sprint,
                      //label: Text('40 Lines'),
                      icon: SvgPicture.asset("res/icons/40l.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                  ButtonSegment<Cards>(
                      value: Cards.blitz,
                      //label: Text('Blitz'),
                      icon: SvgPicture.asset("res/icons/blitz.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                ],
                selected: <Cards>{rightCard},
                onSelectionChanged: (Set<Cards> newSelection) {
                  setState(() {
                    cardMod = CardMod.info;
                    rightCard = newSelection.first;
                  });})
            ]
          ),
        ),
        // SizedBox(
        //     width: 450,
        //     child: _TLRecords(userID: "snapshot.data![0].userId", changePlayer: changePlayer, data: [], wasActiveInTL: true, oldMathcesHere: false, separateScrollController: true)
        // )
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
          Text(getDistinguishmentSubtitle(distinguishment.footer), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
    if (bot) return Color.fromARGB(255, 60, 93, 55);
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
        decoration: banned ? BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, const Color.fromARGB(171, 244, 67, 54), Color.fromARGB(171, 244, 67, 54)],
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
            Text(getDistinguishmentSubtitle(), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
                      width: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBadge&badge=${badge.badgeId}" : "https://tetr.io/res/badges/${badge.badgeId}.png",
                          height: 32,
                          width: 32,
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

class NewUserThingy extends StatelessWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final Function setState;
  
  const NewUserThingy({super.key, required this.player, required this.showStateTimestamp, required this.setState});

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

      while (player.xp > xpTableScuffed.values.toList()[xpTableID]) {
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
                height: player.bannerRevision != null ? 218.0 : 138.0,
                child: Stack(
                //clipBehavior: Clip.none,
                children: [
                  if (player.bannerRevision != null) Image.network(kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${player.userId}&rv=${player.bannerRevision}" : "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                    fit: BoxFit.cover,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 90.0 : 10.0,
                    left: 16.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                        : player.avatarRevision != null
                          ? Image.network(kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${player.userId}&rv=${player.avatarRevision}" : "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                            // TODO: osk banner can cause memory leak
                      fit: BoxFit.fitHeight, height: 128, errorBuilder: (context, error, stackTrace) {
                        return Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight);
                        })
                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                    )
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 120.0 : 40.0,
                    left: 160.0,
                    child: Text(player.username,
                      //softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontFamily: fontStyle(player.username.length),
                        fontSize: 28,
                      )
                    ),
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 160.0 : 80.0,
                    left: 160.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Chip(label: Text(player.role.toUpperCase(), style: const TextStyle(shadows: textShadow),), padding: const EdgeInsets.all(0.0), color: WidgetStatePropertyAll(roleColor(player.role))),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontFamily: "Eurostile Round"),
                            children:
                            [
                            if (player.friendCount > 0) const WidgetSpan(child: Icon(Icons.person), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (player.friendCount > 0) TextSpan(text: "${intf.format(player.friendCount)} "),
                            if (player.supporterTier > 0) WidgetSpan(child: Icon(player.supporterTier > 1 ? Icons.star : Icons.star_border, color: player.supporterTier > 1 ? Colors.yellowAccent : Colors.white), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                            if (player.supporterTier > 0) TextSpan(text: player.supporterTier.toString(), style: TextStyle(color: player.supporterTier > 1 ? Colors.yellowAccent : Colors.white)),
                            ] 
                          ) 
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 193.0 : 113.0,
                    left: 160.0,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          if (player.country != null) TextSpan(text: "${t.countries[player.country]} • "),
                          TextSpan(text: player.registrationTime == null ? t.wasFromBeginning : timestamp(player.registrationTime!), style: const TextStyle(color: Colors.grey))
                        ]
                      )
                    )
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 126.0 : 46.0,
                    right: 16.0,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        style: const TextStyle(fontFamily: "Eurostile Round"),
                        children: [
                          TextSpan(text: "Level ${intf.format(player.level.floor())}", style: const TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted), recognizer: TapGestureRecognizer()..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Level ${intf.format(player.level.floor())}", textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2).format(player.xp)} XP",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontWeight: FontWeight.bold)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: SfLinearGauge(
                                        minimum: 0,
                                        maximum: 1,
                                        interval: 1, 
                                        ranges: [
                                          LinearGaugeRange(startValue: 0, endValue: player.level - player.level.floor(), color: Colors.cyanAccent),
                                          LinearGaugeRange(startValue: 0, endValue: (player.xp / xpTableScuffed.values.toList()[xpTableID]), color: Colors.redAccent, position: LinearElementPosition.cross)
                                          ],
                                        showTicks: true,
                                        showLabels: false
                                        ),
                                    ),
                                    Text("${t.statCellNum.xpProgress}: ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} %"),
                                    Text("${t.statCellNum.xpFrom0ToLevel(n: xpTableScuffed.keys.toList()[xpTableID])}: ${((player.xp / xpTableScuffed.values.toList()[xpTableID]) * 100).toStringAsFixed(2)} % (${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(xpTableScuffed.values.toList()[xpTableID] - player.xp)} ${t.statCellNum.xpLeft})")
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
                          TextSpan(text: player.gameTime.isNegative ? "-h --m" : playtime(player.gameTime), style: TextStyle(color: player.gameTime.isNegative ? Colors.grey : Colors.white, decoration: player.gameTime.isNegative ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted), recognizer: !player.gameTime.isNegative ? (TapGestureRecognizer()..onTap = (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(t.exactGametime, textAlign: TextAlign.center),  
                                content: SingleChildScrollView(
                                  child: ListBody(children: [
                                    Text(
                                      "${intf.format(player.gameTime.inDays)}d ${nonsecs.format(player.gameTime.inHours%24)}h ${nonsecs.format(player.gameTime.inMinutes%60)}m ${nonsecs.format(player.gameTime.inSeconds%60)}s ${nonsecs3.format(player.gameTime.inMilliseconds%1000)}ms ${nonsecs3.format(player.gameTime.inMicroseconds%1000)}μs",
                                      style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 24)
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("It's ${f4.format(player.gameTime.inSeconds/31536000)} years,"),
                                    ),
                                    Text("${f4.format(player.gameTime.inSeconds/2628000)} monts,"),
                                    Text("${f4.format(player.gameTime.inSeconds/3600)} hours,"),
                                    Text("${f2.format(player.gameTime.inMilliseconds/60000)} minutes,"),
                                    Text("${intf.format(player.gameTime.inSeconds)} seconds"),
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
                          TextSpan(text: player.gamesWon > -1 ? intf.format(player.gamesWon) : "---", style: TextStyle(color: player.gamesWon > -1 ? Colors.white : Colors.grey)),
                          TextSpan(text: "/${player.gamesPlayed > -1 ? intf.format(player.gamesPlayed) : "---"}", style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
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
                Expanded(child: ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: const Icon(Icons.person_add), label: Text(t.track), style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))))))),
                Expanded(child: ElevatedButton.icon(onPressed: (){print("ok, and?");}, icon: const Icon(Icons.balance), label: Text(t.compare), style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)))))))
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
            allPlayers.remove(prefs.getString("player") ?? "6098518e3d5155e6ec429cdc"); // player from the home button will be delisted
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
                      widget.changePlayer("6098518e3d5155e6ec429cdc");
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
  final TetraLeagueAlpha league;

  const TetraLeagueThingy({super.key, required this.league});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TLRatingThingy(userID: "w", tlData: league),
          TLProgress(tlData: league,),
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
                        const Text("APM: ", style: TextStyle(fontSize: 21)),
                        Text(league.apm != null ? f2.format(league.apm) : "---", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        //Text(" APM", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        const Text("PPS: ", style: TextStyle(fontSize: 21)),
                        Text(league.apm != null ? f2.format(league.pps) : "---", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        //Text(" PPS", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        const Text("VS: ", style: TextStyle(fontSize: 21)),
                        Text(league.apm != null ? f2.format(league.vs) : "---", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                       // Text(" VS", style: TextStyle(fontSize: 21))
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
                        minimum: 0.4,
                        maximum: 0.6,
                        radiusFactor: 1.01,
                        showTicks: true,
                        showLabels: false,
                        interval: 0.1,
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
                        //Text("VS: ", style: TextStyle(fontSize: 21)),
                        Text("№ ${intf.format(league.standingLocal)}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" in BY", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        //Text("APM: ", style: TextStyle(fontSize: 21)),
                        Text(intf.format(league.gamesPlayed), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" Games", style: TextStyle(fontSize: 21))
                      ]),
                      TableRow(children: [
                        //Text("PPS: ", style: TextStyle(fontSize: 21)),
                        Text(intf.format(league.gamesWon), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" Won", style: TextStyle(fontSize: 21))
                      ])
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

  const NerdStatsThingy({super.key, required this.nerdStats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
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
                                TextSpan(text: f3.format(nerdStats.app), style: const TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
                              //TextSpan(text: "\nAPP"),
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
                                TextSpan(text: f3.format(nerdStats.vsapm), style: const TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
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
                  spacing: 10,
                  children: [
                    GaugetThingy(value: nerdStats.dss, min: 0, max: 1.0, tickInterval: .2, label: "DS/S", sideSize: 128.0, fractionDigits: 3),
                    GaugetThingy(value: nerdStats.dsp, min: 0, max: 1.0, tickInterval: .2, label: "DS/P", sideSize: 128.0, fractionDigits: 3),
                    GaugetThingy(value: nerdStats.appdsp, min: 0, max: 1.2, tickInterval: .2, label: "APP+DS/P", sideSize: 128.0, fractionDigits: 3),
                    GaugetThingy(value: nerdStats.cheese, min: -80, max: 80, tickInterval: 40, label: "Cheese", sideSize: 128.0, fractionDigits: 2),
                    GaugetThingy(value: nerdStats.gbe, min: 0, max: 1.0, tickInterval: .2, label: "GbE", sideSize: 128.0, fractionDigits: 3),
                    GaugetThingy(value: nerdStats.nyaapp, min: 0, max: 1.2, tickInterval: .2, label: "wAPP", sideSize: 128.0, fractionDigits: 3),
                    GaugetThingy(value: nerdStats.area, min: 0, max: 1000, tickInterval: 100, label: "Area", sideSize: 128.0, fractionDigits: 1),
                  ],
                ),
              )
            ]
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
  final double tickInterval;
  final String label;
  final double sideSize;
  final int fractionDigits;

  GaugetThingy({super.key, required this.value, required this.min, required this.max, required this.tickInterval, required this.label, required this.sideSize, required this.fractionDigits});

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
                Text(f.format(value), textAlign: TextAlign.center, style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                angle: 90,positionFactor: 0.10
                ),
                GaugeAnnotation(widget: Container(child:
                Text(label, textAlign: TextAlign.center, style: const TextStyle(height: .9))),
                angle: 270,positionFactor: 0.4
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
                          if (zenith!.rank != -1) TextSpan(text: "№${zenith!.rank}", style: TextStyle(color: getColorOfRank(zenith!.rank))),
                          if (zenith!.rank != -1) const TextSpan(text: " • "),
                          if (zenith!.countryRank != -1) TextSpan(text: "№${zenith!.countryRank} local", style: TextStyle(color: getColorOfRank(zenith!.countryRank))),
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
                        Text("${intf.format(zenith!.stats.kills)}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
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

class _TLRecords extends StatelessWidget {
  final String userID;
  final Function changePlayer;
  final List<BetaRecord> data;
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