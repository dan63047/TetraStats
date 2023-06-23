import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");
final NumberFormat f2 = NumberFormat.decimalPatternDigits(decimalDigits: 2);

class TLThingy extends StatelessWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  const TLThingy({Key? key, required this.tl, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: (tl.gamesPlayed > 0)
                ? [
                    Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (tl.gamesPlayed >= 10)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          userID == "5e32fc85ab319c2ab1beb07c" // he love her so much, you can't even imagine
                              ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
                              : Image.asset("res/tetrio_tl_alpha_ranks/${tl.rank}.png", height: 128),
                          Column(
                            children: [
                              Text("${f2.format(tl.rating)} TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              Text(
                                "Top ${f2.format(tl.percentile * 100)}% (${tl.percentileRank.toUpperCase()}) • Top Rank: ${tl.bestRank.toUpperCase()} • Glicko: ${f2.format(tl.glicko!)}±${f2.format(tl.rd!)}${tl.decaying ? ' • Decaying' : ''}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Text("${10 - tl.gamesPlayed} games until being ranked",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: bigScreen ? 42 : 28,
                            overflow: TextOverflow.visible,
                          )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          if (tl.apm != null)
                            StatCellNum(playerStat: tl.apm!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Attack\nPer Minute"),
                          if (tl.pps != null)
                            StatCellNum(playerStat: tl.pps!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Pieces\nPer Second"),
                          if (tl.apm != null) StatCellNum(playerStat: tl.vs!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Versus\nScore"),
                          if (tl.standing > 0) StatCellNum(playerStat: tl.standing, isScreenBig: bigScreen, playerStatLabel: "Leaderboard\nplacement"),
                          if (tl.standingLocal > 0) StatCellNum(playerStat: tl.standingLocal, isScreenBig: bigScreen, playerStatLabel: "Country LB\nplacement"),
                          StatCellNum(playerStat: tl.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: "Games\nplayed"),
                          StatCellNum(playerStat: tl.gamesWon, isScreenBig: bigScreen, playerStatLabel: "Games\nwon"),
                          StatCellNum(playerStat: tl.winrate * 100, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Winrate\nprecentage"),
                        ],
                      ),
                    ),
                    if (tl.nerdStats != null)
                      Column(
                        children: [
                          Text("Nerd Stats", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                            child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                spacing: 25,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  StatCellNum(playerStat: tl.nerdStats!.app, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Attack\nPer Piece"),
                                  StatCellNum(playerStat: tl.nerdStats!.vsapm, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "VS/APM"),
                                  StatCellNum(
                                      playerStat: tl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Second"),
                                  StatCellNum(
                                      playerStat: tl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Piece"),
                                  StatCellNum(playerStat: tl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "APP + DS/P"),
                                  StatCellNum(playerStat: tl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Cheese\nIndex"),
                                  StatCellNum(playerStat: tl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Garbage\nEfficiency"),
                                  StatCellNum(playerStat: tl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Weighted\nAPP"),
                                  StatCellNum(playerStat: tl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: "Area")
                                ]),
                          )
                        ],
                      ),
                    if (tl.estTr != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                        child: SizedBox(
                          width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Est. of TR:",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    f2.format(tl.estTr!.esttr),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              if (tl.rating >= 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Accuracy:",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      fDiff.format(tl.esttracc!),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (tl.nerdStats != null)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                            child: SizedBox(
                              height: 300,
                              width: 300,
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
                                        return RadarChartTitle(
                                          text: 'APM',
                                          angle: angle,
                                        );
                                      case 1:
                                        return RadarChartTitle(
                                          text: 'PPS',
                                          angle: angle,
                                        );
                                      case 2:
                                        return RadarChartTitle(text: 'VS', angle: angle);
                                      case 3:
                                        return RadarChartTitle(text: 'APP', angle: angle + 180);
                                      case 4:
                                        return RadarChartTitle(text: 'DS/S', angle: angle + 180);
                                      case 5:
                                        return RadarChartTitle(text: 'DS/P', angle: angle + 180);
                                      case 6:
                                        return RadarChartTitle(text: 'APP+DS/P', angle: angle + 180);
                                      case 7:
                                        return RadarChartTitle(text: 'VS/APM', angle: angle + 180);
                                      case 8:
                                        return RadarChartTitle(text: 'Cheese', angle: angle);
                                      case 9:
                                        return RadarChartTitle(text: 'Gb Eff.', angle: angle);
                                      default:
                                        return const RadarChartTitle(text: '');
                                    }
                                  },
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: [
                                        RadarEntry(value: tl.apm! * apmWeight),
                                        RadarEntry(value: tl.pps! * ppsWeight),
                                        RadarEntry(value: tl.vs! * vsWeight),
                                        RadarEntry(value: tl.nerdStats!.app * appWeight),
                                        RadarEntry(value: tl.nerdStats!.dss * dssWeight),
                                        RadarEntry(value: tl.nerdStats!.dsp * dspWeight),
                                        RadarEntry(value: tl.nerdStats!.appdsp * appdspWeight),
                                        RadarEntry(value: tl.nerdStats!.vsapm * vsapmWeight),
                                        RadarEntry(value: tl.nerdStats!.cheese * cheeseWeight),
                                        RadarEntry(value: tl.nerdStats!.gbe * gbeWeight),
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
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                            child: SizedBox(
                              height: 300,
                              width: 300,
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
                                        return RadarChartTitle(
                                          text: 'Opener',
                                          angle: angle,
                                        );
                                      case 1:
                                        return RadarChartTitle(
                                          text: 'Stride',
                                          angle: angle,
                                        );
                                      case 2:
                                        return RadarChartTitle(text: 'Inf Ds', angle: angle + 180);
                                      case 3:
                                        return RadarChartTitle(text: 'Plonk', angle: angle);
                                      default:
                                        return const RadarChartTitle(text: '');
                                    }
                                  },
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: [
                                        RadarEntry(value: tl.playstyle!.opener),
                                        RadarEntry(value: tl.playstyle!.stride),
                                        RadarEntry(value: tl.playstyle!.infds),
                                        RadarEntry(value: tl.playstyle!.plonk),
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
                      )
                  ]
                : [
                    const Text("That user never played Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                  ],
          );
        },
      );
    });
  }
}
