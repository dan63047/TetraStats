import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
import 'package:tetra_stats/data_objects/singleplayer_stream.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetra_league_beta_stream.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';
import 'package:tetra_stats/data_objects/tetrio_players_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/views/tl_match_view.dart';
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/tl_progress_bar.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

var fDiff = NumberFormat("+#,###.####;-#,###.####");
late Future<FetchResults> _data;
late Future<News> _newsData;

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

  Future<FetchResults> _getData() async {
    TetrioPlayer player;
    try{
      if (_searchFor.startsWith("ds:")){
        player = await teto.fetchPlayer(_searchFor.substring(3), isItDiscordID: true); // we trying to get him with that 
      }else{
        player = await teto.fetchPlayer(_searchFor); // Otherwise it's probably a user id or username
      }
    }on TetrioPlayerNotExist{
      return FetchResults(false, null, [], null, null, TetrioPlayerNotExist());
    }
    late Summaries summaries;
    late Cutoffs cutoffs;
    List<dynamic> requests = await Future.wait([
      teto.fetchSummaries(player.userId),
      teto.fetchCutoffsBeanserver(),
    ]);
    List<TetraLeague> states = await teto.getStates(player.userId, season: currentSeason);
    summaries = requests[0];
    cutoffs = requests[1];

    bool isTracking = await teto.isPlayerTracking(player.userId);
    if (isTracking){ // if tracked - save data to local DB
      await teto.storeState(summaries.league);
    }

    return FetchResults(true, player, states, summaries, cutoffs, null);
  }

  void changePlayer(String player) {
    setState(() {
      _searchFor = player;
      _data = _getData();
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
                0 => DestinationHome(searchFor: _searchFor, constraints: constraints),
                1 => DestinationGraphs(searchFor: _searchFor, constraints: constraints),
                2 => DestinationLeaderboards(constraints: constraints),
                3 => DestinationCutoffs(constraints: constraints),
                4 => DestinationCalculator(constraints: constraints),
                _ => Text("Unknown destination $destination")
              },
            )
          ]);
        },
      ));
  }
}

class DestinationCalculator extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationCalculator({super.key, required this.constraints});

  @override
  State<DestinationCalculator> createState() => _DestinationCalculatorState();
}

enum CalcCards{
  calc,
  damage
}

class ClearData{
  final String title;
  final Lineclears lineclear;
  final int lines;
  final bool miniSpin;
  final bool spin;
  bool perfectClear = false;

  ClearData(this.title, this.lineclear, this.lines, this.miniSpin, this.spin);

  bool get difficultClear {
    if (lines == 0) return false;
    if (lines >= 4 || miniSpin || spin) return true;
    else return false;
  }

  void togglePC(){
    perfectClear = !perfectClear;
  }

  int dealsDamage(int combo, int b2b, ComboTables table,){
    if (lines == 0) return 0;
    double damage = 0;
    if (spin){
      if (lines <= 5) damage += garbage[lineclear]!;
      else damage += garbage[Lineclears.TSPIN_PENTA]! + 2 * (lines - 5);
    } else if (miniSpin){
      damage += garbage[lineclear]!;
    } else {
      if (lines <= 5) damage += garbage[lineclear]!;
      else damage += garbage[Lineclears.PENTA]! + (lines - 5);
    }
    if (difficultClear && b2b > 0){
      damage += BACKTOBACK_BONUS * ((1 + log((b2b - 1) * BACKTOBACK_BONUS_LOG)).floor() + (b2b - 1 == 1 ? 0 : (1 + log((b2b - 1) * BACKTOBACK_BONUS_LOG) % 1) / 3));;
    }
    if (combo > 1){
      damage += combotable[table]![max(0, min(combo - 2, combotable[table]!.length - 1))];
    }
    return damage.floor();
  }
}

Map<String, List<ClearData>> clearsExisting = {
  "No Spin Clears": [
    ClearData("No lineclear (Break Combo)", Lineclears.ZERO, 0, false, false),
    ClearData("Single", Lineclears.SINGLE, 1, false, false),
    ClearData("Double", Lineclears.DOUBLE, 2, false, false),
    ClearData("Triple", Lineclears.TRIPLE, 3, false, false),
    ClearData("Quad", Lineclears.QUAD, 4, false, false)
  ],
  "Spins": [
    ClearData("Spin Zero", Lineclears.TSPIN, 0, false, true),
    ClearData("Spin Single", Lineclears.TSPIN_SINGLE, 1, false, true),
    ClearData("Spin Double", Lineclears.TSPIN_DOUBLE, 2, false, true),
    ClearData("Spin Spin Triple", Lineclears.TSPIN_TRIPLE, 3, false, true),
    ClearData("Spin Spin Quad", Lineclears.TSPIN_QUAD, 4, false, true),
  ],
  "Mini spins": [
    ClearData("Mini Spin Zero", Lineclears.TSPIN_MINI, 0, true, false),
    ClearData("Mini Spin Single", Lineclears.TSPIN_MINI_SINGLE, 1, true, false),
    ClearData("Mini Spin Double", Lineclears.TSPIN_MINI_DOUBLE, 2, true, false),
    ClearData("Mini Spin Spin Triple", Lineclears.TSPIN_MINI_TRIPLE, 3, true, false),
  ]
};

class _DestinationCalculatorState extends State<DestinationCalculator> {
  double? apm;
  double? pps;
  double? vs;
  NerdStats? nerdStats;
  EstTr? estTr;
  Playstyle? playstyle;
  TextEditingController ppsController = TextEditingController();
  TextEditingController apmController = TextEditingController();
  TextEditingController vsController = TextEditingController();

