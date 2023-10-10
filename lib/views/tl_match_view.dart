import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:window_manager/window_manager.dart';


final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
int roundSelector = -1; // -1 = match averages, otherwise round number-1
List<DropdownMenuItem> rounds = []; // index zero will be match stats
late String oldWindowTitle;

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
    rounds = [DropdownMenuItem(value: -1, child: Text(t.match))];
    rounds.addAll([for (int i = 0; i < widget.record.endContext.first.secondaryTracking.length; i++) DropdownMenuItem(value: i, child: Text(t.roundNumber(n: i+1)))]);
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username.toUpperCase()} ${t.vs} ${widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username.toUpperCase()} ${t.inTLmatch} ${dateFormat.format(widget.record.timestamp)}");
    }
    super.initState();
  }

  @override
  void dispose(){
    roundSelector = -1;
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username.toUpperCase()} ${t.vs} ${widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username.toUpperCase()} ${t.inTLmatch} ${dateFormat.format(widget.record.timestamp)}"),
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
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: const [Colors.green, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).success ? 0.4 : 0.0],
                          )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(children: [
                              Text(widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username, style: bigScreen ? const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28) : const TextStyle()),
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
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: const [Colors.red, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.0, widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).success ? 0.4 : 0.0],
                          )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Column(children: [
                              Text(widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username, style:  bigScreen ? const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28) : const TextStyle()),
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
              SliverToBoxAdapter(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text("${t.statsFor}: ",
                      style: const TextStyle(color: Colors.white, fontSize: 25)),
                      DropdownButton(items: rounds, value: roundSelector, onChanged: ((value) {
                        roundSelector = value;
                        setState(() {});
                      }),),
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
                                  greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[roundSelector],
                                  redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[roundSelector],
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                                CompareThingy(
                                  label: "PPS",
                                  greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[roundSelector],
                                  redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[roundSelector],
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                                CompareThingy(
                                  label: "VS",
                                  greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[roundSelector],
                                  redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[roundSelector],
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
                            child: Text(t.nerdStats,
                                style: TextStyle(
                                    fontFamily: "Eurostile Round Extended",
                                    fontSize: bigScreen ? 42 : 28)),
                          ),
                          CompareThingy(
                            label: "APP",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.app : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].app,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.app : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].app,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "VS/APM",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.vsapm : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.vsapm : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/S",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dss : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dss,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dss : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dss,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/P",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dsp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dsp,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dsp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "APP + DS/P",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.appdsp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.appdsp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.cheese : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].cheese,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.cheese : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].cheese,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Gb Eff.",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.gbe : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].gbe,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.gbe : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].gbe,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "wAPP",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.nyaapp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].nyaapp,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.nyaapp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].nyaapp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Area",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.area : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].area,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.area : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].area,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: t.statCellNum.estOfTRShort,
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).estTr.esttr : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).estTrTracking[roundSelector].esttr,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).estTr.esttr : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).estTrTracking[roundSelector].esttr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Opener",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].opener,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].opener,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Plonk",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].plonk,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].plonk,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Stride",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.stride : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].stride,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.stride : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].stride,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Inf. DS",
                            greenSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].infds,
                            redSide: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].infds,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            spacing: 25,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            clipBehavior: Clip.hardEdge,
                            children: [Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                          fillColor: const Color.fromARGB(
                                              115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary * apmWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[roundSelector] * apmWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary * ppsWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[roundSelector] * ppsWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra * vsWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[roundSelector] * vsWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.app * appWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].app * appWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dss * dssWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dss * dssWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dsp * dspWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dsp * dspWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.appdsp * appdspWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp * appdspWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.vsapm * vsapmWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm * vsapmWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.cheese * cheeseWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].cheese * cheeseWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.gbe * gbeWeight : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].gbe),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary * apmWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[roundSelector] * apmWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary * ppsWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[roundSelector] * ppsWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra * vsWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[roundSelector] * vsWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.app * appWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].app * appWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dss * dssWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dss * dssWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dsp * dspWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dsp * dspWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.appdsp * appdspWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp * appdspWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.vsapm * vsapmWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm * vsapmWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.cheese * cheeseWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].cheese * cheeseWeight),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.gbe * gbeWeight : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].gbe * gbeWeight),
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
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: SizedBox(
                                height: 310,
                                width: 310,
                                child: RadarChart(RadarChartData(
                                  radarShape: RadarShape.polygon,
                                  tickCount: 4,
                                  ticksTextStyle: const TextStyle(color: Colors.white24, fontSize: 10),
                                  radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                  tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  titleTextStyle: const TextStyle(height: 1.1),
                                      getTitle: (index, angle) {
                                        switch (index) {
                                          case 0:
                                            return RadarChartTitle(text: 'Opener', angle: angle, positionPercentageOffset: 0.05);
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
                                          fillColor: const Color.fromARGB(
                                              115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].opener),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.stride : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].stride),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].infds),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].plonk),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].opener),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.stride : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].stride),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].infds),
                                            RadarEntry(value: roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].plonk),
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
    NumberFormat f = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits ?? 0);
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
