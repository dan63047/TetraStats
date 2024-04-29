import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class TLProgress extends StatelessWidget{
  final double tr;
  final String rank;
  final int position;
  final String? nextRank;
  final String? previousRank;
  final int nextRankPosition;
  final int previousRankPosition;
  final double? nextRankTRcutoff;
  final double? previousRankTRcutoff;
  final double? nextRankTRcutoffTarget;
  final double? previousRankTRcutoffTarget;

  const TLProgress({super.key, required this.tr, required this.rank, required this.position, required this.nextRankPosition, required this.previousRankPosition, this.nextRank, this.previousRank, this.nextRankTRcutoff, this.previousRankTRcutoff, this.nextRankTRcutoffTarget, this.previousRankTRcutoffTarget});

  double getBarPosition(){
    return min(max(0, 1 - (position - nextRankPosition)/(previousRankPosition - nextRankPosition)), 1);
  }

  double? getBarTR(double tr){
    return min(max(0, (tr - previousRankTRcutoff!)/(nextRankTRcutoff! - previousRankTRcutoff!)), 1);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   alignment: Alignment.centerLeft,
    //   height: 50,
    //   width: MediaQuery.of(context).size.width,
    //   color: Colors.blue,
    //   child: Container(
    //     width: MediaQuery.of(context).size.width / 2,
    //     height: 50,
    //     color: Colors.red,
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfLinearGauge(
        minimum: 0,
        maximum: 1,
        interval: 1, 
        ranges: [
          if (previousRankTRcutoff != null && nextRankTRcutoff != null) LinearGaugeRange(endValue: getBarTR(tr)!, color: Colors.cyanAccent, position: LinearElementPosition.cross),
          if (position != -1) LinearGaugeRange(endValue: getBarPosition(), color: Colors.cyanAccent, position: LinearElementPosition.cross),
          if (previousRankTRcutoff != null && previousRankTRcutoffTarget != null) LinearGaugeRange(endValue: getBarTR(previousRankTRcutoffTarget!)!, color: Colors.greenAccent, position: LinearElementPosition.inside),
          if (nextRankTRcutoff != null && nextRankTRcutoffTarget != null) LinearGaugeRange(startValue: getBarTR(nextRankTRcutoffTarget!)!, endValue: 1, color: Colors.yellowAccent, position: LinearElementPosition.inside)
        ],
        markerPointers: [
          LinearShapePointer(value: getBarPosition(), position: LinearElementPosition.cross, shapeType: LinearShapePointerType.diamond, color: Colors.white, height: 20),
          LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: getBarPosition(), child: Text("№ ${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(position)}"))
        ],
        isMirrored: true,
        showTicks: true,
        axisLabelStyle: TextStyle(),
        onGenerateLabels: () => [
          LinearAxisLabel(text: "№ ${f0.format(previousRankPosition)}\n ${intf.format(previousRankTRcutoff)} TR", value: 0),
          LinearAxisLabel(text: "№ ${f0.format(nextRankPosition)}\n ${intf.format(nextRankTRcutoff)} TR", value: 1),
        ],
        // labelFormatterCallback: (value) {
        //   if (value == "0") return "${f0.format(previousRankPosition)}\n 26,700 TR";
        //   else return f0.format(nextRankPosition);
        // },
        showLabels: true
      )
    );        
  }
}