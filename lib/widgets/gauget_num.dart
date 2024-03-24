import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';

class GaugetNum extends StatelessWidget {
  final num playerStat;
  final num? oldPlayerStat;
  final bool higherIsBetter;
  final List<GaugeRange> ranges;
  final double minimum;
  final double maximum;
  final String playerStatLabel;
  final String? okText;
  final String? alertTitle;
  final List<Widget>? alertWidgets;
  final LeaderboardPosition? pos;
  final num? averageStat;

  const GaugetNum(
      {super.key,
      required this.playerStat,
      required this.playerStatLabel,
      this.alertWidgets,
      this.oldPlayerStat,
      required this.higherIsBetter,
      required this.minimum,
      required this.maximum,
      required this.ranges,
      this.okText, this.alertTitle, this.pos, this.averageStat});

  Color getStatColor(){
    if (averageStat == null) return Colors.white;
    num percentile = (higherIsBetter ? playerStat / averageStat! : averageStat! / playerStat).abs();
    if      (percentile > 1.50) return Colors.purpleAccent;
    else if (percentile > 1.20) return Colors.blueAccent;
    else if (percentile > 0.90) return Colors.greenAccent;
    else if (percentile > 0.70) return Colors.yellowAccent;
    else return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: SfRadialGauge(
        title: GaugeTitle(text: playerStatLabel),
        axes: [RadialAxis(
        startAngle: 180,
        endAngle: 360,
        showLabels: false,
        showTicks: false,
        radiusFactor: 2.1,
        centerY: 0.5,
        minimum: minimum,
        maximum: maximum,
        ranges: ranges,
        pointers: [
          NeedlePointer(
            value: playerStat as double,
            enableAnimation: true,
            needleLength: 0.9,
            needleStartWidth: 2,
            needleEndWidth: 15,
            knobStyle: const KnobStyle(color: Colors.transparent),
            gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
          ],
        annotations: [GaugeAnnotation(
          widget: TextButton(child: Text(f3.format(playerStat),
          style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, color: getStatColor())),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(alertTitle??playerStatLabel, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                content:  SingleChildScrollView(child: ListBody(children: alertWidgets!)),
                actions: <Widget>[
                  TextButton(
                    child: Text(okText??t.popupActions.ok),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
        },), verticalAlignment: GaugeAlignment.far, positionFactor: 0.05),
        if (oldPlayerStat != null || pos != null) GaugeAnnotation(
          widget: RichText(text: TextSpan(
                text: "",
                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                children: [
                  if (oldPlayerStat != null) TextSpan(text: comparef.format(playerStat - oldPlayerStat!), style: TextStyle(
                    color: higherIsBetter ?
                    oldPlayerStat! > playerStat ? Colors.redAccent : Colors.greenAccent :
                    oldPlayerStat! < playerStat ? Colors.redAccent : Colors.greenAccent
                  ),),
                  if ((oldTl != null && oldTl!.gamesPlayed > 0) && pos != null) const TextSpan(text: " • "),
                  if (pos != null) TextSpan(text: pos!.position >= 1000 ? "${t.top} ${f2.format(pos!.percentage*100)}%" : "№${pos!.position}", style: TextStyle(color: getColorOfRank(pos!.position)))
                ]
                ),
              ),
        positionFactor: 0.05)],
        )],),
    );
  }
}