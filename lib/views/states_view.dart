import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
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
                    title: Text("On ${widget.states[index].state}"),
                    subtitle: Text("Level ${widget.states[index].level.toStringAsFixed(2)} level, ${widget.states[index].gameTime} of gametime"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {},
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
