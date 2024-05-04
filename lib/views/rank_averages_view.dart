import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/main_view.dart' show MainView;
import 'package:window_manager/window_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

var _chartsShortTitlesDropdowns = <DropdownMenuItem>[for (MapEntry e in chartsShortTitles.entries) DropdownMenuItem(value: e.key, child: Text(e.value),)];
Stats _chartsX = Stats.tr;
Stats _chartsY = Stats.apm;
late TooltipBehavior _tooltipBehavior;
late ZoomPanBehavior _zoomPanBehavior;
List<DropdownMenuItem> _itemStats = [for (MapEntry e in chartsShortTitles.entries) DropdownMenuItem(value: e.key, child: Text(e.value))];
List<_MyScatterSpot> _spots = [];
Stats _sortBy = Stats.tr;
late List<TetrioPlayerFromLeaderboard> they;
bool _reversed = false;
List<DropdownMenuItem> _itemCountries = [for (MapEntry e in t.countries.entries) DropdownMenuItem(value: e.key, child: Text(e.value))];
String _country = "";
late String _oldWindowTitle;
final NumberFormat _f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
final NumberFormat _f4 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 4);

class RankView extends StatefulWidget {
  final List rank;
  const RankView({super.key, required this.rank});

  @override
  State<StatefulWidget> createState() => RankState();
}

