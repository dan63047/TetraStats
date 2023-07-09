import 'package:flutter/material.dart';
import 'package:tetra_stats/views/tl_leaderboard_view.dart';

class RankAveragesView extends StatefulWidget {
  const RankAveragesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RanksAverages();
}

class RanksAverages extends State<RankAveragesView> {
  Map<String, List<dynamic>> averages = {};

  

  @override
  void initState() {
    teto.fetchTLLeaderboard().then((value) {averages = value.averages; setState(() {
    });});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranks averages"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView.builder(
            itemCount: averages.length,
            itemBuilder: (context, index){
              bool bigScreen = MediaQuery.of(context).size.width > 768;
              List<String> keys = averages.keys.toList();
              return ListTile(
                leading: Image.asset("res/tetrio_tl_alpha_ranks/${keys[index]}.png", height: 48),
                title: Text("${averages[keys[index]]?[1]["players"]} players", style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                subtitle: Text("${f2.format(averages[keys[index]]?[0].apm)} APM, ${f2.format(averages[keys[index]]?[0].pps)} PPS, ${f2.format(averages[keys[index]]?[0].vs)} VS, ${f2.format(averages[keys[index]]?[0].nerdStats.app)} APP, ${f2.format(averages[keys[index]]?[0].nerdStats.vsapm)} VS/APM"),
                trailing: Text("${f2.format(averages[keys[index]]?[1]["toEnterTR"])} TR", style: bigScreen ? const TextStyle(fontSize: 28) : null));
          })
          ),
    );
  }
}
