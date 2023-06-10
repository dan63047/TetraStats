import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stored data"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: StreamBuilder(
              stream: teto.allPlayers,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: Text('none case of StreamBuilder'));
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    final allPlayers = (snapshot.data != null) ? snapshot.data as Map<String, List<TetrioPlayer>> : <String, List<TetrioPlayer>>{};
                    List<String> keys = allPlayers.keys.toList();
                    print(allPlayers.toString());
                    return NestedScrollView(
                        headerSliverBuilder: (context, value) {
                          return [
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                'There are ${allPlayers.length} players',
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            )),
                            const SliverToBoxAdapter(child: Divider())
                          ];
                        },
                        body: ListView.builder(
                            itemCount: allPlayers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text("${allPlayers[keys[index]]?.last.username}: ${allPlayers[keys[index]]?.length} states"),
                                subtitle: Text("From ${allPlayers[keys[index]]?.first.state} until ${allPlayers[keys[index]]?.last.state}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {},
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
                    return Center(
                        child: Text('done case of StreamBuilder',
                            style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
                }
              })),
    );
  }
}
