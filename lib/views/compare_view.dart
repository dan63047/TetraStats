import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';

enum Mode{
  player,
  stats,
  averages
}
Mode greenSideMode = Mode.player;
List<dynamic> theGreenSide = [null, null, null]; // TetrioPlayer?, List<DropdownMenuItem<TetrioPlayer>>?, TetraLeagueAlpha?
//TetrioPlayer? theGreenSide;
//List<DropdownMenuItem<TetrioPlayer>>? greenSideStates;
Mode redSideMode = Mode.player;
List<dynamic> theRedSide = [null, null, null];
//TetrioPlayer? theRedSide;
//List<DropdownMenuItem<TetrioPlayer>>? redSideStates;
final TetrioService teto = TetrioService();
final DateFormat dateFormat = DateFormat.yMd().add_Hm();
// ignore: unnecessary_string_escapes
var numbersReg = RegExp(r'\d+(\.\d*)*');

class CompareView extends StatefulWidget {
  final List<dynamic> greenSide;
  final List<dynamic> redSide;
  final Mode greenMode;
  final Mode redMode;
  const CompareView({Key? key, required this.greenSide, required this.redSide, required this.greenMode, required this.redMode})
      : super(key: key);

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
    super.initState();
  }

  @override
  void dispose(){
    theGreenSide = [null, null, null];
    theRedSide = [null, null, null];
    super.dispose();
  }

  void fetchRedSide(String user) async {
    try {
      var tearDownToNumbers = numbersReg.allMatches(user);
      if (tearDownToNumbers.length == 3) {
        redSideMode = Mode.stats;
        var threeNumbers = tearDownToNumbers.toList();
        double apm = double.parse(threeNumbers[0][0]!);
        double pps = double.parse(threeNumbers[1][0]!);
        double vs = double.parse(threeNumbers[2][0]!);
        theRedSide = [null,
        null,
        TetraLeagueAlpha(
          apm: apm,
          pps: pps,
          vs: vs,
          rd: noTrRd,
          gamesPlayed: -1,
          gamesWon: -1,
          bestRank: "z",
          decaying: true,
          rating: -1,
          rank: "z",
          percentileRank: "z",
          percentile: 1,
          standing: -1,
          standingLocal: -1,
          nextAt: -1,
          prevAt: -1)
        ];
        return setState(() {});
      }
      var player = await teto.fetchPlayer(user);
      //theRedSide
      redSideMode = Mode.player;
      late List<TetrioPlayer> states;
      List<DropdownMenuItem<TetrioPlayer>>? dStates = <DropdownMenuItem<TetrioPlayer>>[];
      try{
        states = await teto.getPlayer(player.userId);
      for (final TetrioPlayer state in states) {
        dStates.add(DropdownMenuItem<TetrioPlayer>(
        value: state, child: Text(dateFormat.format(state.state))));
      }
      dStates.firstWhere((element) => element.value == player, orElse: () {
        dStates?.add(DropdownMenuItem<TetrioPlayer>(
        value: player, child: const Text("Most recent one")));
        return DropdownMenuItem<TetrioPlayer>(
        value: player, child: const Text("Most recent one"));
      },);
      }on Exception {
        dStates = null;
      }
      theRedSide = [player, dStates, player.tlSeason1];
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
  }

  void changeRedSide(TetrioPlayer user) {
    setState(() {theRedSide[0] = user;
    theRedSide[2] = user.tlSeason1;});
  }

  void fetchGreenSide(String user) async {
    try {
      var tearDownToNumbers = numbersReg.allMatches(user);
      if (tearDownToNumbers.length == 3) {
        greenSideMode = Mode.stats;
        var threeNumbers = tearDownToNumbers.toList();
        double apm = double.parse(threeNumbers[0][0]!);
        double pps = double.parse(threeNumbers[1][0]!);
        double vs = double.parse(threeNumbers[2][0]!);
        theGreenSide = theRedSide = [null,
        null,
        TetraLeagueAlpha(
          apm: apm,
          pps: pps,
          vs: vs,
          rd: noTrRd,
          gamesPlayed: -1,
          gamesWon: -1,
          bestRank: "z",
          decaying: true,
          rating: -1,
          rank: "z",
          percentileRank: "z",
          percentile: 1,
          standing: -1,
          standingLocal: -1,
          nextAt: -1,
          prevAt: -1)
        ];
        return setState(() {});
      }
      var player = await teto.fetchPlayer(user);
      greenSideMode = Mode.player;
      late List<TetrioPlayer> states;
      List<DropdownMenuItem<TetrioPlayer>>? dStates = <DropdownMenuItem<TetrioPlayer>>[];
      try{
        states = await teto.getPlayer(player.userId);
      for (final TetrioPlayer state in states) {
        dStates.add(DropdownMenuItem<TetrioPlayer>(
        value: state, child: Text(dateFormat.format(state.state))));
      }
      dStates.firstWhere((element) => element.value == player, orElse: () {
        dStates?.add(DropdownMenuItem<TetrioPlayer>(
        value: player, child: const Text("Most recent one")));
        return DropdownMenuItem<TetrioPlayer>(
        value: player, child: const Text("Most recent one"));
      },);
      }on Exception {
        dStates = null;
      }
      theGreenSide = [player, dStates, player.tlSeason1];
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
  }

  void changeGreenSide(TetrioPlayer user) {
    setState(() {theGreenSide[0] = user;
    theGreenSide[2] = user.tlSeason1;});
  }

  double getWinrateByTR(double yourGlicko, double yourRD, double notyourGlicko,
      double notyourRD) {
    return ((1 /
        (1 +
            pow(
                10,
                (notyourGlicko - yourGlicko) /
                    (400 *
                        sqrt(1 +
                            (3 *
                                pow(0.0057564273, 2) *
                                (pow(yourRD, 2) + pow(notyourRD, 2)) /
                                pow(pi, 2))))))));
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    String titleGreenSide;
    String titleRedSide;
    switch (greenSideMode){
      case Mode.player:
        titleGreenSide = theGreenSide[0] != null ? theGreenSide[0].username.toUpperCase() : "???";
        break;
      case Mode.stats:
        titleGreenSide = "${theGreenSide[2].apm} APM, ${theGreenSide[2].pps} PPS, ${theGreenSide[2].vs} VS";
        break;
      case Mode.averages:
        titleGreenSide = "average";
        break;
    }
    switch (redSideMode){
      case Mode.player:
        titleRedSide = theRedSide[0] != null ? theRedSide[0].username.toUpperCase() : "???";
        break;
      case Mode.stats:
        titleRedSide = "${theRedSide[2].apm} APM, ${theRedSide[2].pps} PPS, ${theRedSide[2].vs} VS";
        break;
      case Mode.averages:
        titleRedSide = "average";
        break;
    }
    return Scaffold(
      appBar: AppBar(title: Text("$titleGreenSide vs $titleRedSide")),
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
              ),
              const SliverToBoxAdapter(
                child: Divider(),
              )
            ];
          },
          body: ListView(
                  children: !listEquals(theGreenSide, [null, null, null]) && !listEquals(theRedSide, [null, null, null])? [
                    if (theGreenSide[0] != null &&
                        theRedSide[0] != null &&
                        theGreenSide[0]!.role != "banned" &&
                        theRedSide[0]!.role != "banned")
                      Column(
                        children: [
                          CompareRegTimeThingy(
                              greenSide: theGreenSide[0].registrationTime,
                              redSide: theRedSide[0].registrationTime,
                              label: "Registred"),
                          CompareThingy(
                            label: "Level",
                            greenSide: theGreenSide[0].level,
                            redSide: theRedSide[0].level,
                            higherIsBetter: true,
                            fractionDigits: 2,
                          ),
                          if (!theGreenSide[0].gameTime.isNegative &&
                              !theRedSide[0].gameTime.isNegative)
                            CompareThingy(
                              greenSide: theGreenSide[0].gameTime.inMicroseconds /
                                  1000000 /
                                  60 /
                                  60,
                              redSide: theRedSide[0].gameTime.inMicroseconds /
                                  1000000 /
                                  60 /
                                  60,
                              label: "Hours Played",
                              higherIsBetter: true,
                              fractionDigits: 2,
                            ),
                          if (theGreenSide[0].gamesPlayed >= 0 &&
                              theRedSide[0].gamesPlayed >= 0)
                            CompareThingy(
                              label: "Online Games",
                              greenSide: theGreenSide[0].gamesPlayed,
                              redSide: theRedSide[0].gamesPlayed,
                              higherIsBetter: true,
                            ),
                          if (theGreenSide[0].gamesWon >= 0 &&
                              theRedSide[0].gamesWon >= 0)
                            CompareThingy(
                              label: "Games Won",
                              greenSide: theGreenSide[0].gamesWon,
                              redSide: theRedSide[0].gamesWon,
                              higherIsBetter: true,
                            ),
                          CompareThingy(
                            label: "Friends",
                            greenSide: theGreenSide[0].friendCount,
                            redSide: theRedSide[0].friendCount,
                            higherIsBetter: true,
                          ),
                          const Divider(),
                        ],
                      ),
                    if (theGreenSide[0] != null &&
                        theRedSide[0] != null &&
                        (theGreenSide[0]!.role == "banned" ||
                        theRedSide[0]!.role == "banned"))
                      CompareBoolThingy(
                          greenSide: theGreenSide[0].role == "banned",
                          redSide: theRedSide[0].role == "banned",
                          label: "Banned",
                          trueIsBetter: false),
                    (theGreenSide[2].gamesPlayed > 0 || greenSideMode == Mode.stats) &&
                    (theRedSide[2].gamesPlayed > 0 || redSideMode == Mode.stats)
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text("Tetra League",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ),
                              if (theGreenSide[2].gamesPlayed > 9 &&
                                  theRedSide[2].gamesPlayed > 9 &&
                                  greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                                CompareThingy(
                                  label: "TR",
                                  greenSide: theGreenSide[2].rating,
                                  redSide: theRedSide[2].rating,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                              CompareThingy(
                                label: "Games Played",
                                greenSide: theGreenSide[2].gamesPlayed,
                                redSide: theRedSide[2].gamesPlayed,
                                higherIsBetter: true,
                              ),
                              if (greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                              CompareThingy(
                                label: "Games Won",
                                greenSide: theGreenSide[2].gamesWon,
                                redSide: theRedSide[2].gamesWon,
                                higherIsBetter: true,
                              ),
                              if (greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                              CompareThingy(
                                label: "WR %",
                                greenSide:
                                    theGreenSide[2].winrate * 100,
                                redSide: theRedSide[2].winrate * 100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                              if (theGreenSide[2].gamesPlayed > 9 &&
                                  theRedSide[2].gamesPlayed > 9 &&
                                  greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                                CompareThingy(
                                  label: "Glicko",
                                  greenSide: theGreenSide[2].glicko!,
                                  redSide: theRedSide[2].glicko!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide[2].gamesPlayed > 9 &&
                                  theRedSide[2].gamesPlayed > 9 &&
                                  greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                                CompareThingy(
                                  label: "RD",
                                  greenSide: theGreenSide[2].rd!,
                                  redSide: theRedSide[2].rd!,
                                  fractionDigits: 3,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide[2].standing > 0 &&
                                  theRedSide[2].standing > 0 &&
                                  greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                                CompareThingy(
                                  label: "№ in LB",
                                  greenSide: theGreenSide[2].standing,
                                  redSide: theRedSide[2].standing,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide[2].standingLocal > 0 &&
                                  theRedSide[2].standingLocal > 0 &&
                                  greenSideMode == Mode.player &&
                                  redSideMode == Mode.player)
                                CompareThingy(
                                  label: "№ in local LB",
                                  greenSide:
                                      theGreenSide[2].standingLocal,
                                  redSide: theRedSide[2].standingLocal,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide[2].apm != null &&
                                  theRedSide[2].apm != null)
                                CompareThingy(
                                  label: "APM",
                                  greenSide: theGreenSide[2].apm!,
                                  redSide: theRedSide[2].apm!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide[2].pps != null &&
                                  theRedSide[2].pps != null)
                                CompareThingy(
                                  label: "PPS",
                                  greenSide: theGreenSide[2].pps!,
                                  redSide: theRedSide[2].pps!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide[2].vs != null &&
                                  theRedSide[2].vs != null)
                                CompareThingy(
                                  label: "VS",
                                  greenSide: theGreenSide[2].vs!,
                                  redSide: theRedSide[2].vs!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                            ],
                          )
                        : CompareBoolThingy(
                            greenSide: theGreenSide[2].gamesPlayed > 0,
                            redSide: theRedSide[2].gamesPlayed > 0,
                            label: "Played Tetra League",
                            trueIsBetter: false),
                    const Divider(),
                    if (theGreenSide[2].nerdStats != null &&
                        theRedSide[2].nerdStats != null)
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
                            greenSide: theGreenSide[2].nerdStats!.app,
                            redSide: theRedSide[2].nerdStats!.app,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "VS/APM",
                            greenSide: theGreenSide[2].nerdStats!.vsapm,
                            redSide: theRedSide[2].nerdStats!.vsapm,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/S",
                            greenSide: theGreenSide[2].nerdStats!.dss,
                            redSide: theRedSide[2].nerdStats!.dss,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/P",
                            greenSide: theGreenSide[2].nerdStats!.dsp,
                            redSide: theRedSide[2].nerdStats!.dsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "APP + DS/P",
                            greenSide:
                                theGreenSide[2].nerdStats!.appdsp,
                            redSide: theRedSide[2].nerdStats!.appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Cheese",
                            greenSide:
                                theGreenSide[2].nerdStats!.cheese,
                            redSide: theRedSide[2].nerdStats!.cheese,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Garbage Eff.",
                            greenSide: theGreenSide[2].nerdStats!.gbe,
                            redSide: theRedSide[2].nerdStats!.gbe,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Weighted APP",
                            greenSide:
                                theGreenSide[2].nerdStats!.nyaapp,
                            redSide: theRedSide[2].nerdStats!.nyaapp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Area",
                            greenSide: theGreenSide[2].nerdStats!.area,
                            redSide: theRedSide[2].nerdStats!.area,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Est. of TR",
                            greenSide: theGreenSide[2].estTr!.esttr,
                            redSide: theRedSide[2].estTr!.esttr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          if (theGreenSide[2].gamesPlayed > 9 &&
                              theGreenSide[2].gamesPlayed > 9 &&
                              greenSideMode == Mode.player &&
                              redSideMode == Mode.player)
                            CompareThingy(
                              label: "Acc. of Est.",
                              greenSide: theGreenSide[2].esttracc!,
                              redSide: theRedSide[2].esttracc!,
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
                                            return RadarChartTitle(text: 'APM', angle: angle);
                                          case 1:
                                            return RadarChartTitle(text: 'PPS', angle: angle);
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
                                          fillColor: const Color.fromARGB(115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: theGreenSide[2].apm! * apmWeight),
                                            RadarEntry(value: theGreenSide[2].pps! * ppsWeight),
                                            RadarEntry(value: theGreenSide[2].vs! * vsWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.app * appWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.dss * dssWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.dsp * dspWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.appdsp * appdspWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.vsapm * vsapmWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.cheese * cheeseWeight),
                                            RadarEntry(value: theGreenSide[2].nerdStats!.gbe * gbeWeight),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: theRedSide[2].apm! * apmWeight),
                                            RadarEntry(value: theRedSide[2].pps! * ppsWeight),
                                            RadarEntry(value: theRedSide[2].vs! * vsWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.app * appWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.dss * dssWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.dsp * dspWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.appdsp * appdspWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.vsapm * vsapmWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.cheese * cheeseWeight),
                                            RadarEntry(value: theRedSide[2].nerdStats!.gbe * gbeWeight),
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
                                            return RadarChartTitle(text: 'Opener',angle: angle);
                                          case 1:
                                            return RadarChartTitle(text: 'Stride', angle: angle);
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
                                          fillColor: const Color.fromARGB(115, 76, 175, 79),
                                          borderColor: Colors.green,
                                          dataEntries: [
                                            RadarEntry(value: theGreenSide[2].playstyle!.opener),
                                            RadarEntry(value: theGreenSide[2].playstyle!.stride),
                                            RadarEntry(value: theGreenSide[2].playstyle!.infds),
                                            RadarEntry(value: theGreenSide[2].playstyle!.plonk),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(value: theRedSide[2].playstyle!.opener),
                                            RadarEntry(value: theRedSide[2].playstyle!.stride),
                                            RadarEntry(value: theRedSide[2].playstyle!.infds),
                                            RadarEntry(value: theRedSide[2].playstyle!.plonk),
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
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text("Win Chance",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ),
                              if (greenSideMode == Mode.player && redSideMode == Mode.player)
                              CompareThingy(
                                label: "By Glicko",
                                greenSide: getWinrateByTR(
                                        theGreenSide[2].glicko!,
                                        theGreenSide[2].rd!,
                                        theRedSide[2].glicko!,
                                        theRedSide[2].rd!) *
                                    100,
                                redSide: getWinrateByTR(
                                        theRedSide[2].glicko!,
                                        theRedSide[2].rd!,
                                        theGreenSide[2].glicko!,
                                        theGreenSide[2].rd!) *
                                    100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                              CompareThingy(
                                label: "By Est. TR",
                                greenSide: getWinrateByTR(
                                        theGreenSide[2].estTr!.estglicko,
                                        theGreenSide[2].rd!,
                                        theRedSide[2].estTr!.estglicko,
                                        theRedSide[2].rd!) *
                                    100,
                                redSide: getWinrateByTR(
                                        theRedSide[2].estTr!.estglicko,
                                        theRedSide[2].rd!,
                                        theGreenSide[2].estTr!.estglicko,
                                        theGreenSide[2].rd!) *
                                    100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                            ],
                          )
                        ],
                      )
                  ] : [Text("Please, enter username, user ID, or APM-PPS-VS values (divider doesn't matter) to both of fields")],
                )
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
    if (!listEquals(data, [null, null, null])){
      switch (mode){
        case Mode.player:
          playerController.text = data[0] != null ? data[0].username : "???";
          break;
        case Mode.stats:
          playerController.text = "${data[2].apm} ${data[2].pps} ${data[2].vs}";
          break;
        case Mode.averages:
          playerController.text = "average";
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
              fetch(value);
            }),
        if (data[0] != null && data[1] == null)
          Text(
            data[0].toString(),
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
          if (data[0] != null && data[1] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DropdownButton(
                items: data[1],
                value: data[0],
                onChanged: (value) => change(value!),
              ),
            )
      ],
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
    if (greenSide != null && redSide != null) {
      result = f.format(greenSide.difference(redSide).inDays);
    }
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