  List<ClearData> clears = [];
  int combo = -1;
  int b2b = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void calc() {
    apm = double.tryParse(apmController.text);
    pps = double.tryParse(ppsController.text);
    vs = double.tryParse(vsController.text);
    if (apm != null && pps != null && vs != null) {
      nerdStats = NerdStats(apm!, pps!, vs!);
      estTr = EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp, nerdStats!.gbe);
      playstyle = Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm, nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please, enter valid values")));
    }
  }

  void calcDamage(){
    for (ClearData lineclear in clears){

    }
  }

  Widget getCalculator(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Center(child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: [
                  Text("Stats Calucator", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                ],
              ),
            )),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: TextField(
                        onSubmitted: (value) => calc(),
                        controller: apmController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(suffix: Text("APM"), alignLabelWithHint: true, hintText: "Enter your APM"),
                      ),
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: TextField(
                        onSubmitted: (value) => calc(),
                        controller: ppsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(suffix: Text("PPS"), alignLabelWithHint: true, hintText: "Enter your PPS"),
                      ),
                    )
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: TextField(
                        onSubmitted: (value) => calc(),
                        controller: vsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(suffix: Text("VS"), alignLabelWithHint: true, hintText: "Enter your VS"),
                      ),
                    )
                  ),
                  TextButton(
                    onPressed: () => calc(),
                    child: Text(t.calc),
                  ),
                ],
              ),
            ),
          ),
          if (nerdStats != null) Card(
            child: NerdStatsThingy(nerdStats: nerdStats!)
          ),
          if (playstyle != null) Card(
            child: GraphsThingy(nerdStats: nerdStats!, playstyle: playstyle!, apm: apm!, pps: pps!, vs: vs!)
          )
        ],
      ),
    );
  }

  Widget getDamageCalculator(){
    List<Widget> rSideWidgets = [];
    for (var key in clearsExisting.keys){
      rSideWidgets.add(Text(key));
      for (ClearData data in clearsExisting[key]!) rSideWidgets.add(Card(
        child: ListTile(
            title: Text(data.title),
            subtitle: Text("${data.dealsDamage(0, 0, ComboTables.modern)} damage${data.difficultClear ? ", difficult" : ""}", style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              setState((){
                clears.add(data);
              });
            },
          ),
      ));
      rSideWidgets.add(Text("Custom"));
      rSideWidgets.add(const Divider(color: Color.fromARGB(50, 158, 158, 158)));
    }
    return Column(
      children: [
        Card(
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text("Damage Calucator", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              ],
            ),
          )),
        ),
        Row(
          children: [
            SizedBox(
              width: 350.0,
              child: DefaultTabController(length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: TabBar(tabs: [
                        Tab(text: "Actions"),
                        Tab(text: "Rules"),
                      ]),
                    ),
                    SizedBox(
                      height: widget.constraints.maxHeight - 164,
                      child: TabBarView(children: [
                        SingleChildScrollView(
                          child: Column(
                            children: rSideWidgets,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Doubles"),
                                )
                              ],
                            ),
                          ),
                        )
                      ]),
                    )
                  ],
                )
              ),
            ),
            SizedBox(
              width: widget.constraints.maxWidth - 350 - 80,
              child: Card(
                child: Column(
                  children: [
                    Column(
                      children: [for (ClearData data in clears) ListTile(
                        title: Text(data.title),
                        subtitle: Text("${data.dealsDamage(0, 0, ComboTables.modern)} damage${data.difficultClear ? ", difficult" : ""}", style: TextStyle(color: Colors.grey)),
                        trailing: Text(data.dealsDamage(0, 0, ComboTables.modern).toString()),
                        onTap: (){
                          clears.add(data);
                        },
                      )],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.constraints.maxHeight -32,
          child: getDamageCalculator(),
        ),
        SegmentedButton<CalcCards>(
          showSelectedIcon: false,
          segments: <ButtonSegment<CalcCards>>[
            const ButtonSegment<CalcCards>(
                value: CalcCards.calc,
                label: Text('Stats Calculator'),
                ),
            ButtonSegment<CalcCards>(
                value: CalcCards.damage,
                label: Text('Damage Calculator'),
                ),
          ],
          selected: <CalcCards>{CalcCards.damage},
          onSelectionChanged: (Set<CalcCards> newSelection) {
            setState(() {
              // cardMod = CardMod.info;
              // rightCard = newSelection.first;
            });})
      ],
    );
  }

}

class FetchCutoffsResults{
  late bool success;
  CutoffsTetrio? cutoffs;
  Exception? exception;

  FetchCutoffsResults(this.success, this.cutoffs, this.exception);
}

class DestinationCutoffs extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationCutoffs({super.key, required this.constraints});

  @override
  State<DestinationCutoffs> createState() => _DestinationCutoffsState();
}

class _DestinationCutoffsState extends State<DestinationCutoffs> {

  Future<CutoffsTetrio> fetch() async {
    TetrioPlayerFromLeaderboard top1;
    CutoffsTetrio cutoffs;
    List<dynamic> requests = await Future.wait([
      teto.fetchCutoffsTetrio(),
      teto.fetchTopOneFromTheLeaderboard(),
    ]);
    cutoffs = requests[0];
    top1 = requests[1];
    cutoffs.data["top1"] = CutoffTetrio(
      pos: 1,
      percentile: 0.00,
      tr: top1.tr,
      targetTr: 25000,
      apm: top1.apm,
      pps: top1.pps,
      vs: top1.vs,
      count: 1,
      countPercentile: 0.0 
      );
    return cutoffs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CutoffsTetrio>(
      future: fetch(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Center(child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            Text("Tetra League State", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                            Text("as of ${timestamp(snapshot.data!.timestamp)}"),
                          ],
                        ),
                      )),
                    ), 
                    Padding(
                      padding: const EdgeInsets.only(bottom:4.0),
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Text("Actual"),
                                      ),
                                      Text("Target")
                                    ]  
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                                    child: SfLinearGauge(
                                      minimum: 0.00000000,
                                      maximum: 25000.0000,
                                      showTicks: false,
                                      showLabels: false,
                                      ranges: [
                                        for (var cutoff in snapshot.data!.data.keys) LinearGaugeRange(
                                          position: LinearElementPosition.outside,
                                          startValue: snapshot.data!.data[cutoff]!.tr,
                                          startWidth: 20.0,
                                          endWidth: 20.0,
                                          endValue: switch (cutoff){
                                            "top1" => 25000.00,
                                            "x+" => snapshot.data!.data["top1"]!.tr,
                                            _ => snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr
                                          },
                                          color: cutoff != "top1" ? rankColors[cutoff] : Colors.grey.shade800,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys) LinearGaugeRange(
                                          position: LinearElementPosition.inside,
                                          startValue: snapshot.data!.data[cutoff]!.targetTr,
                                          endValue: switch (cutoff){
                                            "top1" => 25000.00,
                                            "x+" => snapshot.data!.data["top1"]!.targetTr,
                                            _ => snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr
                                          },
                                          color: cutoff != "top1" ? rankColors[cutoff] : null,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys.skip(1)) if (snapshot.data!.data[cutoff]!.tr < snapshot.data!.data[cutoff]!.targetTr) LinearGaugeRange(
                                          position: LinearElementPosition.cross,
                                          startValue: snapshot.data!.data[cutoff]!.tr,
                                          endValue: snapshot.data!.data[cutoff]!.targetTr,
                                          color: Colors.green,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys.skip(1)) if (snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr)LinearGaugeRange(
                                          position: LinearElementPosition.cross,
                                          startValue: snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr,
                                          endValue: snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr,
                                          color: Colors.red,
                                        ),
                                      ],
                                      markerPointers: [
                                        for (var cutoff in snapshot.data!.data.keys) LinearWidgetPointer(child: Container(child: Text(intf.format(snapshot.data!.data[cutoff]!.tr), style: TextStyle(fontSize: 12)), transform: Matrix4.compose(Vector3(0, 35, 0), Quaternion.axisAngle(Vector3(0, 0, 1), -1), Vector3(1, 1, 1)), height: 45.0), value: snapshot.data!.data[cutoff]!.tr, position: LinearElementPosition.outside, offset: 20),
                                        for (var cutoff in snapshot.data!.data.keys) LinearWidgetPointer(child: Container(child: Text(intf.format(snapshot.data!.data[cutoff]!.targetTr), textAlign: ui.TextAlign.right, style: TextStyle(fontSize: 12)), transform: Matrix4.compose(Vector3(-15, 0, 0), Quaternion.axisAngle(Vector3(0, 0, 1), -1), Vector3(1, 1, 1)), height: 45.0, transformAlignment: Alignment.topRight), value: snapshot.data!.data[cutoff]!.targetTr, position: LinearElementPosition.inside, offset: 6)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      border: TableBorder.all(color: Colors.grey.shade900),
                      columnWidths: const {
                        0: FixedColumnWidth(48),
                        1: FixedColumnWidth(155),
                        2: FixedColumnWidth(140),
                        3: FixedColumnWidth(160),
                        4: FixedColumnWidth(150),
                        5: FixedColumnWidth(90),
                        6: FixedColumnWidth(130),
                        7: FixedColumnWidth(120),
                        8: FixedColumnWidth(125),
                        9: FixedColumnWidth(70),
                        },
                      children: [
                        TableRow(
                          children: [
                            Text("Rank", textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("Cutoff TR", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("Target TR", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 24, fontWeight: FontWeight.w100, color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("State", textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("APM", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("PPS", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("VS", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("Advanced", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("Players (${intf.format(snapshot.data!.total)})", textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("More info", textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                          ]
                        ),
                        for (String rank in snapshot.data!.data.keys) if (rank != "top1") TableRow(
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [rankColors[rank]!.withAlpha(200), rankColors[rank]!.withAlpha(100)])),
                          children: [
                            Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(132), blurRadius: 32.0, blurStyle: BlurStyle.inner)]), child: Image.asset("res/tetrio_tl_alpha_ranks/$rank.png", height: 48)),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(f2.format(snapshot.data!.data[rank]!.tr), textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(f2.format(snapshot.data!.data[rank]!.targetTr), textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 24, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow),
                                children: [
                                  if (rank == "x+") TextSpan(text: "№ 1 is ${f2.format(snapshot.data!.data["top1"]!.tr)} TR", style: const TextStyle(color: Colors.white60, shadows: null))
                                  else TextSpan(text: snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr ? "Inflated from ${NumberFormat.compact().format(snapshot.data!.data[rank]!.targetTr)} TR" : "Not inflated", style: TextStyle(color: snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr ? Colors.white :Colors.white60, shadows: null)),
                                  TextSpan(text: "\n", style: const TextStyle(color: Colors.white60, shadows: null)),
                                  if (rank == "d") TextSpan(text: "Well...", style: const TextStyle(color: Colors.white60, shadows: null))
                                  else TextSpan(text: snapshot.data!.data[rank]!.tr < snapshot.data!.data[rank]!.targetTr ? "Deflated untill ${NumberFormat.compact().format(snapshot.data!.data[rank]!.targetTr)} TR" : "Not deflated", style: TextStyle(color: snapshot.data!.data[rank]!.tr < snapshot.data!.data[rank]!.targetTr ? Colors.white : Colors.white60, shadows: null))
                                ]
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(snapshot.data?.data[rank]?.apm != null ? f2.format(snapshot.data!.data[rank]!.apm) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.apm != null ? Colors.white : Colors.grey, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(snapshot.data?.data[rank]?.pps != null ? f2.format(snapshot.data!.data[rank]!.pps) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.pps != null ? Colors.white : Colors.grey, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(snapshot.data?.data[rank]?.vs != null ? f2.format(snapshot.data!.data[rank]!.vs) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.vs != null ? Colors.white : Colors.grey, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("${snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.pps != null ? f3.format(snapshot.data!.data[rank]!.apm! / (snapshot.data!.data[rank]!.pps! * 60)) : "-.---"} APP\n${snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.vs != null ? f3.format(snapshot.data!.data[rank]!.vs! / snapshot.data!.data[rank]!.apm!) : "-.---"} VS/APM", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.pps != null && snapshot.data?.data[rank]?.vs != null ? Colors.white : Colors.grey, shadows: textShadow)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow),
                                children: [
                                  TextSpan(text: intf.format(snapshot.data!.data[rank]!.count)),
                                  TextSpan(text: " (${f2.format(snapshot.data!.data[rank]!.countPercentile * 100)}%)", style: const TextStyle(color: Colors.white60, shadows: null)),
                                  TextSpan(text: "\n(from № ${intf.format(snapshot.data!.data[rank]!.pos)})", style: const TextStyle(color: Colors.white60, shadows: null))
                                ]
                              ))
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextButton(child: Text("View", textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)), onPressed: () {
                                
                              },),
                            ),
                          ]
                        )
                      ],
                    )
                  ] 
                ),
              );
            }
            if (snapshot.hasError){ return FutureError(snapshot); }
          }
        return Text("huh?");
      }
    );
  }
}

