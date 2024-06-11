// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:tetra_stats/data_objects/tetrio_multiplayer_replay.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/compare_view.dart' show CompareThingy, CompareBoolThingy;
import 'package:tetra_stats/widgets/list_tile_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/vs_graphs.dart';
import 'main_view.dart' show secs;
import 'package:tetra_stats/main.dart' show teto;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:window_manager/window_manager.dart';


int roundSelector = -1; // -1 = match averages, otherwise round number-1
List<DropdownMenuItem> rounds = []; // index zero will be match stats
bool timeWeightedStatsAvaliable = true;
int greenSidePlayer = 0;
int redSidePlayer = 1;
late String oldWindowTitle;

Duration framesToTime(int frames){
  return Duration(microseconds: frames~/6e-5);
}

class TlMatchResultView extends StatefulWidget {
  final TetraLeagueAlphaRecord record;
  final String initPlayerId;
  const TlMatchResultView({super.key, required this.record, required this.initPlayerId});

  @override
  State<StatefulWidget> createState() => TlMatchResultState();
}

class TlMatchResultState extends State<TlMatchResultView> {
  late Future<ReplayData?> replayData;

  @override
  void initState(){
    rounds = [DropdownMenuItem(value: -1, child: Text(t.match))];
    rounds.addAll([for (int i = 0; i < widget.record.endContext.first.secondaryTracking.length; i++) DropdownMenuItem(value: i, child: Text(t.roundNumber(n: i+1)))]);
    replayData = teto.analyzeReplay(widget.record.replayId, widget.record.replayAvalable);
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username.toUpperCase()} ${t.vs} ${widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username.toUpperCase()} ${t.inTLmatch} ${timestamp(widget.record.timestamp)}");
    }
    super.initState();
  }

  @override
  void dispose(){
    roundSelector = -1;
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  Widget buildComparison(double width, bool showMobileSelector){
    bool bigScreen = width >= 768;
    return SizedBox(
      width: width,
      child: FutureBuilder(future: replayData, builder: (context, snapshot){
        late Duration time;
        late String readableTime;
        late String reason;
        timeWeightedStatsAvaliable = true;
        if (snapshot.connectionState != ConnectionState.done) return const LinearProgressIndicator();
        if (!snapshot.hasError){
          if (rounds.indexWhere((element) => element.value == -2) == -1) rounds.insert(1, DropdownMenuItem(value: -2, child: Text(t.timeWeightedmatch)));
          greenSidePlayer = snapshot.data!.endcontext.indexWhere((element) => element.userId == widget.initPlayerId);
          redSidePlayer = snapshot.data!.endcontext.indexWhere((element) => element.userId != widget.initPlayerId);
          if (roundSelector.isNegative){
            time = framesToTime(snapshot.data!.totalLength);
            readableTime = "${t.matchLength}: ${time.inMinutes}:${secs.format(time.inMicroseconds /1000000 % 60)}";
          }else{
            time = framesToTime(snapshot.data!.roundLengths[roundSelector]);
            readableTime = "${t.roundLength}: ${time.inMinutes}:${secs.format(time.inMicroseconds /1000000 % 60)}\n${t.winner}: ${snapshot.data!.roundWinners[roundSelector][1]}";
          }
        }else{
          switch (snapshot.error.runtimeType){
            case ReplayNotAvalable:
              reason = t.matchIsTooOld;
              break;
            case SzyNotFound:
              reason = t.matchIsTooOld;
              break;
            case SzyForbidden:
              reason = t.errors.replayRejected;
              break;
            case SzyTooManyRequests:
              reason = t.errors.tooManyRequests;
              break;
            default:
              reason = snapshot.error.toString();
              break;
          }
        }
        return NestedScrollView(
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
              if (showMobileSelector) SliverToBoxAdapter(
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
              if (widget.record.ownId == widget.record.replayId && showMobileSelector) SliverToBoxAdapter(
                child: Center(child: Text(t.p1nkl0bst3rAlert, textAlign: TextAlign.center)),
              ),
              if (showMobileSelector) SliverToBoxAdapter(child: Center(child: Text(snapshot.hasError ? reason : readableTime, textAlign: TextAlign.center))),
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
                      greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].apm :
                      roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[roundSelector],
                      redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].apm :
                      roundSelector == -1 ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[roundSelector],
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PPS",
                      greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].pps:
                      roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[roundSelector],
                      redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].pps :
                      roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary: widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[roundSelector],
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS",
                      greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].vs :
                      roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[roundSelector],
                      redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].vs :
                      roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[roundSelector],
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    if (snapshot.hasData) Column(children: [
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].inputs : snapshot.data!.stats[roundSelector][greenSidePlayer].inputs,
                        redSide: roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].inputs : snapshot.data!.stats[roundSelector][redSidePlayer].inputs,
                        label: "Inputs", higherIsBetter: true),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].piecesPlaced : snapshot.data!.stats[roundSelector][greenSidePlayer].piecesPlaced,
                        redSide: roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].piecesPlaced : snapshot.data!.stats[roundSelector][redSidePlayer].piecesPlaced,
                        label: "Pieces Placed", higherIsBetter: true),
                      CompareThingy(greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].kpp : 
                        roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].kpp : snapshot.data!.stats[roundSelector][greenSidePlayer].kpp,
                        redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].kpp :
                        roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].kpp : snapshot.data!.stats[roundSelector][redSidePlayer].kpp,
                        label: "KPP", higherIsBetter: false, fractionDigits: 2,),
                      CompareThingy(greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].kps : 
                        roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].kps : snapshot.data!.stats[roundSelector][greenSidePlayer].kps,
                        redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].kps :
                        roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].kps : snapshot.data!.stats[roundSelector][redSidePlayer].kps,
                        label: "KPS", higherIsBetter: true, fractionDigits: 2,),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].linesCleared : snapshot.data!.stats[roundSelector][greenSidePlayer].linesCleared,
                        redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].linesCleared : snapshot.data!.stats[roundSelector][redSidePlayer].linesCleared,
                        label: "Lines Cleared", higherIsBetter: true),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].score : snapshot.data!.stats[roundSelector][greenSidePlayer].score,
                        redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].score : snapshot.data!.stats[roundSelector][redSidePlayer].score,
                        label: "Score", higherIsBetter: true),
                      CompareThingy(greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].spp : 
                        roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].spp : snapshot.data!.stats[roundSelector][greenSidePlayer].spp,
                        redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].spp :
                        roundSelector.isNegative ?  snapshot.data!.totalStats[redSidePlayer].spp : snapshot.data!.stats[roundSelector][redSidePlayer].spp,
                        label: "SPP", higherIsBetter: true, fractionDigits: 2,),  
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
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text("Line Clears", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                      ),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].clears.allClears : snapshot.data!.stats[roundSelector][greenSidePlayer].clears.allClears,
                        redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].clears.allClears : snapshot.data!.stats[roundSelector][redSidePlayer].clears.allClears,
                        label: "PC", higherIsBetter: true),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].tspins : snapshot.data!.stats[roundSelector][greenSidePlayer].tspins,
                        redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].tspins : snapshot.data!.stats[roundSelector][redSidePlayer].tspins,
                        label: "T-spins", higherIsBetter: true),
                      CompareThingy(greenSide: roundSelector.isNegative ? snapshot.data!.totalStats[greenSidePlayer].clears.quads : snapshot.data!.stats[roundSelector][greenSidePlayer].clears.quads,
                        redSide: roundSelector.isNegative ? snapshot.data!.totalStats[redSidePlayer].clears.quads : snapshot.data!.stats[roundSelector][redSidePlayer].clears.quads,
                        label: "Quads", higherIsBetter: true),
                    ],),
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
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.app  :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.app : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].app,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.app :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.app : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].app,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "VS/APM",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.vsapm :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.vsapm : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.vsapm :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.vsapm : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].vsapm,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/S",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.dss :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dss : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dss,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.dss :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dss : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dss,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/P",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.dsp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.dsp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].dsp,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.dsp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.dsp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].dsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "APP + DS/P",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.appdsp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.appdsp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.appdsp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.appdsp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.cheese :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.cheese : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].cheese,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.cheese :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.cheese : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].cheese,
                            fractionDigits: 2,
                            higherIsBetter: false,
                          ),
                          CompareThingy(
                            label: "Gb Eff.",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.gbe :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.gbe : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].gbe,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.gbe :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.gbe : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].gbe,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "wAPP",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.nyaapp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.nyaapp : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].nyaapp,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.nyaapp :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.nyaapp : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].nyaapp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Area",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats.area :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats.area : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector].area,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats.area :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats.area : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector].area,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: t.statCellNum.estOfTRShort,
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].estTr.esttr :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).estTr.esttr : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).estTrTracking[roundSelector].esttr,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].estTr.esttr :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).estTr.esttr : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).estTrTracking[roundSelector].esttr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Opener",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].playstyle.opener :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].opener,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].playstyle.opener :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.opener : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].opener,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Plonk",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].playstyle.plonk :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].plonk,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].playstyle.plonk :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.plonk : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].plonk,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Stride",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].playstyle.stride :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.stride  : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].stride,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].playstyle.stride :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.stride : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].stride,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Inf. DS",
                            greenSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].playstyle.infds :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector].infds,
                            redSide: (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].playstyle.infds :
                            roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle.infds : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector].infds,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          VsGraphs(
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].apm : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].pps : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].vs : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].nerdStats : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStats : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).nerdStatsTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[greenSidePlayer].playstyle : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyle : widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).playstyleTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].apm : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].pps : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiary : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].vs : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extra : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].nerdStats : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStats : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).nerdStatsTracking[roundSelector],
                            (roundSelector == -2 && snapshot.hasData) ? snapshot.data!.timeWeightedStats[redSidePlayer].playstyle : roundSelector.isNegative ? widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyle : widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).playstyleTracking[roundSelector]
                          )
                        ],
                      ),
                      if (widget.record.ownId != widget.record.replayId) const Divider(),
                      if (widget.record.ownId != widget.record.replayId) Column(
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
                            label: "Safe HD",
                            trueIsBetter: true)
                        ],
                      )
                  ],
                )
        );
      }),
    );
  }

  Widget buildRoundSelector(double width){
    return Padding(
      padding: const EdgeInsets.all(8.000000),
      child: SizedBox(
        width: width,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { 
            return [
              SliverToBoxAdapter(child: 
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    FutureBuilder(future: replayData, builder: (context, snapshot) {
                      switch(snapshot.connectionState){
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        if (!snapshot.hasError){
                          var time = framesToTime(snapshot.data!.totalLength);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(t.matchLength),
                            RichText(
                              text: TextSpan(
                                text: "${time.inMinutes}:${NumberFormat("00", LocaleSettings.currentLocale.languageCode).format(time.inSeconds%60)}",
                                style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
                                children: [TextSpan(text: ".${NumberFormat("000", LocaleSettings.currentLocale.languageCode).format(time.inMilliseconds%1000)}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                                ),
                              )
                          ],);
                        }else{
                          String reason;
                          switch (snapshot.error.runtimeType){
                            case ReplayNotAvalable:
                              reason = t.matchIsTooOld;
                              break;
                            case SzyNotFound:
                              reason = t.matchIsTooOld;
                              break;
                            case SzyForbidden:
                              reason = t.errors.replayRejected;
                              break;
                            case SzyTooManyRequests:
                              reason = t.errors.tooManyRequests;
                              break;
                            default:
                              reason = snapshot.error.toString();
                              break;
                          }
                          timeWeightedStatsAvaliable = false;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              if (widget.record.ownId != widget.record.replayId) Text("${t.replayIssue}: $reason"),
                              if (widget.record.ownId == widget.record.replayId) Center(child: Text(t.p1nkl0bst3rAlert, textAlign: TextAlign.center)),
                              if (widget.record.ownId != widget.record.replayId) RichText(
                                text: const TextSpan(
                                  text: "-:--",
                                  style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.grey),
                                  children: [TextSpan(text: ".---", style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                                  ),
                                )
                            ],);
                        }
                          
                      }
                    },),
                     if (widget.record.ownId != widget.record.replayId) Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                      Text(t.numberOfRounds),
                      RichText(
                        text: TextSpan(
                          text: widget.record.endContext.first.secondaryTracking.isNotEmpty ? widget.record.endContext.first.secondaryTracking.length.toString() : "---",
                          style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: widget.record.endContext.first.secondaryTracking.isEmpty ? Colors.grey : Colors.white
                            ),
                          ),
                        )
                    ],),
                    Column(children: [
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton( style: roundSelector == -1 ? ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)) : null,
                          onPressed: () {
                            roundSelector = -1;
                            setState(() {});
                          }, child: Text(t.matchStats)),
                          TextButton( style: roundSelector == -2 ? ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)) : null,
                          onPressed: timeWeightedStatsAvaliable ? () {
                            roundSelector = -2;
                            setState(() {});
                          } : null, child: Text(t.timeWeightedmatchStats)) ,
                          //TextButton( child: const Text('Button 3'), onPressed: () {}),
                        ],
                      )
                    ]),
                    // Column(
                    //   children: [
                    //     ListTile(
                    //       leading: Text("Round time"),
                    //       title: Text("Winner", textAlign: TextAlign.center,),
                    //       trailing: Text("Round stats"),
                    //     )
                    //   ],
                    // )
                  ],
                )
              )
            ];
           },
          body: ListView.builder(itemCount: widget.record.endContext.first.secondaryTracking.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(future: replayData, builder: (context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const LinearProgressIndicator();
                  case ConnectionState.done:
                  if (!snapshot.hasError){
                    var time = framesToTime(snapshot.data!.roundLengths[index]);
                    var accentColor = snapshot.data!.roundWinners[index][0] == widget.initPlayerId ? Colors.green : Colors.red;
                    var bgColor = roundSelector == index ? Colors.grey.shade900 : Colors.transparent;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: const [0, 0.05],
                          colors: [accentColor, bgColor]
                        )
                      ),
                      child: ListTile(
                        leading:RichText(
                          text: TextSpan(
                            text: "${time.inMinutes}:${NumberFormat("00", LocaleSettings.currentLocale.languageCode).format(time.inSeconds%60)}",
                            style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                            children: [TextSpan(text: ".${NumberFormat("000", LocaleSettings.currentLocale.languageCode).format(time.inMilliseconds%1000)}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                          ), 
                        ),
                        title: Text(snapshot.data!.roundWinners[index][1], textAlign: TextAlign.center),
                        trailing: TrailingStats(
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[index]
                        ),
                        onTap:(){
                          roundSelector = index;
                          setState(() {});
                        },
                      ),
                    );
                  }else{
                    return Container(
                      decoration: BoxDecoration(
                        color: roundSelector == index ? Colors.grey.shade900 : Colors.transparent
                      ),
                      child: ListTile(
                        leading: RichText(
                        text: const TextSpan(
                          text: "-:--",
                          style: TextStyle(fontFamily: "Eurostile Round", fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
                          children: [TextSpan(text: ".---", style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                          ),
                        ),
                        title: const Text("---", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                        trailing: TrailingStats(
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).secondaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).tertiaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).extraTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).secondaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).tertiaryTracking[index],
                          widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).extraTracking[index]
                        ),
                        onTap:(){
                          roundSelector = index;
                          setState(() {});
                        },
                      ),
                    );
                  }
                }
              }
            );
          })
        ),
      ),
    );
  }
  
  Widget getMainWidget(double viewportWidth) {
    if (viewportWidth <= 1200) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 768),
          child: buildComparison(viewportWidth, true)
        ),
      );
    } else {
      double comparisonWidth = viewportWidth - 450 - 16;
      comparisonWidth = comparisonWidth > 768 ? 768 : comparisonWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildComparison(comparisonWidth, false),
          buildRoundSelector(450)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.record.endContext.firstWhere((element) => element.userId == widget.initPlayerId).username.toUpperCase()} ${t.vs} ${widget.record.endContext.firstWhere((element) => element.userId != widget.initPlayerId).username.toUpperCase()} ${t.inTLmatch} ${timestamp(widget.record.timestamp)}"),
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
                  await launchInBrowser(Uri.parse("https://inoue.szy.lol/api/replay/${widget.record.replayId}"));
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
      body: getMainWidget(MediaQuery.of(context).size.width),
      );
  }
}
