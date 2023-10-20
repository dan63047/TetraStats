import 'dart:io';
import 'package:tetra_stats/main.dart' show accentColor;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:window_manager/window_manager.dart';

late String oldWindowTitle;

class CustomizationView extends StatefulWidget {
  const CustomizationView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomizationState();
}

class CustomizationState extends State<CustomizationView> {
  late SharedPreferences prefs;

  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.settings}");
    }
    _getPreferences();
    super.initState();
  }

  @override
  void dispose(){
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    List<DropdownMenuItem<AppLocale>>? locales = <DropdownMenuItem<AppLocale>>[];
    for (var v in AppLocale.values){
      locales.add(DropdownMenuItem<AppLocale>(
        value: v, child: Text(t.locales[v.languageTag]!)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(title: Text("Accent Color"),
          onTap: () {
            accentColor = Colors.cyanAccent;
            setState(() {});
          },),
          ListTile(title: Text("Font"),),
          ListTile(title: Text("Stats Table in TL mathes list"),),
        ],
      )),
    );
  }
}
