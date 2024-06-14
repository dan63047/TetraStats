import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:window_manager/window_manager.dart';

late String oldWindowTitle;
final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode);

class SprintAndBlitzView extends StatefulWidget {
  const SprintAndBlitzView({super.key});

  @override
  State<StatefulWidget> createState() => SprintAndBlitzState();
}

class SprintAndBlitzState extends State<SprintAndBlitzView> {

  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.settings}");
    }
    super.initState();
  }

  @override
  void dispose(){
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width >= 368;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.sprintAndBlitsViewTitle),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey.shade900),
                    columnWidths: {0: const FixedColumnWidth(48)},
                    children: [
                      TableRow(
                        children: [
                          Text(t.rank, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(t.sprint, textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(t.blitz, textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                          ),
                        ]
                      ),
                      for (MapEntry<String, Duration> sprintEntry in sprintAverages.entries) TableRow(
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [rankColors[sprintEntry.key]!.withAlpha(100), rankColors[sprintEntry.key]!.withAlpha(200)])),
                        children: [
                          Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(132), blurRadius: 32.0, blurStyle: BlurStyle.inner)]), child: Image.asset("res/tetrio_tl_alpha_ranks/${sprintEntry.key}.png", height: 48)),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(get40lTime(sprintEntry.value.inMicroseconds), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(NumberFormat.decimalPattern().format(blitzAverages[sprintEntry.key]), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                          ),
                        ]
                      )
                    ],
                  ),
                  Text(t.sprintAndBlitsRelevance(date: dateFormat.format(DateTime(2024, 5, 26))))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
