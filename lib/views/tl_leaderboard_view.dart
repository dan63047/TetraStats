import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/views/states_view.dart';

final TetrioService teto = TetrioService();

class TLLeaderboardView extends StatefulWidget {
  const TLLeaderboardView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TLLeaderboardState();
}

final DateFormat dateFormat = DateFormat.yMMMd().add_Hms();
final NumberFormat f2 = NumberFormat.decimalPatternDigits(decimalDigits: 2);

class TLLeaderboardState extends State<TLLeaderboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tetra League Leaderboard"),
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
                                zero: 'Empty list. Press "Track" button in previous view to add current player here',
                                one: 'There is only one player',
                                other: 'There are $numberOfPlayers players',
                                name: 'howManyPeople',
                                args: [numberOfPlayers],
                                desc: 'Description of how many people are seen in a place.',
                                examples: const {'numberOfPeople': 3},
                              );
                          return [
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                howManyPlayers(allPlayers.length),
                                style: const TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            )),
                            const SliverToBoxAdapter(child: Divider())
                          ];
                        },
                        body: ListView.builder(
                            itemCount: allPlayers!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Text((index+1).toString(), style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                                title: Text("${allPlayers[index].username}", style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                subtitle: Text(
                                    "${f2.format(allPlayers[index].apm)} APM, ${f2.format(allPlayers[index].pps)} PPS, ${f2.format(allPlayers[index].vs)} VS, ${f2.format(allPlayers[index].app)} APP, ${f2.format(allPlayers[index].vsapm)} VS/APM"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${f2.format(allPlayers[index].rating)} TR", style: const TextStyle(fontSize: 28)),
                                    Image.asset("res/tetrio_tl_alpha_ranks/${allPlayers[index].rank}.png", height: 48),
                                  ],
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => StatesView(states: allPlayers!),
                                  //   ),
                                  // );
                                },
                              );
                            }));
                }
              })),
    );
  }
}
