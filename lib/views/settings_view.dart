import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsView> {
  PackageInfo _packageInfo = PackageInfo(appName: "TetraStats", packageName: "idk man", version: "some numbers", buildNumber: "anotherNumber");

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
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
                "They are not implemented yet. But its gonna be possible to change player for main view init, save logs, as well as import and export app sqlite database."),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: const Text("Very egg"),
            subtitle: const Text("very ass"),
            trailing: const Text("dan63047"),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Your username in TETR.IO", style: TextStyle(fontFamily: "Eurostile Round Extended")),
                      content: SingleChildScrollView(
                        child: ListBody(children: [const TextField()]),
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
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )),
          ),
          Divider(),
          ListTile(
            title: const Text("About app"),
            subtitle: Text("${_packageInfo.appName} (${_packageInfo.packageName}) Version ${_packageInfo.version} Build ${_packageInfo.buildNumber}"),
          ),
        ],
      )),
    );
  }
}
