import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/views/settings_view.dart' show subtitleStyle;
import 'package:tetra_stats/main.dart' show prefs;
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:window_manager/window_manager.dart';

late String oldWindowTitle;
Color pickerColor = Colors.cyanAccent;
Color currentColor = Colors.cyanAccent;

class CustomizationView extends StatefulWidget {
  const CustomizationView({super.key});

  @override
  State<StatefulWidget> createState() => CustomizationState();
}

class CustomizationState extends State<CustomizationView> {
  late bool oskKagariGimmick;
  late bool sheetbotRadarGraphs;
  late int ratingMode;
  late int timestampMode;

  void changeColor(Color color) {
  setState(() => pickerColor = color);
  }

  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.settings}");
    }
    _getPreferences();
    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void _getPreferences() {
    if (prefs.getBool("oskKagariGimmick") != null) {
      oskKagariGimmick = prefs.getBool("oskKagariGimmick")!;
    } else {
      oskKagariGimmick = true;
    }
    if (prefs.getBool("sheetbotRadarGraphs") != null) {
      sheetbotRadarGraphs = prefs.getBool("sheetbotRadarGraphs")!;
    } else {
      sheetbotRadarGraphs = false;
    }
    if (prefs.getInt("ratingMode") != null) {
      ratingMode = prefs.getInt("ratingMode")!;
    } else {
      ratingMode = 0;
    }
    if (prefs.getInt("timestampMode") != null) {
      timestampMode = prefs.getInt("timestampMode")!;
    } else {
      timestampMode = 0;
    }
  }

  ThemeData getTheme(BuildContext context, Color color){
    return Theme.of(context).copyWith(colorScheme: ColorScheme.dark(primary: color, secondary: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    List<DropdownMenuItem<AppLocale>>? locales =
        <DropdownMenuItem<AppLocale>>[];
    for (var v in AppLocale.values) {
      locales.add(DropdownMenuItem<AppLocale>(
          value: v, child: Text(t.locales[v.languageTag]!)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(t.customization),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          // ListTile(
          //     title: const Text("Accent color"),
          //     trailing: ColorIndicator(HSVColor.fromColor(Theme.of(context).colorScheme.primary)),
          //     onTap: () {
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) => AlertDialog(
          //                   title: const Text('Pick an accent color'),
          //                   content: SingleChildScrollView(
          //                     child: ColorPicker(
          //                       pickerColor: pickerColor,
          //                       onColorChanged: changeColor,
          //                     ),
          //                   ),
          //                   actions: <Widget>[
          //                     ElevatedButton(
          //                       child: const Text('Set'),
          //                       onPressed: () {
          //                         setState(() {
          //                           setAccentColor(pickerColor);
          //                         });
          //                         Navigator.of(context).pop();
          //                       },
          //                     ),
          //                   ]));
          //     }),
          // const ListTile(
          //   title: Text("Font"),
          //   subtitle: Text("Not implemented"),
          // ),
          // const ListTile(
          //   title: Text("Stats Table in TL mathes list"),
          //   subtitle: Text("Not implemented"),
          // ),
           ListTile(title: Text(t.oskKagari),
          subtitle: Text(t.oskKagariDescription, style: subtitleStyle),
          trailing: Switch(value: oskKagariGimmick, onChanged: (bool value){
            prefs.setBool("oskKagariGimmick", value);
            setState(() {
              oskKagariGimmick = value;
            });
          }),),
          ListTile(title: Text("Timestamps"),
          subtitle: Text(t.oskKagariDescription, style: subtitleStyle),
          trailing: DropdownButton(
            value: timestampMode,
            items: <DropdownMenuItem>[
              DropdownMenuItem(value: 0, child: Text("Absolute (GMT)")),
              DropdownMenuItem(value: 1, child: Text("Absolute (Local Time)")),
              DropdownMenuItem(value: 2, child: Text("Relative"))
            ],
            onChanged: (dynamic value){
              prefs.setInt("timestampMode", value);
              setState(() {
                timestampMode = value;
              });
            },
          ),
          ),
          ListTile(title: Text("Main representation of rating"),
          subtitle: Text(t.oskKagariDescription, style: subtitleStyle),
          trailing: DropdownButton(
            value: ratingMode,
            items: <DropdownMenuItem>[
              DropdownMenuItem(value: 0, child: Text("TR")),
              DropdownMenuItem(value: 1, child: Text("Glicko")),
              DropdownMenuItem(value: 2, child: Text("LB position"))
            ],
            onChanged: (dynamic value){
              prefs.setInt("ratingMode", value);
              setState(() {
                ratingMode = value;
              });
            },
          ),
          ),
          ListTile(title: Text("Sheetbot-like behavior for radar graphs"),
          subtitle: Text(t.oskKagariDescription, style: subtitleStyle),
          trailing: Switch(value: sheetbotRadarGraphs, onChanged: (bool value){
            prefs.setBool("sheetbotRadarGraphs", value);
            setState(() {
              sheetbotRadarGraphs = value;
            });
          }),)
        ],
      )),
    );
  }
}
