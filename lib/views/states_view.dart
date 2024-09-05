import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/mathes_view.dart';
import 'package:tetra_stats/views/state_view.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:window_manager/window_manager.dart';

class StatesView extends StatefulWidget {
  final String nickname;
  final String id;
  const StatesView({required this.nickname, required this.id, super.key});

  @override
  State<StatefulWidget> createState() => StatesState();
}

late String oldWindowTitle;

class StatesState extends State<StatesView> {
  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      //windowManager.setTitle("Tetra Stats: ${t.statesViewTitle(number: widget.states.length, nickname: widget.states.last.id.toUpperCase())}");
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(t.statesViewTitle(number: "", nickname: widget.nickname)),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchesView(userID: widget.id, username: widget.nickname),
                    ),
                  );
                }, icon: const Icon(Icons.list), tooltip: t.viewAllMatches)
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: FutureBuilder<List<TetraLeague>>(future: teto.getStates(widget.id), builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    prototypeItem: ListTile(
                      title: Text(""),
                      subtitle: Text("", style: TextStyle(color: Colors.grey)),
                      trailing: IconButton(icon: const Icon(Icons.delete_forever), onPressed: (){}),
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(timestamp(snapshot.data![index].timestamp)),
                        subtitle: Text(
                          t.statesViewEntry(level: f2.format(snapshot.data![index].tr), games: intf.format(snapshot.data![index].gamesPlayed), glicko: snapshot.data![index].glicko != null ? f2.format(snapshot.data![index].glicko) : "---", rd: snapshot.data![index].rd != null ? f2.format(snapshot.data![index].rd) : "--"),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever),
                          onPressed: () {
                              teto.deleteState(snapshot.data![index].id+snapshot.data![index].timestamp.millisecondsSinceEpoch.toRadixString(16)).then((value) => setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.stateRemoved(date: timestamp(snapshot.data![index].timestamp)))));
                            }));
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StateView(state: snapshot.data![index]),
                            ),
                          );
                        },
                      );
                    });
                } else if (snapshot.hasError) {
                  return Center(child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(snapshot.stackTrace.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 18), textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  );
                }
                break;
            }
            return const Center(child: Text('default case of FutureBuilder', style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center));
          }
          )));}
  }
