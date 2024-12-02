import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/filesizes_converter.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/widgets/future_error.dart';

class DestinationSettings extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationSettings({super.key, required this.constraints});

  @override
  State<DestinationSettings> createState() => _DestinationSettings();
}

enum SettingsCardMod{
  general,
  customization,
  database
}

Map<SettingsCardMod, String> settingsCardTitles = {
  SettingsCardMod.general: t.settingsDestination.general,
  SettingsCardMod.customization: t.settingsDestination.customization,
  SettingsCardMod.database: t.settingsDestination.database
};
const EdgeInsets descriptionPadding = EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0);

class _DestinationSettings extends State<DestinationSettings> with SingleTickerProviderStateMixin {
  SettingsCardMod mod = SettingsCardMod.general;
  List<DropdownMenuItem<AppLocale>> locales = <DropdownMenuItem<AppLocale>>[];
  String defaultNickname = t.settingsDestination.checking;
  String defaultID = "";
  Color pickerColor = Colors.cyanAccent;
  Color currentColor = Colors.cyanAccent;
  late bool oskKagariGimmick;
  late bool sheetbotRadarGraphs;
  late int ratingMode;
  late int timestampMode;
  late bool showPositions;
  late bool showAverages;
  late bool updateInBG;
  late AnimationController _defaultNicknameAnimController;
  late Animation _goodDefaultNicknameAnim;
  late Animation _badDefaultNicknameAnim;
  late Animation _defaultNicknameAnim = _goodDefaultNicknameAnim;
  double helperTextOpacity = 0;
  String helperText = t.settingsDestination.enterToSubmit;

  @override
  void initState() {
    // if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
    //   windowManager.getTitle().then((value) => oldWindowTitle = value);
    //   windowManager.setTitle("Tetra Stats: ${t.settings}");
    // }
    _defaultNicknameAnimController = AnimationController(
      value: 1.0,
      duration: Durations.extralong4,
      vsync: this,
    );
    _goodDefaultNicknameAnim = new ColorTween(
      begin: Colors.greenAccent,
      end: Colors.grey,
    ).animate(new CurvedAnimation(
      parent: _defaultNicknameAnimController,
      curve: Easing.emphasizedAccelerate,
      //reverseCurve: Cubic(0,.99,.99,1.01)
    ))..addStatusListener((status) {
      if (status.index == 3) setState((){helperText = t.settingsDestination.enterToSubmit; helperTextOpacity = 0;});
    });
    _badDefaultNicknameAnim = new ColorTween(
      begin: Colors.redAccent,
      end: Colors.grey,
    ).animate(new CurvedAnimation(
      parent: _defaultNicknameAnimController,
      curve: Easing.emphasizedAccelerate,
      //reverseCurve: Cubic(0,.99,.99,1.01)
    ))..addStatusListener((status) {
      if (status.index == 3) setState((){helperText = t.settingsDestination.enterToSubmit; helperTextOpacity = 0;});
    });
    _getPreferences();
    super.initState();
  }

  @override
  void dispose(){
    // if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void changeColor(Color color) {
  setState(() => pickerColor = color);
  }

  void _getPreferences() {
    showPositions = prefs.getBool("showPositions") ?? false;
    showAverages = prefs.getBool("showAverages") ?? true;
    updateInBG = prefs.getBool("updateInBG") ?? false;
    oskKagariGimmick = prefs.getBool("oskKagariGimmick") ?? true;
    sheetbotRadarGraphs = prefs.getBool("sheetbotRadarGraphs")?? false;
    ratingMode = prefs.getInt("ratingMode") ?? 0;
    timestampMode = prefs.getInt("timestampMode") ?? 0;
    _setDefaultNickname(prefs.getString("player")??"").then((v){setState((){});});
    defaultID = prefs.getString("playerID")??"";
  }

