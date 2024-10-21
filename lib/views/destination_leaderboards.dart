import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/views/main_view_tiles.dart';
import 'package:tetra_stats/views/user_view.dart';

class DestinationLeaderboards extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationLeaderboards({super.key, required this.constraints});

  @override
  State<DestinationLeaderboards> createState() => _DestinationLeaderboardsState();
}

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
    Leaderboards.tl: "Tetra League (Current Season)",
    Leaderboards.fullTL: "Tetra League (Current Season, full one)",
    Leaderboards.xp: "XP",
    Leaderboards.ar: "Acievement Points",
    Leaderboards.sprint: "40 Lines",
    Leaderboards.blitz: "Blitz",
    Leaderboards.zenith: "Quick Play",
    Leaderboards.zenithex: "Quick Play Expert",
    };
  Leaderboards _currentLb = Leaderboards.tl;
  final StreamController<List<dynamic>> _dataStreamController = StreamController<List<dynamic>>.broadcast();
  late final ScrollController _scrollController;
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  List<dynamic> list = [];
  bool _isFetchingData = false;
  String? prisecter;
  List<DropdownMenuEntry> _countries = [for (MapEntry e in t.countries.entries) DropdownMenuEntry(value: e.key, label: e.value)];
  List<DropdownMenuEntry> _stats = [for (MapEntry e in chartsShortTitles.entries) DropdownMenuEntry(value: e.key, label: e.value)];
  String? _country;
  Stats stat = Stats.tr;

  Future<void> _fetchData() async {
    if (_isFetchingData) {
      // Avoid fetching new data while already fetching
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});

      final items = switch(_currentLb){
        Leaderboards.tl => await teto.fetchTetrioLeaderboard(prisecter: prisecter, country: _country),
        Leaderboards.fullTL => (await teto.fetchTLLeaderboard()).getStatRankingFromLB(stat, country: _country??""),
        Leaderboards.xp => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "xp", country: _country),
        Leaderboards.ar => await teto.fetchTetrioLeaderboard(prisecter: prisecter, lb: "ar", country: _country),
        Leaderboards.sprint => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, country: _country),
        Leaderboards.blitz => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "blitz_global", country: _country),
        Leaderboards.zenith => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenith_global", country: _country),
        Leaderboards.zenithex => await teto.fetchTetrioRecordsLeaderboard(prisecter: prisecter, lb: "zenithex_global", country: _country),
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

        if (currentScroll == maxScroll && _currentLb != Leaderboards.fullTL) {
          // When the last item is fully visible, load the next page.
          _fetchData();
        }
      });
    });
  }

  static TextStyle trailingStyle = TextStyle(fontSize: 28);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 350.0,
          height: widget.constraints.maxHeight,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text("Leaderboards", style: Theme.of(context).textTheme.headlineMedium),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboards.length,
                  itemBuilder: (BuildContext context, int index) { 
                    return Card(
                      surfaceTintColor: index == 1 ? Colors.redAccent : theme.colorScheme.primary,
                      child: ListTile(
                        title: Text(leaderboards.values.elementAt(index)),
                        subtitle: index == 1 ? Text("Heavy, but allows you to sort players by their stats", style: TextStyle(color: Colors.grey, fontSize: 12)) : null,
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
                          Text(leaderboards[_currentLb]!, style: Theme.of(context).textTheme.titleSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  setState((){_fetchData();});
                                })
                              )
                            ],
                          ),
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
                                    Leaderboards.fullTL => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("${f2.format(snapshot.data![index].tr)} TR", style: trailingStyle),
                                        Image.asset("res/tetrio_tl_alpha_ranks/${snapshot.data![index].rank}.png", height: 36)
                                      ],
                                    ),
                                    Leaderboards.xp => Text("LVL ${f2.format(snapshot.data![index].level)}", style: trailingStyle),
                                    Leaderboards.ar => Text("${intf.format(snapshot.data![index].ar)} AR", style: trailingStyle),
                                    Leaderboards.sprint => Text(get40lTime(snapshot.data![index].stats.finalTime.inMicroseconds), style: trailingStyle),
                                    Leaderboards.blitz => Text(intf.format(snapshot.data![index].stats.score), style: trailingStyle),
                                    Leaderboards.zenith => Text("${f2.format(snapshot.data![index].stats.zenith!.altitude)} m", style: trailingStyle),
                                    Leaderboards.zenithex => Text("${f2.format(snapshot.data![index].stats.zenith!.altitude)} m", style: trailingStyle)
                                  },
                                  subtitle: Text(switch (_currentLb){
                                    Leaderboards.tl => "${f2.format(snapshot.data![index].apm)} APM, ${f2.format(snapshot.data![index].pps)} PPS, ${f2.format(snapshot.data![index].vs)} VS, ${f2.format(snapshot.data![index].nerdStats.app)} APP, ${f2.format(snapshot.data![index].nerdStats.vsapm)} VS/APM",
                                    Leaderboards.fullTL => "${f2.format(snapshot.data![index].apm)} APM, ${f2.format(snapshot.data![index].pps)} PPS, ${f2.format(snapshot.data![index].vs)} VS, ${f2.format(snapshot.data![index].nerdStats.app)} APP, ${f2.format(snapshot.data![index].nerdStats.vsapm)} VS/APM",
                                    Leaderboards.xp => "${f2.format(snapshot.data![index].xp)} XP${snapshot.data![index].playtime.isNegative ? "" : ", ${playtime(snapshot.data![index].playtime)} of gametime"}",
                                    Leaderboards.ar => "${snapshot.data![index].ar_counts}",
                                    Leaderboards.sprint => "${intf.format(snapshot.data![index].stats.finesse.faults)} FF, ${f2.format(snapshot.data![index].stats.kpp)} KPP, ${f2.format(snapshot.data![index].stats.kps)} KPS, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${intf.format(snapshot.data![index].stats.piecesPlaced)} P",
                                    Leaderboards.blitz => "lvl ${snapshot.data![index].stats.level}, ${f2.format(snapshot.data![index].stats.pps)} PPS, ${f2.format(snapshot.data![index].stats.spp)} SPP",
                                    Leaderboards.zenith => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B",
                                    Leaderboards.zenithex => "${f2.format(snapshot.data![index].aggregateStats.apm)} APM, ${f2.format(snapshot.data![index].aggregateStats.pps)} PPS, ${intf.format(snapshot.data![index].stats.kills)} KO's, ${f2.format(snapshot.data![index].stats.cps)} climb speed (${f2.format(snapshot.data![index].stats.zenith!.peakrank)} peak), ${intf.format(snapshot.data![index].stats.topBtB)} B2B"
                                  }, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserView(searchFor: snapshot.data![index].userId),
                                        maintainState: false,
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
        ),
        ],
      );
  }
}
