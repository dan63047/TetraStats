import 'package:flutter/material.dart';

class StatesView extends StatefulWidget {
  const StatesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatesState();
}

class StatesState extends State<StatesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("States of NICKNAME account"),
      ),
      backgroundColor: Colors.black,
      body: const SafeArea(
          child: Text(
              "So it's gonna be possible to store history of the account. One single piece of account history is what i call \"State\". In this view you will be able to control states, delete really old ones if too many.\n\nRight now app doesn't even store it.")),
    );
  }
}
