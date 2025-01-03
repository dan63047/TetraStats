import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/beta_record.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/views/tl_match_view.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class BetaLeagueEntryThingy extends StatelessWidget{
  final BetaRecord record;
  final String userID;
  // TODO: Rating delta string is too long for small screens
  const BetaLeagueEntryThingy(this.record, this.userID);

  TextSpan matchResult(String result){
    return switch(result){
      "victory" => TextSpan(
        text: t.matchResult.victory,
        style: TextStyle(color: Colors.greenAccent)
      ),
      "defeat" => TextSpan(
        text: t.matchResult.defeat,
        style: TextStyle(color: Colors.redAccent)
      ),
      "tie" => TextSpan(
        text: t.matchResult.tie,
        style: TextStyle(color: Colors.white)
      ),
      "dqvictory" => TextSpan(
        text: t.matchResult.dqvictory,
        style: TextStyle(color: Colors.lightGreenAccent)
      ),
      "dqdefeat" => TextSpan(
        text: t.matchResult.dqdefeat,
        style: TextStyle(color: Colors.red)
      ),
      "nocontest" => TextSpan(
        text: t.matchResult.nocontest,
        style: TextStyle(color: Colors.blueAccent)
      ),
      "nullified" => TextSpan(
        text: t.matchResult.nullified,
        style: TextStyle(color: Colors.purpleAccent)
      ),
      _ => TextSpan(
        text: "${result.toUpperCase()}",
        style: TextStyle(color: Colors.orangeAccent)
      )
    };
  }

  Color deltaColor(double? delta){
    if (delta == null || delta.isNaN || ["nocontest", "nullified"].contains(record.extras.result)) return Colors.grey;
    if (delta.isNegative) return Colors.redAccent;
    else return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    double? deltaTR = (record.extras.league[userID]?[1]?.tr != null && record.extras.league[userID]?[0]?.tr != null) ? record.extras.league[userID]![1]!.tr - record.extras.league[userID]![0]!.tr : null;
    double? deltaGlicko = (record.extras.league[userID]?[1]?.glicko != null && record.extras.league[userID]?[0]?.glicko != null) ? record.extras.league[userID]![1]!.glicko - record.extras.league[userID]![0]!.glicko : null;
    double? deltaRD = (record.extras.league[userID]?[1]?.rd != null && record.extras.league[userID]?[0]?.rd != null) ? record.extras.league[userID]![1]!.rd - record.extras.league[userID]![0]!.rd : null;
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              "${record.results.leaderboard.firstWhere((element) => element.id != record.enemyID).wins} - ${record.results.leaderboard.firstWhere((element) => element.id == record.enemyID).wins} ",
              style: TextStyle(fontSize: 26, height: 0.75, fontWeight: FontWeight.bold),
            ),
            Text(
              "vs.\n${record.enemyUsername}",
              style: TextStyle(fontSize: 14, height: 0.8, fontWeight: FontWeight.w100),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                  children: [
                    matchResult(record.extras.result),
                    TextSpan(
                      text: ", ${timestamp(record.ts)}\n"
                    ),
                    TextSpan(
                      text: deltaTR != null ? "${fDiff.format(deltaTR)} TR" : "??? TR",
                      style: TextStyle(
                        color: deltaColor(deltaTR)
                      )
                    ),
                    TextSpan(
                      text: ", "
                    ),
                    TextSpan(
                      text: deltaGlicko != null ? "${fDiff.format(deltaGlicko)} Glicko" : "??? Glicko",
                      style: TextStyle(
                        color: deltaColor(deltaGlicko)
                      )
                    ),
                    TextSpan(
                      text: ", "
                    ),
                    TextSpan(
                      text: deltaRD != null ? "${fDiff.format(deltaRD)} RD" : "??? RD",
                      style: TextStyle(
                        color: Colors.grey
                      )
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
        trailing: TrailingStats(
          record.results.leaderboard.firstWhere((element) => element.id != record.enemyID).stats.apm,
          record.results.leaderboard.firstWhere((element) => element.id != record.enemyID).stats.pps,
          record.results.leaderboard.firstWhere((element) => element.id != record.enemyID).stats.vs,
          record.results.leaderboard.firstWhere((element) => element.id == record.enemyID).stats.apm,
          record.results.leaderboard.firstWhere((element) => element.id == record.enemyID).stats.pps,
          record.results.leaderboard.firstWhere((element) => element.id == record.enemyID).stats.vs,
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: record, initPlayerId: userID))) //Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: data[index], initPlayerId: userID))),
      ),
    );
  } 
}