class RankState extends State<RankView> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  late String previousAxisTitles;
  late double minX;
  late double actualMinX;
  late double maxX;
  late double actualMaxX;
  late double minY;
  late double actualMinY;
  late double maxY;
  late double actualMaxY;
  late double xScale;
  late double yScale;
  String headerTooltip = t.pseudoTooltipHeaderInit;
  String footerTooltip = t.pseudoTooltipFooterInit;
  ValueNotifier<int> hoveredPointId = ValueNotifier<int>(-1);
  double scaleFactor = 5e2;
  double dragFactor = 7e2;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 6, vsync: this);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming : true,
      enablePanning: true,
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
                Text('${_f4.format(data.x)} ${chartsShortTitles[_chartsX]}\n${_f4.format(data.y)} ${chartsShortTitles[_chartsY]}')
              ],
            ),
          );
      }
    );
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => _oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${widget.rank[1]["everyone"] ? t.everyoneAverages : t.rankAverages(rank: widget.rank[0].rank.toUpperCase())}");
    }
    super.initState();
    previousAxisTitles = _chartsX.toString()+_chartsY.toString();
    they = TetrioPlayersLeaderboard("lol", []).getStatRanking(widget.rank[1]["entries"]!, _sortBy, reversed: _reversed, country: _country);
    createSpots();
  }

  void createSpots(){
    _spots = [
      for (TetrioPlayerFromLeaderboard entry in widget.rank[1]["entries"])
      if (entry.apm != 0.0 && entry.vs != 0.0) // prevents from ScatterChart "Offset argument contained a NaN value." exception
        _MyScatterSpot(
            entry.getStatByEnum(_chartsX).toDouble(),
            entry.getStatByEnum(_chartsY).toDouble(),
            entry.userId,
            entry.username,
            entry.rank,
            rankColors[entry.rank]??Colors.white
        )
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(_oldWindowTitle);
    super.dispose();
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    if (previousAxisTitles != _chartsX.toString()+_chartsY.toString()){
      createSpots();
      previousAxisTitles = _chartsX.toString()+_chartsY.toString();
    }
    final t = Translations.of(context);
    //they = TetrioPlayersLeaderboard("lol", []).getStatRanking(widget.rank[1]["entries"]!, _sortBy, reversed: _reversed, country: _country);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.rank[1]["everyone"] ? t.everyoneAverages : t.rankAverages(rank: widget.rank[0].rank.toUpperCase())),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [ SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [Image.asset("res/tetrio_tl_alpha_ranks/${widget.rank[0].rank}.png",fit: BoxFit.fitHeight,height: 128), ],
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
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 20,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("X:", style: TextStyle(fontSize: 22))),
                                    DropdownButton(
                                        items: _chartsShortTitlesDropdowns,
                                        value: _chartsX,
                                        onChanged: (value) {
                                          _chartsX = value;
                                          _justUpdate();
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Y:", style: TextStyle(fontSize: 22)),
                                    ),
                                    DropdownButton(
                                        items: _chartsShortTitlesDropdowns,
                                        value: _chartsY,
                                        onChanged: (value) {
                                          _chartsY = value;
                                          _justUpdate();
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(onPressed: () => _zoomPanBehavior.reset(), icon: const Icon(Icons.refresh), alignment: Alignment.center,)
                          ],
                        ),
                        if (widget.rank[1]["entries"].length > 1)
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 104,
                              child: Padding(
                                padding: bigScreen ? const EdgeInsets.fromLTRB(40, 10, 40, 20) : const EdgeInsets.fromLTRB(0, 10, 16, 20),
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
                                    //primaryXAxis: CategoryAxis(),
                                    series: [
                                      ScatterSeries(
                                        enableTooltip: true,
                                        dataSource: _spots,
                                        animationDuration: 0,
                                        pointColorMapper: (data, _) => data.color,
                                        xValueMapper: (data, _) => data.x,
                                        yValueMapper: (data, _) => data.y,
                                        onPointTap: (point) => Navigator.push(context, MaterialPageRoute(builder: (context) => MainView(player: _spots[point.pointIndex!].nickname), maintainState: false)),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        else Center(child: Text(t.notEnoughData, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("${t.sortBy}: ", style: const TextStyle(color: Colors.white, fontSize: 25)),
                                  DropdownButton(
                                    items: _itemStats,
                                    value: _sortBy,
                                    onChanged: ((value) {
                                      _sortBy = value;
                                      setState(() {
                                        they = TetrioPlayersLeaderboard("lol", []).getStatRanking(widget.rank[1]["entries"]!, _sortBy, reversed: _reversed, country: _country);
                                      });
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("${t.reversed}: ", style: const TextStyle(color: Colors.white, fontSize: 25)),
                                  Padding(padding: const EdgeInsets.fromLTRB(0, 5.5, 0, 7.5),
                                    child: Checkbox(
                                      value: _reversed,
                                      checkColor: Colors.black,
                                      onChanged: ((value) {
                                        _reversed = value!;
                                        setState(() {
                                          they = TetrioPlayersLeaderboard("lol", []).getStatRanking(widget.rank[1]["entries"]!, _sortBy, reversed: _reversed, country: _country);
                                        });
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text("${t.country}: ", style: const TextStyle(color: Colors.white, fontSize: 25)),
                                  DropdownButton(
                                    items: _itemCountries,
                                    value: _country,
                                    onChanged: ((value) {
                                      _country = value;
                                      setState(() {
                                        they = TetrioPlayersLeaderboard("lol", []).getStatRanking(widget.rank[1]["entries"]!, _sortBy, reversed: _reversed, country: _country);
                                      });
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: they.length,
                              itemBuilder: (context, index) {
                                bool bigScreen = MediaQuery.of(context).size.width > 768;
                                return ListTile(
                                  title: Text(they[index].username, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                  subtitle: Text(
                                    _sortBy == Stats.tr ? "${_f2.format(they[index].apm)} APM, ${_f2.format(they[index].pps)} PPS, ${_f2.format(they[index].vs)} VS, ${_f2.format(they[index].nerdStats.app)} APP, ${_f2.format(they[index].nerdStats.vsapm)} VS/APM" : "${_f4.format(they[index].getStatByEnum(_sortBy))} ${chartsShortTitles[_sortBy]}",
                                    style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${_f2.format(they[index].rating)} TR", style: bigScreen ? const TextStyle(fontSize: 28) : null),
                                      Image.asset("res/tetrio_tl_alpha_ranks/${they[index].rank}.png", height: bigScreen ? 48 : 16),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainView(player: they[index].username), maintainState: false));
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.lowestValues, style: TextStyle( fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(value: widget.rank[1]["lowestTR"], label: t.statCellNum.tr.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestTRid"], username: widget.rank[1]["lowestTRnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestGlicko"], label: "Glicko", id: widget.rank[1]["lowestGlickoID"], username: widget.rank[1]["lowestGlickoNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestRD"], label: t.statCellNum.rd.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestRdID"], username: widget.rank[1]["lowestRdNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestGamesPlayed"], label: t.statCellNum.gamesPlayed.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestGamesPlayedID"], username: widget.rank[1]["lowestGamesPlayedNick"], approximate: false),
                              _ListEntry(value: widget.rank[1]["lowestGamesWon"], label: t.statCellNum.gamesWonTL.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestGamesWonID"], username: widget.rank[1]["lowestGamesWonNick"], approximate: false),
                              _ListEntry(value: widget.rank[1]["lowestWinrate"] * 100, label: t.statCellNum.winrate.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestWinrateID"], username: widget.rank[1]["lowestWinrateNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestAPM"], label: t.statCellNum.apm.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestAPMid"], username: widget.rank[1]["lowestAPMnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestPPS"], label: t.statCellNum.pps.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestPPSid"], username: widget.rank[1]["lowestPPSnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestVS"], label: t.statCellNum.vs.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestVSid"], username: widget.rank[1]["lowestVSnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestAPP"], label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestAPPid"], username: widget.rank[1]["lowestAPPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestVSAPM"], label: "VS / APM", id: widget.rank[1]["lowestVSAPMid"], username: widget.rank[1]["lowestVSAPMnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestDSS"], label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestDSSid"], username: widget.rank[1]["lowestDSSnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestDSP"], label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestDSPid"], username: widget.rank[1]["lowestDSPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestAPPDSP"], label: t.statCellNum.appdsp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestAPPDSPid"], username: widget.rank[1]["lowestAPPDSPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestCheese"], label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestCheeseID"], username: widget.rank[1]["lowestCheeseNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestGBE"], label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestGBEid"], username: widget.rank[1]["lowestGBEnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestNyaAPP"], label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestNyaAPPid"], username: widget.rank[1]["lowestNyaAPPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestArea"], label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestAreaID"], username: widget.rank[1]["lowestAreaNick"], approximate: false, fractionDigits: 1),
                              _ListEntry(value: widget.rank[1]["lowestEstTR"], label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestEstTRid"], username: widget.rank[1]["lowestEstTRnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["lowestEstAcc"], label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["lowestEstAccID"], username: widget.rank[1]["lowestEstAccNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestOpener"], label: "Opener", id: widget.rank[1]["lowestOpenerID"], username: widget.rank[1]["lowestOpenerNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestPlonk"], label: "Plonk", id: widget.rank[1]["lowestPlonkID"], username: widget.rank[1]["lowestPlonkNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestStride"], label: "Stride", id: widget.rank[1]["lowestStrideID"], username: widget.rank[1]["lowestStrideNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["lowestInfDS"], label: "Inf. DS", id: widget.rank[1]["lowestInfDSid"], username: widget.rank[1]["lowestInfDSnick"], approximate: false, fractionDigits: 3)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.averageValues, style: TextStyle( fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                            child: ListView(children: [
                          _ListEntry(value: widget.rank[0].rating, label: t.statCellNum.tr.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[0].glicko, label: "Glicko", id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[0].rd, label: t.statCellNum.rd.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[0].gamesPlayed, label: t.statCellNum.gamesPlayed.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 0),
                          _ListEntry(value: widget.rank[0].gamesWon, label: t.statCellNum.gamesWonTL.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 0),
                          _ListEntry(value: widget.rank[0].winrate * 100, label: t.statCellNum.winrate.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[0].apm, label: t.statCellNum.apm.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[0].pps, label: t.statCellNum.pps.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[0].vs, label: t.statCellNum.vs.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[1]["avgAPP"], label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgVSAPM"], label: "VS / APM", id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgDSS"], label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgDSP"], label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgAPPDSP"], label: t.statCellNum.appdsp.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgCheese"], label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[1]["avgGBE"], label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgNyaAPP"], label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgArea"], label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 1),
                          _ListEntry(value: widget.rank[1]["avgEstTR"], label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 2),
                          _ListEntry(value: widget.rank[1]["avgEstAcc"], label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgOpener"], label: "Opener", id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgPlonk"], label: "Plonk", id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgStride"], label: "Stride", id: "", username: "", approximate: true, fractionDigits: 3),
                          _ListEntry(value: widget.rank[1]["avgInfDS"], label: "Inf. DS", id: "", username: "", approximate: true, fractionDigits: 3),
                        ]))
                      ],
                    ),
                    Column(
                      children: [
                        Text(t.highestValues, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(value: widget.rank[1]["highestTR"], label: t.statCellNum.tr.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestTRid"], username: widget.rank[1]["highestTRnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestGlicko"], label: "Glicko", id: widget.rank[1]["highestGlickoID"], username: widget.rank[1]["highestGlickoNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestRD"], label: t.statCellNum.rd.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestRdID"], username: widget.rank[1]["highestRdNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestGamesPlayed"], label: t.statCellNum.gamesPlayed.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestGamesPlayedID"], username: widget.rank[1]["highestGamesPlayedNick"], approximate: false),
                              _ListEntry(value: widget.rank[1]["highestGamesWon"], label: t.statCellNum.gamesWonTL.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestGamesWonID"], username: widget.rank[1]["highestGamesWonNick"], approximate: false),
                              _ListEntry(value: widget.rank[1]["highestWinrate"] * 100, label: t.statCellNum.winrate.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestWinrateID"], username: widget.rank[1]["highestWinrateNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestAPM"], label: t.statCellNum.apm.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestAPMid"], username: widget.rank[1]["highestAPMnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestPPS"], label: t.statCellNum.pps.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestPPSid"], username: widget.rank[1]["highestPPSnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestVS"], label: t.statCellNum.vs.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestVSid"], username: widget.rank[1]["highestVSnick"],  approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestAPP"], label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestAPPid"], username: widget.rank[1]["highestAPPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestVSAPM"], label: "VS / APM", id: widget.rank[1]["highestVSAPMid"], username: widget.rank[1]["highestVSAPMnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestDSS"], label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestDSSid"], username: widget.rank[1]["highestDSSnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestDSP"], label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestDSPid"], username: widget.rank[1]["highestDSPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestAPPDSP"], label: t.statCellNum.appdsp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestAPPDSPid"], username: widget.rank[1]["highestAPPDSPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestCheese"], label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestCheeseID"], username: widget.rank[1]["highestCheeseNick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestGBE"], label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestGBEid"], username: widget.rank[1]["highestGBEnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestNyaAPP"], label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestNyaAPPid"], username: widget.rank[1]["highestNyaAPPnick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestArea"], label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestAreaID"], username: widget.rank[1]["highestAreaNick"], approximate: false, fractionDigits: 1),
                              _ListEntry(value: widget.rank[1]["highestEstTR"], label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestEstTRid"], username: widget.rank[1]["highestEstTRnick"], approximate: false, fractionDigits: 2),
                              _ListEntry(value: widget.rank[1]["highestEstAcc"], label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "), id: widget.rank[1]["highestEstAccID"], username: widget.rank[1]["highestEstAccNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestOpener"], label: "Opener", id: widget.rank[1]["highestOpenerID"], username: widget.rank[1]["highestOpenerNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestPlonk"], label: "Plonk", id: widget.rank[1]["highestPlonkID"], username: widget.rank[1]["highestPlonkNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestStride"], label: "Stride", id: widget.rank[1]["highestStrideID"], username: widget.rank[1]["highestStrideNick"], approximate: false, fractionDigits: 3),
                              _ListEntry(value: widget.rank[1]["highestInfDS"], label: "Inf. DS", id: widget.rank[1]["highestInfDSid"], username: widget.rank[1]["highestInfDSnick"], approximate: false, fractionDigits: 3),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                            child: ListView(children: [
                          _ListEntry(value: widget.rank[1]["totalGamesPlayed"], label: t.statCellNum.totalGames, id: "", username: "", approximate: true, fractionDigits: 0),
                          _ListEntry(value: widget.rank[1]["totalGamesWon"], label: t.statCellNum.totalWon, id: "", username: "", approximate: true, fractionDigits: 0),
                          _ListEntry(value: (widget.rank[1]["totalGamesWon"] / widget.rank[1]["totalGamesPlayed"]) * 100, label: t.statCellNum.winrate.replaceAll(RegExp(r'\n'), " "), id: "", username: "", approximate: true, fractionDigits: 3),
                        ]))
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

class _MyScatterSpot{
  num x;
  num y;
  String id;
  String nickname;
  String rank;
  Color color;
  _MyScatterSpot(this.x, this.y, this.id, this.nickname, this.rank, this.color);
}
