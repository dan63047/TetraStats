import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';

class SpTrailingStats extends StatelessWidget{
  final RecordSingle record;
  final String gamemode;

  const SpTrailingStats(this.record, this.gamemode, {super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(height: 1.1, fontWeight: FontWeight.w100, fontSize: 13);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(switch(gamemode){
          "40l" => "${record.stats.piecesPlaced} P, ${f2.format(record.stats.pps)} PPS",
          "blitz" => "${record.stats.piecesPlaced} P, ${f2.format(record.stats.pps)} PPS",
          "5mblast" => "${record.stats.piecesPlaced} P, ${f2.format(record.stats.pps)} PPS",
          "zenith" => "${f2.format(record.aggregateStats.apm)} APM, ${f2.format(record.aggregateStats.pps)} PPS",
          "zenithex" => "${f2.format(record.aggregateStats.apm)} APM, ${f2.format(record.aggregateStats.pps)} PPS",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right),
        Text(switch(gamemode){
          "40l" => "${intf.format(record.stats.finessePercentage*100)}% F, ${record.stats.finesse?.faults} FF",
          "blitz" => "${intf.format(record.stats.finessePercentage*100)}% F, ${record.stats.finesse?.faults} FF",
          "5mblast" => "${intf.format(record.stats.finessePercentage*100)}% F, ${record.stats.finesse?.faults} FF",
          "zenith" => "${f2.format(record.stats.cps)} CSP (${f2.format(record.stats.zenith!.peakrank)} peak)",
          "zenithex" => "${f2.format(record.stats.cps)} CSP (${f2.format(record.stats.zenith!.peakrank)} peak)",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right),
        Text(switch(gamemode){
          "40l" => "${f2.format(record.stats.kps)} KPS, ${f2.format(record.stats.kpp)} KPP",
          "blitz" => "${intf.format(record.stats.spp)} SPP, lvl ${record.stats.level}",
          "5mblast" => "${intf.format(record.stats.spp)} SPP, ${record.stats.lines} L",
          "zenith" => "${record.stats.kills} KO's, ${getMoreNormalTime(record.stats.finalTime)}",
          "zenithex" => "${record.stats.kills} KO's, ${getMoreNormalTime(record.stats.finalTime)}",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right)
      ],
    );
  }
}