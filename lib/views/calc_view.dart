import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';

double? apm;
double? pps;
double? vs;
NerdStats? nerdStats;
EstTr? estTr;
Playstyle? playstyle;

class CalcView extends StatefulWidget {
  const CalcView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalcState();
}

class CalcState extends State<CalcView> {
  late ScrollController _scrollController;
  TextEditingController ppsController = TextEditingController();
  TextEditingController apmController = TextEditingController();
  TextEditingController vsController = TextEditingController();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void calc() {
    apm = double.tryParse(apmController.text);
    pps = double.tryParse(ppsController.text);
    vs = double.tryParse(vsController.text);
    if (apm != null && pps != null && vs != null) {
      nerdStats = NerdStats(apm!, pps!, vs!);
      estTr = EstTr(apm!, pps!, vs!, 60.9, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp, nerdStats!.gbe);
      playstyle = Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm, nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please, enter valid values")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.statsCalc),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 16, 32),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: TextField(
                            onSubmitted: (value) => calc(),
                            controller: apmController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(label: Text("APM"), alignLabelWithHint: true),
                          ),
                        )),
                        Expanded(
                            child: TextField(
                          onSubmitted: (value) => calc(),
                          controller: ppsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(label: Text("PPS"), alignLabelWithHint: true),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: TextField(
                            onSubmitted: (value) => calc(),
                            controller: vsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(label: Text("VS"), alignLabelWithHint: true),
                          ),
                        )),
                        TextButton(
                          onPressed: () => calc(),
                          child: Text(t.calc),
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
            body: nerdStats == null
                ? Text(t.calcViewNoValues)
                : ListView(
                    children: [
                      _ListEntry(value: nerdStats!.app, label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.vsapm, label: "VS/APM", fractionDigits: 3),
                      _ListEntry(value: nerdStats!.dss, label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.dsp, label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.appdsp, label: "APP + DS/P", fractionDigits: 3),
                      _ListEntry(value: nerdStats!.cheese, label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.gbe, label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.nyaapp, label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: nerdStats!.area, label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "), fractionDigits: 3),
                      _ListEntry(value: estTr!.esttr, label: t.statCellNum.estOfTR, fractionDigits: 3),
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
                                        RadarEntry(value: apm! * 1),
                                        RadarEntry(value: pps! * 45),
                                        RadarEntry(value: vs! * 0.444),
                                        RadarEntry(value: nerdStats!.app * 185),
                                        RadarEntry(value: nerdStats!.dss * 175),
                                        RadarEntry(value: nerdStats!.dsp * 450),
                                        RadarEntry(value: nerdStats!.appdsp * 140),
                                        RadarEntry(value: nerdStats!.vsapm * 60),
                                        RadarEntry(value: nerdStats!.cheese * 1.25),
                                        RadarEntry(value: nerdStats!.gbe * 315),
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
                                        RadarEntry(value: playstyle!.opener),
                                        RadarEntry(value: playstyle!.stride),
                                        RadarEntry(value: playstyle!.infds),
                                        RadarEntry(value: playstyle!.plonk),
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
                    ],
                  )),
      ),
    );
  }
}

class _ListEntry extends StatelessWidget {
  final double value;
  final String label;
  final int? fractionDigits;
  const _ListEntry({required this.value, required this.label, this.fractionDigits});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###.##");
    f.maximumFractionDigits = fractionDigits ?? 0;
    return ListTile(title: Text(label), trailing: Text(f.format(value), style: const TextStyle(fontSize: 22)));
  }
}
