import 'package:flutter/material.dart';

class CompareView extends StatefulWidget {
  const CompareView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("you vs someone"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: const [
          ListTile(
            title: Center(child: Text("So thats gonna be the main purpose of the app")),
            subtitle: Center(child: Text("We gonna look who is the best")),
            trailing: Text("Opponent value"),
            leading: Text("Your value"),
          )
        ],
      )),
    );
  }
}
