import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/rank_averages_view.dart';
import 'package:tetra_stats/views/ranks_averages_view.dart';
import 'package:window_manager/window_manager.dart';

final TetrioService _teto = TetrioService();
List<DropdownMenuItem> _itemStats = [for (MapEntry e in chartsShortTitles.entries) DropdownMenuItem(value: e.key, child: Text(e.value))];
Stats _sortBy = Stats.tr;
bool reversed = false;
List<DropdownMenuItem> _itemCountries = [for (MapEntry e in t.countries.entries) DropdownMenuItem(value: e.key, child: Text(e.value))];
String _country = "";
late String _oldWindowTitle;
final NumberFormat _f4 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 4);

class TLLeaderboardView extends StatefulWidget {
  const TLLeaderboardView({super.key});

  @override
  State<StatefulWidget> createState() => TLLeaderboardState();
}

class TLLeaderboardState extends State<TLLeaderboardView> {
  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.getTitle().then((value) => _oldWindowTitle = value);
    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(_oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final NumberFormat f2 = NumberFormat.decimalPattern(LocaleSettings.currentLocale.languageCode)..maximumFractionDigits = 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tlLeaderboard),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RankAveragesView(),
                  maintainState: false,
                ),
              );
            },
            icon: const Icon(Icons.compress),
            tooltip: t.averages,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: FutureBuilder(
              future: _teto.fetchTLLeaderboard(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    final allPlayers = snapshot.data?.getStatRanking(snapshot.data!.leaderboard, _sortBy, reversed: reversed, country: _country);
                    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle("Tetra Stats: ${t.tlLeaderboard} - ${t.players(n: allPlayers!.length)}");
                    return NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          String howManyPlayers(int numberOfPlayers) => Intl.plural(
                                numberOfPlayers,
                                zero: t.lbViewZeroEntrys,
                                one: t.lbViewOneEntry,
                                other: t.lbViewManyEntrys(numberOfPlayers: t.players(n: numberOfPlayers)),
                                name: 'howManyPeople',
                                args: [numberOfPlayers],
                                desc: 'Description of how many people are seen in a place.',
                                examples: const {'numberOfPeople': 3},
                              );
                          return [
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                Text(
                                howManyPlayers(allPlayers.length),
                                style: const TextStyle(color: Colors.white, fontSize: 25),
                              ),
                              TextButton(onPressed: (){
                                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankView(rank: snapshot.data!.getAverageOfRank("")),
                        ),
                      );
                              }, child: Text(t.everyoneAverages,
                                style: const TextStyle(fontSize: 25)))
                              ],) 
                            )),
                            SliverToBoxAdapter(child: Padding(
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
                                      Text("${t.sortBy}: ",
                                      style: const TextStyle(color: Colors.white, fontSize: 25)),
                                      DropdownButton(items: _itemStats, value: _sortBy, onChanged: ((value) {
                                        _sortBy = value;
                                        setState(() {});
                                      }),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text("${t.reversed}: ",
                                      style: const TextStyle(color: Colors.white, fontSize: 25)),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 5.5, 0, 7.5),
                                        child: Checkbox(value: reversed,
                                        checkColor: Colors.black,
                                        onChanged: ((value) {
                                          reversed = value!;
                                          setState(() {});
                                        }),),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text("${t.country}: ",
                                      style: const TextStyle(color: Colors.white, fontSize: 25)),
                                      DropdownButton(items: _itemCountries, value: _country, onChanged: ((value) {
                                        _country = value;
                                        setState(() {});
                                      }),),
                                    ],
                                  ),
                                ],
                              ),
                            ),),
                            const SliverToBoxAdapter(child: Divider())
                          ];
                        },
                        body: ListView.builder(
                            itemCount: allPlayers!.length,
                            itemBuilder: (context, index) {
                              bool bigScreen = MediaQuery.of(context).size.width > 768;
                              return ListTile(
                                leading: Text((index+1).toString(), style: bigScreen ? const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28) : null),
                                title: Text(allPlayers[index].username, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                subtitle: Text(_sortBy == Stats.tr ? "${f2.format(allPlayers[index].apm)} APM, ${f2.format(allPlayers[index].pps)} PPS, ${f2.format(allPlayers[index].vs)} VS, ${f2.format(allPlayers[index].nerdStats.app)} APP, ${f2.format(allPlayers[index].nerdStats.vsapm)} VS/APM" : "${_f4.format(allPlayers[index].getStatByEnum(_sortBy))} ${chartsShortTitles[_sortBy]}",
                                style: TextStyle(fontFamily: "Eurostile Round Condensed", color: _sortBy == Stats.tr ? Colors.grey : null)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${f2.format(allPlayers[index].rating)} TR", style: bigScreen ? const TextStyle(fontSize: 28) : null),
                                    Image.asset("res/tetrio_tl_alpha_ranks/${allPlayers[index].rank}.png", height: bigScreen ? 48 : 16),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainView(player: allPlayers[index].userId),
                                      maintainState: false,
                                    ),
                                  );
                                },
                              );
                            }));
                }
              })),
    );
  }
}
