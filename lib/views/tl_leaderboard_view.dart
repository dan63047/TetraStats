import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/rank_averages_view.dart';
import 'package:tetra_stats/views/ranks_averages_view.dart';

final TetrioService teto = TetrioService();

class TLLeaderboardView extends StatefulWidget {
  const TLLeaderboardView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TLLeaderboardState();
}


class TLLeaderboardState extends State<TLLeaderboardView> {
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
              future: teto.fetchTLLeaderboard(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  return const Center(child: Text('Fetching...'));
                  case ConnectionState.done:
                    final allPlayers = snapshot.data?.leaderboard;
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                subtitle: Text(
                                    "${f2.format(allPlayers[index].apm)} APM, ${f2.format(allPlayers[index].pps)} PPS, ${f2.format(allPlayers[index].vs)} VS, ${f2.format(allPlayers[index].nerdStats.app)} APP, ${f2.format(allPlayers[index].nerdStats.vsapm)} VS/APM"),
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