class DestinationLeaderboards extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationLeaderboards({super.key, required this.constraints});

  @override
  State<DestinationLeaderboards> createState() => _DestinationLeaderboardsState();
}

enum Leaderboards{
  tl,
  xp,
  ar,
  sprint,
  blitz,
  zenith,
  zenithex,
}

class _DestinationLeaderboardsState extends State<DestinationLeaderboards> {
  //Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  final Map<Leaderboards, String> leaderboards = {
    Leaderboards.tl: "Tetra League",
    Leaderboards.xp: "XP",
    Leaderboards.ar: "Acievement Points",
    Leaderboards.sprint: "40 Lines",
    Leaderboards.blitz: "Blitz",
    Leaderboards.zenith: "Quick Play",
    Leaderboards.zenithex: "Quick Play Expert",
    };
  Leaderboards _currentLb = Leaderboards.tl;
  final StreamController<List<dynamic>> _dataStreamController = StreamController<List<dynamic>>();
  late final ScrollController _scrollController;
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  List<dynamic> list = [];
  bool _isFetchingData = false;
  String? prisecter;

  Future<void> _fetchData() async {
    if (_isFetchingData) {
      // Avoid fetching new data while already fetching
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});

      final items = switch(_currentLb){
        Leaderboards.tl => await teto.fetchTetrioLeaderboard(prisecter: prisecter),
        Leaderboards.xp => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "xp"),
        Leaderboards.ar => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "ar"),
        Leaderboards.sprint => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter),
        Leaderboards.blitz => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "blitz_global"),
        Leaderboards.zenith => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenith_global"),
        Leaderboards.zenithex => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenithex_global"),
      };

      list.addAll(items);

      _dataStreamController.add(list);
      prisecter = list.last.prisecter.toString();
    } catch (e) {
      _dataStreamController.addError(e);
    } finally {
      // Set to false when data fetching is complete
      _isFetchingData = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchData();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          // When the last item is fully visible, load the next page.
          _fetchData();
        }
      });
    });
  }

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
                        title: Text(leaderboards.values.elementAt(index)),
                        onTap: () {
                          _currentLb = leaderboards.keys.elementAt(index);
                          list.clear();
                          prisecter = null;
                          _fetchData();
                        },
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
          child: Card(
            child: StreamBuilder<List<dynamic>>(
              stream: dataStream,
              builder:(context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData){
                      return Column(
                        children: [
                          Text(leaderboards[_currentLb]!, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                          const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index){
                                return ListTile(
                                  leading: Text(intf.format(index+1)),
                                  title: Text(snapshot.data![index].username, style: TextStyle(fontSize: 22)),
                                  trailing: Text(switch (_currentLb){
                                    Leaderboards.tl => "${f2.format(snapshot.data![index].tr)} TR",
                                    Leaderboards.xp => "LVL ${f2.format(snapshot.data![index].level)}",
                                    Leaderboards.ar => "${intf.format(snapshot.data![index].ar)} AR",
                                    Leaderboards.sprint => get40lTime(snapshot.data![index].stats.finalTime.inMicroseconds),
                                    Leaderboards.blitz => intf.format(snapshot.data![index].stats.score),
                                    Leaderboards.zenith => "${f2.format(snapshot.data![index].stats.zenith!.altitude)} m",
                                    Leaderboards.zenithex => "${f2.format(snapshot.data![index].stats.zenith!.altitude)} m"
                                  }, style: TextStyle(fontSize: 28)),
                                  subtitle: Text(switch (_currentLb){
                                    Leaderboards.tl => "${f2.format(snapshot.data![index].apm)} APM, ${f2.format(snapshot.data![index].pps)} PPS, ${f2.format(snapshot.data![index].vs)} VS, ${f2.format(snapshot.data![index].nerdStats.app)} APP, ${f2.format(snapshot.data![index].nerdStats.vsapm)} VS/APM",
                                    Leaderboards.xp => "${f2.format(snapshot.data![index].xp)} XP${snapshot.data![index].playtime.isNegative ? "" : ", ${playtime(snapshot.data![index].playtime)} of gametime"}",
                                    Leaderboards.ar => "${snapshot.data![index].ar_counts}",
                                    Leaderboards.sprint => "${intf.format(snapshot.data![index].stats.finesse.faults)} FF, ${f2.format(snapshot.data![index].stats.kpp)} KPP, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${intf.format(snapshot.data![index].stats.piecesPlaced)} P",
                                    Leaderboards.blitz => "lvl ${snapshot.data![index].stats.level}, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${f2.format(snapshot.data![index].stats.spp)} SPP",
                                    Leaderboards.zenith => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B",
                                    Leaderboards.zenithex => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B"
                                  }, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                );
                              }
                            ),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError){ return FutureError(snapshot); }
                  }
                return Text("huh?");
              },
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

enum Graph{
  history,
  leagueState,
  leagueCutoffs
}

class _DestinationGraphsState extends State<DestinationGraphs> {
  bool fetchData = false;
  bool _gamesPlayedInsteadOfDateAndTime = false;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _historyTooltipBehavior;
  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _leagueTooltipBehavior;
  String yAxisTitle = "";
  bool _smooth = false;
  final List<DropdownMenuItem<Stats>> _yAxis = [for (MapEntry e in chartsShortTitles.entries) DropdownMenuItem(value: e.key, child: Text(e.value))];
  Graph _graph = Graph.history;
  Stats _Ychart = Stats.tr;
  Stats _Xchart = Stats.tr;
  int _season = currentSeason-1;
  //Duration postSeasonLeft = seasonStart.difference(DateTime.now());

  @override
  void initState(){
    _historyTooltipBehavior = TooltipBehavior(
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
                    "${data.nickname} (${data.rank.toUpperCase()})",
                    style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 20),
                  ),
                ),
                Text('${f4.format(data.x)} ${chartsShortTitles[_Xchart]}\n${f4.format(data.y)} ${chartsShortTitles[_Ychart]}')
              ],
            ),
          );
      }
    );
    _leagueTooltipBehavior = TooltipBehavior(
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
                    "${f4.format(point.y)} $yAxisTitle",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
                  ),
                ),
                Text(timestamp(data.ts))
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

  Future<List<Map<Stats, List<_HistoryChartSpot>>>> getHistoryData(bool fetchHistory) async {
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

    List<List<TetraLeague>> states = await Future.wait<List<TetraLeague>>([
      teto.getStates(widget.searchFor, season: 1), teto.getStates(widget.searchFor, season: 2),
    ]);
    List<Map<Stats, List<_HistoryChartSpot>>> historyData = []; // [season][metric][spot]
    for (int season = 0; season < currentSeason; season++){
      if (states[season].length >= 2){
      Map<Stats, List<_HistoryChartSpot>> statsMap = {};
        for (var stat in Stats.values) statsMap[stat] = [for (var tl in states[season]) if (tl.getStatByEnum(stat) != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.getStatByEnum(stat)!.toDouble())];
        historyData.add(statsMap);
      }else{
        historyData.add({});
        break;
      }
    }
    fetchData = false;

    return historyData;
  }

  Future<List<_MyScatterSpot>> getTetraLeagueData(Stats x, Stats y) async {
    TetrioPlayersLeaderboard leaderboard = await teto.fetchTLLeaderboard();
    List<_MyScatterSpot> _spots = [
      for (TetrioPlayerFromLeaderboard entry in leaderboard.leaderboard)
        _MyScatterSpot(
          entry.getStatByEnum(x).toDouble(),
          entry.getStatByEnum(y).toDouble(),
          entry.userId,
          entry.username,
          entry.rank,
          rankColors[entry.rank]??Colors.white
        )
    ];
    return _spots;
  }

  Widget getHistoryGraph(){
   return FutureBuilder<List<Map<Stats, List<_HistoryChartSpot>>>>(
    future: getHistoryData(fetchData),
    builder: (context, snapshot) {
      switch (snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
        if (snapshot.hasData){
          List<_HistoryChartSpot> selectedGraph = snapshot.data![_season][_Ychart]!;
          yAxisTitle = chartsShortTitles[_Ychart]!;
          return SfCartesianChart(
            tooltipBehavior: _historyTooltipBehavior,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: _gamesPlayedInsteadOfDateAndTime ? const NumericAxis() : const DateTimeAxis(),
            primaryYAxis: const NumericAxis(
              rangePadding: ChartRangePadding.additional,
            ),
            margin: const EdgeInsets.all(0),
            series: <CartesianSeries>[
              if (_gamesPlayedInsteadOfDateAndTime) StepLineSeries<_HistoryChartSpot, int>(
                enableTooltip: true,
                dataSource: selectedGraph,
                animationDuration: 0,
                opacity: _smooth ? 0 : 1,
                xValueMapper: (_HistoryChartSpot data, _) => data.gamesPlayed,
                yValueMapper: (_HistoryChartSpot data, _) => data.stat,
                color: Theme.of(context).colorScheme.primary,
                trendlines:<Trendline>[
                  Trendline(
                    isVisible: _smooth,
                    period: (selectedGraph.length/175).floor(),
                    type: TrendlineType.movingAverage,
                    color: Theme.of(context).colorScheme.primary)
                  ],
                )
                else StepLineSeries<_HistoryChartSpot, DateTime>(
                  enableTooltip: true,
                  dataSource: selectedGraph,
                  animationDuration: 0,
                  opacity: _smooth ? 0 : 1,
                  xValueMapper: (_HistoryChartSpot data, _) => data.timestamp,
                  yValueMapper: (_HistoryChartSpot data, _) => data.stat,
                  color: Theme.of(context).colorScheme.primary,
                  trendlines:<Trendline>[
                    Trendline(
                      isVisible: _smooth,
                      period: (selectedGraph.length/175).floor(),
                      type: TrendlineType.movingAverage,
                      color: Theme.of(context).colorScheme.primary)
                  ],
                ),
              ],
            );
        }else{ return FutureError(snapshot); }
      }
     }
   ); 
  }

  Widget getLeagueState (){
    return FutureBuilder<List<_MyScatterSpot>>(
      future: getTetraLeagueData(_Xchart, _Ychart),
      builder: (context, snapshot) {
      switch (snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
        if (snapshot.hasData){
          return SfCartesianChart(
            tooltipBehavior: _tooltipBehavior,
            zoomPanBehavior: _zoomPanBehavior,
            //primaryXAxis: CategoryAxis(),
            series: [
              ScatterSeries(
                enableTooltip: true,
                dataSource: snapshot.data,
                animationDuration: 0,
                pointColorMapper: (data, _) => data.color,
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                onPointTap: (point) => Navigator.push(context, MaterialPageRoute(builder: (context) => MainView(player: snapshot.data![point.pointIndex!].nickname), maintainState: false)),
              )
            ],
          );
        }else{ return FutureError(snapshot); }
      }
     }
    );
  }

  Widget getCutoffsHistory(){
    return FutureBuilder<List<Cutoffs>>(
    future: teto.fetchCutoffsHistory(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
        if (snapshot.hasData){
          yAxisTitle = chartsShortTitles[_Ychart]!;
          return SfCartesianChart(
            tooltipBehavior: _leagueTooltipBehavior,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: const DateTimeAxis(),
            primaryYAxis: NumericAxis(
              // isInversed: true,
              maximum: switch (_Ychart){
                Stats.tr => 25000.0,
                Stats.gxe => 100.00,
                _ => null
              },
            ),
            margin: const EdgeInsets.all(0),
            series: <CartesianSeries>[
              for (String rank in ranks) StepLineSeries<Cutoffs, DateTime>(
                enableTooltip: true,
                dataSource: snapshot.data,
                animationDuration: 0,
                //opacity: 0.5,
                xValueMapper: (Cutoffs data, _) => data.ts,
                yValueMapper: (Cutoffs data, _) => switch (_Ychart){
                  Stats.glicko => data.glicko[rank],
                  Stats.gxe => data.gxe[rank],
                  _ => data.tr[rank]
                },
                color: rankColors[rank]!
                )
              ],
            );
        }else{ return FutureError(snapshot); }
      }
     }
   ); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Wrap(
                    spacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (_graph == Graph.history) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Season:", style: TextStyle(fontSize: 22))),
                          DropdownButton(
                            items: [for (int i = 1; i <= currentSeason; i++) DropdownMenuItem(value: i-1, child: Text("$i"))],
                            value: _season,
                            onChanged: (value) {
                              setState(() {
                                _season = value!;
                              });
                            }
                          ),
                        ],
                      ),
                      if (_graph != Graph.leagueCutoffs) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("X:", style: TextStyle(fontSize: 22))),
                          DropdownButton(
                            items: switch (_graph){
                              Graph.history => [DropdownMenuItem(value: false, child: Text("Date & Time")), DropdownMenuItem(value: true, child: Text("Games Played"))],
                              Graph.leagueState => _yAxis,
                              Graph.leagueCutoffs => [],
                            },
                            value: _graph == Graph.history ? _gamesPlayedInsteadOfDateAndTime :  _Xchart,
                            onChanged: (value) {
                              setState(() {
                                if (_graph == Graph.history)
                                _gamesPlayedInsteadOfDateAndTime = value! as bool;
                                else _Xchart = value! as Stats;
                              });
                            }
                          ),
                          ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Y:", style: TextStyle(fontSize: 22))),
                          DropdownButton<Stats>(
                            items: _graph == Graph.leagueCutoffs ? [DropdownMenuItem(value: Stats.tr, child: Text(chartsShortTitles[Stats.tr]!)), DropdownMenuItem(value: Stats.glicko, child: Text(chartsShortTitles[Stats.glicko]!)), DropdownMenuItem(value: Stats.gxe, child: Text(chartsShortTitles[Stats.gxe]!))] : _yAxis,
                            value: _Ychart,
                            onChanged: (value) {
                              setState(() {
                                _Ychart = value!;
                              });
                            }
                          ),
                        ],
                      ),
                      if (_graph != Graph.leagueState) Row(
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
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 88,
                    height: MediaQuery.of(context).size.height - 96,
                    child: Padding( padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
                    child: switch (_graph){
                      Graph.history => getHistoryGraph(),
                      Graph.leagueState => getLeagueState(),
                      Graph.leagueCutoffs => getCutoffsHistory()
                    },
                    )
                  ),
                )
              ],
            ),
        ),
        SegmentedButton<Graph>(
          showSelectedIcon: false,
          segments: <ButtonSegment<Graph>>[
            const ButtonSegment<Graph>(
              value: Graph.history,
              label: Text('Player History')),
            ButtonSegment<Graph>(
              value: Graph.leagueState,
              label: Text('League State')),
            ButtonSegment<Graph>(
              value: Graph.leagueCutoffs,
              label: Text('League Cutoffs'),
            ),
          ],
          selected: <Graph>{_graph},
          onSelectionChanged: (Set<Graph> newSelection) {
            setState(() {
              _graph = newSelection.first;
              switch (newSelection.first){
                case Graph.leagueCutoffs:
                case Graph.history:
                  _Ychart = Stats.tr;
                case Graph.leagueState:
                  _Ychart = Stats.apm;
              }
            });})
      ],
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

