import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsView> {
  PackageInfo _packageInfo = PackageInfo(
      appName: "TetraStats",
      packageName: "idk man",
      version: "some numbers",
      buildNumber: "anotherNumber");
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
    final t = Translations.of(context);
    List<DropdownMenuItem<AppLocale>>? locales = <DropdownMenuItem<AppLocale>>[];
    for (var v in AppLocale.values){
      locales.add(DropdownMenuItem<AppLocale>(
        value: v, child: Text(t.locales[v.languageTag]!)));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(
            title: const Text("Export local database"),
            subtitle: const Text(
                "It contains states and Tetra League records of the tracked players and list of tracked players."),
            onTap: () {
              if (Platform.isLinux || Platform.isWindows) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Desktop export",
                              style: TextStyle(
                                  fontFamily: "Eurostile Round Extended")),
                          content: const SingleChildScrollView(
                            child: ListBody(children: [
                              Text(
                                  "It seems like you using this app on desktop. Check your documents folder, you should find \"TetraStats.db\". Copy it somewhere")
                            ]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              }
              if (Platform.isAndroid){
                var downloadFolder = Directory("/storage/emulated/0/Download");
                File exportedDB = File("${downloadFolder.path}/TetraStats.db");
                getApplicationDocumentsDirectory().then((value) {
                  exportedDB.writeAsBytes(File("${value.path}/TetraStats.db").readAsBytesSync());
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Android export",
                              style: TextStyle(
                                  fontFamily: "Eurostile Round Extended")),
                          content: SingleChildScrollView(
                            child: ListBody(children: [Text("Exported.\n$exportedDB")]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
                });
              }
            },
          ),
          ListTile(
            title: const Text("Import local database"),
            subtitle: const Text("Restore your backup. Notice that already stored database will be overwritten."),
            onTap: () {
              if(Platform.isAndroid){
                FilePicker.platform.pickFiles(
                  type: FileType.any,
                ).then((value){
                if (value != null){
                  var newDB = value.paths[0]!;
                    teto.close().then((value){
                      if(!newDB.endsWith("db")){
                        return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong file type")));
                      }
                    getApplicationDocumentsDirectory().then((value){
                      var oldDB = File("${value.path}/TetraStats.db");
                      oldDB.writeAsBytes(File(newDB).readAsBytesSync(), flush: true).then((value){
                        teto.open();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Import successful")));
                      });
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Operation was cancelled")));
                }
              }); 
              }else{
               const XTypeGroup typeGroup = XTypeGroup(
                label: 'Tetra Stats Database',
                extensions: <String>['db'],
              );
              openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]).then((value){
                if (value != null){
                  var newDB = value.path;
                    teto.close().then((value){
                    getApplicationDocumentsDirectory().then((value){
                      var oldDB = File("${value.path}/TetraStats.db");
                      oldDB.writeAsBytes(File(newDB).readAsBytesSync()).then((value){
                        teto.open();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Import successful")));
                      });
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Operation was cancelled")));
                }
              }); 
              }
            },
          ),
          ListTile(
            title: const Text("Your TETR.IO account"),
            trailing: Text(defaultNickname),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Your TETR.IO account nickname or ID",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended")),
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
          ListTile(
            title: const Text("Language"),
            trailing: DropdownButton(
                items: locales,
                value: LocaleSettings.currentLocale,
                onChanged: (value) => LocaleSettings.setLocale(value!),
              ),
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
