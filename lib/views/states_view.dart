import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:tetra_stats/views/state_view.dart';

class StatesView extends StatefulWidget {
  final List<TetrioPlayer> states;
  const StatesView({Key? key, required this.states}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatesState();
}

class StatesState extends State<StatesView> {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return Scaffold(
        appBar: AppBar(
          title: Text(t.statesViewTitle(number: widget.states.length, nickname: widget.states.last.username.toUpperCase())),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: ListView.builder(
                itemCount: widget.states.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dateFormat.format(widget.states[index].state)),
                    subtitle: Text(t.statesViewEntry(level: widget.states[index].level.toStringAsFixed(2), gameTime: widget.states[index].gameTime, friends: widget.states[index].friendCount, rd: NumberFormat.compact().format(widget.states[index].tlSeason1.rd))),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        DateTime nn = widget.states[index].state;
                        teto.deleteState(widget.states[index]).then((value) => setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.stateRemoved(date: dateFormat.format(nn)))));
                            }));
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
