import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/leaderboard_position.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class GaugetThingy extends StatelessWidget{
  final double? value;
  final String? subString;
  final double min;
  final double max;
  final double? oldValue;
  final double? avgValue;
  final bool moreIsBetter;
  final double tickInterval;
  final String label;
  final double sideSize;
  final bool percentileFormat;
  final int fractionDigits;
  final LeaderboardPosition? lbPos;

  const GaugetThingy({super.key, required this.value, this.subString, required this.min, required this.max, this.oldValue, this.avgValue, required this.tickInterval, required this.label, required this.sideSize, required this.fractionDigits, required this.moreIsBetter, this.percentileFormat = false, this.lbPos});

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits);
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: SizedBox(
        height: sideSize,
        width: sideSize,
        child: SfRadialGauge(
          backgroundColor: Colors.black,
          axes: [
            RadialAxis(
              radiusFactor: 1.01,
              minimum: min,
              maximum: max,
              showTicks: true,
              showLabels: false,
              interval: tickInterval,
              minorTicksPerInterval: 0,
              ranges:[
                GaugeRange(startValue: 0, endValue: (value != null && !value!.isNaN) ? value! : 0, color: theme.colorScheme.primary)
              ],
              annotations: [
                GaugeAnnotation(widget: Container(child:
                Text((value != null && !value!.isNaN) ? percentileFormat ? percentage.format(value) : f.format(value) : "---", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: (value != null && !value!.isNaN) ? getStatColor(value!, avgValue, moreIsBetter) : Colors.grey))),
                angle: 90,positionFactor: 0.10
                ),
                GaugeAnnotation(widget: Container(child:
                Text(label, textAlign: TextAlign.center, style: TextStyle(height: .9, color: (value != null && !value!.isNaN) ? null : Colors.grey))),
                angle: 270,positionFactor: 0.3, verticalAlignment: GaugeAlignment.far,
                ),
                if (oldValue != null && (value != null && !value!.isNaN)) GaugeAnnotation(widget: Container(child:
                Text(comparef2.format(percentileFormat ? (value!-oldValue!) * 100 : value!-oldValue!), textAlign: TextAlign.center, style: TextStyle(color: getDifferenceColor(moreIsBetter ? value!-oldValue! : oldValue!-value!)))),
                angle: 90,positionFactor: lbPos != null ? 0.7 : 0.45
                ),
                if (subString != null) GaugeAnnotation(widget: Container(child:
                Text(subString!, textAlign: TextAlign.center, style: TextStyle(color: (value != null && !value!.isNaN) ? null : Colors.grey))),
                angle: 90,positionFactor: lbPos != null ? 0.7 : 0.45
                ),
                if (lbPos != null) GaugeAnnotation(widget: Container(child:
                Text(lbPos!.position >= 1000 ? "${t.top} ${f2.format(lbPos!.percentage*100)}%" : "№ ${lbPos!.position}", textAlign: TextAlign.center, style: TextStyle(color: (lbPos != null) ? getColorOfRank(lbPos!.position) : Colors.grey))),
                angle: 90,positionFactor: 0.45
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}