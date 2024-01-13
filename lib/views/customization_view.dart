import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
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
  late SharedPreferences prefs;

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

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
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
        title: Text(t.settings),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(
              title: const Text("Accent Color"),
              trailing: ColorIndicator(HSVColor.fromColor(Theme.of(context).colorScheme.primary)),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                              // Use Material color picker:
                              //
                              // child: MaterialPicker(
                              //   pickerColor: pickerColor,
                              //   onColorChanged: changeColor,
                              //   showLabel: true, // only on portrait mode
                              // ),
                              //
                              // Use Block color picker:
                              //
                              // child: BlockPicker(
                              //   pickerColor: currentColor,
                              //   onColorChanged: changeColor,
                              // ),
                              //
                              // child: MultipleChoiceBlockPicker(
                              //   pickerColors: currentColors,
                              //   onColorsChanged: changeColors,
                              // ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  setState(() {
                                    setAccentColor(pickerColor);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]));
              }),
          const ListTile(
            title: Text("Font"),
            subtitle: Text("Not implemented"),
          ),
          const ListTile(
            title: Text("Stats Table in TL mathes list"),
            subtitle: Text("Not implemented"),
          ),
        ],
      )),
    );
  }
}
