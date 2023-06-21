import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';


final DateFormat dateFormat = DateFormat.yMMMd().add_Hms();

class TlMatchResultView extends StatefulWidget {
  final TetraLeagueAlphaRecord record;
  final String initPlayerId;
  const TlMatchResultView({Key? key, required this.record, required this.initPlayerId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TlMatchResultState();
}

class TlMatchResultState extends State<TlMatchResultView> {
  late ScrollController _scrollController;

  @override
  void initState(){
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username.toUpperCase()} vs. ${widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username.toUpperCase()} in TL match ${dateFormat.format(widget.record.timestamp!)}"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            colors: [Colors.green, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, 0.4],
                          )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(children: [
                              Text(widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username, style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28)),
                              Text(widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).points.toString(), style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 42))
                            ]),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text("VS"),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            colors: [Colors.red, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, 0.4],
                          )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(children: [
                              Text(widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username, style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28)),
                              Text(widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).points.toString(), style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 42))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(),
              )
            ];
          },
          body: ListView(
                  children: [
                    Column(
                            children: [
                                CompareThingy(
                                  label: "APM",
                                  greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary,
                                  redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                                CompareThingy(
                                  label: "PPS",
                                  greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary,
                                  redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                                CompareThingy(
                                  label: "VS",
                                  greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra,
                                  redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                            ],
                          ),
                    const Divider(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text("Nerd Stats",
                                style: TextStyle(
                                    fontFamily: "Eurostile Round Extended",
                                    fontSize: bigScreen ? 42 : 28)),
                          ),
                          CompareThingy(
                            label: "APP",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.app,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.app,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "VS/APM",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.vsapm,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.vsapm,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/S",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dss,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dss,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/P",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dsp,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "APP + DS/P",
                            greenSide:
                                widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.appdsp,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Cheese",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.cheese,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.cheese,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Garbage Eff.",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.gbe,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.gbe,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Weighted APP",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.nyaapp,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.nyaapp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Area",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.area,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.area,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Est. of TR",
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).estTr.esttr,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).estTr.esttr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceAround,
                            spacing: 25,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: RadarChart(
                                    RadarChartData(
                                      radarShape: RadarShape.polygon,
                                      tickCount: 4,
                                      ticksTextStyle: const TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 10),
                                      radarBorderData: const BorderSide(
                                          color: Colors.transparent, width: 1),
                                      gridBorderData: const BorderSide(
                                          color: Colors.white24, width: 1),
                                      tickBorderData: const BorderSide(
                                          color: Colors.transparent, width: 1),
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
                                            return RadarChartTitle(
                                                text: 'VS', angle: angle);
                                          case 3:
                                            return RadarChartTitle(
                                                text: 'APP',
                                                angle: angle + 180);
                                          case 4:
                                            return RadarChartTitle(
                                                text: 'DS/S',
                                                angle: angle + 180);
                                          case 5:
                                            return RadarChartTitle(
                                                text: 'DS/P',
                                                angle: angle + 180);
                                          case 6:
                                            return RadarChartTitle(
                                                text: 'APP+DS/P',
                                                angle: angle + 180);
                                          case 7:
                                            return RadarChartTitle(
                                                text: 'VS/APM',
                                                angle: angle + 180);
                                          case 8:
                                            return RadarChartTitle(
                                                text: 'Cheese', angle: angle);
                                          case 9:
                                            return RadarChartTitle(
                                                text: 'Gb Eff.', angle: angle);
                                          default:
                                            return const RadarChartTitle(
                                                text: '');
                                        }
                                      },
                                      dataSets: [
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary * apmWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary * ppsWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra * vsWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.app * appWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dss * dssWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dsp * dspWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.appdsp * appdspWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.vsapm * vsapmWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.cheese * cheeseWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.gbe * gbeWeight),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary * apmWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary * ppsWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra * vsWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.app * appWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dss * dssWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dsp * dspWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.appdsp * appdspWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.vsapm * vsapmWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.cheese * cheeseWeight),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.gbe * gbeWeight),
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
                                    swapAnimationDuration: const Duration(
                                        milliseconds: 150), // Optional
                                    swapAnimationCurve:
                                        Curves.linear, // Optional
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: RadarChart(
                                    RadarChartData(
                                      radarShape: RadarShape.polygon,
                                      tickCount: 4,
                                      ticksTextStyle: const TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 10),
                                      radarBorderData: const BorderSide(
                                          color: Colors.transparent, width: 1),
                                      gridBorderData: const BorderSide(
                                          color: Colors.white24, width: 1),
                                      tickBorderData: const BorderSide(
                                          color: Colors.transparent, width: 1),
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
                                            return RadarChartTitle(
                                                text: 'Inf Ds',
                                                angle: angle + 180);
                                          case 3:
                                            return RadarChartTitle(
                                                text: 'Plonk', angle: angle);
                                          default:
                                            return const RadarChartTitle(
                                                text: '');
                                        }
                                      },
                                      dataSets: [
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.opener),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.stride),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.infds),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.plonk),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.opener),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.stride),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.infds),
                                            RadarEntry(value: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.plonk),
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
                                    swapAnimationDuration: const Duration(
                                        milliseconds: 150), // Optional
                                    swapAnimationCurve:
                                        Curves.linear, // Optional
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  ],
                )
        ),
      ),
    );
  }
}


