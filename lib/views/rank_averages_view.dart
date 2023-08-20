import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
//import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/main_view.dart' show MainView, f4, f2;
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
//import 'package:tetra_stats/widgets/tl_thingy.dart';

List chartsShortTitles = [
  "TR",
  "Glicko",
  "RD",
  "GP",
  "GW",
  "WR%",
  "APM",
  "PPS",
  "VS",
  "APP",
  "DS/S",
  "DS/P",
  "APP + DS/P",
  "VS/APM",
  "Cheese",
  "GbE",
  "wAPP",
  "Area",
  "eTR",
  "±eTR",
  "Opener",
  "Plonk",
  "Inf. DS",
  "Stride",
  "Stride - Plonk",
  "Opener - Inf. DS"
  ];
var chartsShortTitlesDropdowns = <DropdownMenuItem>[for (String e in chartsShortTitles) DropdownMenuItem(child: Text(e), value: e,)];
int chartsIndexX = 0;
int chartsIndexY = 6;
//final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
double pfpHeight = 128;

class RankView extends StatefulWidget {
  final List rank;
  const RankView({Key? key, required this.rank}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RankState();
}

class RankState extends State<RankView> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.rank[1]["everyone"] ? t.everyoneAverages : t.rankAverages(rank: widget.rank[0].rank.toUpperCase())),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Image.asset(
                                      "res/tetrio_tl_alpha_ranks/${widget.rank[0].rank}.png",
                                      fit: BoxFit.fitHeight,
                                      height: 128),
                              ],
                            ),
                            Flexible(
                                child: Column(
                              children: [
                                Text(
                                    widget.rank[1]["everyone"] ? t.everyoneAverages : t.rankAverages(rank: widget.rank[0].rank.toUpperCase()),
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                                Text(
                                    t.players(n: widget.rank[1]["entries"].length),
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ],
                            )),
                          ],
                        ),
                      ],
                    )),
                    SliverToBoxAdapter(
                        child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: [
                        Tab(text: t.chart),
                        Tab(text: t.entries),
                        Tab(text: t.minimums),
                        Tab(text: t.averages),
                        Tab(text: t.maximums),
                        Tab(text: t.other),
                      ],
                    )),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          spacing: 25,
                          children: [Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(t.currentAxis(axis: "X"), style: const TextStyle(fontSize: 22))),
                                DropdownButton(
                                      items: chartsShortTitlesDropdowns,
                                      value: chartsShortTitlesDropdowns[chartsIndexX].value,
                                      onChanged: (value) {
                                        chartsIndexX = chartsShortTitlesDropdowns.indexWhere((element) => element.value == value);
                                        _justUpdate();
                                      }
                                    ),
                              ],
                            ),
                          ],
                        ),Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(t.currentAxis(axis: "Y"), style: const TextStyle(fontSize: 22)),
                                ),
                                DropdownButton(
                                      items: chartsShortTitlesDropdowns,
                                      value: chartsShortTitlesDropdowns[chartsIndexY].value,
                                      onChanged: (value) {
                                        chartsIndexY = chartsShortTitlesDropdowns.indexWhere((element) => element.value == value);
                                        _justUpdate();
                                      }
                                    ),
                              ],
                            ),
                          ],
                        ),],),
                        if(widget.rank[1]["entries"].length > 1) SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 104,
        child: Stack(
          children: [
            Padding(
              padding: bigScreen
                  ? const EdgeInsets.fromLTRB(40, 40, 40, 48)
                  : const EdgeInsets.fromLTRB(0, 40, 16, 48),
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: [ for (TetrioPlayerFromLeaderboard entry in widget.rank[1]["entries"]) _MyScatterSpot(takeStat(entry, chartsShortTitles[chartsIndexX]), takeStat(entry, chartsShortTitles[chartsIndexY]), entry.userId, entry.username, color: rankColors[entry.rank])],
                  scatterTouchData: ScatterTouchData(touchTooltipData: ScatterTouchTooltipData(
                    fitInsideHorizontally: true, fitInsideVertically: true, getTooltipItems: (touchedSpot) {
                    touchedSpot as _MyScatterSpot;
                  return ScatterTooltipItem("${touchedSpot.nickname}\n", textStyle: TextStyle(fontFamily: "Eurostile Round Extended"), children: [TextSpan(text: "${f4.format(touchedSpot.x)} ${chartsShortTitles[chartsIndexX]}\n${f4.format(touchedSpot.y)} ${chartsShortTitles[chartsIndexY]}", style: TextStyle(fontFamily: "Eurostile Round"))]);
                }),
                touchCallback:(event, response) {
                  if (event.runtimeType == FlTapDownEvent && response?.touchedSpot?.spot != null){
                    var spot = response?.touchedSpot?.spot as _MyScatterSpot;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainView(player: spot.nickname),
                        maintainState: false,
                      ),
                    );
                  }
                },),
                ),
                swapAnimationDuration: Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear, // Optional
              ),
            ),
          ],
        ))
                        else Center(child: Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.entries,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView.builder(
                              itemCount: widget.rank[1]["entries"]!.length,
                              itemBuilder: (context, index) {
                                bool bigScreen =
                                    MediaQuery.of(context).size.width > 768;
                                return ListTile(
                                  title: Text(
                                      widget.rank[1]["entries"][index].username,
                                      style: const TextStyle(
                                          fontFamily:
                                              "Eurostile Round Extended")),
                                  subtitle: Text(
                                      "${f2.format(widget.rank[1]["entries"][index].apm)} APM, ${f2.format(widget.rank[1]["entries"][index].pps)} PPS, ${f2.format(widget.rank[1]["entries"][index].vs)} VS, ${f2.format(widget.rank[1]["entries"][index].nerdStats.app)} APP, ${f2.format(widget.rank[1]["entries"][index].nerdStats.vsapm)} VS/APM"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "${f2.format(widget.rank[1]["entries"][index].rating)} TR",
                                          style: bigScreen
                                              ? const TextStyle(fontSize: 28)
                                              : null),
                                      Image.asset(
                                          "res/tetrio_tl_alpha_ranks/${widget.rank[1]["entries"][index].rank}.png",
                                          height: bigScreen ? 48 : 16),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainView(
                                            player: widget
                                                .rank[1]["entries"][index]
                                                .username),
                                        maintainState: false,
                                      ),
                                    );
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.lowestValues,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[1]["lowestTR"],
                                  label: t.statCellNum.tr
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestTRid"],
                                  username: widget.rank[1]["lowestTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGlicko"],
                                  label: "Glicko",
                                  id: widget.rank[1]["lowestGlickoID"],
                                  username: widget.rank[1]["lowestGlickoNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestRD"],
                                  label: t.statCellNum.rd
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestRdID"],
                                  username: widget.rank[1]["lowestRdNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGamesPlayed"],
                                  label: t.statCellNum.gamesPlayed
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestGamesPlayedID"],
                                  username: widget.rank[1]
                                      ["lowestGamesPlayedNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGamesWon"],
                                  label: t.statCellNum.gamesWonTL
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestGamesWonID"],
                                  username: widget.rank[1]
                                      ["lowestGamesWonNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["lowestWinrate"] * 100,
                                  label: t.statCellNum.winrate
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestWinrateID"],
                                  username: widget.rank[1]["lowestWinrateNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestAPM"],
                                  label: t.statCellNum.apm
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAPMid"],
                                  username: widget.rank[1]["lowestAPMnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestPPS"],
                                  label: t.statCellNum.pps
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestPPSid"],
                                  username: widget.rank[1]["lowestPPSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestVS"],
                                  label: t.statCellNum.vs
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestVSid"],
                                  username: widget.rank[1]["lowestVSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestAPP"],
                                  label: t.statCellNum.app
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAPPid"],
                                  username: widget.rank[1]["lowestAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestVSAPM"],
                                  label: "VS / APM",
                                  id: widget.rank[1]["lowestVSAPMid"],
                                  username: widget.rank[1]["lowestVSAPMnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestDSS"],
                                  label: t.statCellNum.dss
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestDSSid"],
                                  username: widget.rank[1]["lowestDSSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestDSP"],
                                  label: t.statCellNum.dsp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestDSPid"],
                                  username: widget.rank[1]["lowestDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestAPPDSP"],
                                  label: t.statCellNum.dsp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAPPDSPid"],
                                  username: widget.rank[1]["lowestAPPDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestCheese"],
                                  label: t.statCellNum.cheese
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestCheeseID"],
                                  username: widget.rank[1]["lowestCheeseNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGBE"],
                                  label: t.statCellNum.gbe
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestGBEid"],
                                  username: widget.rank[1]["lowestGBEnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestNyaAPP"],
                                  label: t.statCellNum.nyaapp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestNyaAPPid"],
                                  username: widget.rank[1]["lowestNyaAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestArea"],
                                  label: t.statCellNum.area
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAreaID"],
                                  username: widget.rank[1]["lowestAreaNick"],
                                  approximate: false,
                                  fractionDigits: 1),
                              _ListEntry(
                                  value: widget.rank[1]["lowestEstTR"],
                                  label: t.statCellNum.estOfTR
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestEstTRid"],
                                  username: widget.rank[1]["lowestEstTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestEstAcc"],
                                  label: t.statCellNum.accOfEst
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestEstAccID"],
                                  username: widget.rank[1]["lowestEstAccNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestOpener"],
                                  label: "Opener",
                                  id: widget.rank[1]["lowestOpenerID"],
                                  username: widget.rank[1]["lowestOpenerNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestPlonk"],
                                  label: "Plonk",
                                  id: widget.rank[1]["lowestPlonkID"],
                                  username: widget.rank[1]["lowestPlonkNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestStride"],
                                  label: "Stride",
                                  id: widget.rank[1]["lowestStrideID"],
                                  username: widget.rank[1]["lowestStrideNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestInfDS"],
                                  label: "Inf. DS",
                                  id: widget.rank[1]["lowestInfDSid"],
                                  username: widget.rank[1]["lowestInfDSnick"],
                                  approximate: false,
                                  fractionDigits: 3)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.averageValues,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                            child: ListView(children: [
                          _ListEntry(
                              value: widget.rank[0].rating,
                              label: t.statCellNum.tr
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[0].glicko,
                              label: "Glicko",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[0].rd,
                              label: t.statCellNum.rd
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[0].gamesPlayed,
                              label: t.statCellNum.gamesPlayed
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 0),
                          _ListEntry(
                              value: widget.rank[0].gamesWon,
                              label: t.statCellNum.gamesWonTL
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 0),
                          _ListEntry(
                              value: widget.rank[0].winrate * 100,
                              label: t.statCellNum.winrate
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[0].apm,
                              label: t.statCellNum.apm
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[0].pps,
                              label: t.statCellNum.pps
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[0].vs,
                              label: t.statCellNum.vs
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[1]["avgAPP"],
                              label: t.statCellNum.app
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgAPP"],
                              label: "VS / APM",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgDSS"],
                              label: t.statCellNum.dss
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgDSP"],
                              label: t.statCellNum.dsp
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgAPPDSP"],
                              label: t.statCellNum.dsp
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgCheese"],
                              label: t.statCellNum.cheese
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[1]["avgGBE"],
                              label: t.statCellNum.gbe
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgNyaAPP"],
                              label: t.statCellNum.nyaapp
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgArea"],
                              label: t.statCellNum.area
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 1),
                          _ListEntry(
                              value: widget.rank[1]["avgEstTR"],
                              label: t.statCellNum.estOfTR
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 2),
                          _ListEntry(
                              value: widget.rank[1]["avgEstAcc"],
                              label: t.statCellNum.accOfEst
                                  .replaceAll(RegExp(r'\n'), " "),
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgOpener"],
                              label: "Opener",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgPlonk"],
                              label: "Plonk",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgStride"],
                              label: "Stride",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                          _ListEntry(
                              value: widget.rank[1]["avgInfDS"],
                              label: "Inf. DS",
                              id: "",
                              username: "",
                              approximate: true,
                              fractionDigits: 3),
                        ]))
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.highestValues,
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[1]["highestTR"],
                                  label: t.statCellNum.tr
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestTRid"],
                                  username: widget.rank[1]["highestTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestGlicko"],
                                  label: "Glicko",
                                  id: widget.rank[1]["highestGlickoID"],
                                  username: widget.rank[1]["highestGlickoNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestRD"],
                                  label: t.statCellNum.rd
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestRdID"],
                                  username: widget.rank[1]["highestRdNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestGamesPlayed"],
                                  label: t.statCellNum.gamesPlayed
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestGamesPlayedID"],
                                  username: widget.rank[1]
                                      ["highestGamesPlayedNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["highestGamesWon"],
                                  label: t.statCellNum.gamesWonTL
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestGamesWonID"],
                                  username: widget.rank[1]
                                      ["highestGamesWonNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["highestWinrate"] * 100,
                                  label: t.statCellNum.winrate
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestWinrateID"],
                                  username: widget.rank[1]
                                      ["highestWinrateNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestAPM"],
                                  label: t.statCellNum.apm
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAPMid"],
                                  username: widget.rank[1]["highestAPMnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestPPS"],
                                  label: t.statCellNum.pps
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestPPSid"],
                                  username: widget.rank[1]["highestPPSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestVS"],
                                  label: t.statCellNum.vs
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestVSid"],
                                  username: widget.rank[1]["highestVSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestAPP"],
                                  label: t.statCellNum.app
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAPPid"],
                                  username: widget.rank[1]["highestAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestVSAPM"],
                                  label: "VS / APM",
                                  id: widget.rank[1]["highestVSAPMid"],
                                  username: widget.rank[1]["highestVSAPMnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestDSS"],
                                  label: t.statCellNum.dss
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestDSSid"],
                                  username: widget.rank[1]["highestDSSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestDSP"],
                                  label: t.statCellNum.dsp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestDSPid"],
                                  username: widget.rank[1]["highestDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestAPPDSP"],
                                  label: t.statCellNum.dsp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAPPDSPid"],
                                  username: widget.rank[1]["highestAPPDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestCheese"],
                                  label: t.statCellNum.cheese
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestCheeseID"],
                                  username: widget.rank[1]["highestCheeseNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestGBE"],
                                  label: t.statCellNum.gbe
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestGBEid"],
                                  username: widget.rank[1]["highestGBEnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestNyaAPP"],
                                  label: t.statCellNum.nyaapp
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestNyaAPPid"],
                                  username: widget.rank[1]["highestNyaAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestArea"],
                                  label: t.statCellNum.area
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAreaID"],
                                  username: widget.rank[1]["highestAreaNick"],
                                  approximate: false,
                                  fractionDigits: 1),
                              _ListEntry(
                                  value: widget.rank[1]["highestEstTR"],
                                  label: t.statCellNum.estOfTR
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestEstTRid"],
                                  username: widget.rank[1]["highestEstTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestEstAcc"],
                                  label: t.statCellNum.accOfEst
                                      .replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestEstAccID"],
                                  username: widget.rank[1]["highestEstAccNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestOpener"],
                                  label: "Opener",
                                  id: widget.rank[1]["highestOpenerID"],
                                  username: widget.rank[1]["highestOpenerNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestPlonk"],
                                  label: "Plonk",
                                  id: widget.rank[1]["highestPlonkID"],
                                  username: widget.rank[1]["highestPlonkNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestStride"],
                                  label: "Stride",
                                  id: widget.rank[1]["highestStrideID"],
                                  username: widget.rank[1]["highestStrideNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestInfDS"],
                                  label: "Inf. DS",
                                  id: widget.rank[1]["highestInfDSid"],
                                  username: widget.rank[1]["highestInfDSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                         Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[1]["totalGamesPlayed"],
                                  label: t.statCellNum.totalGames,
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 0),
                              _ListEntry(
                                  value: widget.rank[1]["totalGamesWon"],
                                  label: t.statCellNum.totalWon,
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 0),
                              _ListEntry(
                                  value: (widget.rank[1]["totalGamesWon"] /
                                         widget.rank[1]["totalGamesPlayed"]) *
                                    100,
                                  label: t.statCellNum.winrate
                                  .replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                              
                            ]
                            )
                          )
                      ],
                    ),
                  ],
                ))));
  }
}

