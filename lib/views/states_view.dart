import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:tetra_stats/views/state_view.dart';

class StatesView extends StatefulWidget {
  final List<TetrioPlayer> states;
  const StatesView({Key? key, required this.states}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatesState();
}

final DateFormat dateFormat = DateFormat.yMMMd().add_Hms();

class StatesState extends State<StatesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.states.length} states of ${widget.states.last.username.toUpperCase()} account"),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: ListView.builder(
                itemCount: widget.states.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("On ${dateFormat.format(widget.states[index].state)}"),
                    subtitle: Text("Level ${widget.states[index].level.toStringAsFixed(2)}, ${widget.states[index].gameTime} of gametime, ${widget.states[index].friendCount} friends, ${NumberFormat.compact().format(widget.states[index].tlSeason1.rd)} RD"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        DateTime nn = widget.states[index].state;
                        teto.deleteState(widget.states[index]).then((value) => setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${dateFormat.format(nn)} state was removed from database!")));
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
