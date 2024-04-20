import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';

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
    return  1 - (position - nextRankPosition)/(previousRankPosition - nextRankPosition);
  }

  double? getBarTR(){
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(getBarPosition());
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
        ranges: [LinearGaugeRange(endValue: getBarPosition(), color: Colors.cyanAccent,)],
        markerPointers: [LinearShapePointer(value: getBarPosition(), position: LinearElementPosition.inside, shapeType: LinearShapePointerType.triangle, color: Colors.white, height: 20),
        LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: getBarPosition(), child: Text(NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(position)))],
        isMirrored: true,
        showTicks: true,
        showLabels: true
      )
    );        
  }
}