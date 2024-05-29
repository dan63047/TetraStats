import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/main.dart' show packageInfo;
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:window_manager/window_manager.dart';

late String oldWindowTitle;

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsView> {
  late SharedPreferences prefs;
  final TetrioService teto = TetrioService();
  String defaultNickname = "Checking...";
  late bool showPositions;
  final TextEditingController _playertext = TextEditingController();

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
    showPositions = prefs.getBool("showPositions") ?? false;
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

  Future<void> _removePlayer() async {
    await prefs.remove('player');
    await _setDefaultNickname("6098518e3d5155e6ec429cdc");
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
            subtitle: Text(t.exportDBDescription, style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
            onTap: () {
              if (kIsWeb){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.notForWeb)));
              } else if (Platform.isAndroid){
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
              } else if (Platform.isLinux || Platform.isWindows) {
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
            },
          ),
          ListTile(
            title: Text(t.importDB),
            subtitle: Text(t.importDBDescription, style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
            onTap: () {
              if (kIsWeb){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.notForWeb)));
              }else if(Platform.isAndroid){
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
                          onPressed: () async {
                            if (_playertext.text.isEmpty) {
                              _removePlayer();
                              Navigator.of(context).pop();
                              return;
                            }
                            late TetrioPlayer user;
                            try{
                              user = await teto.fetchPlayer(_playertext.text.toLowerCase().trim());
                            }on Exception{
                              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.noSuchUser)));
                              return;
                            }                          
                            _setPlayer(user.userId);
                            if (context.mounted)  Navigator.of(context).pop();
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
          ListTile(title: Text(t.customization),
          subtitle: Text(t.customizationDescription, style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            context.go("/customization");
          },),
          ListTile(title: Text(t.lbStats),
          subtitle: Text(t.lbStatsDescription, style: const TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
          trailing: Switch(value: showPositions, onChanged: (bool value){
            prefs.setBool("showPositions", value);
            setState(() {
              showPositions = value;
            });
          }),),
          const Divider(),
          ListTile(
            onTap: (){
              launchInBrowser(Uri.https("github.com", "dan63047/TetraStats"));
            },
            title: Text(t.aboutApp, style: const TextStyle(fontWeight: FontWeight.w500),),
            subtitle: Text(t.aboutAppText(appName: packageInfo.appName, packageName: packageInfo.packageName, version: packageInfo.version, buildNumber: packageInfo.buildNumber)),
            trailing: const Icon(Icons.arrow_right)
          ),
        ],
      )),
    );
  }
}
