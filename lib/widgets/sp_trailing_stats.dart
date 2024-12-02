import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/gen/strings.g.dart';
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
          "40l" => "${record.stats.piecesPlaced} ${t.stats.pieces.short}, ${f2.format(record.stats.pps)} ${t.stats.pps.short}",
          "blitz" => "${record.stats.piecesPlaced} ${t.stats.pieces.short}, ${f2.format(record.stats.pps)} ${t.stats.pps.short}",
          "5mblast" => "${record.stats.piecesPlaced} ${t.stats.pieces.short}, ${f2.format(record.stats.pps)} ${t.stats.pps.short}",
          "zenith" => "${f2.format(record.aggregateStats.apm)} ${t.stats.apm.short}, ${f2.format(record.aggregateStats.pps)} ${t.stats.pps.short}",
          "zenithex" => "${f2.format(record.aggregateStats.apm)} ${t.stats.apm.short}, ${f2.format(record.aggregateStats.pps)} ${t.stats.pps.short}",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right),
        Text(switch(gamemode){
          "40l" => "${intf.format(record.stats.finessePercentage*100)}% ${t.stats.finesse.short}, ${record.stats.finesse?.faults} ${t.stats.finesseFaults.short}",
          "blitz" => "${intf.format(record.stats.finessePercentage*100)}% ${t.stats.finesse.short}, ${record.stats.finesse?.faults} ${t.stats.finesseFaults.short}",
          "5mblast" => "${intf.format(record.stats.finessePercentage*100)}% ${t.stats.finesse.short}, ${record.stats.finesse?.faults} ${t.stats.finesseFaults.short}",
          "zenith" => "${f2.format(record.stats.cps)} ${t.stats.climbSpeed.short} (${f2.format(record.stats.zenith!.peakrank)} ${t.stats.peak})",
          "zenithex" => "${f2.format(record.stats.cps)} ${t.stats.climbSpeed.short} (${f2.format(record.stats.zenith!.peakrank)} ${t.stats.peak})",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right),
        Text(switch(gamemode){
          "40l" => "${f2.format(record.stats.kps)} ${t.stats.kps.short}, ${f2.format(record.stats.kpp)} ${t.stats.kpp.short}",
          "blitz" => "${intf.format(record.stats.spp)} ${t.stats.spp.short}, ${t.stats.level.short} ${record.stats.level}",
          "5mblast" => "${intf.format(record.stats.spp)} ${t.stats.spp.short}, ${record.stats.lines} ${t.stats.linesShort}",
          "zenith" => "${record.stats.kills} ${t.stats.kos.short}, ${getMoreNormalTime(record.stats.finalTime)}",
          "zenithex" => "${record.stats.kills} ${t.stats.kos.short}, ${getMoreNormalTime(record.stats.finalTime)}",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right)
      ],
    );
  }
}