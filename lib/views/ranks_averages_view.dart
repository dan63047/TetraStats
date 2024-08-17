import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_stats.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:tetra_stats/views/rank_averages_view.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tetra_stats/main.dart' show teto;

class RankAveragesView extends StatefulWidget {
  const RankAveragesView({super.key});

  @override
  State<StatefulWidget> createState() => RanksAverages();
}

late String oldWindowTitle;

class RanksAverages extends State<RankAveragesView> {

  @override
  void initState() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.rankAveragesViewTitle}");
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width >= 700;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.rankAveragesViewTitle),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<Cutoffs?>(future: teto.fetchCutoffs(), builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            case ConnectionState.done:
              if (snapshot.hasData){
                return Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(maxWidth: 900, minWidth: 610),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              border: TableBorder.all(color: Colors.grey.shade900),
                              columnWidths: const {0: FixedColumnWidth(48)},
                              children: [
                                TableRow(
                                  children: [
                                    Text(t.rank, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text("TR", textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text("Glicko", textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text("Glixare", textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text("S1 TR", textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                                    ),
                                  ]
                                ),
                                for (String rank in snapshot.data!.tr.keys) TableRow(
                                  decoration: BoxDecoration(gradient: LinearGradient(colors: [rankColors[rank]!.withAlpha(100), rankColors[rank]!.withAlpha(200)])),
                                  children: [
                                    Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(132), blurRadius: 32.0, blurStyle: BlurStyle.inner)]), child: Image.asset("res/tetrio_tl_alpha_ranks/$rank.png", height: 48)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(f2.format(snapshot.data!.tr[rank]), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(f2.format(snapshot.data!.glicko[rank]), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(f2.format(snapshot.data!.gxe[rank]), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(f2.format(snapshot.data!.gxe[rank]!*250), textAlign: TextAlign.right, style: TextStyle(fontFamily: bigScreen ? "Eurostile Round" : "Eurostile Round Condensed", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                                    ),
                                  ]
                                )
                              ],
                            ),
                            Text(t.sprintAndBlitsRelevance(date: timestamp(snapshot.data!.ts)))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError){
                return Center(child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snapshot.error.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 42, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        if (snapshot.stackTrace != null) Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(snapshot.stackTrace.toString(), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 18), textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  );
              }
              return const Text("end of FutureBuilder");
          }
        })
        ),
    );
  }
}
