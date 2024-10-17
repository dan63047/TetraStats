import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetra_league_alpha_record.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/main_view_tiles.dart';
import 'package:tetra_stats/views/state_view.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class DestinationSavedData extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationSavedData({super.key, required this.constraints});

  @override
  State<DestinationSavedData> createState() => _DestinationSavedData();
}

class _DestinationSavedData extends State<DestinationSavedData> {
  String? selectedID;

  Future<(List<TetraLeague>, List<TetraLeague>, List<TetraLeagueAlphaRecord>)> getDataAbout(String id) async {
    return (await teto.getStates(id, season: currentSeason), await teto.getStates(id, season: 1), await teto.getTLMatchesbyPlayerID(id));
  }

  Widget getTetraLeagueListTile(TetraLeague data){
    return ListTile(
      title: Text("${timestamp(data.timestamp)}"),
      subtitle: Text("${f2.format(data.apm)} APM, ${f2.format(data.pps)} PPS, ${f2.format(data.vs)} VS, ${intf.format(data.gamesPlayed)} games", style: TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${f2.format(data.tr)} TR", style: TextStyle(fontSize: 28)),
          Image.asset("res/tetrio_tl_alpha_ranks/${data.rank}.png", height: 36)
        ],
      ),
      leading: IconButton(
        onPressed: () {
          teto.deleteState(data.id+data.timestamp.millisecondsSinceEpoch.toRadixString(16)).then((value) => setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.stateRemoved(date: timestamp(data.timestamp)))));
          }));
        },
        icon: Icon(Icons.delete_forever)
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StateView(state: data),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: teto.getAllPlayers(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          if (snapshot.hasError){ return FutureError(snapshot); }
          if (snapshot.hasData){
            return Row(
              children: [
                SizedBox(
                  width: 450,
                  child: Column(
                    children: [
                      const Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer(),
                            Text("Saved Data", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36)),
                            Spacer()
                          ],
                        ),
                      ),
                      for (String id in snapshot.data!.keys) Card(
                        child: ListTile(
                          title: Text(snapshot.data![id]!),
                          //subtitle: Text("NaN states, NaN TL records", style: TextStyle(color: Colors.grey)),
                          onTap: () => setState(() {
                            selectedID = id;
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: widget.constraints.maxWidth - 450 - 80,
                  child: selectedID != null ? FutureBuilder<(List<TetraLeague>, List<TetraLeague>, List<TetraLeagueAlphaRecord>)>(
                    future: getDataAbout(selectedID!),
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState){
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                        if (snapshot.hasError){ return FutureError(snapshot); }
                        if (snapshot.hasData){
                          return DefaultTabController(
                            length: 3,
                            child: Card(
                              child: Column(
                                children: [
                                  Card(
                                    child: TabBar(tabs: [
                                      Tab(text: "S${currentSeason} TL States"),
                                      Tab(text: "S1 TL States"),
                                      Tab(text: "TL Records")
                                    ]),
                                  ),
                                  SizedBox(
                                    height: widget.constraints.maxHeight - 64,
                                    child: TabBarView(children: [
                                      ListView.builder(
                                        itemCount: snapshot.data!.$1.length,
                                        itemBuilder: (context, index) {
                                        return getTetraLeagueListTile(snapshot.data!.$1[index]);
                                      },),
                                      ListView.builder(
                                        itemCount: snapshot.data!.$2.length,
                                        itemBuilder: (context, index) {
                                        return getTetraLeagueListTile(snapshot.data!.$2[index]);
                                      },),
                                      ListView.builder(
                                        itemCount: snapshot.data!.$3.length,
                                        itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(snapshot.data!.$3[index].toString()),
                                        );
                                      },),
                                      ]
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Text("what?");
                      }
                    }
                  ) : 
                  Text("Select nickname on the left to see data assosiated with it")
                )
              ],
            );
          }
        }
        return const Text("End of FutureBuilder<FetchResults>");
      },
    );
  }
}
