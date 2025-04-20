import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';
import 'package:tetra_stats/data_objects/tetrio_players_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/views/user_view.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class DestinationLeaderboards extends StatefulWidget{
  final BoxConstraints constraints;
  final bool noSidebar;

  const DestinationLeaderboards({super.key, required this.constraints, required this.noSidebar});

  @override
  State<DestinationLeaderboards> createState() => _DestinationLeaderboardsState();
}

const double transformThreshold = 768.0;

enum Leaderboards{
  tl,
  fullTL,
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
    Leaderboards.tl: t.leaderboardsDestination.tl,
    Leaderboards.fullTL: t.leaderboardsDestination.fullTL,
    Leaderboards.xp: t.stats.xp.full,
    Leaderboards.ar: t.leaderboardsDestination.ar,
    Leaderboards.sprint: t.gamemodes["40l"]!,
    Leaderboards.blitz: t.gamemodes["blitz"]!,
    Leaderboards.zenith: t.gamemodes["zenith"]!,
    Leaderboards.zenithex: t.gamemodes["zenithex"]!,
    };
  Leaderboards _currentLb = Leaderboards.tl;
  final StreamController<List<dynamic>> _dataStreamController = StreamController<List<dynamic>>.broadcast();
  late final ScrollController _scrollController;
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  List<dynamic> list = [];
  bool _isFetchingData = false;
  bool _reachedTheEnd = false;
  List<String> _excludeRanks = [];
  bool _reverse = false;
  String? prisecter;
  List<DropdownMenuEntry> _countries = [for (MapEntry e in t.countries.entries) DropdownMenuEntry(value: e.key, label: e.value)];
  List<DropdownMenuEntry> _stats = [for (MapEntry e in chartsShortTitles.entries) DropdownMenuEntry(value: e.key, label: e.value)];
  String? _country;
  Stats stat = Stats.tr;
  int? fullTLlbPlayers;
  DateTime? fullTLlbTimestamp;

  bool? getTotalFilterValue(){
    if (_excludeRanks.isEmpty) return true;
    if (_excludeRanks.length == ranks.length) return false;
    return null;
  }

  Future<void> _fetchData() async {
    if (_isFetchingData || _reachedTheEnd) {
      // Avoid fetching new data while already fetching
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});
      TetrioPlayersLeaderboard? fullLB;

      if (_currentLb == Leaderboards.fullTL){
        fullLB = await teto.fetchTLLeaderboard();
        fullTLlbPlayers = fullLB.leaderboard.length;
        fullTLlbTimestamp = fullLB.timestamp;
        _reachedTheEnd = true;
      } 

      final items = switch(_currentLb){
        Leaderboards.tl => await teto.fetchTetrioLeaderboard(prisecter: prisecter, country: _country),
        Leaderboards.fullTL => fullLB!.getStatRankingFromLB(stat, country: _country??""),
        Leaderboards.xp => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "xp", country: _country),
        Leaderboards.ar => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "ar", country: _country),
        Leaderboards.sprint => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, country: _country),
        Leaderboards.blitz => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "blitz", country: _country),
        Leaderboards.zenith => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenith", country: _country),
        Leaderboards.zenithex => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenithex", country: _country),
      };

      if (_currentLb == Leaderboards.fullTL && _excludeRanks.isNotEmpty) items.removeWhere((e) => _excludeRanks.indexOf((e as TetrioPlayerFromLeaderboard).rank) != -1);
      if (items.isEmpty) _reachedTheEnd = true;
      list.addAll((_reverse && _currentLb == Leaderboards.fullTL) ? items.reversed : items);
      if (items.isNotEmpty){
        _dataStreamController.add(list);
        prisecter = list.last.prisecter.toString();
      } else{
        _dataStreamController.add([]);
      }
      
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

        if (currentScroll == maxScroll && _currentLb != Leaderboards.fullTL) {
          // When the last item is fully visible, load the next page.
          _fetchData();
        }
      });
    });
  }

  Widget rightSide(double width){
    const double eukjsakjas = 450;
    TextStyle trailingStyle = TextStyle(fontSize: 28, fontFamily: width < eukjsakjas ? "Eurostile Round Condensed" : null);
    return SizedBox(
      width: width,
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
                      Text(leaderboards[_currentLb]!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          DropdownMenu(
                            leadingIcon: Icon(Icons.public),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                              ),
                              textStyle: TextStyle(fontSize: 14, height: 0.9),
                              dropdownMenuEntries: _countries,
                              initialSelection: "",
                              onSelected: ((value) {
                              _country = value as String?;
                              list.clear();
                              prisecter = null;
                              _isFetchingData = false;
                              _reachedTheEnd = false;
                              setState((){_fetchData();});
                            })
                          ),
                          if (_currentLb == Leaderboards.fullTL) SizedBox(width: 5.0),
                          if (_currentLb == Leaderboards.fullTL) DropdownMenu(
                            leadingIcon: Icon(Icons.sort),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                              ),
                              textStyle: TextStyle(fontSize: 14, height: 0.9),
                              dropdownMenuEntries: _stats,
                              initialSelection: stat,
                              onSelected: ((value) {
                              stat = value;
                              list.clear();
                              prisecter = null;
                              _isFetchingData = false;
                              _reachedTheEnd = false;
                              setState((){_fetchData();});
                            })
                          ),
                          if (_currentLb == Leaderboards.fullTL) IconButton(
                            color: _excludeRanks.isNotEmpty ? Theme.of(context).colorScheme.primary : null,
                            onPressed: () async {
                            await showDialog(context: context, builder: (BuildContext context) {
                              return StatefulBuilder(
                              builder: (context, StateSetter setAlertState) {
                                return AlertDialog(
                                  title: Text("Filter", textAlign: TextAlign.center),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CheckboxListTile(value: getTotalFilterValue(), tristate: true, title: Text("All", style: TextStyle(fontFamily: "Eurostile Round Extended")), onChanged: (value){
                                          setAlertState(
                                            (){
                                              if (_excludeRanks.length*2 > ranks.length){
                                                _excludeRanks.clear();
                                              }else{
                                                _excludeRanks = List.of(ranks);
                                              }
                                            }
                                          );
                                        }),
                                        for(String rank in ranks.reversed) CheckboxListTile(value: _excludeRanks.indexOf(rank) == -1, onChanged: (value){
                                          setAlertState(
                                            (){
                                              if (_excludeRanks.indexOf(rank) == -1){
                                                _excludeRanks.add(rank);
                                              }else{
                                                _excludeRanks.remove(rank);
                                              }
                                            }
                                          );
                                        }, title: Text(rank.toUpperCase()),)
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Apply"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                    )  
                                  ]
                                );
                              }
                            );
                            });
                            setState(() {
                              _currentLb = Leaderboards.fullTL;
                              list.clear();
                              prisecter = null;
                              _isFetchingData = false;
                              _reachedTheEnd = false;
                              _fetchData();
                            });
                          }, icon: Icon(Icons.filter_alt)),
                          if (_currentLb == Leaderboards.fullTL) IconButton(
                            color: _reverse ? Theme.of(context).colorScheme.primary : null,
                            icon: Transform.rotate(angle: _reverse ? pi : 0.0, child: Icon(Icons.filter_list)),
                            onPressed: (){
                              _reverse = !_reverse;
                              list.clear();
                              prisecter = null;
                              _isFetchingData = false;
                              _reachedTheEnd = false;
                              _fetchData();
                            },
                          )
                        ],
                      ),
                      if (_currentLb == Leaderboards.fullTL && fullTLlbPlayers != null && fullTLlbTimestamp != null) Text("${t.stats.players(n: fullTLlbPlayers!)} • ${t.sprintAndBlitsRelevance(date: timestamp(fullTLlbTimestamp!))}"),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: list.length,
                          prototypeItem: ListTile(
                            leading: Text("0"),
                            title: Text("ehhh...", style: TextStyle(fontSize: 22)),
                            trailing: SizedBox(height: 36, width: 1),
                            subtitle: const Text("eh...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(
                              leading: Text(intf.format(index+1)),
                              title: Text(snapshot.data![index].username, style: TextStyle(fontSize: 22)),
                              trailing: switch (_currentLb){
                                Leaderboards.tl => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${f2.format(snapshot.data![index].tr)} TR", style: trailingStyle),
                                    Image.asset("res/tetrio_tl_alpha_ranks/${snapshot.data![index].rank}.png", height: 36)
                                  ],
                                ),
                                Leaderboards.fullTL => switch (stat) {
                                  Stats.tr => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${f2.format(snapshot.data![index].tr)} TR", style: trailingStyle),
                                      Image.asset("res/tetrio_tl_alpha_ranks/${snapshot.data![index].rank}.png", height: 36)
                                    ],
                                  ),
                                  Stats.gp => Text("${intf.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle),
                                  Stats.gw => Text("${intf.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle),
                                  Stats.apm => Text("${f2.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle),
                                  Stats.pps => Text("${f2.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle),
                                  Stats.vs => Text("${f2.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle),
                                  _ => Text("${f4.format(snapshot.data![index].getStatByEnum(stat))} ${chartsShortTitles[stat]}", style: trailingStyle)
                                },
                                Leaderboards.xp => Text("LVL ${f2.format(snapshot.data![index].level)}", style: trailingStyle),
                                Leaderboards.ar => Text("${intf.format(snapshot.data![index].ar)} AR", style: trailingStyle),
                                Leaderboards.sprint => Text(getALittleBitMoreNormalTime(snapshot.data![index].stats.finalTime), style: trailingStyle),
                                Leaderboards.blitz => Text(intf.format(snapshot.data![index].stats.score), style: trailingStyle),
                                Leaderboards.zenith => Text("${f2.format(snapshot.data![index].stats.zenith!.altitude)} m", style: trailingStyle),
                                Leaderboards.zenithex => Text("${f2.format(snapshot.data![index].stats.zenith!.altitude)} m", style: trailingStyle)
                              },
                              subtitle: width >= eukjsakjas ? Text(switch (_currentLb){
                                Leaderboards.tl => "${f2.format(snapshot.data![index].apm)} APM, ${f2.format(snapshot.data![index].pps)} PPS, ${f2.format(snapshot.data![index].vs)} VS, ${f2.format(snapshot.data![index].nerdStats.app)} APP, ${f2.format(snapshot.data![index].nerdStats.vsapm)} VS/APM",
                                Leaderboards.fullTL => switch (stat) {
                                  Stats.tr => "${f2.format(snapshot.data![index].apm)} APM, ${f2.format(snapshot.data![index].pps)} PPS, ${f2.format(snapshot.data![index].vs)} VS, ${f2.format(snapshot.data![index].nerdStats.app)} APP, ${f2.format(snapshot.data![index].nerdStats.vsapm)} VS/APM",
                                  _ => "${f2.format(snapshot.data![index].tr)} TR, ${snapshot.data![index].rank.toUpperCase()} rank"
                                },
                                Leaderboards.xp => "${f2.format(snapshot.data![index].xp)} XP${snapshot.data![index].playtime.isNegative ? "" : ", ${playtime(snapshot.data![index].playtime)} of gametime"}",
                                Leaderboards.ar => "${snapshot.data![index].ar_counts}",
                                Leaderboards.sprint => "${snapshot.data?[index]?.stats?.finesse?.faults != null ? intf.format(snapshot.data![index].stats.finesse.faults) : "?"} FF, ${f2.format(snapshot.data![index].stats.kpp)} KPP, ${f2.format(snapshot.data![index].stats.kps)} KPS, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${intf.format(snapshot.data![index].stats.piecesPlaced)} P",
                                Leaderboards.blitz => "lvl ${snapshot.data![index].stats.level}, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${f2.format(snapshot.data![index].stats.spp)} SPP",
                                Leaderboards.zenith => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B",
                                Leaderboards.zenithex => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B"
                              }, style: TextStyle(color: Colors.grey, fontSize: 12)) : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserView(searchFor: snapshot.data![index].userId),
                                    
                                  ),
                                );
                              },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.constraints.maxWidth > transformThreshold ? 300.0 : widget.constraints.maxWidth,
          height: widget.constraints.maxHeight,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text(t.leaderboardsDestination.title, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 32)),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboards.length,
                  itemBuilder: (BuildContext context, int index) { 
                    return Card(
                      child: ListTile(
                        title: Text(leaderboards.values.elementAt(index)),
                        trailing: Icon(Icons.arrow_right, color: _currentLb.index == index ? Colors.white : Colors.grey),
                        subtitle: index == 1 ? Text(t.TLfullLBnote, style: TextStyle(color: Colors.grey, fontSize: 12)) : null,
                        onTap: () {
                          if (widget.constraints.maxWidth <= transformThreshold) Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                                floatingActionButton: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                                  child: FloatingActionButton(
                                    onPressed: () => Navigator.pop(context),
                                    tooltip: t.goBackButton,
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                ),
                                body: SafeArea(
                                  child: rightSide(widget.constraints.maxWidth)
                                  )
                                ),
                              
                            ),
                          );
                          _currentLb = leaderboards.keys.elementAt(index);
                          list.clear();
                          prisecter = null;
                          _reachedTheEnd = false;
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
        if (widget.constraints.maxWidth > transformThreshold) rightSide(widget.constraints.maxWidth - 300 - (widget.noSidebar ? 0 : 88)),
        ],
      );
  }
}
