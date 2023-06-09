import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/views/states_view.dart';

final TetrioService teto = TetrioService();

class TrackedPlayersView extends StatefulWidget {
  const TrackedPlayersView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrackedPlayersState();
}

class TrackedPlayersState extends State<TrackedPlayersView> {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return Scaffold(
      appBar: AppBar(
        title: Text(t.trackedPlayersViewTitle),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: StreamBuilder(
              stream: teto.allPlayers,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(child: Text('none case of StreamBuilder'));
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    final allPlayers = (snapshot.data != null) ? snapshot.data as Map<String, List<TetrioPlayer>> : <String, List<TetrioPlayer>>{};
                    List<String> keys = allPlayers.keys.toList();
                    return NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          String howManyPlayers(int numberOfPlayers) => Intl.plural(
                                numberOfPlayers,
                                zero: t.trackedPlayersZeroEntrys,
                                one: t.trackedPlayersOneEntry,
                                other: t.trackedPlayersManyEntrys(numberOfPlayers: numberOfPlayers),
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
                            itemCount: allPlayers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(t.trackedPlayersEntry(nickname: allPlayers[keys[index]]!.last.username, numberOfStates: allPlayers[keys[index]]!.length)),
                                subtitle: Text(t.trackedPlayersDescription(firstStateDate: dateFormat.format(allPlayers[keys[index]]!.first.state), lastStateDate: dateFormat.format(allPlayers[keys[index]]!.last.state))),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    String nn = allPlayers[keys[index]]!.last.username;
                                    teto.deletePlayer(keys[index]);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.trackedPlayersStatesDeleted(nickname: nn))));
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatesView(states: allPlayers[keys[index]]!),
                                    ),
                                  );
                                },
                              );
                            }));
                  case ConnectionState.done:
                    return const Center(
                        child: Text('done case of StreamBuilder',
                            style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
                }
              })),
    );
  }
}
