import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:window_manager/window_manager.dart';

double? apm;
double? pps;
double? vs;
NerdStats? nerdStats;
EstTr? estTr;
Playstyle? playstyle;
late String oldWindowTitle;

class CalcView extends StatefulWidget {
  const CalcView({super.key});

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
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.statsCalc}");
    } 
    super.initState();
  }

  @override
  void dispose() {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Column(children: [
              Padding(
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
              Divider(),
              if (nerdStats == null) Text(t.calcViewNoValues)
              else Column(children: [
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
                Graphs(apm!, pps!, vs!, nerdStats!, playstyle!)
              ],)
            ],),
          ),
        ),
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
