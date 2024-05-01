import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/glicko.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class TLProgress extends StatelessWidget{
  final TetraLeagueAlpha tlData;
  final String? nextRank;
  final String? previousRank;
  final double? nextRankTRcutoff;
  final double? previousRankTRcutoff;
  final double? nextRankGlickoCutoff;
  final double? previousGlickoCutoff;
  final double? nextRankTRcutoffTarget;
  final double? previousRankTRcutoffTarget;

  const TLProgress({super.key, required this.tlData, this.nextRank, this.previousRank, this.nextRankTRcutoff, this.previousRankTRcutoff, this.nextRankGlickoCutoff, this.previousGlickoCutoff, this.nextRankTRcutoffTarget, this.previousRankTRcutoffTarget});

  double getBarPosition(){
    return min(max(0, 1 - (tlData.standing - tlData.nextAt)/(tlData.prevAt - tlData.nextAt)), 1);
  }

  double? getBarTR(double tr){
    return min(max(0, (tr - previousRankTRcutoff!)/(nextRankTRcutoff! - previousRankTRcutoff!)), 1);
  }

  @override
  Widget build(BuildContext context) {
    final glickoForWin = rate(tlData.glicko!, tlData.rd!, 0.06, [[tlData.glicko!, tlData.rd!, 1]], {})[0]-tlData.glicko!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SfLinearGauge(
            minimum: 0,
            maximum: 1,
            interval: 1, 
            ranges: [
              if (previousRankTRcutoff != null && nextRankTRcutoff != null) LinearGaugeRange(endValue: getBarTR(tlData.rating)!, color: Colors.cyanAccent, position: LinearElementPosition.cross)
              else if (tlData.standing != -1) LinearGaugeRange(endValue: getBarPosition(), color: Colors.cyanAccent, position: LinearElementPosition.cross),
              if (previousRankTRcutoff != null && previousRankTRcutoffTarget != null) LinearGaugeRange(endValue: getBarTR(previousRankTRcutoffTarget!)!, color: Colors.greenAccent, position: LinearElementPosition.inside),
              if (nextRankTRcutoff != null && nextRankTRcutoffTarget != null) LinearGaugeRange(startValue: getBarTR(nextRankTRcutoffTarget!)!, endValue: 1, color: Colors.yellowAccent, position: LinearElementPosition.inside)
            ],
            markerPointers: [
              LinearShapePointer(value: (previousRankTRcutoff != null && nextRankTRcutoff != null) ? getBarTR(tlData.rating)! : getBarPosition(), position: LinearElementPosition.cross, shapeType: LinearShapePointerType.diamond, color: Colors.white, height: 20),
              LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: (previousRankTRcutoff != null && nextRankTRcutoff != null) ? getBarTR(tlData.rating)! : getBarPosition(), child: Text("№ ${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(tlData.standing)}"))
            ],
            isMirrored: true,
            showTicks: true,
            axisLabelStyle: TextStyle(),
            onGenerateLabels: () => [
              LinearAxisLabel(text: "${tlData.prevAt > 0 ? "№ ${f0.format(tlData.prevAt)}" : ""}\n ${intf.format(previousRankTRcutoff)} TR", value: 0),
              LinearAxisLabel(text: "${tlData.nextAt > 0 ? "№ ${f0.format(tlData.nextAt)}" : ""}\n ${intf.format(nextRankTRcutoff)} TR", value: 1),
            ],
            // labelFormatterCallback: (value) {
            //   if (value == "0") return "${f0.format(previousRankPosition)}\n 26,700 TR";
            //   else return f0.format(nextRankPosition);
            // },
            showLabels: true
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            child: Stack(
              fit: StackFit.expand,
              children: [
              Positioned(child: Text("${f2.format(tlData.rating-previousRankTRcutoff!)} (${f2.format((tlData.glicko!-previousGlickoCutoff!)/glickoForWin)} losses)"), left: 0,),
              Positioned(child: Text("${f2.format(nextRankTRcutoff!-tlData.rating)} (${f2.format((nextRankGlickoCutoff!-tlData.glicko!)/glickoForWin)} wins)"), right: 0,)
            ],),
          )
          
        ],
      )
    );        
  }
}