class CompareThingy extends StatelessWidget {
  final num greenSide;
  final num redSide;
  final String label;
  final bool higherIsBetter;
  final int? fractionDigits;
  const CompareThingy(
      {super.key,
      required this.greenSide,
      required this.redSide,
      required this.label,
      required this.higherIsBetter,
      this.fractionDigits});

  String verdict(num greenSide, num redSide, int fraction) {
    var f = NumberFormat("+#,###.##;-#,###.##");
    f.maximumFractionDigits = fraction;
    return f.format((greenSide - redSide));
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###.##");
    f.maximumFractionDigits = fractionDigits ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [Colors.green, Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.0,
                higherIsBetter
                    ? greenSide > redSide
                        ? 0.6
                        : 0
                    : greenSide < redSide
                        ? 0.6
                        : 0
              ],
            )),
            child: Text(
              f.format(greenSide),
              style: const TextStyle(
                fontSize: 22,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          )),
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Text(
                verdict(greenSide, redSide,
                    fractionDigits != null ? fractionDigits! + 2 : 0),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [Colors.red, Colors.transparent],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [
                0.0,
                higherIsBetter
                    ? redSide > greenSide
                        ? 0.6
                        : 0
                    : redSide < greenSide
                        ? 0.6
                        : 0
              ],
            )),
            child: Text(
              f.format(redSide),
              style: const TextStyle(
                fontSize: 22,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.end,
            ),
          )),
        ],
      ),
    );
  }
}

class CompareBoolThingy extends StatelessWidget {
  final bool greenSide;
  final bool redSide;
  final String label;
  final bool trueIsBetter;
  const CompareBoolThingy(
      {super.key,
      required this.greenSide,
      required this.redSide,
      required this.label,
      required this.trueIsBetter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Row(children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: const [Colors.green, Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [
              0.0,
              trueIsBetter
                  ? greenSide
                      ? 0.6
                      : 0
                  : !greenSide
                      ? 0.6
                      : 0
            ],
          )),
          child: Text(
            greenSide ? "Yes" : "No",
            style: const TextStyle(
              fontSize: 22,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 8.0,
                  color: Colors.black,
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        )),
        Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const Text(
              "---",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: const [Colors.red, Colors.transparent],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: [
              0.0,
              trueIsBetter
                  ? redSide
                      ? 0.6
                      : 0
                  : !redSide
                      ? 0.6
                      : 0
            ],
          )),
          child: Text(
            redSide ? "Yes" : "No",
            style: const TextStyle(
              fontSize: 22,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 8.0,
                  color: Colors.black,
                ),
              ],
            ),
            textAlign: TextAlign.end,
          ),
        )),
      ]),
    );
  }
}

class CompareDurationThingy extends StatelessWidget {
  final Duration greenSide;
  final Duration redSide;
  final String label;
  final bool higherIsBetter;
  const CompareDurationThingy(
      {super.key,
      required this.greenSide,
      required this.redSide,
      required this.label,
      required this.higherIsBetter});

  Duration verdict(Duration greenSide, Duration redSide) {
    return greenSide - redSide;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            greenSide.toString(),
            style: const TextStyle(
              fontSize: 22,
            ),
            textAlign: TextAlign.start,
          )),
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                verdict(greenSide, redSide).toString(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
              child: Text(
            redSide.toString(),
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }
}

class CompareRegTimeThingy extends StatelessWidget {
  final DateTime? greenSide;
  final DateTime? redSide;
  final String label;
  final int? fractionDigits;
  const CompareRegTimeThingy(
      {super.key,
      required this.greenSide,
      required this.redSide,
      required this.label,
      this.fractionDigits});

  String verdict(DateTime? greenSide, DateTime? redSide) {
    var f = NumberFormat("#,### days later;#,### days before");
    String result = "---";
    if (greenSide != null && redSide != null)
      result = f.format(greenSide.difference(redSide).inDays);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    DateFormat f = DateFormat.yMMMd();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [Colors.green, Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.0,
                greenSide == null
                    ? 0.6
                    : redSide != null && greenSide!.isBefore(redSide!)
                        ? 0.6
                        : 0
              ],
            )),
            child: Text(
              greenSide != null ? f.format(greenSide!) : "From beginning",
              style: const TextStyle(
                fontSize: 22,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          )),
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Text(
                verdict(greenSide, redSide),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [Colors.red, Colors.transparent],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [
                0.0,
                redSide == null
                    ? 0.6
                    : greenSide != null && redSide!.isBefore(greenSide!)
                        ? 0.6
                        : 0
              ],
            )),
            child: Text(
              redSide != null ? f.format(redSide!) : "From beginning",
              style: const TextStyle(
                fontSize: 22,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.end,
            ),
          )),
        ],
      ),
    );
  }
}