class _MyScatterSpot{
  num x;
  num y;
  String id;
  String nickname;
  String rank;
  Color color;
  _MyScatterSpot(this.x, this.y, this.id, this.nickname, this.rank, this.color);
}

class DestinationHome extends StatefulWidget{
  final String searchFor;
  //final Function setState;
  final BoxConstraints constraints;

  const DestinationHome({super.key, required this.searchFor, required this.constraints});

  @override
  State<DestinationHome> createState() => _DestinationHomeState();
}

class FetchResults{
  bool success;
  TetrioPlayer? player;
  List<TetraLeague> states;
  Summaries? summaries;
  Cutoffs? cutoffs;
  Exception? exception;

  FetchResults(this.success, this.player, this.states, this.summaries, this.cutoffs, this.exception);
}

class RecordSummary extends StatelessWidget{
  final RecordSingle? record;
  final bool hideRank;
  final bool? betterThanRankAverage;
  final MapEntry? closestAverage;
  final bool? betterThanClosestAverage;
  final String? rank;

  const RecordSummary({super.key, required this.record, this.betterThanRankAverage, this.closestAverage, this.betterThanClosestAverage, this.rank, this.hideRank = false});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (closestAverage != null && record != null) Padding(padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage!.key}.png", height: 96))
        else !hideRank ? Image.asset("res/tetrio_tl_alpha_ranks/z.png", height: 96) : Container(),
        if (record != null) Column(
          crossAxisAlignment: hideRank ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          RichText(
            textAlign: hideRank ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              text: switch(record!.gamemode){
                "40l" => get40lTime(record!.stats.finalTime.inMicroseconds),
                "blitz" => NumberFormat.decimalPattern().format(record!.stats.score),
                "5mblast" => get40lTime(record!.stats.finalTime.inMicroseconds),
                "zenith" => "${f2.format(record!.stats.zenith!.altitude)} m",
                "zenithex" => "${f2.format(record!.stats.zenith!.altitude)} m",
                _ => record!.stats.score.toString()
              },
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white, height: 0.9),
              ),
            ),
          RichText(
            textAlign: hideRank ? TextAlign.center : TextAlign.start,
            text: TextSpan(
            text: "",
            style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
            children: [
              if (rank != null && rank != "z" && rank != "x+") TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                "40l" => readableTimeDifference(record!.stats.finalTime, sprintAverages[rank]!),
                "blitz" => readableIntDifference(record!.stats.score, blitzAverages[rank]!),
                _ => record!.stats.score.toString()
              }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
              ))
              else if ((rank == null || rank == "z") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                "40l" => readableTimeDifference(record!.stats.finalTime, closestAverage!.value),
                "blitz" => readableIntDifference(record!.stats.score, closestAverage!.value),
                _ => record!.stats.score.toString()
              }, verdict: betterThanClosestAverage??false ? t.verdictBetter : t.verdictWorse, rank: closestAverage!.key.toUpperCase())}\n", style: TextStyle(
                color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
              )),
              if (record!.rank != -1) TextSpan(text: "№ ${intf.format(record!.rank)}", style: TextStyle(color: getColorOfRank(record!.rank))),
              if (record!.rank != -1 && record!.countryRank != -1) const TextSpan(text: " • "),
              if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} local", style: TextStyle(color: getColorOfRank(record!.countryRank))),
              const TextSpan(text: "\n"),
              TextSpan(text: timestamp(record!.timestamp)),
            ]
            ),
          ),
        ],
      ) else if (hideRank) RichText(text: const TextSpan(
        text: "---",
        style: TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      )
      ],
    );
  }
  
}