class _ListEntry extends StatelessWidget {
  final num value;
  final String label;
  final String id;
  final String username;
  final bool approximate;
  final int? fractionDigits;
  const _ListEntry(
      {required this.value,
      required this.label,
      this.fractionDigits,
      required this.id,
      required this.username,
      required this.approximate});

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat.decimalPatternDigits(
        locale: LocaleSettings.currentLocale.languageCode,
        decimalDigits: fractionDigits ?? 0);
    return ListTile(
      title: Text(label),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(f.format(value),
              style: const TextStyle(fontSize: 22, height: 0.9)),
          if (id.isNotEmpty) Text(t.forPlayer(username: username))
        ],
      ),
      onTap: id.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainView(player: id),
                  maintainState: false,
                ),
              );
            }
          : null,
    );
  }
}

double takeStat(TetrioPlayerFromLeaderboard entry, String stat) {
  switch (stat) {
    case "TR":
      return entry.rating;
    case "Glicko":
      return entry.glicko;
    case "RD":
      return entry.rd;
    case "GP":
      return entry.gamesPlayed.toDouble();
    case "GW":
      return entry.gamesWon.toDouble();
    case "WR%":
      return entry.winrate*100;
    case "APM":
      return entry.apm;
    case "PPS":
      return entry.pps;
    case "VS":
      return entry.vs;
    case "APP":
      return entry.nerdStats.app;
    case "DS/S":
      return entry.nerdStats.dss;
    case "DS/P":
      return entry.nerdStats.dsp;
    case "APP + DS/P":
      return entry.nerdStats.appdsp;
    case "VS/APM":
      return entry.nerdStats.vsapm;
    case "Cheese":
      return entry.nerdStats.cheese;
    case "GbE":
      return entry.nerdStats.gbe;
    case "wAPP":
      return entry.nerdStats.nyaapp;
    case "Area":
      return entry.nerdStats.area;
    case "eTR":
      return entry.estTr.esttr;
    case "±eTR":
      return entry.esttracc;
    case "Opener":
      return entry.playstyle.opener;
    case "Plonk":
      return entry.playstyle.plonk;
    case "Inf. DS":
      return entry.playstyle.infds;
    case "Stride":
      return entry.playstyle.stride;
    case "Stride - Plonk":
      return entry.playstyle.stride - entry.playstyle.plonk;
    case "Opener - Inf. DS":
      return entry.playstyle.opener - entry.playstyle.infds;
    default:
      throw ArgumentError.value(stat, "Incorrect stat", "We don't have that stat");
  }
}

class _MyScatterSpot extends ScatterSpot{
  String id;
  String nickname;

  _MyScatterSpot(super.x, super.y, this.id, this.nickname, {super.color});
  
}