// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/widgets/vs_graphs.dart';
import 'package:window_manager/window_manager.dart';

enum Mode{
  player,
  stats,
  averages
}
Mode greenSideMode = Mode.player;
List<dynamic> theGreenSide = [null, null, null]; // TetrioPlayer?, List<DropdownMenuItem<TetrioPlayer>>?, Summary
Mode redSideMode = Mode.player;
List<dynamic> theRedSide = [null, null, null];
final DateFormat dateFormat = DateFormat.yMd(LocaleSettings.currentLocale.languageCode).add_Hm();
var numbersReg = RegExp(r'\d+(\.\d*)*');
late String oldWindowTitle;

class CompareView extends StatefulWidget {
  final List<dynamic> greenSide;
  final List<dynamic> redSide;
  final Mode greenMode;
  final Mode redMode;
  const CompareView({super.key, required this.greenSide, required this.redSide, required this.greenMode, required this.redMode});

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    theGreenSide = widget.greenSide;
    fetchGreenSide(widget.greenSide[0].userId);
    if (widget.redSide[0] != null) fetchRedSide(widget.redSide[0].userId); 
    _scrollController = ScrollController();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
    }
    super.initState();
  }

  @override
  void dispose(){
    theGreenSide = [null, null, null];
    greenSideMode = Mode.player;
    theRedSide = [null, null, null];
    redSideMode = Mode.player;
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void fetchRedSide(String user) async {
    try {
      if (user.startsWith("\$avg")){
        try{
          //var average = (await teto.fetchTLLeaderboard()).getAverageOfRank(user.substring(4).toLowerCase())[0];
          //Summaries summary = Summaries("avg${user.substring(4).toLowerCase()}", average, TetrioZen(level: 0, score: 0));
          redSideMode = Mode.averages;
          //theRedSide = [null, null, summary];
          return setState(() {});
        }on Exception {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.compareViewWrongValue(value: user))));
          return;
        }
      }
      var tearDownToNumbers = numbersReg.allMatches(user);
      if (tearDownToNumbers.length == 3) {
        redSideMode = Mode.stats;
        var threeNumbers = tearDownToNumbers.toList();
        double apm = double.parse(threeNumbers[0][0]!);
        double pps = double.parse(threeNumbers[1][0]!);
        double vs = double.parse(threeNumbers[2][0]!);
        theRedSide = [null,
        null,
         Summaries(user, TetraLeague(
          id: "",
          timestamp: DateTime.now(),
          apm: apm,
          pps: pps,
          vs: vs,
          rd: noTrRd,
          gamesPlayed: -1,
          gamesWon: -1,
          bestRank: "z",
          decaying: true,
          tr: -1,
          gxe: -1,
          rank: "z",
          percentileRank: "z",
          percentile: 1,
          standing: -1,
          standingLocal: -1,
          nextAt: -1,
          prevAt: -1, season: currentSeason), TetrioZen(level: 0, score: 0))];
        return setState(() {});
      }
      var player = await teto.fetchPlayer(user);
      Summaries summary = await teto.fetchSummaries(player.userId);
      redSideMode = Mode.player;
      //late List<TetrioPlayer> states;
      // List<DropdownMenuItem<TetrioPlayer>>? dStates = <DropdownMenuItem<TetrioPlayer>>[];
      // try{
      //   states = await teto.getPlayer(player.userId);
      // for (final TetrioPlayer state in states) {
      //   dStates.add(DropdownMenuItem<TetrioPlayer>(
      //   value: state, child: Text(dateFormat.format(state.state))));
      // }
      // dStates.firstWhere((element) => element.value == player, orElse: () {
      //   dStates?.add(DropdownMenuItem<TetrioPlayer>(
      //   value: player, child: Text(t.mostRecentOne)));
      //   return DropdownMenuItem<TetrioPlayer>(
      //   value: player, child: Text(t.mostRecentOne));
      // },);
      // }on Exception {
      //   dStates = null;
      // }
      theRedSide = [player, null, summary];
    } on Exception {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.compareViewWrongValue(value: user))));
    }
    _justUpdate();
  }

  void changeRedSide(TetraLeague user) {
    setState(() {
      //theRedSide[0] = user;
      theRedSide[2].league = user;
      });
  }

  void fetchGreenSide(String user) async {
    try {
      if (user.startsWith("\$avg")){
        try{
          //var average = (await teto.fetchTLLeaderboard()).getAverageOfRank(user.substring(4).toLowerCase())[0];
          //Summaries summary = Summaries("avg${user.substring(4).toLowerCase()}", average, TetrioZen(level: 0, score: 0));
          greenSideMode = Mode.averages;
          //theGreenSide = [null, null, summary];
          return setState(() {});
        }on Exception {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Falied to assign $user")));
          return;
        }
      }
      var tearDownToNumbers = numbersReg.allMatches(user);
      if (tearDownToNumbers.length == 3) {
        greenSideMode = Mode.stats;
        var threeNumbers = tearDownToNumbers.toList();
        double apm = double.parse(threeNumbers[0][0]!);
        double pps = double.parse(threeNumbers[1][0]!);
        double vs = double.parse(threeNumbers[2][0]!);
        theGreenSide = [null,
        null,
        Summaries(user, TetraLeague(
          id: "",
          timestamp: DateTime.now(),
          apm: apm,
          pps: pps,
          vs: vs,
          rd: noTrRd,
          gamesPlayed: -1,
          gamesWon: -1,
          bestRank: "z",
          decaying: true,
          tr: -1,
          gxe: -1,
          rank: "z",
          percentileRank: "z",
          percentile: 1,
          standing: -1,
          standingLocal: -1,
          nextAt: -1,
          prevAt: -1, season: currentSeason), TetrioZen(level: 0, score: 0))];
        return setState(() {});
      }
      var player = await teto.fetchPlayer(user);
      Summaries summary = await teto.fetchSummaries(player.userId);
      greenSideMode = Mode.player;
      // late List<TetrioPlayer> states;
      // List<DropdownMenuItem<TetrioPlayer>>? dStates = <DropdownMenuItem<TetrioPlayer>>[];
      // try{
      //   states = await teto.getPlayer(player.userId);
      // for (final TetrioPlayer state in states) {
      //   dStates.add(DropdownMenuItem<TetrioPlayer>(
      //   value: state, child: Text(dateFormat.format(state.state))));
      // }
      // dStates.firstWhere((element) => element.value == player, orElse: () {
      //   dStates?.add(DropdownMenuItem<TetrioPlayer>(
      //   value: player, child: Text(t.mostRecentOne)));
      //   return DropdownMenuItem<TetrioPlayer>(
      //   value: player, child: Text(t.mostRecentOne));
      // },);
      // }on Exception {
      //   dStates = null;
      // }
      theGreenSide = [player, null, summary];
    } on Exception {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    _justUpdate();
  }

  void changeGreenSide(TetraLeague user) {
    setState(() {
      //theGreenSide[0] = user;
      theGreenSide[2].league = user;
    });
  }

  double getWinrateByTR(double yourGlicko, double yourRD, double notyourGlicko,double notyourRD) {
    return ((1 /
      (1 + pow(10,
        (notyourGlicko - yourGlicko) /
          (400 * sqrt(1 + (3 * pow(0.0057564273, 2) *
            (pow(yourRD, 2) + pow(notyourRD, 2)) / pow(pi, 2)
          )))
        )
      )
    ));
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    String titleGreenSide;
    String titleRedSide;
    switch (greenSideMode){
      case Mode.player:
        titleGreenSide = theGreenSide[0] != null ? theGreenSide[0].username.toUpperCase() : "???";
        break;
      case Mode.stats:
        titleGreenSide = "${theGreenSide[2].league.apm} APM, ${theGreenSide[2].league.pps} PPS, ${theGreenSide[2].league.vs} VS";
        break;
      case Mode.averages:
        titleGreenSide = t.averageXrank(rankLetter: theGreenSide[2].league.rank.toUpperCase());
        break;
    }
    switch (redSideMode){
      case Mode.player:
        titleRedSide = theRedSide[0] != null ? theRedSide[0].username.toUpperCase() : "???";
        break;
      case Mode.stats:
        titleRedSide = "${theRedSide[2].league.apm} APM, ${theRedSide[2].league.pps} PPS, ${theRedSide[2].league.vs} VS";
        break;
      case Mode.averages:
        titleRedSide = t.averageXrank(rankLetter: theRedSide[2].league.rank.toUpperCase());
        break;
    }
    windowManager.setTitle("Tetra Stats: $titleGreenSide ${t.vs} $titleRedSide");
    return Scaffold(
      appBar: AppBar(title: Text("$titleGreenSide ${t.vs} $titleRedSide")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Column(children: [
              Padding(
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
                          child: PlayerSelector(
                            data: theGreenSide,
                            mode: greenSideMode,
                            fetch: fetchGreenSide,
                            change: changeGreenSide,
                            updateState: _justUpdate,
                          ),
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
                          child: PlayerSelector(
                            data: theRedSide,
                            mode: redSideMode,
                            fetch: fetchRedSide,
                            change: changeRedSide,
                            updateState: _justUpdate,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (!listEquals(theGreenSide, [null, null, null]) && !listEquals(theRedSide, [null, null, null])) Column(
                children: [
                  if (theGreenSide[0] != null && theRedSide[0] != null && theGreenSide[0]!.role != "banned" && theRedSide[0]!.role != "banned")
                  Column(
                    children: [
                      CompareRegTimeThingy(
                        greenSide: theGreenSide[0].registrationTime,
                        redSide: theRedSide[0].registrationTime,
                        label: t.registred),
                      CompareThingy(
                        label: t.statCellNum.level,
                        greenSide: theGreenSide[0].level,
                        redSide: theRedSide[0].level,
                        higherIsBetter: true,
                        fractionDigits: 2,
                      ),
                      if (!theGreenSide[0].gameTime.isNegative && !theRedSide[0].gameTime.isNegative)
                        CompareThingy(
                          greenSide: theGreenSide[0].gameTime.inMicroseconds /
                              1000000 /
                              60 /
                              60,
                          redSide: theRedSide[0].gameTime.inMicroseconds /
                              1000000 /
                              60 /
                              60,
                          label: t.statCellNum.hoursPlayed.replaceAll(RegExp(r'\n'), " "),
                          higherIsBetter: true,
                          fractionDigits: 2,
                        ),
                      if (theGreenSide[0].gamesPlayed >= 0 && theRedSide[0].gamesPlayed >= 0)
                        CompareThingy(
                          label: t.statCellNum.onlineGames.replaceAll(RegExp(r'\n'), " "),
                          greenSide: theGreenSide[0].gamesPlayed,
                          redSide: theRedSide[0].gamesPlayed,
                          higherIsBetter: true,
                        ),
                      if (theGreenSide[0].gamesWon >= 0 && theRedSide[0].gamesWon >= 0)
                        CompareThingy(
                          label: t.statCellNum.gamesWon.replaceAll(RegExp(r'\n'), " "),
                          greenSide: theGreenSide[0].gamesWon,
                          redSide: theRedSide[0].gamesWon,
                          higherIsBetter: true,
                        ),
                      CompareThingy(
                        label: t.statCellNum.friends,
                        greenSide: theGreenSide[0].friendCount,
                        redSide: theRedSide[0].friendCount,
                        higherIsBetter: true,
                      ),
                      const Divider(),
                    ],
                  ),
                  if (theGreenSide[0] != null && theRedSide[0] != null && (theGreenSide[0]!.role == "banned" || theRedSide[0]!.role == "banned"))
                    CompareBoolThingy(
                      greenSide: theGreenSide[0].role == "banned",
                      redSide: theRedSide[0].role == "banned",
                      label: t.normalBanned,
                      trueIsBetter: false
                    ),
                  (theGreenSide[2].league.gamesPlayed > 0 || greenSideMode == Mode.stats) && (theRedSide[2].league.gamesPlayed > 0 || redSideMode == Mode.stats)
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(t.tetraLeague,
                              style: TextStyle(
                                  fontFamily: "Eurostile Round Extended",
                                  fontSize: bigScreen ? 42 : 28)),
                        ),
                        if (theGreenSide[2].league.gamesPlayed > 9 &&
                            theRedSide[2].league.gamesPlayed > 9 &&
                            greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                          CompareThingy(
                            label: "TR",
                            greenSide: theGreenSide[2].league.tr,
                            redSide: theRedSide[2].league.tr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                        if (greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                        CompareThingy(
                          label: t.statCellNum.gamesPlayed.replaceAll(RegExp(r'\n'), " "),
                          greenSide: theGreenSide[2].league.gamesPlayed,
                          redSide: theRedSide[2].league.gamesPlayed,
                          higherIsBetter: true,
                        ),
                        if (greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                        CompareThingy(
                          label: t.statCellNum.gamesWonTL.replaceAll(RegExp(r'\n'), " "),
                          greenSide: theGreenSide[2].league.gamesWon,
                          redSide: theRedSide[2].league.gamesWon,
                          higherIsBetter: true,
                        ),
                        if (greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                        CompareThingy(
                          label: "WR %",
                          greenSide:
                              theGreenSide[2].league.winrate * 100,
                          redSide: theRedSide[2].league.winrate * 100,
                          fractionDigits: 2,
                          higherIsBetter: true,
                        ),
                        if (theGreenSide[2].league.gamesPlayed > 9 &&
                            theRedSide[2].league.gamesPlayed > 9 &&
                            greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                          CompareThingy(
                            label: "Glicko",
                            greenSide: theGreenSide[2].league.glicko!,
                            redSide: theRedSide[2].league.glicko!,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                        if (theGreenSide[2].league.gamesPlayed > 9 &&
                            theRedSide[2].league.gamesPlayed > 9 &&
                            greenSideMode != Mode.stats &&
                            redSideMode != Mode.stats)
                          CompareThingy(
                            label: "RD",
                            greenSide: theGreenSide[2].league.rd!,
                            redSide: theRedSide[2].league.rd!,
                            fractionDigits: 3,
                            higherIsBetter: false,
                          ),
                        if (theGreenSide[2].league.standing > 0 &&
                            theRedSide[2].league.standing > 0 &&
                            greenSideMode == Mode.player &&
                            redSideMode == Mode.player)
                          CompareThingy(
                            label: t.statCellNum.lbpShort,
                            greenSide: theGreenSide[2].league.standing,
                            redSide: theRedSide[2].league.standing,
                            higherIsBetter: false,
                          ),
                        if (theGreenSide[2].league.standingLocal > 0 &&
                            theRedSide[2].league.standingLocal > 0 &&
                            greenSideMode == Mode.player &&
                            redSideMode == Mode.player)
                          CompareThingy(
                            label: t.statCellNum.lbpcShort,
                            greenSide:
                                theGreenSide[2].league.standingLocal,
                            redSide: theRedSide[2].league.standingLocal,
                            higherIsBetter: false,
                          ),
                        if (theGreenSide[2].league.apm != null &&
                            theRedSide[2].league.apm != null)
                          CompareThingy(
                            label: "APM",
                            greenSide: theGreenSide[2].league.apm!,
                            redSide: theRedSide[2].league.apm!,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                        if (theGreenSide[2].league.pps != null &&
                            theRedSide[2].league.pps != null)
                          CompareThingy(
                            label: "PPS",
                            greenSide: theGreenSide[2].league.pps!,
                            redSide: theRedSide[2].league.pps!,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                        if (theGreenSide[2].league.vs != null &&
                            theRedSide[2].league.vs != null)
                          CompareThingy(
                            label: "VS",
                            greenSide: theGreenSide[2].league.vs!,
                            redSide: theRedSide[2].league.vs!,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                      ],
                    )
                  : CompareBoolThingy(
                      greenSide: theGreenSide[2].league.gamesPlayed > 0,
                      redSide: theRedSide[2].league.gamesPlayed > 0,
                      label: t.playedTL,
                      trueIsBetter: false),
              if (theGreenSide[2].league.nerdStats != null &&
                  theRedSide[2].league.nerdStats != null)
                Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.nerdStats,
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareThingy(
                      label: "APP",
                      greenSide: theGreenSide[2].league.nerdStats!.app,
                      redSide: theRedSide[2].league.nerdStats!.app,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS/APM",
                      greenSide: theGreenSide[2].league.nerdStats!.vsapm,
                      redSide: theRedSide[2].league.nerdStats!.vsapm,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/S",
                      greenSide: theGreenSide[2].league.nerdStats!.dss,
                      redSide: theRedSide[2].league.nerdStats!.dss,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/P",
                      greenSide: theGreenSide[2].league.nerdStats!.dsp,
                      redSide: theRedSide[2].league.nerdStats!.dsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "APP + DS/P",
                      greenSide:
                          theGreenSide[2].league.nerdStats!.appdsp,
                      redSide: theRedSide[2].league.nerdStats!.appdsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                      greenSide:
                          theGreenSide[2].league.nerdStats!.cheese,
                      redSide: theRedSide[2].league.nerdStats!.cheese,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Gb Eff.",
                      greenSide: theGreenSide[2].league.nerdStats!.gbe,
                      redSide: theRedSide[2].league.nerdStats!.gbe,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "wAPP",
                      greenSide:
                          theGreenSide[2].league.nerdStats!.nyaapp,
                      redSide: theRedSide[2].league.nerdStats!.nyaapp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Area",
                      greenSide: theGreenSide[2].league.nerdStats!.area,
                      redSide: theRedSide[2].league.nerdStats!.area,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.estOfTRShort,
                      greenSide: theGreenSide[2].league.estTr!.esttr,
                      redSide: theRedSide[2].league.estTr!.esttr,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    if (theGreenSide[2].league.gamesPlayed > 9 &&
                        theGreenSide[2].league.gamesPlayed > 9 &&
                        greenSideMode != Mode.stats &&
                        redSideMode != Mode.stats)
                    CompareThingy(
                      label: t.statCellNum.accOfEstShort,
                      greenSide: theGreenSide[2].league.esttracc!,
                      redSide: theRedSide[2].league.esttracc!,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Opener",
                      greenSide: theGreenSide[2].league.playstyle!.opener,
                      redSide: theRedSide[2].league.playstyle!.opener,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Plonk",
                      greenSide: theGreenSide[2].league.playstyle!.plonk,
                      redSide: theRedSide[2].league.playstyle!.plonk,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Stride",
                      greenSide: theGreenSide[2].league.playstyle!.stride,
                      redSide: theRedSide[2].league.playstyle!.stride,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Inf. DS",
                      greenSide: theGreenSide[2].league.playstyle!.infds,
                      redSide: theRedSide[2].league.playstyle!.infds,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    VsGraphs(theGreenSide[2].league.apm!, theGreenSide[2].league.pps!, theGreenSide[2].league.vs!, theGreenSide[2].league.nerdStats!, theGreenSide[2].league.playstyle!, theRedSide[2].league.apm!, theRedSide[2].league.pps!, theRedSide[2].league.vs!, theRedSide[2].league.nerdStats!, theRedSide[2].league.playstyle!),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.winChance,
                          style: TextStyle(
                              fontFamily: "Eurostile Round Extended",
                              fontSize: bigScreen ? 42 : 28)),
                    ),
                    if (greenSideMode != Mode.stats && redSideMode != Mode.stats &&
                    theGreenSide[2].league.gamesPlayed > 9 && theRedSide[2].league.gamesPlayed > 9)
                    CompareThingy(
                      label: t.byGlicko,
                      greenSide: getWinrateByTR(
                              theGreenSide[2].league.glicko!,
                              theGreenSide[2].league.rd!,
                              theRedSide[2].league.glicko!,
                              theRedSide[2].league.rd!) *
                          100,
                      redSide: getWinrateByTR(
                              theRedSide[2].league.glicko!,
                              theRedSide[2].league.rd!,
                              theGreenSide[2].league.glicko!,
                              theGreenSide[2].league.rd!) *
                          100,
                      fractionDigits: 2,
                      higherIsBetter: true,
                      postfix: "%",
                    ),
                    CompareThingy(
                      label: t.byEstTR,
                      greenSide: getWinrateByTR(
                              theGreenSide[2].league.estTr!.estglicko,
                              theGreenSide[2].league.rd ?? noTrRd,
                              theRedSide[2].league.estTr!.estglicko,
                              theRedSide[2].league.rd ?? noTrRd) *
                          100,
                      redSide: getWinrateByTR(
                              theRedSide[2].league.estTr!.estglicko,
                              theRedSide[2].league.rd ?? noTrRd,
                              theGreenSide[2].league.estTr!.estglicko,
                              theGreenSide[2].league.rd ?? noTrRd) *
                          100,
                      fractionDigits: 2,
                      higherIsBetter: true,
                      postfix: "%",
                    ),
                  ],
                ),
                if (theGreenSide[2].zenith != null && theRedSide[2].zenith != null && greenSideMode == Mode.player && redSideMode == Mode.player) Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.quickPlay, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareThingy(
                      label: "Height",
                      greenSide: theGreenSide[2].zenith.stats.zenith!.altitude,
                      redSide: theRedSide[2].zenith.stats.zenith!.altitude,
                      fractionDigits: 2,
                      higherIsBetter: true,
                      postfix: "m",
                    ),
                    CompareThingy(
                      label: "Position",
                      greenSide: theGreenSide[2].zenith.rank,
                      redSide: theRedSide[2].zenith.rank,
                      higherIsBetter: false,
                      prefix: "№ ",
                    ),
                    CompareThingy(
                      label: "Position (Country)",
                      greenSide: theGreenSide[2].zenith.countryRank,
                      redSide: theRedSide[2].zenith.countryRank,
                      higherIsBetter: false,
                      prefix: "№ ",
                    ),
                    CompareThingy(
                      label: "APM",
                      greenSide: theGreenSide[2].zenith.aggregateStats.apm,
                      redSide: theRedSide[2].zenith.aggregateStats.apm,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PPS",
                      greenSide: theGreenSide[2].zenith.aggregateStats.pps,
                      redSide: theRedSide[2].zenith.aggregateStats.pps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS",
                      greenSide: theGreenSide[2].zenith.aggregateStats.vs,
                      redSide: theRedSide[2].zenith.aggregateStats.vs,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "KO's",
                      greenSide: theGreenSide[2].zenith.stats.kills,
                      redSide: theRedSide[2].zenith.stats.kills,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "CPS",
                      greenSide: theGreenSide[2].zenith.stats.cps,
                      redSide: theRedSide[2].zenith.stats.cps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Peak CPS",
                      greenSide: theGreenSide[2].zenith.stats.zenith!.peakrank,
                      redSide: theRedSide[2].zenith.stats.zenith!.peakrank,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareDurationThingy(
                      label: "Time",
                      greenSide: theGreenSide[2].zenith.stats.finalTime,
                      redSide: theRedSide[2].zenith.stats.finalTime,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "Finesse",
                      greenSide: theGreenSide[2].zenith.stats.finessePercentage * 100,
                      redSide: theRedSide[2].zenith.stats.finessePercentage * 100,
                      fractionDigits: 2,
                      postfix: "%",
                      higherIsBetter: true,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text("${t.quickPlay} ${t.nerdStats}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                    ),
                    CompareThingy(
                      label: "APP",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.app,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.app,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS/APM",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.vsapm,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.vsapm,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/S",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.dss,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.dss,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/P",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.dsp,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.dsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "APP + DS/P",
                      greenSide:
                          theGreenSide[2].zenith.aggregateStats.nerdStats.appdsp,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.appdsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                      greenSide:
                          theGreenSide[2].zenith.aggregateStats.nerdStats.cheese,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.cheese,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Gb Eff.",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.gbe,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.gbe,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "wAPP",
                      greenSide:
                          theGreenSide[2].zenith.aggregateStats.nerdStats.nyaapp,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.nyaapp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Area",
                      greenSide: theGreenSide[2].zenith.aggregateStats.nerdStats.area,
                      redSide: theRedSide[2].zenith.aggregateStats.nerdStats.area,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Opener",
                      greenSide: theGreenSide[2].zenith.aggregateStats.playstyle.opener,
                      redSide: theRedSide[2].zenith.aggregateStats.playstyle.opener,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Plonk",
                      greenSide: theGreenSide[2].zenith.aggregateStats.playstyle.plonk,
                      redSide: theRedSide[2].zenith.aggregateStats.playstyle.plonk,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Stride",
                      greenSide: theGreenSide[2].zenith.aggregateStats.playstyle.stride,
                      redSide: theRedSide[2].zenith.aggregateStats.playstyle.stride,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Inf. DS",
                      greenSide: theGreenSide[2].zenith.aggregateStats.playstyle.infds,
                      redSide: theRedSide[2].zenith.aggregateStats.playstyle.infds,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    VsGraphs(theGreenSide[2].zenith.aggregateStats.apm, theGreenSide[2].zenith.aggregateStats.pps, theGreenSide[2].zenith.aggregateStats.vs, theGreenSide[2].zenith.aggregateStats.nerdStats, theGreenSide[2].zenith.aggregateStats.playstyle, theRedSide[2].zenith.aggregateStats.apm, theRedSide[2].zenith.aggregateStats.pps, theRedSide[2].zenith.aggregateStats.vs, theRedSide[2].zenith.aggregateStats.nerdStats, theRedSide[2].zenith.aggregateStats.playstyle),
                  ],
                )
                else if (greenSideMode == Mode.player && redSideMode == Mode.player) CompareBoolThingy(greenSide: theGreenSide[2].zenith != null, redSide: theRedSide[2].zenith != null, label: "Played QP", trueIsBetter: true),
                if (theGreenSide[2].zenithEx != null && theRedSide[2].zenithEx != null && greenSideMode == Mode.player && redSideMode == Mode.player) Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text("${t.quickPlay} ${t.expert}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareThingy(
                      label: "Height",
                      greenSide: theGreenSide[2].zenithEx.stats.zenith!.altitude,
                      redSide: theRedSide[2].zenithEx.stats.zenith!.altitude,
                      fractionDigits: 2,
                      higherIsBetter: true,
                      postfix: "m",
                    ),
                    CompareThingy(
                      label: "Position",
                      greenSide: theGreenSide[2].zenithEx.rank,
                      redSide: theRedSide[2].zenithEx.rank,
                      higherIsBetter: false,
                      prefix: "№ ",
                    ),
                    CompareThingy(
                      label: "Position (Country)",
                      greenSide: theGreenSide[2].zenithEx.countryRank,
                      redSide: theRedSide[2].zenithEx.countryRank,
                      higherIsBetter: false,
                      prefix: "№ ",
                    ),
                    CompareThingy(
                      label: "APM",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.apm,
                      redSide: theRedSide[2].zenithEx.aggregateStats.apm,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PPS",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.pps,
                      redSide: theRedSide[2].zenithEx.aggregateStats.pps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.vs,
                      redSide: theRedSide[2].zenithEx.aggregateStats.vs,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "KO's",
                      greenSide: theGreenSide[2].zenithEx.stats.kills,
                      redSide: theRedSide[2].zenithEx.stats.kills,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "CPS",
                      greenSide: theGreenSide[2].zenithEx.stats.cps,
                      redSide: theRedSide[2].zenithEx.stats.cps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Peak CPS",
                      greenSide: theGreenSide[2].zenithEx.stats.zenith!.peakrank,
                      redSide: theRedSide[2].zenithEx.stats.zenith!.peakrank,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareDurationThingy(
                      label: "Time",
                      greenSide: theGreenSide[2].zenithEx.stats.finalTime,
                      redSide: theRedSide[2].zenithEx.stats.finalTime,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "Finesse",
                      greenSide: theGreenSide[2].zenithEx.stats.finessePercentage * 100,
                      redSide: theRedSide[2].zenithEx.stats.finessePercentage * 100,
                      fractionDigits: 2,
                      postfix: "%",
                      higherIsBetter: true,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text("${t.quickPlay} ${t.expert} ${t.nerdStats}", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                    ),
                    CompareThingy(
                      label: "APP",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.app,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.app,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "VS/APM",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.vsapm,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.vsapm,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/S",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.dss,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.dss,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "DS/P",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.dsp,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.dsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "APP + DS/P",
                      greenSide:
                          theGreenSide[2].zenithEx.aggregateStats.nerdStats.appdsp,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.appdsp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                      greenSide:
                          theGreenSide[2].zenithEx.aggregateStats.nerdStats.cheese,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.cheese,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Gb Eff.",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.gbe,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.gbe,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "wAPP",
                      greenSide:
                          theGreenSide[2].zenithEx.aggregateStats.nerdStats.nyaapp,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.nyaapp,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Area",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.nerdStats.area,
                      redSide: theRedSide[2].zenithEx.aggregateStats.nerdStats.area,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Opener",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.playstyle.opener,
                      redSide: theRedSide[2].zenithEx.aggregateStats.playstyle.opener,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Plonk",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.playstyle.plonk,
                      redSide: theRedSide[2].zenithEx.aggregateStats.playstyle.plonk,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Stride",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.playstyle.stride,
                      redSide: theRedSide[2].zenithEx.aggregateStats.playstyle.stride,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Inf. DS",
                      greenSide: theGreenSide[2].zenithEx.aggregateStats.playstyle.infds,
                      redSide: theRedSide[2].zenithEx.aggregateStats.playstyle.infds,
                      fractionDigits: 3,
                      higherIsBetter: true,
                    ),
                    VsGraphs(theGreenSide[2].zenithEx.aggregateStats.apm, theGreenSide[2].zenithEx.aggregateStats.pps, theGreenSide[2].zenithEx.aggregateStats.vs, theGreenSide[2].zenithEx.aggregateStats.nerdStats, theGreenSide[2].zenithEx.aggregateStats.playstyle, theRedSide[2].zenithEx.aggregateStats.apm, theRedSide[2].zenithEx.aggregateStats.pps, theRedSide[2].zenithEx.aggregateStats.vs, theRedSide[2].zenithEx.aggregateStats.nerdStats, theRedSide[2].zenithEx.aggregateStats.playstyle),
                  ],
                )
                else if (greenSideMode == Mode.player && redSideMode == Mode.player) CompareBoolThingy(greenSide: theGreenSide[2].zenithEx != null, redSide: theRedSide[2].zenithEx != null, label: "Played QP Expert", trueIsBetter: true),
                if (theGreenSide[2].sprint != null && theRedSide[2].sprint != null && greenSideMode == Mode.player && redSideMode == Mode.player) Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.sprint, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareDurationThingy(
                      label: "Time",
                      greenSide: theGreenSide[2].sprint.stats.finalTime,
                      redSide: theRedSide[2].sprint.stats.finalTime,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "Lines",
                      greenSide: theGreenSide[2].sprint.stats.lines,
                      redSide: theRedSide[2].sprint.stats.lines,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: t.statCellNum.pieces.replaceAll(RegExp(r'\n'), " "),
                      greenSide: theGreenSide[2].sprint.stats.piecesPlaced,
                      redSide: theRedSide[2].sprint.stats.piecesPlaced,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: t.statCellNum.keys.replaceAll(RegExp(r'\n'), " "),
                      greenSide: theGreenSide[2].sprint.stats.inputs,
                      redSide: theRedSide[2].sprint.stats.inputs,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "PPS",
                      greenSide: theGreenSide[2].sprint.stats.pps,
                      redSide: theRedSide[2].sprint.stats.pps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "KPP",
                      greenSide: theGreenSide[2].sprint.stats.kpp,
                      redSide: theRedSide[2].sprint.stats.kpp,
                      fractionDigits: 2,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "KPS",
                      greenSide: theGreenSide[2].sprint.stats.kps,
                      redSide: theRedSide[2].sprint.stats.kps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Finesse",
                      greenSide: theGreenSide[2].sprint.stats.finessePercentage * 100,
                      redSide: theRedSide[2].sprint.stats.finessePercentage * 100,
                      fractionDigits: 2,
                      postfix: "%",
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Holds",
                      greenSide: theGreenSide[2].sprint.stats.holds,
                      redSide: theRedSide[2].sprint.stats.holds,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "T-spins",
                      greenSide: theGreenSide[2].sprint.stats.tSpins,
                      redSide: theRedSide[2].sprint.stats.tSpins,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "Quads",
                      greenSide: theGreenSide[2].sprint.stats.clears.quads,
                      redSide: theRedSide[2].sprint.stats.clears.quads,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PC's",
                      greenSide: theGreenSide[2].sprint.stats.clears.allClears,
                      redSide: theRedSide[2].sprint.stats.clears.allClears,
                      higherIsBetter: true,
                    ),
                  ],
                )
                else if (greenSideMode == Mode.player && redSideMode == Mode.player) CompareBoolThingy(greenSide: theGreenSide[2].sprint != null, redSide: theRedSide[2].sprint != null, label: "Played 40 Lines", trueIsBetter: true),
                if (theGreenSide[2].blitz != null && theRedSide[2].blitz != null && greenSideMode == Mode.player && redSideMode == Mode.player) Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.blitz, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareThingy(
                      label: "Score",
                      greenSide: theGreenSide[2].blitz.stats.score,
                      redSide: theRedSide[2].blitz.stats.score,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "SPP",
                      greenSide: theGreenSide[2].blitz.stats.spp,
                      redSide: theRedSide[2].blitz.stats.spp,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Level",
                      greenSide: theGreenSide[2].blitz.stats.level,
                      redSide: theRedSide[2].blitz.stats.level,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Lines",
                      greenSide: theGreenSide[2].blitz.stats.lines,
                      redSide: theRedSide[2].blitz.stats.lines,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.pieces.replaceAll(RegExp(r'\n'), " "),
                      greenSide: theGreenSide[2].blitz.stats.piecesPlaced,
                      redSide: theRedSide[2].blitz.stats.piecesPlaced,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: t.statCellNum.keys.replaceAll(RegExp(r'\n'), " "),
                      greenSide: theGreenSide[2].blitz.stats.inputs,
                      redSide: theRedSide[2].blitz.stats.inputs,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PPS",
                      greenSide: theGreenSide[2].blitz.stats.pps,
                      redSide: theRedSide[2].blitz.stats.pps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "KPP",
                      greenSide: theGreenSide[2].blitz.stats.kpp,
                      redSide: theRedSide[2].blitz.stats.kpp,
                      fractionDigits: 2,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "KPS",
                      greenSide: theGreenSide[2].blitz.stats.kps,
                      redSide: theRedSide[2].blitz.stats.kps,
                      fractionDigits: 2,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Finesse",
                      greenSide: theGreenSide[2].blitz.stats.finessePercentage * 100,
                      redSide: theRedSide[2].blitz.stats.finessePercentage * 100,
                      fractionDigits: 2,
                      postfix: "%",
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Holds",
                      greenSide: theGreenSide[2].blitz.stats.holds,
                      redSide: theRedSide[2].blitz.stats.holds,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "T-spins",
                      greenSide: theGreenSide[2].blitz.stats.tSpins,
                      redSide: theRedSide[2].blitz.stats.tSpins,
                      higherIsBetter: false,
                    ),
                    CompareThingy(
                      label: "Quads",
                      greenSide: theGreenSide[2].blitz.stats.clears.quads,
                      redSide: theRedSide[2].blitz.stats.clears.quads,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "PC's",
                      greenSide: theGreenSide[2].blitz.stats.clears.allClears,
                      redSide: theRedSide[2].blitz.stats.clears.allClears,
                      higherIsBetter: true,
                    ),
                  ],
                )
                else if (greenSideMode == Mode.player && redSideMode == Mode.player) CompareBoolThingy(greenSide: theGreenSide[2].blitz != null, redSide: theRedSide[2].blitz != null, label: "Played Blitz", trueIsBetter: true),
                if (greenSideMode == Mode.player && redSideMode == Mode.player) Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(t.zen, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    ),
                    CompareThingy(
                      label: "Level",
                      greenSide: theGreenSide[2].zen.level,
                      redSide: theRedSide[2].zen.level,
                      higherIsBetter: true,
                    ),
                    CompareThingy(
                      label: "Score",
                      greenSide: theGreenSide[2].zen.score,
                      redSide: theRedSide[2].zen.score,
                      higherIsBetter: true,
                    ),
                  ],
                )
              ],
            )
            else Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(t.compareViewNoValues(avgR: "\$avgR"), textAlign: TextAlign.center),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerSelector extends StatelessWidget {
  final List data;
  final Mode mode;
  final Function fetch;
  final Function change;
  final Function updateState;
  const PlayerSelector(
      {super.key,
      required this.data,
      required this.mode,
      required this.updateState,
      required this.fetch,
      required this.change});

  @override
  Widget build(BuildContext context) {
    final TextEditingController playerController = TextEditingController();
    String underFieldString = "";
    if (!listEquals(data, [null, null, null])){
      switch (mode){
        case Mode.player:
          playerController.text = data[0] != null ? data[0].username : "";
          break;
        case Mode.stats:
          playerController.text = "${data[2].league.apm} ${data[2].league.pps} ${data[2].league.vs}";
          break;
        case Mode.averages:
          playerController.text = "\$avg${data[2].league.rank.toUpperCase()}";
          break;
      }
    }
    if (!listEquals(data, [null, null, null])){
      switch (mode){
        case Mode.player:
          underFieldString = data[0] != null ? data[0].toString() : "???";
          break;
        case Mode.stats:
          underFieldString = "${data[2].league.apm} APM, ${data[2].league.pps} PPS, ${data[2].league.vs} VS";
          break;
        case Mode.averages:
          underFieldString = t.averageXrank(rankLetter: data[2].league.rank.toUpperCase());
          break;
      }
    }
    return Column(
      children: [
        TextField(
            autocorrect: false,
            enableSuggestions: false,
            maxLength: 25,
            controller: playerController,
            decoration: const InputDecoration(counter: Offstage()),
            onSubmitted: (String value) {
              underFieldString = "Fetching...";
              fetch(value);
            }),
          if (data[0] != null && data[1] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DropdownButton(
                items: data[1],
                value: data[0],
                onChanged: (value) => change(value!),
              ),
            )
          else Text(
            underFieldString,
            style: const TextStyle(
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
          ),
      ],
    );
  }
}

const TextStyle verdictStyle = TextStyle(fontSize: 14, fontFamily: "Eurostile Round Condensed", color: Colors.grey, height: 1.1);

class CompareThingy extends StatelessWidget {
  final num greenSide;
  final num redSide;
  final String label;
  final bool higherIsBetter;
  final int? fractionDigits;
  final String? postfix;
  final String? prefix;
  const CompareThingy(
      {super.key,
      required this.greenSide,
      required this.redSide,
      required this.label,
      required this.higherIsBetter,
      this.fractionDigits,
      this.prefix,
      this.postfix});

  String verdict(num greenSide, num redSide, int fraction) {
    var f = NumberFormat("+#,###.##;-#,###.##");
    f.maximumFractionDigits = fraction;
    return f.format((greenSide - redSide)) + (postfix ?? "");
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat.decimalPattern(LocaleSettings.currentLocale.languageCode);
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
                transform: const GradientRotation(0.6),
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
              )
            ),
            child: Text(
              (prefix ?? "") + f.format(greenSide) + (postfix ?? ""),
              style: const TextStyle(
                fontSize: 22,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 1.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 2.0,
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
                style: verdictStyle,
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
              transform: const GradientRotation(-0.6),
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
              (prefix ?? "") + f.format(redSide) + (postfix ?? ""),
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
            greenSide ? t.yes : t.no,
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
            const Text("---", style: verdictStyle, textAlign: TextAlign.center)
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
            redSide ? t.yes : t.no,
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
          Expanded(child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [Colors.green, Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                transform: const GradientRotation(0.6),
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
              )
            ),
            child: Text(get40lTime(greenSide.inMicroseconds), style: const TextStyle(
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
              ), textAlign: TextAlign.start)
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
                verdict(greenSide, redSide).toString(), style: verdictStyle, textAlign: TextAlign.center)
            ],
          ),
          Expanded(child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [Colors.red, Colors.transparent],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              transform: const GradientRotation(-0.6),
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
            child: Text(get40lTime(redSide.inMicroseconds), style: const TextStyle(
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
              ), textAlign: TextAlign.end)
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
    var f = NumberFormat("#,### ${t.daysLater};#,### ${t.dayseBefore}");
    String result = "---";
    if (greenSide != null && redSide != null) {
      result = f.format(greenSide.difference(redSide).inDays);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    DateFormat f = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode);
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
              greenSide != null ? f.format(greenSide!) : t.fromBeginning,
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
              Text(verdict(greenSide, redSide), style: verdictStyle, textAlign: TextAlign.center)
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
              redSide != null ? f.format(redSide!) : t.fromBeginning,
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
