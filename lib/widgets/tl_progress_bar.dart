import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/glicko.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class TLProgress extends StatelessWidget{
  final TetraLeague tlData;
  final double? nextRankTRcutoff;
  final double? previousRankTRcutoff;
  final double? nextRankGlickoCutoff;
  final double? previousGlickoCutoff;
  final double? nextRankTRcutoffTarget;
  final double? previousRankTRcutoffTarget;

  const TLProgress({super.key, required this.tlData, this.nextRankTRcutoff, this.previousRankTRcutoff, this.nextRankGlickoCutoff, this.previousGlickoCutoff, this.nextRankTRcutoffTarget, this.previousRankTRcutoffTarget});

  double getBarPosition(){
    return min(max(0, 1 - (tlData.standing - tlData.nextAt)/(tlData.prevAt - tlData.nextAt)), 1);
  }

  double? getBarTR(double tr){
    return min(max(0, (tr - previousRankTRcutoff!)/(nextRankTRcutoff! - previousRankTRcutoff!)), 1);
  }

  @override
  Widget build(BuildContext context) {
    if (tlData.prevAt < 0 && tlData.nextAt < 0 && nextRankTRcutoff == null && previousRankTRcutoff == null && nextRankGlickoCutoff == null && previousGlickoCutoff == null && nextRankTRcutoffTarget == null && previousRankTRcutoffTarget == null) return Container();
    final glickoForWin = rate(tlData.glicko!, tlData.rd!, 0.06, [[tlData.glicko!, tlData.rd!, 1]], {})[0]-tlData.glicko!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round", fontSize: 12),
                  children: [
                    if (tlData.prevAt > 0) TextSpan(text: "№ ${f0.format(tlData.prevAt)}"),
                    if (tlData.prevAt > 0 && previousRankTRcutoff != null) const TextSpan(text: "\n"),
                    if (previousRankTRcutoff != null) TextSpan(text: "${f2.format(previousRankTRcutoff)} (${comparef2.format(previousRankTRcutoff!-tlData.tr)}) ${t.stats.tr.short}"),
                    if ((tlData.prevAt > 0 || previousRankTRcutoff != null) && previousGlickoCutoff != null) const TextSpan(text: "\n"),
                    if (previousGlickoCutoff != null) TextSpan(text: (tlData.standing > tlData.prevAt || ((tlData.glicko!-previousGlickoCutoff!)/glickoForWin < 0.5 && tlData.percentileRank != "d")) ? t.demotionOnNextLoss : t.numOfdefeats(losses: f2.format((tlData.glicko!-previousGlickoCutoff!)/glickoForWin)), style: TextStyle(color: (tlData.standing > tlData.prevAt || ((tlData.glicko!-previousGlickoCutoff!)/glickoForWin < 0.5 && tlData.percentileRank != "d")) ? Colors.redAccent : null))
                  ]
                )
              ),
              const Spacer(),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round", fontSize: 12),
                  children: [
                    if (tlData.nextAt > 0) TextSpan(text: "№ ${f0.format(tlData.nextAt)}"),
                    if (tlData.nextAt > 0 && nextRankTRcutoff != null) const TextSpan(text: "\n"),
                    if (nextRankTRcutoff != null) TextSpan(text: "${f2.format(nextRankTRcutoff)} (${comparef2.format(nextRankTRcutoff!-tlData.tr)}) ${t.stats.tr.short}"),
                    if ((tlData.nextAt > 0 || nextRankTRcutoff != null) && nextRankGlickoCutoff != null) const TextSpan(text: "\n"),
                    if (nextRankGlickoCutoff != null) TextSpan(text: (tlData.standing < tlData.nextAt || ((nextRankGlickoCutoff!-tlData.glicko!)/glickoForWin < 0.5 && ((tlData.rank != "x+" && tlData.rank != "z") || tlData.percentileRank != "x+"))) ? t.promotionOnNextWin : t.numOfVictories(wins: f2.format((nextRankGlickoCutoff!-tlData.glicko!)/glickoForWin)), style: TextStyle(color: (tlData.standing < tlData.nextAt || ((nextRankGlickoCutoff!-tlData.glicko!)/glickoForWin < 0.5 && tlData.percentileRank != "x+")) ? Colors.greenAccent : null))
                  ]
                )
              )
            ],
          ),
          SfLinearGauge(
            minimum: 0,
            maximum: 1,
            interval: 1, 
            ranges: [
              if (previousRankTRcutoff != null && nextRankTRcutoff != null) LinearGaugeRange(endValue: getBarTR(tlData.tr)!, color: Theme.of(context).colorScheme.primary, position: LinearElementPosition.cross)
              else if (tlData.standing != -1) LinearGaugeRange(endValue: getBarPosition(), color: Theme.of(context).colorScheme.primary, position: LinearElementPosition.cross),
              if (previousRankTRcutoff != null && previousRankTRcutoffTarget != null) LinearGaugeRange(endValue: getBarTR(previousRankTRcutoffTarget!)!, color: Colors.greenAccent.withAlpha(175), position: LinearElementPosition.inside),
              if (nextRankTRcutoff != null && nextRankTRcutoffTarget != null && previousRankTRcutoff != null) LinearGaugeRange(startValue: getBarTR(nextRankTRcutoffTarget!)!, endValue: 1, color: Colors.yellowAccent.withAlpha(175), position: LinearElementPosition.inside)
            ],
            markerPointers: [
              LinearShapePointer(value: (previousRankTRcutoff != null && nextRankTRcutoff != null) ? getBarTR(tlData.tr)! : getBarPosition(), position: LinearElementPosition.cross, shapeType: LinearShapePointerType.diamond, color: Colors.white, height: 20),
              if (tlData.standing != -1) LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: (previousRankTRcutoff != null && nextRankTRcutoff != null) ? getBarTR(tlData.tr)! : getBarPosition(), child: Text("№ ${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(tlData.standing)}", style: const TextStyle(fontSize: 14),))
            ],
            isMirrored: true,
            showTicks: true,
            showLabels: false
          )
        ]
      ),
    );        
  }
}