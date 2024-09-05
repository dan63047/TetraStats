import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/widgets/graphs.dart' show MyRadarChart;
import 'package:tetra_stats/gen/strings.g.dart';

class VsGraphs extends StatelessWidget{
  final double greenAPM;
  final double greenPPS;
  final double greenVS;
  final NerdStats greenNerdStats;
  final Playstyle greenPlaystyle;
  final double redAPM;
  final double redPPS;
  final double redVS;
  final NerdStats redNerdStats;
  final Playstyle redPlaystyle;

  const VsGraphs(this.greenAPM, this.greenPPS, this.greenVS, this.greenNerdStats, this.greenPlaystyle, this.redAPM, this.redPPS, this.redVS, this.redNerdStats, this.redPlaystyle, {super.key});
  
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
        child: MyRadarChart(
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
                  return RadarChartTitle(
                    text: 'APM',
                    angle: angle,
                    positionPercentageOffset: 0.05
                  );
                case 1:
                  return RadarChartTitle(
                    text: 'PPS',
                    angle: angle,
                    positionPercentageOffset: 0.05
                  );
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
                    fillColor: const Color.fromARGB(115, 76, 175, 79),
                    borderColor: Colors.green,
                    dataEntries: [
                      RadarEntry(value: greenAPM * apmWeight),
                      RadarEntry(value: greenPPS * ppsWeight),
                      RadarEntry(value: greenVS * vsWeight),
                      RadarEntry(value: greenNerdStats.app * appWeight),
                      RadarEntry(value: greenNerdStats.dss * dssWeight),
                      RadarEntry(value: greenNerdStats.dsp * dspWeight),
                      RadarEntry(value: greenNerdStats.appdsp * appdspWeight),
                      RadarEntry(value: greenNerdStats.vsapm * vsapmWeight),
                      RadarEntry(value: greenNerdStats.cheese * cheeseWeight),
                      RadarEntry(value: greenNerdStats.gbe * gbeWeight),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: const Color.fromARGB(115, 244, 67, 54),
                    borderColor: Colors.red,
                    dataEntries: [
                      RadarEntry(value: redAPM * apmWeight),
                      RadarEntry(value: redPPS * ppsWeight),
                      RadarEntry(value: redVS * vsWeight),
                      RadarEntry(value: redNerdStats.app * appWeight),
                      RadarEntry(value: redNerdStats.dss * dssWeight),
                      RadarEntry(value: redNerdStats.dsp * dspWeight),
                      RadarEntry(value: redNerdStats.appdsp * appdspWeight),
                      RadarEntry(value: redNerdStats.vsapm * vsapmWeight),
                      RadarEntry(value: redNerdStats.cheese * cheeseWeight),
                      RadarEntry(value: redNerdStats.gbe * gbeWeight),
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
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),
        ),
        Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
      child: SizedBox(
        height: 310,
        width: 310,
        child: MyRadarChart(
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
                      return RadarChartTitle(text: 'Opener',angle: angle, positionPercentageOffset: 0.05);
                    case 1:
                      return RadarChartTitle(text: 'Stride', angle: angle, positionPercentageOffset: 0.05);
                    case 2:
                      return RadarChartTitle(text: 'Inf Ds', angle: angle + 180, positionPercentageOffset: 0.05);
                    case 3:
                      return RadarChartTitle(text: 'Plonk', angle: angle, positionPercentageOffset: 0.05);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color.fromARGB(115, 76, 175, 79),
                    borderColor: Colors.green,
                    dataEntries: [
                      RadarEntry(value: greenPlaystyle.opener),
                      RadarEntry(value: greenPlaystyle.stride),
                      RadarEntry(value: greenPlaystyle.infds),
                      RadarEntry(value: greenPlaystyle.plonk),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: const Color.fromARGB(115, 244, 67, 54),
                    borderColor: Colors.red,
                    dataEntries: [
                      RadarEntry(value: redPlaystyle.opener),
                      RadarEntry(value: redPlaystyle.stride),
                      RadarEntry(value: redPlaystyle.infds),
                      RadarEntry(value: redPlaystyle.plonk),
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
        Padding( // sq graph
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
          child: SizedBox(
            height: 310,
            width: 310,
            child: MyRadarChart(
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
                      return RadarChartTitle(text: t.graphs.attack, angle: 0, positionPercentageOffset: 0.05);
                    case 1:
                      return RadarChartTitle(text: t.graphs.speed, angle: 0, positionPercentageOffset: 0.05);
                    case 2:
                      return RadarChartTitle(text: t.graphs.defense, angle: angle + 180, positionPercentageOffset: 0.05);
                    case 3:
                      return RadarChartTitle(text: t.graphs.cheese, angle: 0, positionPercentageOffset: 0.05);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color.fromARGB(115, 76, 175, 79),
                    borderColor: Colors.green,
                    dataEntries: [
                      RadarEntry(value: greenAPM / 60 * 0.4),
                      RadarEntry(value: greenPPS / 3.75),
                      RadarEntry(value: greenNerdStats.dss * 1.15),
                      RadarEntry(value: greenNerdStats.cheese / 110),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: const Color.fromARGB(115, 244, 67, 54),
                    borderColor: Colors.red,
                    dataEntries: [
                      RadarEntry(value: redAPM / 60 * 0.4),
                      RadarEntry(value: redPPS / 3.75),
                      RadarEntry(value: redNerdStats.dss * 1.15),
                      RadarEntry(value: redNerdStats.cheese / 110),
                    ],
                  ),
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    dataEntries: [
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 1.2),
                      const RadarEntry(value: 0),
                      const RadarEntry(value: 0),
                    ],
                  )
                ],
              )
            )
          )
        )
      ],
    );
  }
}