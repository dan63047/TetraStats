import 'package:flutter/material.dart' hide Badge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

List <Color> palette = const <Color>[
  Color.fromRGBO(75, 135, 185, 1),
  Color.fromRGBO(192, 108, 132, 1),
  Color.fromRGBO(246, 114, 128, 1),
  Color.fromRGBO(248, 177, 149, 1),
  Color.fromRGBO(116, 180, 155, 1),
  Color.fromRGBO(0, 168, 181, 1),
  Color.fromRGBO(73, 76, 162, 1),
  Color.fromRGBO(255, 205, 96, 1),
  Color.fromRGBO(255, 240, 219, 1),
  Color.fromRGBO(238, 238, 238, 1)
];

class CheeseAndDSThingy extends StatelessWidget {
  final List<double> atkCheesiness;
  final List<double> DSratio;
  final List<String> nicknames;
  const CheeseAndDSThingy(this.atkCheesiness, this.DSratio, this.nicknames, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        runSpacing: 10.0,
        runAlignment: WrapAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 200.0, maxHeight: 200.0),
            child: SfRadialGauge(axes: [
              RadialAxis(
                startAngle: 170,
                endAngle: 10,
                showLabels: false,
                showTicks: true,
                canScaleToFit: true,
                radiusFactor: 1,
                minimum: 0,
                maximum: 1,
                ranges: [
                  GaugeRange(startValue: 0, endValue: 0.2, color: Colors.blueGrey),
                  GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.greenAccent),
                  GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.yellowAccent),
                  GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.orangeAccent),
                  GaugeRange(startValue: 0.8, endValue: 1, color: Colors.redAccent),
                ],
                pointers: [
                  for (int i = 0; i < atkCheesiness.length; i++) NeedlePointer(
                    value: atkCheesiness[i],
                    enableAnimation: true,
                    needleLength: 0.9,
                    needleStartWidth: 2,
                    needleEndWidth: 15,
                    knobStyle: const KnobStyle(color: Colors.transparent),
                    gradient: LinearGradient(
                        colors: [Colors.transparent, atkCheesiness.length == 1 ? Colors.white : palette[i]],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.5, 1]),
                  )
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Container(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
                            children: [
                              TextSpan(text: "${t.stats.attackCheesiness}\n"),
                              if (atkCheesiness.length == 1) TextSpan(text: f3.format(atkCheesiness[0]), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
                              if (atkCheesiness.length > 1) WidgetSpan(child: Column(
                                children: [
                                  for (int i = 0; i < atkCheesiness.length; i++) Container(
                                    height: 20,
                                    width: 160,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                                                child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: palette[i])),
                                              ),
                                              Text("${nicknames[i]}:"),
                                            ],
                                          ),
                                          Text("${f3.format(atkCheesiness[i])}")
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                              ]))),
                      angle: 270,
                      positionFactor: 0.3)
                ],
              )
            ]),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 200.0, maxHeight: 200.0),
            child: SfRadialGauge(axes: [
              RadialAxis(
                startAngle: 170,
                endAngle: 10,
                showLabels: false,
                showTicks: true,
                canScaleToFit: true,
                radiusFactor: 1,
                minimum: 0,
                maximum: 1,
                ranges: [
                  GaugeRange(startValue: 0, endValue: 0.2, color: Colors.blueGrey),
                  GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.greenAccent),
                  GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.yellowAccent),
                  GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.orangeAccent),
                  GaugeRange(startValue: 0.8, endValue: 1, color: Colors.redAccent),
                ],
                pointers: [
                  for (int i = 0; i < DSratio.length; i++) NeedlePointer(
                    value: DSratio[i],
                    enableAnimation: true,
                    needleLength: 0.9,
                    needleStartWidth: 2,
                    needleEndWidth: 15,
                    knobStyle: const KnobStyle(color: Colors.transparent),
                    gradient: LinearGradient(
                        colors: [Colors.transparent, DSratio.length == 1 ? Colors.white : palette[i]],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.5, 1]),
                  )
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Container(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(fontFamily: "Eurostile Round", color: Colors.white),
                            children: [
                              TextSpan(text: "${t.stats.downstackingRatio}\n"),
                              if (DSratio.length == 1) TextSpan(text: f3.format(DSratio[0]), style: TextStyle(fontSize: 25, fontFamily: "Eurostile Round Extended", fontWeight: FontWeight.w100)),
                              if (DSratio.length > 1) WidgetSpan(child: Column(
                                children: [
                                  for (int i = 0; i < DSratio.length; i++) Container(
                                    height: 20,
                                    width: 160,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                                                child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: palette[i])),
                                              ),
                                              Text("${nicknames[i]}:"),
                                            ],
                                          ),
                                          Text("${f3.format(DSratio[i])}")
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                              ]))),
                      angle: 270,
                      positionFactor: 0.3)
                ],
              )
            ]),
          )
        ],
      ),
    ));
  }
}
