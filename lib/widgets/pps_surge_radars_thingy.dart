import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/minomuncher.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/cheese_ds_ratio_thingy.dart';
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
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10.0,
          runSpacing: 10.0,
          runAlignment: WrapAlignment.start,
          children: [
            Column(
              children: [
                Text(t.stats.pps.short, style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
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
                    case 0: return RadarChartTitle(text: "${t.stats.overall}\n${f3.format(data[0].PPS)}", positionPercentageOffset: 0.05);
                    case 1: return RadarChartTitle(text: "${t.stats.plonk.full}\n${f3.format(data[0].PlonkPPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 2: return RadarChartTitle(text: "${t.stats.upstack}\n${f3.format(data[0].upstackPPS)}", positionPercentageOffset: 0.05, angle: -60.0);
                    case 3: return RadarChartTitle(text: "${t.stats.variance}\n${f3.format(data[0].PPSCoeff)}", positionPercentageOffset: 0.05);
                    case 4: return RadarChartTitle(text: "${t.stats.downstack}\n${f3.format(data[0].downstackPPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 5: return RadarChartTitle(text: "${t.stats.burst}\n${f3.format(data[0].BurstPPS)}", positionPercentageOffset: 0.05, angle: -60.0);
                    default: return const RadarChartTitle(text: '');
                    }
                  },
                  dataSets: [
                    for (int i = 0; i < data.length; i++) RadarDataSet(
                    fillColor: data.length == 1 ? Theme.of(context).colorScheme.primary.withAlpha(170) : palette[i].withAlpha(170),
                    borderColor: data.length == 1 ? Theme.of(context).colorScheme.primary : palette[i],
                    dataEntries: [
                      RadarEntry(value: data[i].PPS),
                      RadarEntry(value: data[i].PlonkPPS),
                      RadarEntry(value: data[i].upstackPPS),
                      RadarEntry(value: data[i].PPSCoeff), // variance
                      RadarEntry(value: data[i].downstackPPS),
                      RadarEntry(value: data[i].BurstPPS),
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
                Text(t.calcDestination.surge, style: width > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
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
                    case 0: return RadarChartTitle(text: "${t.stats.apm.short}\n${f2.format(data[0].surgeAPM)}", positionPercentageOffset: 0.05);
                    case 1: return RadarChartTitle(text: "${t.stats.pps.short}\n${f2.format(data[0].surgePPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 2: return RadarChartTitle(text: "${t.stats.length}\n${f2.format(data[0].surgeLength)}", positionPercentageOffset: 0.05, angle: -60.0);
                    case 3: return RadarChartTitle(text: "${t.stats.rate}\n${percentage.format(data[0].surgeRate)}", positionPercentageOffset: 0.05);
                    case 4: return RadarChartTitle(text: "${t.stats.secsDS}\n${f2.format(data[0].surgeDS)}", positionPercentageOffset: 0.05, angle: 60.0);
                    case 5: return RadarChartTitle(text: "${t.stats.secsCheese}\n${f2.format(data[0].surgeSecsPerCheese)}", positionPercentageOffset: 0.05, angle: -60.0);
                    default: return const RadarChartTitle(text: '');
                    }
                  },
                  dataSets: [
                    for (int i = 0; i < data.length; i++) RadarDataSet(
                    fillColor: data.length == 1 ? Theme.of(context).colorScheme.primary.withAlpha(170) : palette[i].withAlpha(170),
                    borderColor: data.length == 1 ? Theme.of(context).colorScheme.primary : palette[i],
                    dataEntries: [
                      RadarEntry(value: data[i].surgeAPM),
                      RadarEntry(value: data[i].surgePPS * 60),
                      RadarEntry(value: data[i].surgeLength * 30),
                      RadarEntry(value: data[i].surgeRate * 2000),
                      RadarEntry(value: data[i].surgeDS * 43),
                      RadarEntry(value: data[i].surgeSecsPerCheese! * 13)
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