import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/graphs.dart';

class PPSSurgeThingy extends StatelessWidget{
  final List<MinomuncherData> data;
  final double width;
  const PPSSurgeThingy(this.data, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("PPS", style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
                Center(child: SizedBox(width: 0.0, height: 16.0)),
                SizedBox(
                  height: 330,
                  width: 330,
                  child: MyRadarChart(
                  RadarChartData(
                  radarShape: RadarShape.circle,
                  tickCount: 4,
                  radarBackgroundColor: Colors.black.withAlpha(170),
                  radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                  tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                  getTitle: (index, angle) {
                    switch (index) {
                    case 0: return RadarChartTitle(text: "Overall\n${f3.format(data[0].PPS)}", positionPercentageOffset: 0.05);
                    case 1: return RadarChartTitle(text: "Plonk\n${f3.format(data[0].PlonkPPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 2: return RadarChartTitle(text: "Upstack\n${f3.format(data[0].upstackPPS)}", positionPercentageOffset: 0.05, angle: -60.0);
                    case 3: return RadarChartTitle(text: "Variance\n${f3.format(data[0].PPSCoeff)}", positionPercentageOffset: 0.05);
                    case 4: return RadarChartTitle(text: "Downstack\n${f3.format(data[0].downstackPPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 5: return RadarChartTitle(text: "Burst\n${f3.format(data[0].BurstPPS)}", positionPercentageOffset: 0.05, angle: -60.0);
                    default: return const RadarChartTitle(text: '');
                    }
                  },
                  dataSets: [
                    for (MinomuncherData e in data) RadarDataSet(
                    fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                    borderColor: Theme.of(context).colorScheme.primary,
                    dataEntries: [
                      RadarEntry(value: e.PPS),
                      RadarEntry(value: e.PlonkPPS),
                      RadarEntry(value: e.upstackPPS),
                      RadarEntry(value: e.PPSCoeff), // variance
                      RadarEntry(value: e.downstackPPS),
                      RadarEntry(value: e.BurstPPS),
                    ],
                    ),
                    RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      RadarEntry(value: 2),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0)
                    ],
                    ),
                  ]
                  )
                  ),
                ),
                Center(child: SizedBox(width: 0.0, height: 16.0)),
              ],
            ),
            Column(
              children: [
                Text("Surge", style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
                Center(child: SizedBox(width: 0.0, height: 16.0)),
                SizedBox(
                  height: 330,
                  width: 330,
                  child: MyRadarChart(
                  RadarChartData(
                  radarShape: RadarShape.circle,
                  tickCount: 4,
                  radarBackgroundColor: Colors.black.withAlpha(170),
                  radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                  tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                  getTitle: (index, angle) {
                    switch (index) {
                    case 0: return RadarChartTitle(text: "APM\n${f2.format(data[0].surgeAPM)}", positionPercentageOffset: 0.05);
                    case 1: return RadarChartTitle(text: "PPS\n${f2.format(data[0].surgePPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 2: return RadarChartTitle(text: "Length\n${f2.format(data[0].surgeLength)}", positionPercentageOffset: 0.05, angle: -60.0);
                    case 3: return RadarChartTitle(text: "Rate\n${percentage.format(data[0].surgeRate)}", positionPercentageOffset: 0.05);
                    case 4: return RadarChartTitle(text: "Secs/DS\n${f2.format(data[0].surgeDS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 5: return RadarChartTitle(text: "Secs/Cheese\n${f2.format(data[0].surgeSecsPerCheese)}", positionPercentageOffset: 0.05, angle: -60.0);
                    default: return const RadarChartTitle(text: '');
                    }
                  },
                  dataSets: [
                    for (MinomuncherData e in data) RadarDataSet(
                    fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                    borderColor: Theme.of(context).colorScheme.primary,
                    dataEntries: [
                      RadarEntry(value: e.surgeAPM),
                      RadarEntry(value: e.surgePPS * 60),
                      RadarEntry(value: e.surgeLength * 30),
                      RadarEntry(value: e.surgeRate * 2000),
                      RadarEntry(value: e.surgeDS * 43),
                      RadarEntry(value: e.surgeSecsPerCheese! * 13)
                    ],
                    ),
                    RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      RadarEntry(value: 300),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0),
                      RadarEntry(value: 0)
                    ],
                    ),
                  ]
                  )
                  ),
                ),
                Center(child: SizedBox(width: 0.0, height: 16.0)),
              ],
            ),
          ],
        ),
      )
    );
  }
}