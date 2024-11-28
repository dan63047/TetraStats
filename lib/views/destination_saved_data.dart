import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetra_league_alpha_record.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/state_view.dart';
import 'package:tetra_stats/widgets/alpha_league_entry_thingy.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/info_thingy.dart';
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
      subtitle: Text("${data.apm != null ? f2.format(data.apm) : "-.--"} APM, ${data.pps != null ? f2.format(data.pps) : "-.--"} PPS, ${data.vs != null ? f2.format(data.vs) : "-.--"} VS, ${intf.format(data.gamesPlayed)} games", style: TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${data.tr != -1.00 ? f2.format(data.tr) : "-.--"} TR", style: TextStyle(fontSize: 28)),
          Image.asset("res/tetrio_tl_alpha_ranks/${data.rank}.png", height: 36)
        ],
      ),
      leading: IconButton(
        onPressed: () {
          teto.deleteState(data.id+data.timestamp.millisecondsSinceEpoch.toRadixString(16)).then((value) => setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.stateRemoved(date: timestamp(data.timestamp)))));
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

  Widget rightSide(double width, bool hasSidebar){
    return SizedBox(
      width: width - (hasSidebar ? 80.0 : 0.00),
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
                        child: TabBar(
                          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 28),
                          labelColor: Theme.of(context).colorScheme.primary,
                          tabs: [
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
                            return AlphaLeagueEntryThingy(snapshot.data!.$3[index], selectedID!);
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
      InfoThingy("Select nickname on the left to see data assosiated with it")
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
                  width: widget.constraints.maxWidth > 900.0 ? 350 : widget.constraints.maxWidth - (widget.constraints.maxWidth <= 768.0 ? 0 : 80),
                  child: Column(
                    children: [
                      Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer(),
                            Text("Saved Data", style: Theme.of(context).textTheme.headlineMedium),
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
                            if (widget.constraints.maxWidth <= 900.0) Navigator.push(
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
                                  child: rightSide(widget.constraints.maxWidth, false)
                                  )
                                ),
                              
                            ),
                          );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                if (widget.constraints.maxWidth > 900.0) rightSide(widget.constraints.maxWidth - 350, true)
              ],
            );
          }
        }
        return const Text("End of FutureBuilder<FetchResults>");
      },
    );
  }
}
