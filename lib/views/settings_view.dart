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
        title: Text(t.settings),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView(
        children: [
          ListTile(
            title: Text(t.exportDB),
            subtitle: Text(t.exportDBDescription),
            onTap: () {
              if (Platform.isLinux || Platform.isWindows) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(t.desktopExportAlertTitle,
                              style: const TextStyle(
                                  fontFamily: "Eurostile Round Extended")),
                          content: SingleChildScrollView(
                            child: ListBody(children: [
                              Text(t.desktopExportText)
                            ]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(t.popupActions.ok),
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
                          title: Text(t.androidExportAlertTitle,
                              style: const TextStyle(
                                  fontFamily: "Eurostile Round Extended")),
                          content: SingleChildScrollView(
                            child: ListBody(children: [Text(t.androidExportText(exportedDB: exportedDB))]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(t.popupActions.ok),
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
            title: Text(t.importDB),
            subtitle: Text(t.importDBDescription),
            onTap: () {
              if(Platform.isAndroid){
                FilePicker.platform.pickFiles(
                  type: FileType.any,
                ).then((value){
                if (value != null){
                  var newDB = value.paths[0]!;
                    teto.close().then((value){
                      if(!newDB.endsWith("db")){
                        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.importWrongFileType)));
                      }
                    getApplicationDocumentsDirectory().then((value){
                      var oldDB = File("${value.path}/TetraStats.db");
                      oldDB.writeAsBytes(File(newDB).readAsBytesSync(), flush: true).then((value){
                        teto.open();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.importSuccess)));
                      });
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.importCancelled)));
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.importSuccess)));
                      });
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.importCancelled)));
                }
              }); 
              }
            },
          ),
          ListTile(
            title: Text(t.yourID),
            trailing: Text(defaultNickname),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(t.yourIDAlertTitle,
                          style: const TextStyle(
                              fontFamily: "Eurostile Round Extended")),
                      content: SingleChildScrollView(
                        child: ListBody(children: [
                          Text(t.yourIDText),
                          TextField(controller: _playertext, maxLength: 25)
                        ]),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(t.popupActions.cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(t.popupActions.submit),
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
            title: Text(t.language),
            trailing: DropdownButton(
                items: locales,
                value: LocaleSettings.currentLocale,
                onChanged: (value){
                  LocaleSettings.setLocale(value!);
                  if(value.languageCode == Platform.localeName.substring(0, 2)){
                    prefs.remove('locale');
                  }else{
                    prefs.setString('locale', value.languageCode);
                  }
                },
              ),
          ),
          const Divider(),
          ListTile(
            title: Text(t.aboutApp),
            subtitle: Text(t.aboutAppText(appName: _packageInfo.appName, packageName: _packageInfo.packageName, version: _packageInfo.version, buildNumber: _packageInfo.buildNumber)),
          ),
        ],
      )),
    );
  }
}