class LeagueCard extends StatelessWidget{
  final TetraLeague league;
  final bool showSeasonNumber;

  const LeagueCard({super.key, required this.league, this.showSeasonNumber = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showSeasonNumber) Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("Season ${league.season}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                  Spacer(),
                  Text(
                    "${seasonStarts.elementAtOrNull(league.season - 1) != null ? timestamp(seasonStarts[league.season - 1]) : "---"} — ${seasonEnds.elementAtOrNull(league.season - 1) != null ? timestamp(seasonEnds[league.season - 1]) : "---"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                ],
              )
              else Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
              const Divider(color: Color.fromARGB(50, 158, 158, 158)),
              TLRatingThingy(userID: "", tlData: league, showPositions: true),
              const Divider(color: Color.fromARGB(50, 158, 158, 158)),
              Text("${league.apm != null ? f2.format(league.apm) : "-.--"} APM • ${league.pps != null ? f2.format(league.pps) : "-.--"} PPS • ${league.vs != null ? f2.format(league.vs) : "-.--"} VS • ${league.nerdStats != null ? f2.format(league.nerdStats!.app) : "-.--"} APP • ${league.nerdStats != null ? f2.format(league.nerdStats!.vsapm) : "-.--"} VS/APM", style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }

}

class _DestinationHomeState extends State<DestinationHome> with SingleTickerProviderStateMixin {
  Cards rightCard = Cards.overview;
  CardMod cardMod = CardMod.info;
  //Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  late Map<Cards, List<ButtonSegment<CardMod>>> modeButtons;
  late MapEntry? closestAverageBlitz;
  late bool blitzBetterThanClosestAverage;
  late MapEntry? closestAverageSprint;
  late bool sprintBetterThanClosestAverage;
  late AnimationController _transition;
  late final Animation<Offset> _offsetAnimation;
  bool? sprintBetterThanRankAverage;
  bool? blitzBetterThanRankAverage;

  Widget getOverviewCard(Summaries summaries){
    return Column(
      children: [
        const Card(
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
        LeagueCard(league: summaries.league),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("40 Lines", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      RecordSummary(record: summaries.sprint, betterThanClosestAverage: sprintBetterThanClosestAverage, betterThanRankAverage: sprintBetterThanRankAverage, closestAverage: closestAverageSprint, rank: summaries.league.percentileRank),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      Text("${summaries.sprint != null ? intf.format(summaries.sprint!.stats.piecesPlaced) : "---"} P • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.pps) : "---"} PPS • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.kpp) : "---"} KPP", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Blitz", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      RecordSummary(record: summaries.blitz, betterThanClosestAverage: blitzBetterThanClosestAverage, betterThanRankAverage: blitzBetterThanRankAverage, closestAverage: closestAverageBlitz, rank: summaries.league.percentileRank),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      Text("Level ${summaries.blitz != null ? intf.format(summaries.blitz!.stats.level): "--"} • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.spp) : "-.--"} SPP • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.pps) : "---"} PPS", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("QP", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      RecordSummary(record: summaries.zenith, hideRank: true),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      Text("Overall PB: ${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 18).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 18).v!) : "-.--"} m", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("QP Expert", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      RecordSummary(record: summaries.zenithEx, hideRank: true,),
                      const Divider(color: Color.fromARGB(50, 158, 158, 158)),
                      Text("Overall PB: ${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 19).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 19).v!) : "-.--"} m", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Zen", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      Text("Level ${intf.format(summaries.zen.level)}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white)),
                      Text("Score ${intf.format(summaries.zen.score)}"),
                      Text("Level up requirement: ${intf.format(summaries.zen.scoreRequirement)}", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        const Text("f", style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 65,
                          height: 1.2,
                        )),
                        const Positioned(left: 25, top: 20, child: Text("inesse", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 4).v != null && summaries.achievements.firstWhere((e) => e.k == 1).v != null) ?
                          f3.format(summaries.achievements.firstWhere((e) => e.k == 4).v!/summaries.achievements.firstWhere((e) => e.k == 1).v! * 100) : "--.---"}%", style: const TextStyle(
                            //shadows: textShadow,
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          )),
                        )
                      ],
                      ),
                      Row(
                        children: [
                          const Text("Total pieces placed:"),
                          const Spacer(),
                          Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 1).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 1).v!) : "---"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(" - Placed with perfect finesse:"),
                          const Spacer(),
                          Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 4).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 4).v!) : "---"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (summaries.achievements.isNotEmpty) Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              children: [
                if (summaries.achievements.firstWhere((e) => e.k == 16).v != null) Row(
                  children: [
                    const Text("Total height climbed in QP"),
                    const Spacer(),
                    Text("${f2.format(summaries.achievements.firstWhere((e) => e.k == 16).v!)} m"),
                  ],
                ),
                if (summaries.achievements.firstWhere((e) => e.k == 17).v != null) Row(
                  children: [
                    const Text("KO's in QP"),
                    const Spacer(),
                    Text(intf.format(summaries.achievements.firstWhere((e) => e.k == 17).v!)),
                  ],
                )
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget getTetraLeagueCard(TetraLeague data, Cutoffs? cutoffs, List<TetraLeague> states){
    TetraLeague? toCompare = states.length >= 2 ? states.elementAtOrNull(states.length-2) : null;
    return Column(
      children: [
        Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.tetraLeague, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${states.last.timestamp} ${states.last.tr}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        TetraLeagueThingy(league: data, toCompare: toCompare, cutoffs: cutoffs),
        if (data.nerdStats != null) Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              const Spacer()
            ],
          ),
        ),
        if (data.nerdStats != null) NerdStatsThingy(nerdStats: data.nerdStats!, oldNerdStats: toCompare?.nerdStats),
        if (data.nerdStats != null) GraphsThingy(nerdStats: data.nerdStats!, playstyle: data.playstyle!, apm: data.apm!, pps: data.pps!, vs: data.vs!)
      ],
    );
  }

  Widget getPreviousSeasonsList(Map<int, TetraLeague> pastLeague){
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
                  Text("Previous Seasons", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        for (var key in pastLeague.keys) Card(
          child: LeagueCard(league: pastLeague[key]!, showSeasonNumber: true),
        )
      ],
    );
  }

  Widget getListOfRecords(String recentStream, String topStream, BoxConstraints constraints){
    return Column(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Records", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: DefaultTabController(length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Recent"),
                    Tab(text: "Top"),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      FutureBuilder<SingleplayerStream>(
                        future: teto.fetchStream(widget.searchFor, recentStream),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData){
                              return Column(
                                children: [
                                  for (int i = 0; i < snapshot.data!.records.length; i++) ListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: snapshot.data!.records[i]))),
                                  leading: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => "40L",
                                      "blitz" => "BLZ",
                                      "5mblast" => "5MB",
                                      "zenith" => "QP",
                                      "zenithex" => "QPE",
                                      String() => "huh",
                                    },
                                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
                                  ),
                                  title: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                      "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      String() => "huh",
                                    },
                                  style: const TextStyle(fontSize: 18)),
                                  subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                  trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                )
                                ],
                              );
                            }
                            if (snapshot.hasError){ return FutureError(snapshot); }
                          }
                        return const Text("what?");
                        },
                      ),
                      FutureBuilder<SingleplayerStream>(
                        future: teto.fetchStream(widget.searchFor, topStream),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData){
                              return Column(
                                children: [
                                  for (int i = 0; i < snapshot.data!.records.length; i++) ListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: snapshot.data!.records[i]))),
                                  leading: Text(
                                    "#${i+1}",
                                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
                                  ),
                                  title: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                      "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      String() => "huh",
                                    },
                                  style: const TextStyle(fontSize: 18)),
                                  subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                  trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                )
                                ],
                              );
                            }
                            if (snapshot.hasError){ return FutureError(snapshot); }
                          }
                        return const Text("what?");
                        },
                      ),
                    ]
                  ),
                )
              ],
            ),
          ) 
        ),
      ],
    );
  }

  Widget getRecentTLrecords(BoxConstraints constraints){
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
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder<TetraLeagueBetaStream>(
            future: teto.fetchTLStream(widget.searchFor),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData){
                  return SizedBox(height: constraints.maxHeight - 145, child: _TLRecords(userID: widget.searchFor, changePlayer: (){}, data: snapshot.data!.records, wasActiveInTL: snapshot.data!.records.isNotEmpty, oldMathcesHere: false));
                }
                if (snapshot.hasError){ return FutureError(snapshot); }
              }
            return const Text("what?");
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
                  //Text("Leaderboard reset in ${countdown(postSeasonLeft)}", textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        ZenithThingy(zenith: record),
        if (record != null) Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    FinesseThingy(record.stats.finesse, record.stats.finessePercentage),
                    LineclearsThingy(record.stats.clears, record.stats.lines, record.stats.holds, record.stats.tSpins, showMoreClears: true),
                    if (record.gamemode == 'blitz') Text("${f2.format(record.stats.kpp)} KPP")
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: SizedBox(
                  width: 300,
                  height: 318,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          const Text("T", style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 65,
                            height: 1.2,
                          )),
                          const Positioned(left: 25, top: 20, child: Text("otal time", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(getMoreNormalTime(record.stats.finalTime), style: const TextStyle(
                              shadows: textShadow,
                              fontFamily: "Eurostile Round Extended",
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                            )),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 300.0,
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(36)
                          },
                          children: [
                            const TableRow(
                              children: [
                                Text("Floor"),
                                Text("Split", textAlign: TextAlign.right),
                                Text("Total", textAlign: TextAlign.right),
                              ]
                            ),
                            for (int i = 0; i < record.stats.zenith!.splits.length; i++) TableRow(
                              children: [
                                Text((i+1).toString()),
                                Text(record.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record.stats.zenith!.splits[i]-(i-1 != -1 ? record.stats.zenith!.splits[i-1] : Duration.zero)) : "--:--.---", textAlign: TextAlign.right),
                                Text(record.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record.stats.zenith!.splits[i]) : "--:--.---", textAlign: TextAlign.right),
                              ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    if (record == null) {
      return const Card(
        child: Center(child: Text("No record", style: TextStyle(fontSize: 42))),
      );
    }
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
                  Text(switch(record.gamemode){
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
          child: Column(
            children: [
              Row(
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
                        if (rank != null && rank != "z" && rank != "x+") TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                          "40l" => readableTimeDifference(record.stats.finalTime, sprintAverages[rank]!),
                          "blitz" => readableIntDifference(record.stats.score, blitzAverages[rank]!),
                          _ => record.stats.score.toString()
                        }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank.toUpperCase())}\n", style: TextStyle(
                          color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                        ))
                        else if ((rank == null || rank == "z" || rank == "x+") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                          "40l" => readableTimeDifference(record.stats.finalTime, closestAverage.value),
                          "blitz" => readableIntDifference(record.stats.score, closestAverage.value),
                          _ => record.stats.score.toString()
                        }, verdict: betterThanClosestAverage??false ? t.verdictBetter : t.verdictWorse, rank: closestAverage.key.toUpperCase())}\n", style: TextStyle(
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
                  ],
                ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Table(
                      defaultColumnWidth:const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => record.stats.piecesPlaced.toString(),
                            "blitz" => record.stats.level.toString(),
                            "5mblast" => NumberFormat.decimalPattern().format(record.stats.spp),
                            _ => "What if "
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " Pieces",
                            "blitz" => " Level",
                            "5mblast" => " SPP",
                            _ => " i wanted to"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(f2.format(record.stats.pps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" PPS", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => f2.format(record.stats.kpp),
                            "blitz" => f2.format(record.stats.spp),
                            "5mblast" => record.stats.piecesPlaced.toString(),
                            _ => "but god said"
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " KPP",
                            "blitz" => " SPP",
                            "5mblast" => " Pieces",
                            _ => " no"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Table(
                      defaultColumnWidth:const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          Text(intf.format(record.stats.inputs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" Key presses", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(f2.format(record.stats.kps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" KPS", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => " ",
                            "blitz" => record.stats.piecesPlaced.toString(),
                            "5mblast" => record.stats.piecesPlaced.toString(),
                            _ => "but god said"
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " ",
                            "blitz" => " Pieces",
                            "5mblast" => " Pieces",
                            _ => " no"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ])
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Card(
          child: Center(
            child: Column(
              children: [
                FinesseThingy(record.stats.finesse, record.stats.finessePercentage),
                LineclearsThingy(record.stats.clears, record.stats.lines, record.stats.holds, record.stats.tSpins),
                if (record.gamemode == 'blitz') Text("${f2.format(record.stats.kpp)} KPP")
              ],
            ),
          ),
        )
      ]
    );
  }

  @override
  initState(){
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
            value: CardMod.ex, // yeah i misusing my own Enum shut the fuck up
            label: Text('Previous Seasons'),
          ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Recent Matches'),
          ),
        ],
      Cards.quickPlay: [
        const ButtonSegment<CardMod>(
            value: CardMod.info,
            label: Text('Normal'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.ex,
            label: Text('Expert'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.exRecords,
            label: Text('Expert Records'),
        )
      ],
      Cards.blitz: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        )
      ],
      Cards.sprint: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        )
      ]
    };

    _transition = AnimationController(vsync: this, duration: Durations.long4);

    // _transition.addListener((){
    //   setState(() {
        
    //   });
    // });

    _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _transition,
    curve: Curves.elasticIn,
  ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchResults>(
      future: _data,
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          if (snapshot.hasError){ return FutureError(snapshot); }
          if (snapshot.hasData){
            blitzBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.blitz != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.blitz!.stats.score > blitzAverages[snapshot.data!.summaries!.league.rank]! : null;
            sprintBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.sprint != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.sprint!.stats.finalTime < sprintAverages[snapshot.data!.summaries!.league.rank]! : null;
              if (snapshot.data!.summaries!.sprint != null) {
              closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.sprint!.stats.finalTime).abs() < (b -snapshot.data!.summaries!.sprint!.stats.finalTime).abs() ? a : b));
              sprintBetterThanClosestAverage = snapshot.data!.summaries!.sprint!.stats.finalTime < closestAverageSprint!.value;
            }
            if (snapshot.data!.summaries!.blitz != null){
              closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.blitz!.stats.score).abs() < (b -snapshot.data!.summaries!.blitz!.stats.score).abs() ? a : b));
              blitzBetterThanClosestAverage = snapshot.data!.summaries!.blitz!.stats.score > closestAverageBlitz!.value;
            }
            return TweenAnimationBuilder(
              duration: Durations.long4,
              tween: Tween<double>(begin: 0, end: 1),
              curve: Easing.standard,
              builder: (context, value, child) {
                return Container(
                  transform: Matrix4.translationValues(0, 600-value*600, 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: [
                        NewUserThingy(player: snapshot.data!.player!, showStateTimestamp: false, setState: setState),
                        if (snapshot.data!.player!.badges.isNotEmpty) BadgesThingy(badges: snapshot.data!.player!.badges),
                        if (snapshot.data!.player!.distinguishment != null) DistinguishmentThingy(snapshot.data!.player!.distinguishment!),
                        if (snapshot.data!.player!.role == "bot") FakeDistinguishmentThingy(bot: true, botMaintainers: snapshot.data!.player!.botmaster),
                        if (snapshot.data!.player!.role == "banned") FakeDistinguishmentThingy(banned: true)
                        else if (snapshot.data!.player!.badstanding == true) FakeDistinguishmentThingy(badStanding: true),
                        if (snapshot.data!.player!.bio != null) Card(
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
                                child: MarkdownBody(data: snapshot.data!.player!.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center)),
                              )
                            ],
                          ),
                        ),
                          //if (testNews != null && testNews!.news.isNotEmpty)
                        Expanded(
                          child: FutureBuilder<News>(
                            future: _newsData,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return const Card(child: Center(child: CircularProgressIndicator()));
                                case ConnectionState.done:
                                  if (snapshot.hasData){
                                    return NewsThingy(snapshot.data!);
                                  }else if (snapshot.hasError){ return FutureError(snapshot); }
                              }
                              return const Text("what?");
                            }
                          ),
                        )
                        ],
                      ),
                  ),
                  SizedBox(
                    width: widget.constraints.maxWidth - 450 - 80,
                    child: Column(
                      children: [
                        SizedBox(
                          height: rightCard != Cards.overview ? widget.constraints.maxHeight - 64 : widget.constraints.maxHeight - 32,
                          child: SingleChildScrollView(
                            child: SlideTransition(
                              position: _offsetAnimation,
                              child: switch (rightCard){
                                Cards.overview => getOverviewCard(snapshot.data!.summaries!),
                                Cards.tetraLeague => switch (cardMod){
                                  CardMod.info => getTetraLeagueCard(snapshot.data!.summaries!.league, snapshot.data!.cutoffs, snapshot.data!.states),
                                  CardMod.ex => getPreviousSeasonsList(snapshot.data!.summaries!.pastLeague),
                                  CardMod.records => getRecentTLrecords(widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                                Cards.quickPlay => switch (cardMod){
                                  CardMod.info => getZenithCard(snapshot.data?.summaries!.zenith),
                                  CardMod.records => getListOfRecords("zenith/recent", "zenith/top", widget.constraints),
                                  CardMod.ex => getZenithCard(snapshot.data?.summaries!.zenithEx),
                                  CardMod.exRecords => getListOfRecords("zenithex/recent", "zenithex/top", widget.constraints),
                                },
                                Cards.sprint => switch (cardMod){
                                  CardMod.info => getRecordCard(snapshot.data?.summaries!.sprint, sprintBetterThanRankAverage, closestAverageSprint, sprintBetterThanClosestAverage, snapshot.data!.summaries!.league.rank),
                                  CardMod.records => getListOfRecords("40l/recent", "40l/top", widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                                Cards.blitz => switch (cardMod){
                                  CardMod.info => getRecordCard(snapshot.data?.summaries!.blitz, blitzBetterThanRankAverage, closestAverageBlitz, blitzBetterThanClosestAverage, snapshot.data!.summaries!.league.rank),
                                  CardMod.records => getListOfRecords("blitz/recent", "blitz/top", widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                              },
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
                              //_transition.;
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
                      ],
                    )
                  )
                ],
              ),
            );
          }
        }
        return const Text("End of FutureBuilder<FetchResults>");
      },
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
                  // TODO: osk banner can cause memory leak
                  if (player.bannerRevision != null) FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${player.userId}&rv=${player.bannerRevision}" : "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                    height: 120,
                    fadeInCurve: Easing.standard, fadeInDuration: Durations.long4
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 90.0 : 10.0,
                    left: 16.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                        : player.avatarRevision != null
                          ? FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${player.userId}&rv=${player.avatarRevision}" : "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                            fit: BoxFit.fitHeight, height: 128, placeholder: kTransparentImage, fadeInCurve: Easing.emphasizedDecelerate, fadeInDuration: Durations.long4)
                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                    )
                  ),
                  Positioned(
                    top: player.bannerRevision != null ? 120.0 : 40.0,
                    left: 160.0,
                    child: Tooltip(
                      message: "${player.userId}\n(Click to copy user ID)",
                      child: RichText(text: TextSpan(text: player.username, style: TextStyle(
                          fontFamily: fontStyle(player.username.length),
                          fontSize: 28,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = (){
                            copyToClipboard(player.userId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copiedToClipboard)));
                          }
                        )
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
                    child: SizedBox(
                      width: 270,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: "Eurostile Round"),
                          children: [
                            if (player.country != null) TextSpan(text: "${t.countries[player.country]} • "),
                            TextSpan(text: player.registrationTime == null ? t.wasFromBeginning : timestamp(player.registrationTime!), style: const TextStyle(color: Colors.grey))
                          ]
                        )
                      ),
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
                          TextSpan(text: "Level ${(player.level.isNegative || player.level.isNaN) ? "---" : intf.format(player.level.floor())}", style: TextStyle(decoration: (player.level.isNegative || player.level.isNaN) ? null : TextDecoration.underline, decorationColor: Colors.white70, decorationStyle: TextDecorationStyle.dotted, color: (player.level.isNegative || player.level.isNaN) ? Colors.grey : Colors.white), recognizer: (player.level.isNegative || player.level.isNaN) ? null : TapGestureRecognizer()?..onTap = (){
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
  final TetraLeague league;
  final TetraLeague? toCompare;
  final Cutoffs? cutoffs;

  const TetraLeagueThingy({super.key, required this.league, this.toCompare, this.cutoffs});
  
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
                        Text(f2.format(league.apm??0.00), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" APM", style: TextStyle(fontSize: 21)),
                        if (toCompare != null) Text(" (${comparef2.format(league.apm!-toCompare!.apm!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.apm!-toCompare!.apm!)))
                      ]),
                      TableRow(children: [
                        Text(f2.format(league.pps??0.00), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" PPS", style: TextStyle(fontSize: 21)),
                        if (toCompare != null) Text(" (${comparef2.format(league.pps!-toCompare!.pps!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.pps!-toCompare!.pps!)))
                      ]),
                      TableRow(children: [
                        Text(f2.format(league.vs??0.00), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" VS", style: TextStyle(fontSize: 21)),
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

  const NerdStatsThingy({super.key, required this.nerdStats, this.oldNerdStats});

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
                                  TextSpan(text: f3.format(nerdStats.app), style: const TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
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
                                  TextSpan(text: f3.format(nerdStats.vsapm), style: const TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
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
                      GaugetThingy(value: nerdStats.dss, oldValue: oldNerdStats?.dss, min: 0, max: 1.0, tickInterval: .2, label: "DS/S", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true),
                      GaugetThingy(value: nerdStats.dsp, oldValue: oldNerdStats?.dsp, min: 0, max: 1.0, tickInterval: .2, label: "DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true),
                      GaugetThingy(value: nerdStats.appdsp, oldValue: oldNerdStats?.appdsp, min: 0, max: 1.2, tickInterval: .2, label: "APP+DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true),
                      GaugetThingy(value: nerdStats.cheese, oldValue: oldNerdStats?.cheese, min: -80, max: 80, tickInterval: 40, label: "Cheese", sideSize: 128.0, fractionDigits: 2, moreIsBetter: false),
                      GaugetThingy(value: nerdStats.gbe, oldValue: oldNerdStats?.gbe, min: 0, max: 1.0, tickInterval: .2, label: "GbE", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true),
                      GaugetThingy(value: nerdStats.nyaapp, oldValue: oldNerdStats?.nyaapp, min: 0, max: 1.2, tickInterval: .2, label: "wAPP", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true),
                      GaugetThingy(value: nerdStats.area, oldValue: oldNerdStats?.area, min: 0, max: 1000, tickInterval: 100, label: "Area", sideSize: 128.0, fractionDigits: 1, moreIsBetter: true),
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
  final bool moreIsBetter;
  final double tickInterval;
  final String label;
  final double sideSize;
  final int fractionDigits;

  GaugetThingy({super.key, required this.value, required this.min, required this.max, this.oldValue, required this.tickInterval, required this.label, required this.sideSize, required this.fractionDigits, required this.moreIsBetter});

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
    return Center(child: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(snapshot.stackTrace.toString(), textAlign: TextAlign.center),
          ),
        ],
      )
    );
  }
}