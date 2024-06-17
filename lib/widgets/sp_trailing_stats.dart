import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class SpTrailingStats extends StatelessWidget{
  final EndContextSingle endContext;

  const SpTrailingStats(this.endContext, {super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(height: 1.1, fontWeight: FontWeight.w100, fontSize: 13);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${endContext.piecesPlaced} P, ${f2.format(endContext.pps)} PPS", style: style, textAlign: TextAlign.right),
        Text("${intf.format(endContext.finessePercentage*100)}% F, ${endContext.finesse?.faults} FF", style: style, textAlign: TextAlign.right),
        Text(switch(endContext.gameType){
          "40l" => "${f2.format(endContext.kps)} KPS, ${f2.format(endContext.kpp)} KPP",
          "blitz" => "${intf.format(endContext.spp)} SPP, lvl ${endContext.level}",
          "5mblast" => "${intf.format(endContext.spp)} SPP, ${endContext.lines} L",
          String() => "huh"
        }, style: style, textAlign: TextAlign.right)
      ],
    );
  }
}