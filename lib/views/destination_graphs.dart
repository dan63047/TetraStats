import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';
import 'package:tetra_stats/data_objects/tetrio_players_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/widgets/error_thingy.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class DestinationGraphs extends StatefulWidget{
  final String searchFor;
  //final Function setState;
  final BoxConstraints constraints;
  final bool noSidebar;

  const DestinationGraphs({super.key, required this.searchFor, required this.constraints, required this.noSidebar});

  @override
  State<DestinationGraphs> createState() => _DestinationGraphsState();
}

Graph graph = Graph.history;
Stats Ychart = Stats.tr;

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
  Stats _Xchart = Stats.tr;
  int _season = currentSeason-1;
  ValueNotifier<String> historyPlayerUsername = ValueNotifier("");
  ValueNotifier<String> historyPlayerAvatarRevizion = ValueNotifier("");
  List<String> excludeRanks = [];
  late Future<List<_MyScatterSpot>> futureLeague = getTetraLeagueData(_Xchart, Ychart);
  String searchLeague = "";
  int? TLstatePlayers;
  DateTime? TLrelevance;

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
                Text(_gamesPlayedInsteadOfDateAndTime ? t.graphsDestination.gamesPlayed(games: t.stats.games(n: data.gamesPlayed)) : timestamp(data.timestamp))
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
                Text('${f4.format(data.x)} ${chartsShortTitles[_Xchart]}\n${f4.format(data.y)} ${chartsShortTitles[Ychart]}')
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

  Future<Map<int, Map<Stats, List<_HistoryChartSpot>>>> getHistoryData(bool fetchHistory) async {
    if(fetchHistory){
      try{
        var history = await teto.fetchAndsaveTLHistory(widget.searchFor, 1);
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.graphsDestination.fetchAndsaveTLHistoryResult(number: history.length))));
      }on TetrioHistoryNotExist{
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.noHistorySaved)));
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
    Map<int, Map<Stats, List<_HistoryChartSpot>>> historyData = {}; // [season][metric][spot]
    for (int season = 0; season < currentSeason; season++){
      if (states[season].length >= 2){
      Map<Stats, List<_HistoryChartSpot>> statsMap = {};
        for (var stat in Stats.values) statsMap[stat] = [for (var tl in states[season]) if (tl.getStatByEnum(stat) != null) _HistoryChartSpot(tl.timestamp, tl.gamesPlayed, tl.rank, tl.getStatByEnum(stat)!.toDouble())];
        historyData[season] = statsMap;
      }
    }
    fetchData = false;

    historyPlayerUsername.value = await teto.getNicknameByID(widget.searchFor);

    return historyData;
  }

  Future<List<_MyScatterSpot>> getTetraLeagueData(Stats x, Stats y) async {
    TetrioPlayersLeaderboard leaderboard = await teto.fetchTLLeaderboard();
    TLrelevance = leaderboard.timestamp;
    TLstatePlayers = leaderboard.leaderboard.length;
    List<_MyScatterSpot> _spots = [
      for (TetrioPlayerFromLeaderboard entry in leaderboard.leaderboard)
        if (excludeRanks.indexOf(entry.rank) == -1) _MyScatterSpot(
          entry.getStatByEnum(x).toDouble(),
          entry.getStatByEnum(y).toDouble(),
          entry.userId,
          entry.username,
          entry.rank,
          (rankColors[entry.rank]??Colors.white).withOpacity((searchLeague.isEmpty || entry.username.startsWith(searchLeague.toLowerCase())) ? 1.0 : 0.005)
        )
    ];
    return _spots;
  }

  bool? getTotalFilterValue(){
    if (excludeRanks.isEmpty) return true;
    if (excludeRanks.length == ranks.length) return false;
    return null;
  }

  Widget getHistoryGraph(){
   return FutureBuilder<Map<int, Map<Stats, List<_HistoryChartSpot>>>>(
    future: getHistoryData(fetchData),
    builder: (context, snapshot) {
      switch (snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
        if (snapshot.hasData){
          if (snapshot.data!.isEmpty || !snapshot.data!.containsKey(_season)) return ErrorThingy(eText: t.errors.notEnoughData);
          List<_HistoryChartSpot> selectedGraph = snapshot.data![_season]![Ychart]!;
          yAxisTitle = chartsShortTitles[Ychart]!;
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
      future: futureLeague,
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
                markerSettings: MarkerSettings(
                  isVisible: false,
                  borderColor: Colors.black,
                ),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                onPointTap: (point) => Navigator.push(context, MaterialPageRoute(builder: (context) => MainView(player: snapshot.data![point.pointIndex!].nickname))),
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
          yAxisTitle = chartsShortTitles[Ychart]!;
          return SfCartesianChart(
            tooltipBehavior: _leagueTooltipBehavior,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: const DateTimeAxis(),
            primaryYAxis: NumericAxis(
              // isInversed: true,
              maximum: switch (Ychart){
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
                yValueMapper: (Cutoffs data, _) => switch (Ychart){
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Wrap(
                    spacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      if (graph == Graph.leagueState && TLstatePlayers != null && TLrelevance != null) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                style: TextStyle(color: Colors.white, fontFamily: "Eurostile Round"),
                                children: [
                                  TextSpan(text: t.stats.players(n: TLstatePlayers!)),
                                  TextSpan(text: "\n"),
                                  TextSpan(text: timestamp(TLrelevance!))
                                ]
                              )
                            ),
                          )
                        ],
                      ),
                      if (graph == Graph.history) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ValueListenableBuilder<String>(
                              valueListenable: historyPlayerUsername,
                              builder: (context, value, child) {
                                return Text(value, style: TextStyle(fontSize: 22, fontFamily: "Eurostile Round Extended"));
                              },
                            )
                          ),
                        ],
                      ),
                      if (graph == Graph.leagueState) SizedBox(
                        width: 300,
                        child: TextField(
                          style: TextStyle(fontSize: 18.0000),
                          decoration: InputDecoration(
                            icon: Icon(Icons.search),
                            isDense: true
                          ),
                          onChanged: (v){
                            searchLeague = v;
                          },
                          onSubmitted: (v){
                            searchLeague = v;
                            setState((){futureLeague = getTetraLeagueData(_Xchart, Ychart);});
                          },
                        )
                      ),
                      if (graph == Graph.history) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text("${t.season}:", style: TextStyle(fontSize: 22))),
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
                      if (graph != Graph.leagueCutoffs) Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("X:", style: TextStyle(fontSize: 22))),
                          DropdownButton(
                            items: switch (graph){
                              Graph.history => [DropdownMenuItem(value: false, child: Text(t.graphsDestination.dateAndTime)), DropdownMenuItem(value: true, child: Text(t.stats.gp.full))],
                              Graph.leagueState => _yAxis,
                              Graph.leagueCutoffs => [],
                            },
                            value: graph == Graph.history ? _gamesPlayedInsteadOfDateAndTime :  _Xchart,
                            onChanged: (value) {
                              setState(() {
                                if (graph == Graph.history)
                                _gamesPlayedInsteadOfDateAndTime = value! as bool;
                                else{
                                  _Xchart = value! as Stats;
                                  setState((){futureLeague = getTetraLeagueData(_Xchart, Ychart);});
                                } 
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
                            items: graph == Graph.leagueCutoffs ? [DropdownMenuItem(value: Stats.tr, child: Text(chartsShortTitles[Stats.tr]!)), DropdownMenuItem(value: Stats.glicko, child: Text(chartsShortTitles[Stats.glicko]!)), DropdownMenuItem(value: Stats.gxe, child: Text(chartsShortTitles[Stats.gxe]!))] : _yAxis,
                            value: Ychart,
                            onChanged: (value) {
                              setState(() {
                                Ychart = value!;
                                futureLeague = getTetraLeagueData(_Xchart, Ychart);
                              });
                            }
                          ),
                        ],
                      ),
                      if (graph == Graph.history) Row(
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
                      if (graph == Graph.leagueState) IconButton(
                        color: excludeRanks.isNotEmpty ? Theme.of(context).colorScheme.primary : null,
                        onPressed: (){
                        showDialog(context: context, builder: (BuildContext context) {
                          return StatefulBuilder(
                          builder: (context, StateSetter setAlertState) {
                            return AlertDialog(
                              title: Text(t.graphsDestination.filterModaleTitle, textAlign: TextAlign.center),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    CheckboxListTile(value: getTotalFilterValue(), tristate: true, title: Text(t.filterModale.all, style: TextStyle(fontFamily: "Eurostile Round Extended")), onChanged: (value){
                                      setAlertState(
                                        (){
                                          if (excludeRanks.length*2 > ranks.length){
                                            excludeRanks.clear();
                                          }else{
                                            excludeRanks = List.of(ranks);
                                          }
                                        }
                                      );
                                    }),
                                    for(String rank in ranks.reversed) CheckboxListTile(value: excludeRanks.indexOf(rank) == -1, onChanged: (value){
                                      setAlertState(
                                        (){
                                          if (excludeRanks.indexOf(rank) == -1){
                                            excludeRanks.add(rank);
                                          }else{
                                            excludeRanks.remove(rank);
                                          }
                                        }
                                      );
                                    }, title: Text(rank.toUpperCase()),)
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(t.actions.cancel),
                                  onPressed: () {Navigator.of(context).pop();}
                                ),
                                TextButton(
                                  child: Text(t.actions.apply),
                                  onPressed: () {Navigator.of(context).pop(); setState((){futureLeague = getTetraLeagueData(_Xchart, Ychart);});}
                                )
                              ]
                            );
                          }
                        );
                        });
                      }, icon: Icon(Icons.filter_alt)),
                      IconButton(onPressed: () => _zoomPanBehavior.reset(), icon: const Icon(Icons.refresh), alignment: Alignment.center,)
                    ],
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - (widget.noSidebar ? 0 : 88),
                    height: MediaQuery.of(context).size.height - 96,
                    child: Padding( padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
                    child: switch (graph){
                      Graph.history => getHistoryGraph(),
                      Graph.leagueState => getLeagueState(),
                      Graph.leagueCutoffs => getCutoffsHistory()
                    },
                    )
                  ),
                )
              ],
            ),
          if (!widget.noSidebar) SegmentedButton<Graph>(
            showSelectedIcon: false,
            segments: <ButtonSegment<Graph>>[
              ButtonSegment<Graph>(
                value: Graph.history,
                label: Text(t.graphsNavigation.history)),
              ButtonSegment<Graph>(
                value: Graph.leagueState,
                label: Text(t.graphsNavigation.league)),
              ButtonSegment<Graph>(
                value: Graph.leagueCutoffs,
                label: Text(t.graphsNavigation.cutoffs),
              ),
            ],
            selected: <Graph>{graph},
            onSelectionChanged: (Set<Graph> newSelection) {
              setState(() {
                graph = newSelection.first;
                switch (newSelection.first){
                  case Graph.leagueCutoffs:
                  case Graph.history:
                    Ychart = Stats.tr;
                  case Graph.leagueState:
                    Ychart = Stats.apm;
                }
              });})
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

class _MyScatterSpot{
  num x;
  num y;
  String id;
  String nickname;
  String rank;
  Color color;
  _MyScatterSpot(this.x, this.y, this.id, this.nickname, this.rank, this.color);
}
