import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/rank_averages_view.dart';
import 'package:window_manager/window_manager.dart';
import 'main_view.dart'; // lol

class RankAveragesView extends StatefulWidget {
  const RankAveragesView({super.key});

  @override
  State<StatefulWidget> createState() => RanksAverages();
}

late String oldWindowTitle;

class RanksAverages extends State<RankAveragesView> {
  Map<String, List<dynamic>> averages = {};

  @override
  void initState() {
    teto.fetchTLLeaderboard().then((value){
      averages = value.averages;
      setState(() {});
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(t.rankAveragesViewTitle),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: averages.isEmpty ? const Center(child: Text('Fetching...')) : ListView.builder(
            itemCount: averages.length,
            itemBuilder: (context, index){
              bool bigScreen = MediaQuery.of(context).size.width > 768;
              List<String> keys = averages.keys.toList();
              return ListTile(
                leading: Image.asset("res/tetrio_tl_alpha_ranks/${keys[index]}.png", height: 48),
                title: Text(t.players(n: averages[keys[index]]?[1]["players"]), style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                subtitle: Text("${f2.format(averages[keys[index]]?[0].apm)} APM, ${f2.format(averages[keys[index]]?[0].pps)} PPS, ${f2.format(averages[keys[index]]?[0].vs)} VS, ${f2.format(averages[keys[index]]?[0].nerdStats.app)} APP, ${f2.format(averages[keys[index]]?[0].nerdStats.vsapm)} VS/APM",
                  style: TextStyle(fontFamily: "Eurostile Round Condensed", color: Colors.grey)),
                trailing: Text("${f2.format(averages[keys[index]]?[1]["toEnterTR"])} TR", style: bigScreen ? const TextStyle(fontSize: 28) : null),
                onTap: (){
                  if (averages[keys[index]]?[1]["players"] > 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RankView(rank: averages[keys[index]]!),
                        ),
                      );
                  }
                },
                );
          })
          ),
    );
  }
}
