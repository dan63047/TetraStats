import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsView> {
  PackageInfo _packageInfo = PackageInfo(appName: "TetraStats", packageName: "idk man", version: "some numbers", buildNumber: "anotherNumber");
  late SharedPreferences prefs;
  final TetrioService teto = TetrioService();
  String defaultNickname = "Checking...";
  final TextEditingController _playertext = TextEditingController();

  @override
  void initState() {
    _initPackageInfo();
    _getPreferences();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _setDefaultNickname(prefs.getString("player"));
  }

  Future<void> _setDefaultNickname(String? n) async {
    if (n != null) {
      try {
        defaultNickname = await teto.getNicknameByID(n);
      } on TetrioPlayerNotExist {
        defaultNickname = n;
      }
    } else {
      defaultNickname = "dan63047";
    }
    setState(() {});
  }

  Future<void> _setPlayer(String player) async {
    await prefs.setString('player', player);
    await _setDefaultNickname(player);
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
            subtitle: const Text("Only \"Your TETR.IO account\" implemented yet. In the future you will able to import and export app sqlite database."),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: const Text("Your TETR.IO account"),
            trailing: Text(defaultNickname),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Your TETR.IO account nickname or ID", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                      content: SingleChildScrollView(
                        child: ListBody(children: [
                          const Text(
                              "Every time when app loads, stats of that player will be fetched. Please prefer ID over nickname because nickname can be changed."),
                          TextField(controller: _playertext, maxLength: 25)
                        ]),
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
            subtitle: Text("""
${_packageInfo.appName} (${_packageInfo.packageName}) Version ${_packageInfo.version} Build ${_packageInfo.buildNumber}

Developed by dan63047
Formulas provided by kerrmunism
"""),
          ),
        ],
      )),
    );
  }
}
