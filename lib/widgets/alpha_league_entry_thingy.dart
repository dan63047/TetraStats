import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_league_alpha_record.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class AlphaLeagueEntryThingy extends StatelessWidget{
  final TetraLeagueAlphaRecord record;
  final String userID;

  const AlphaLeagueEntryThingy(this.record, this.userID);
  
  @override
  Widget build(BuildContext context) {
    var accentColor = record.endContext.firstWhere((element) => element.userId == userID).success ? Colors.green : Colors.red;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0, 0.05],
          colors: [accentColor, Colors.transparent]
        )
      ),
      child: ListTile(
        leading: Text("${record.endContext.firstWhere((element) => element.userId == userID).points} : ${record.endContext.firstWhere((element) => element.userId != userID).points}",
        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, shadows: textShadow)),
        title: Text("vs. ${record.endContext.firstWhere((element) => element.userId != userID).username}"),
        subtitle: Text(timestamp(record.timestamp), style: const TextStyle(color: Colors.grey)),
        trailing: TrailingStats(
          record.endContext.firstWhere((element) => element.userId == userID).secondary,
          record.endContext.firstWhere((element) => element.userId == userID).tertiary,
          record.endContext.firstWhere((element) => element.userId == userID).extra,
          record.endContext.firstWhere((element) => element.userId != userID).secondary,
          record.endContext.firstWhere((element) => element.userId != userID).tertiary,
          record.endContext.firstWhere((element) => element.userId != userID).extra
          ),
        //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TlMatchResultView(record: record, initPlayerId: userID))),
      ),
    );
  }
}