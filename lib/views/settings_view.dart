import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsView> {
  PackageInfo _packageInfo = PackageInfo(appName: "TetraStats", packageName: "idk man", version: "some numbers", buildNumber: "anotherNumber");
  late SharedPreferences prefs;
  final TextEditingController _playertext = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _getPreferences();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _setPlayer(String player) async {
    await prefs.setString('player', player);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(
            title: const Text("So there you gonna be able to change some settings"),
            subtitle: const Text(
                "Only \"Your TETR.IO account nickname or ID\" implemented yet. But its gonna be possible to change player for main view init, save logs, as well as import and export app sqlite database."),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: const Text("Your TETR.IO account nickname or ID"),
            subtitle:
                const Text("Every time when app loads, stats of that player will be fetched. Please prefer ID over nickname because nickname can be changed."),
            trailing: Text(prefs.getString("player") ?? "dan63047"),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Your TETR.IO account nickname or ID", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                      content: SingleChildScrollView(
                        child: ListBody(children: [TextField(controller: _playertext, maxLength: 25)]),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            _setPlayer(_playertext.text.toLowerCase().trim());
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        )
                      ],
                    )),
          ),
          const Divider(),
          ListTile(
            title: const Text("About app"),
            subtitle: Text("${_packageInfo.appName} (${_packageInfo.packageName}) Version ${_packageInfo.version} Build ${_packageInfo.buildNumber}"),
          ),
        ],
      )),
    );
  }
}
