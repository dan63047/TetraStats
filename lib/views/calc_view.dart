import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:window_manager/window_manager.dart';

double? apm;
double? pps;
double? vs;
NerdStats? nerdStats;
EstTr? estTr;
Playstyle? playstyle;
final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
late String oldWindowTitle;

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
    if (!Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.statsCalc}");
    } 
    super.initState();
  }

  @override
  void dispose() {
    if (!Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void calc() {
    apm = double.tryParse(apmController.text);
    pps = double.tryParse(ppsController.text);
    vs = double.tryParse(vsController.text);
    if (apm != null && pps != null && vs != null) {
      nerdStats = NerdStats(apm!, pps!, vs!);
      estTr = EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp, nerdStats!.gbe);
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
                                        return RadarChartTitle(text: 'Opener\n${f2.format(playstyle!.opener)}', angle: 0, positionPercentageOffset: 0.05);
                                      case 1:
                                        return RadarChartTitle(text: 'Stride\n${f2.format(playstyle!.stride)}', angle: 0, positionPercentageOffset: 0.05);
                                      case 2:
                                        return RadarChartTitle(text: 'Inf Ds\n${f2.format(playstyle!.infds)}', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 3:
                                        return RadarChartTitle(text: 'Plonk\n${f2.format(playstyle!.plonk)}', angle: 0, positionPercentageOffset: 0.05);
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
    NumberFormat f = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits ?? 0);
    return ListTile(title: Text(label), trailing: Text(f.format(value), style: const TextStyle(fontSize: 22)));
  }
}
