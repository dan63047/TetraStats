import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/gauget_thingy.dart';

class NerdStatsThingy extends StatelessWidget{
  final NerdStats nerdStats;
  final NerdStats? oldNerdStats;
  final CutoffTetrio? averages;
  final PlayerLeaderboardPosition? lbPos;

  const NerdStatsThingy({super.key, required this.nerdStats, this.oldNerdStats, this.averages, this.lbPos});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 256.0,
                  width: 256.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                      decoration: BoxDecoration(gradient: RadialGradient(colors: [Colors.black12.withAlpha(100), Colors.black], radius: 0.6)),
                      child: SfRadialGauge(
                        axes: [
                          RadialAxis(
                          startAngle: 190,
                          endAngle: 350,
                          showLabels: false,
                          showTicks: true,
                          radiusFactor: 1,
                          centerY: 0.5,
                          minimum: 0,
                          maximum: 1,
                        ranges: [
                          GaugeRange(startValue: 0, endValue: 0.2, color: Colors.red),
                          GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.yellow),
                          GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.green),
                          GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.blue),
                          GaugeRange(startValue: 0.8, endValue: 1, color: Colors.purple),
                        ],
                        pointers: [
                          NeedlePointer(
                            value: nerdStats.app,
                            enableAnimation: true,
                            needleLength: 0.9,
                            needleStartWidth: 2,
                            needleEndWidth: 15,
                            knobStyle: const KnobStyle(color: Colors.transparent),
                            gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                          ],
                        annotations: [
                          GaugeAnnotation(widget: Container(child:
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(fontFamily: "Eurostile Round"),
                              children: [
                                const TextSpan(text: "APP\n"),
                                TextSpan(text: f3.format(nerdStats.app), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.app, averages?.nerdStats?.app, true))),
                                if (lbPos != null) TextSpan(text: lbPos!.app!.position >= 1000 ? "\n${t.top} ${f2.format(lbPos!.app!.percentage*100)}%" : "\n№${lbPos!.app!.position}", style: TextStyle(color: getColorOfRank(lbPos!.app!.position))),
                                if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.app - oldNerdStats!.app)}", style: TextStyle(color: getDifferenceColor(nerdStats.app - oldNerdStats!.app)))
                              ]
                          ))),
                          angle: 270,positionFactor: 0.5
                          )],
                          ),
                          RadialAxis(
                            startAngle: 20,
                            endAngle: 160,
                            isInversed: true,
                            showLabels: false,
                            showTicks: true,
                            radiusFactor: 1,
                            centerY: 0.5,
                            minimum: 1.8,
                            maximum: 2.4,
                          ranges: [
                            GaugeRange(startValue: 1.8, endValue: 2.0, color: Colors.green),
                            GaugeRange(startValue: 2.0, endValue: 2.2, color: Colors.blue),
                            GaugeRange(startValue: 2.2, endValue: 2.4, color: Colors.purple),
                          ],
                          pointers: [
                            NeedlePointer(
                              value: nerdStats.vsapm,
                              enableAnimation: true,
                              needleLength: 0.9,
                              needleStartWidth: 2,
                              needleEndWidth: 15,
                              knobStyle: const KnobStyle(color: Colors.transparent),
                              gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                            ],
                            annotations: [
                              GaugeAnnotation(widget: Container(child:
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(fontFamily: "Eurostile Round"),
                                  children: [
                                    const TextSpan(text: "VS/APM\n"),
                                    TextSpan(text: f3.format(nerdStats.vsapm), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100, color: getStatColor(nerdStats.vsapm, averages?.nerdStats?.vsapm, true))),
                                    if (lbPos != null) TextSpan(text: lbPos!.vsapm!.position >= 1000 ? "\n${t.top} ${f2.format(lbPos!.vsapm!.percentage*100)}%" : "\n№${lbPos!.vsapm!.position}", style: TextStyle(color: getColorOfRank(lbPos!.vsapm!.position))),
                                    if (oldNerdStats != null) TextSpan(text: "\n${comparef.format(nerdStats.vsapm - oldNerdStats!.vsapm)}", style: TextStyle(color: getDifferenceColor(nerdStats.vsapm - oldNerdStats!.vsapm))),
                                  ]
                              ))),
                              angle: 90,positionFactor: 0.5
                              )
                            ],
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    runAlignment: WrapAlignment.start,
                    children: [
                      GaugetThingy(value: nerdStats.dss, oldValue: oldNerdStats?.dss, min: 0, max: 1.0, tickInterval: .2, label: "DS/S", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.dss, lbPos: lbPos?.dss),
                      GaugetThingy(value: nerdStats.dsp, oldValue: oldNerdStats?.dsp, min: 0, max: 1.0, tickInterval: .2, label: "DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.dsp, lbPos: lbPos?.dsp),
                      GaugetThingy(value: nerdStats.appdsp, oldValue: oldNerdStats?.appdsp, min: 0, max: 1.2, tickInterval: .2, label: "APP+DS/P", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.appdsp, lbPos: lbPos?.appdsp),
                      GaugetThingy(value: nerdStats.cheese, oldValue: oldNerdStats?.cheese, min: -80, max: 80, tickInterval: 40, label: "Cheese", sideSize: 128.0, fractionDigits: 2, moreIsBetter: false, lbPos: lbPos?.cheese),
                      GaugetThingy(value: nerdStats.gbe, oldValue: oldNerdStats?.gbe, min: 0, max: 1.0, tickInterval: .2, label: "GbE", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.gbe, lbPos: lbPos?.gbe),
                      GaugetThingy(value: nerdStats.nyaapp, oldValue: oldNerdStats?.nyaapp, min: 0, max: 1.2, tickInterval: .2, label: "wAPP", sideSize: 128.0, fractionDigits: 3, moreIsBetter: true, avgValue: averages?.nerdStats?.nyaapp, lbPos: lbPos?.nyaapp),
                      GaugetThingy(value: nerdStats.area, oldValue: oldNerdStats?.area, min: 0, max: 1000, tickInterval: 100, label: "Area", sideSize: 128.0, fractionDigits: 1, moreIsBetter: true, avgValue: averages?.nerdStats?.area, lbPos: lbPos?.area),
                    ],
                  ),
                )
              ]
            ),
          ),
        ],
      )
    );
  } 
}