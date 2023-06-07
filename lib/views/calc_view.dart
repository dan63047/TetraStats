import 'package:flutter/material.dart';

class CalcView extends StatefulWidget {
  const CalcView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalcState();
}

class CalcState extends State<CalcView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats Calculator"),
      ),
      backgroundColor: Colors.black,
      body: const SafeArea(child: Text("Maybe next commit idk... or shoud i think about CRUD??? idk idk")),
    );
  }
}
