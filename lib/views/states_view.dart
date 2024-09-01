import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/views/mathes_view.dart';
import 'package:tetra_stats/views/state_view.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:window_manager/window_manager.dart';

class StatesView extends StatefulWidget {
  final List<TetrioPlayer> states;
  const StatesView({super.key, required this.states});

  @override
  State<StatefulWidget> createState() => StatesState();
}

late String oldWindowTitle;

class StatesState extends State<StatesView> {
  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.statesViewTitle(number: widget.states.length, nickname: widget.states.last.username.toUpperCase())}");
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
          title: Text(t.statesViewTitle(number: widget.states.length, nickname: widget.states.last.username.toUpperCase())),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchesView(userID: widget.states.first.userId, username: widget.states.first.username),
                        ),
                      );
                }, icon: const Icon(Icons.list), tooltip: t.viewAllMatches)
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: ListView.builder(
                itemCount: widget.states.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(timestamp(widget.states[index].state)),
                    subtitle: Text(t.statesViewEntry(level: widget.states[index].level.toStringAsFixed(2), gameTime: widget.states[index].gameTime, friends: widget.states[index].friendCount, rd: 0)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        DateTime nn = widget.states[index].state;
                        // teto.deleteState(widget.states[index]).then((value) => setState(() {
                        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.stateRemoved(date: timestamp(nn)))));
                        //     }));
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StateView(state: widget.states[index]),
                        ),
                      );
                    },
                  );
                })));
  }
}
