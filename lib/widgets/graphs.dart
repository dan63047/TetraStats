import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class Graphs extends StatelessWidget{
  const Graphs(
    this.apm,
    this.pps,
    this.vs,
    this.nerdStats,
    this.playstyle, {super.key}
  );

  final double apm;
  final double pps;
  final double vs;
  final NerdStats nerdStats;
  final Playstyle playstyle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 25,
      crossAxisAlignment: WrapCrossAlignment.start,
      clipBehavior: Clip.hardEdge,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
          child: SizedBox(
            height: 310,
            width: 310,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return RadarChartTitle(text: 'APM', angle: angle, positionPercentageOffset: 0.05);
                    case 1:
                      return RadarChartTitle(text: 'PPS', angle: angle, positionPercentageOffset: 0.05);
                    case 2:
                      return RadarChartTitle(text: 'VS', angle: angle, positionPercentageOffset: 0.05);
                    case 3:
                      return RadarChartTitle(text: 'APP', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 4:
                      return RadarChartTitle(text: 'DS/S', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 5:
                      return RadarChartTitle(text: 'DS/P', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 6:
                      return RadarChartTitle(text: 'APP+DS/P', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 7:
                      return RadarChartTitle(text: 'VS/APM', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 8:
                      return RadarChartTitle(text: 'Cheese', angle: angle, positionPercentageOffset: 0.05);
                    case 9:
                      return RadarChartTitle(text: 'Gb Eff.', angle: angle, positionPercentageOffset: 0.05);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: apm * apmWeight),
                      RadarEntry(value: pps * ppsWeight),
                      RadarEntry(value: vs * vsWeight),
                      RadarEntry(value: nerdStats.app * appWeight),
                      RadarEntry(value: nerdStats.dss * dssWeight),
                      RadarEntry(value: nerdStats.dsp * dspWeight),
                      RadarEntry(value: nerdStats.appdsp * appdspWeight),
                      RadarEntry(value: nerdStats.vsapm * vsapmWeight),
                      RadarEntry(value: nerdStats.cheese * cheeseWeight),
                      RadarEntry(value: nerdStats.gbe * gbeWeight),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                    ],
                  )
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
          child: SizedBox(
            height: 310,
            width: 310,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.white24, fontSize: 10),
                radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                titleTextStyle: const TextStyle(height: 1.1),
                radarTouchData: RadarTouchData(),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return RadarChartTitle(text: 'Opener\n${percentage.format(playstyle.opener)}', angle: 0, positionPercentageOffset: 0.05);
                    case 1:
                      return RadarChartTitle(text: 'Stride\n${percentage.format(playstyle.stride)}', angle: 0, positionPercentageOffset: 0.05);
                    case 2:
                      return RadarChartTitle(text: 'Inf Ds\n${percentage.format(playstyle.infds)}', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 3:
                      return RadarChartTitle(text: 'Plonk\n${percentage.format(playstyle.plonk)}', angle: 0, positionPercentageOffset: 0.05);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: playstyle.opener),
                      RadarEntry(value: playstyle.stride),
                      RadarEntry(value: playstyle.infds),
                      RadarEntry(value: playstyle.plonk),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      const RadarEntry(value: 1),
                      const RadarEntry(value: 1),
                      const RadarEntry(value: 1),
                      const RadarEntry(value: 1),
                    ],
                  )
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          ),
        ),
      ],
    );
  }

}