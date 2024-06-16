import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/widgets/singleplayer_record.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class RecentSingleplayerGames extends StatelessWidget{
  final SingleplayerStream recent;
  final bool hideTitle;

  const RecentSingleplayerGames({required this.recent, this.hideTitle = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hideTitle) Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(t.recent, style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
        ),
        for(RecordSingle record in recent.records) ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: record))),
          leading: Text(
            switch (record.endContext.gameType){
              "40l" => "40L",
              "blitz" => "BLZ",
              "5mblast" => "5MB",
              String() => "huh",
            },
            style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
          ),
          title: Text(
            switch (record.endContext.gameType){
              "40l" => get40lTime(record.endContext.finalTime.inMicroseconds),
              "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(record.endContext.score)),
              "5mblast" => get40lTime(record.endContext.finalTime.inMicroseconds),
              String() => "huh",
            },
          style: const TextStyle(fontSize: 18)),
          subtitle: Text(timestamp(record.timestamp), style: TextStyle(color: Colors.grey, height: 0.85)),
          trailing: SpTrailingStats(record.endContext)
        )
      ],
    );
  }
}