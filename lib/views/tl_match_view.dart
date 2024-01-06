// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:tetra_stats/data_objects/tetrio_multiplayer_replay.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/compare_view.dart' show CompareThingy, CompareBoolThingy;
import 'package:tetra_stats/widgets/vs_graphs.dart';
import 'main_view.dart' show teto, secs;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:window_manager/window_manager.dart';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' show AnchorElement, document;


final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
int roundSelector = -1; // -1 = match averages, otherwise round number-1
List<DropdownMenuItem> rounds = []; // index zero will be match stats
late String oldWindowTitle;

Duration framesToTime(int frames){
  return Duration(microseconds: frames~/6e-5);
}

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
  late Future<ReplayData?> replayData;

  @override
  void initState(){
    _scrollController = ScrollController();
    rounds = [DropdownMenuItem(value: -1, child: Text(t.match))];
    rounds.addAll([for (int i = 0; i < widget.record.endContext.first.secondaryTracking.length; i++) DropdownMenuItem(value: i, child: Text(t.roundNumber(n: i+1)))]);
    replayData = teto.analyzeReplay(widget.record.replayId);
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
        actions: [
          PopupMenuButton(
            enabled: widget.record.replayAvalable,
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 1,
                child: Text(t.downloadReplay),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(t.openReplay),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 1:
                  if (kIsWeb){
                    // final _base64 = base64Encode([1,2,3,4,5]);
                    // final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$_base64')..target = 'blank';
                    //final anchor = AnchorElement(href: 'https://inoue.szy.lol/api/replay/${widget.record.replayId}')..target = 'blank';
                    //anchor.download = "${widget.record.replayId}.ttrm";
                    //document.body!.append(anchor);
                    //anchor.click();
                    //anchor.remove();
                  } else{
                    try{
                      String path = await teto.SaveReplay(widget.record.replayId);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.replaySaved(path: path))));
                    } on TetrioReplayAlreadyExist{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.replayAlreadySaved)));
                    } on SzyNotFound {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.replayExpired)));
                    } on SzyForbidden {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.replayRejected)));
                    } on SzyTooManyRequests {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errors.tooManyRequests)));
                    }
                  }
                  break;
                case 2:
                  await launchInBrowser(Uri.parse("https://tetr.io/#r:${widget.record.replayId}"));
                  break;
                default:
              }
            })
        ]
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
              SliverToBoxAdapter(child: FutureBuilder(future: replayData, builder: (context, snapshot) {
                switch(snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const LinearProgressIndicator();
                          case ConnectionState.done:
                          if (!snapshot.hasError){
                            if (roundSelector.isNegative){
                              var time = framesToTime(snapshot.data!.totalLength);
                              return Center(child: Text("Match Length: ${time.inMinutes}:${secs.format(time.inMicroseconds /1000000 % 60)}", textAlign: TextAlign.center));
                            }else{
                              var time = framesToTime(snapshot.data!.roundLengths[roundSelector]);
                              return Center(child: Text("Round Length: ${time.inMinutes}:${secs.format(time.inMicroseconds /1000000 % 60)}\nWinner: ${snapshot.data!.roundWinners[roundSelector][1]}", textAlign: TextAlign.center,));
                            }
                          }else{
                            return const Text("skill issue", textAlign: TextAlign.center);
                          }
                            
                        }
              },),),
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
                                FutureBuilder(future: replayData, builder: (BuildContext context, AsyncSnapshot<ReplayData?> snapshot){
                                  switch(snapshot.connectionState){
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return const LinearProgressIndicator();
                                    case ConnectionState.done:
                                    if (!snapshot.hasError){
                                      var greenSidePlayer = snapshot.data!.endcontext.indexWhere((element) => element.userId == widget.initPlayerId);
                                      var redSidePlayer = snapshot.data!.endcontext.indexWhere((element) => element.userId != widget.initPlayerId);
                                      return Column(children: [
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].piecesPlaced : snapshot.data!.stats[roundSelector][greenSidePlayer].piecesPlaced,
                                          redSide: roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].piecesPlaced : snapshot.data!.stats[roundSelector][redSidePlayer].piecesPlaced,
                                          label: "Pieces Placed", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].linesCleared : snapshot.data!.stats[roundSelector][greenSidePlayer].linesCleared,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].linesCleared : snapshot.data!.stats[roundSelector][redSidePlayer].linesCleared,
                                          label: "Lines Cleared", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].finessePercentage * 100 : snapshot.data!.stats[roundSelector][greenSidePlayer].finessePercentage * 100,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].finessePercentage * 100 : snapshot.data!.stats[roundSelector][redSidePlayer].finessePercentage * 100,
                                          label: "Finnese", postfix: "%", fractionDigits: 2, higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].topSpike : snapshot.data!.stats[roundSelector][greenSidePlayer].topSpike,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].topSpike : snapshot.data!.stats[roundSelector][redSidePlayer].topSpike,
                                          label: "Best Spike", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].topCombo : snapshot.data!.stats[roundSelector][greenSidePlayer].topCombo,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].topCombo : snapshot.data!.stats[roundSelector][redSidePlayer].topCombo,
                                          label: "Best Combo", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].topBtB : snapshot.data!.stats[roundSelector][greenSidePlayer].topBtB,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].topBtB : snapshot.data!.stats[roundSelector][redSidePlayer].topBtB,
                                          label: "Best BtB", higherIsBetter: true),
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Text("Garbage", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                                        ),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].garbage.sent : snapshot.data!.stats[roundSelector][greenSidePlayer].garbage.sent,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].garbage.sent : snapshot.data!.stats[roundSelector][redSidePlayer].garbage.sent,
                                          label: "Sent", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].garbage.recived : snapshot.data!.stats[roundSelector][greenSidePlayer].garbage.recived,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].garbage.recived : snapshot.data!.stats[roundSelector][redSidePlayer].garbage.recived,
                                          label: "Recived", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].garbage.attack : snapshot.data!.stats[roundSelector][greenSidePlayer].garbage.attack,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].garbage.attack : snapshot.data!.stats[roundSelector][redSidePlayer].garbage.attack,
                                          label: "Attack", higherIsBetter: true),
                                        CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].garbage.cleared : snapshot.data!.stats[roundSelector][greenSidePlayer].garbage.cleared,
                                          redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].garbage.cleared : snapshot.data!.stats[roundSelector][redSidePlayer].garbage.cleared,
                                          label: "Cleared", higherIsBetter: true),
                                      ],);
                                    }else{
                                      return Text("skill issue");
                                    }
                                      
                                  }
                                })
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
                          VsGraphs(
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector],
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector]
                          )
                        ],
                      ),
                      const Divider(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text("Handling",
                                style: TextStyle(
                                    fontFamily: "Eurostile Round Extended",
                                    fontSize: bigScreen ? 42 : 28)),
                          ),
                          CompareThingy(
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).handling.das,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).handling.das,
                            label: "DAS", fractionDigits: 1, postfix: "F",
                            higherIsBetter: false),
                          CompareThingy(
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).handling.arr,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).handling.arr,
                            label: "ARR", fractionDigits: 1, postfix: "F",
                            higherIsBetter: false),
                          CompareThingy(
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).handling.sdf,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).handling.sdf,
                            label: "SDF", prefix: "x",
                            higherIsBetter: true),
                          CompareBoolThingy(
                            greenSide: widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).handling.safeLock,
                            redSide: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).handling.safeLock,
                            label: "safeLock",
                            trueIsBetter: true)
                        ],
                      )
                  ],
                )
        ),
      ),
    );
  }
}