  Future<bool> _setDefaultNickname(String n) async {
    if (n.isNotEmpty) {
      try {
        if (n.length > 16){
          defaultNickname = await teto.getNicknameByID(n);
          await prefs.setString('playerID', n);
        }else{
          TetrioPlayer player = await teto.fetchPlayer(n);
          defaultNickname = player.username;
          await prefs.setString('playerID', player.userId);
        }
        await prefs.setString('player', defaultNickname);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      defaultNickname = "dan63";
      await prefs.setString('player', "dan63");
      await prefs.setString('playerID', "6098518e3d5155e6ec429cdc");
      return true;
    }
    //setState(() {});
  }

  Widget getGeneralSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text(t.settingsDestination.general, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          )),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.account, style: Theme.of(context).textTheme.displayLarge),
                trailing: SizedBox(width: 150.0, child: AnimatedBuilder(
                  animation: _defaultNicknameAnim,
                  builder: (context, child) {
                    return Focus(
                      onFocusChange: (value) {
                        setState((){helperTextOpacity = ((value || helperText != t.settingsDestination.enterToSubmit)) ? 1 : 0;});
                      },
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: defaultNickname,
                          helper: AnimatedOpacity(
                            opacity: helperTextOpacity,
                            duration: Durations.long1,
                            curve: Easing.standardDecelerate,
                            child: Text(helperText, style: TextStyle(color: _defaultNicknameAnim.value, height: 0.2))
                          ),
                        ),
                        onSubmitted: (value) {
                          helperText = t.settingsDestination.checking;
                          _setDefaultNickname(value).then((v) {
                            _defaultNicknameAnim = v ? _goodDefaultNicknameAnim : _badDefaultNicknameAnim;
                            _defaultNicknameAnimController.forward(from: 0);
                            setState((){ helperText = v ? t.settingsDestination.done : t.settingsDestination.noSuchAccount;});
                          });
                        },
                      ),
                    );
                  },
                )),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.accountDescription),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Language", style: Theme.of(context).textTheme.displayLarge),
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
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.languageDescription(languages: t.settingsDestination.languages(n: locales.length))),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.updateInTheBackground, style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: updateInBG, onChanged: (bool value){
                prefs.setBool("updateInBG", value);
                setState(() {
                  updateInBG = value;
                });
                })
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.updateInTheBackgroundDescription),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.compareStats, style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: showAverages, onChanged: (bool value){
                  prefs.setBool("showAverages", value);
                  setState(() {
                    showAverages = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.compareStatsDescription),
              )
            ],
          ),
        ),
        Card(
          surfaceTintColor: Colors.redAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.showPosition, style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: showPositions, onChanged: (bool value){
                  prefs.setBool("showPositions", value);
                  setState(() {
                    showPositions = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.showPositionDescription),
              )
            ],
          ),
        )
      ]
    );
  }

  Widget getCustomizationSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text(t.settingsDestination.customization, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          )),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.accentColor, style: Theme.of(context).textTheme.displayLarge),
                trailing: ColorIndicator(HSVColor.fromColor(Theme.of(context).colorScheme.primary), width: 25, height: 25),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                    title: Text(t.settingsDestination.accentColorModale),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text(t.actions.apply),
                        onPressed: () {
                          setState(() {
                            context.findAncestorStateOfType<MyAppState>()?.setAccentColor(pickerColor);
                            prefs.setInt("accentColor", pickerColor.value);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ]));
            }
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.accentColorDescription),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(t.settingsDestination.timestamps, style: Theme.of(context).textTheme.displayLarge),
                trailing:  DropdownButton(
                  value: timestampMode,
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(value: 0, child: Text(t.settingsDestination.timestampsAbsoluteGMT)),
                    DropdownMenuItem(value: 1, child: Text(t.settingsDestination.timestampsAbsoluteLocalTime)),
                    DropdownMenuItem(value: 2, child: Text(t.settingsDestination.timestampsRelative))
                  ],
                  onChanged: (dynamic value){
                    prefs.setInt("timestampMode", value);
                    setState(() {
                      timestampMode = value;
                    });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.timestampsDescriptionPart1(d: DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms().format(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19)))),
              ),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.timestampsDescriptionPart2(y: DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms().format(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19).toLocal()), r: relativeDateTime(DateTime.utc(2023, DateTime.july, 20, 21, 03, 19)))),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.sheetbotLikeGraphs, style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: sheetbotRadarGraphs, onChanged: (bool value){
                  prefs.setBool("sheetbotRadarGraphs", value);
                  setState(() {
                    sheetbotRadarGraphs = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.sheetbotLikeGraphsDescription),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.settingsDestination.oskKagariGimmick, style: Theme.of(context).textTheme.displayLarge),
                trailing: Switch(value: oskKagariGimmick, onChanged: (bool value){
                  prefs.setBool("oskKagariGimmick", value);
                  setState(() {
                    oskKagariGimmick = value;
                  });
                }),
              ),
              Divider(),
              Padding(
                padding: descriptionPadding,
                child: Text(t.settingsDestination.oskKagariGimmickDescription),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getDatabaseSettings(){
    return Column(
      children: [
        Card(
          child: Center(child: Column(
            children: [
              Text(t.settingsDestination.database, style: Theme.of(context).textTheme.titleLarge),
              Divider(),
              FutureBuilder<(int, int, int)>(future: teto.getDatabaseData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData){
                        return RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
                            children: [
                              TextSpan(text: "${bytesToSize(snapshot.data!.$1)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: "${t.settingsDestination.bytesOfDataStored}\n"),
                              TextSpan(text: "${intf.format(snapshot.data!.$2)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: "${t.settingsDestination.TLrecordsSaved}\n"),
                              TextSpan(text: "${intf.format(snapshot.data!.$3)} ", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                              TextSpan(text: t.settingsDestination.TLplayerstatesSaved),
                            ]
                          )
                        );
                      }
                      if (snapshot.hasError){ return FutureError(snapshot); }
                    }
                  return Text("huh?");
                }
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (){teto.removeDuplicatesFromTLMatches().then((_) => setState((){}));},
                      icon: const Icon(Icons.build),
                      label: Text(t.settingsDestination.fixButton),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0)))))
                    )
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (){teto.compressDB().then((_) => setState((){}));},
                      icon: const Icon(Icons.compress),
                      label: Text(t.settingsDestination.compressButton),
                      style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)))))
                    )
                  )
                ],
                )
            ],
          )),
        ),
        Card(
          child: ListTile(
            title: Text(t.settingsDestination.exportDB, style: Theme.of(context).textTheme.displayLarge),
            onTap: () {
              if (kIsWeb){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.notForWeb)));
              } else if (Platform.isAndroid){
                var downloadFolder = Directory("/storage/emulated/0/Download");
                File exportedDB = File("${downloadFolder.path}/TetraStats.db");
                getApplicationDocumentsDirectory().then((value) {
                  exportedDB.writeAsBytes(File("${value.path}/TetraStats.db").readAsBytesSync());
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(t.settingsDestination.androidExportAlertTitle,
                              style: const TextStyle(
                                  fontFamily: "Eurostile Round Extended")),
                          content: SingleChildScrollView(
                            child: ListBody(children: [Text(t.settingsDestination.androidExportText(exportedDB: exportedDB))]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(t.actions.ok),
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
                    title: Text(t.settingsDestination.desktopExportAlertTitle,
                        style: const TextStyle(
                            fontFamily: "Eurostile Round Extended")),
                    content: SingleChildScrollView(
                      child: ListBody(children: [
                        Text(t.settingsDestination.desktopExportText)
                      ]),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(t.actions.ok),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
              }
            }
          ),
        ),
        Card(
          child: ListTile(
            title: Text(t.settingsDestination.importDB, style: Theme.of(context).textTheme.displayLarge),
            onTap: (){
              if (kIsWeb){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.notForWeb)));
              }else if(Platform.isAndroid){
                FilePicker.platform.pickFiles(
                  type: FileType.any,
                ).then((value){
                if (value != null){
                  var newDB = value.paths[0]!;
                  teto.checkImportingDB(File(newDB)).then((v){
                    if (v){
                      teto.close().then((value){
                      getApplicationDocumentsDirectory().then((value){
                        var oldDB = File("${value.path}/TetraStats.db");
                        oldDB.writeAsBytes(File(newDB).readAsBytesSync()).then((value){
                          teto.open();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.importSuccess)));
                        });
                      });
                    });
                    }else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Import Failed: Wrong database sheme")));
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.importCancelled)));
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
                  teto.checkImportingDB(File(newDB)).then((v){
                    if (v){
                      teto.close().then((value){
                      getApplicationDocumentsDirectory().then((value){
                        var oldDB = File("${value.path}/TetraStats.db");
                        oldDB.writeAsBytes(File(newDB).readAsBytesSync()).then((value){
                          teto.open();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.importSuccess)));
                        });
                      });
                    });
                    }else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Import Failed: Wrong database sheme")));
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.importCancelled)));
                }
              }); 
              }
            },
          ),
        )
      ],
    );
  }

  Widget rightSide(double width, bool hasSidebar){
    return SizedBox(
          width: width - (hasSidebar ? 80 : 0),
          child: SingleChildScrollView(
            child: switch (mod){
              SettingsCardMod.general => getGeneralSettings(),
              SettingsCardMod.customization => getCustomizationSettings(),
              SettingsCardMod.database => getDatabaseSettings(),
            },
          )
        );
  }
  
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    if (locales.isEmpty) for (var v in AppLocale.values){
      locales.add(DropdownMenuItem<AppLocale>(
        value: v, child: Text(t.locales[v.languageTag]!)));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.constraints.maxWidth > 900.0 ? 350 : widget.constraints.maxWidth - (widget.constraints.maxWidth <= 768.0 ? 0 : 80),
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text(t.settingsDestination.title, style: Theme.of(context).textTheme.headlineMedium),
                    Spacer()
                  ],
                ),
              ),
              for (SettingsCardMod m in SettingsCardMod.values) Card(
                child: ListTile(
                  title: Text(settingsCardTitles[m]!),
                  trailing: Icon(Icons.arrow_right, color: mod == m ? Colors.white : Colors.grey),
                  onTap: () {
                    setState(() {
                      mod = m;
                    });
                    if (widget.constraints.maxWidth <= 900.0) Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                          floatingActionButton: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                            child: FloatingActionButton(
                              onPressed: () => Navigator.pop(context),
                              tooltip: t.goBackButton,
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          body: SafeArea(
                            child: rightSide(widget.constraints.maxWidth, false)
                            )
                          ),
                        
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        if (widget.constraints.maxWidth > 900.0) rightSide(widget.constraints.maxWidth - 350, true)
      ],
    );
  }
}
