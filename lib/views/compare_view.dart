import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';

TetrioPlayer? theGreenSide;
List<DropdownMenuItem<TetrioPlayer>>? greenSideStates;
TetrioPlayer? theRedSide;
List<DropdownMenuItem<TetrioPlayer>>? redSideStates;
final TetrioService teto = TetrioService();
final DateFormat dateFormat = DateFormat.yMMMd().add_Hms();

class CompareView extends StatefulWidget {
  final TetrioPlayer greenSide;
  final TetrioPlayer? redSide;
  const CompareView({Key? key, required this.greenSide, required this.redSide})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    theGreenSide = widget.greenSide;
    fetchGreenSide(widget.greenSide.userId);
    if (widget.redSide != null) fetchRedSide(widget.redSide!.userId); 
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose(){
    greenSideStates = null;
    theGreenSide = null;
    redSideStates = null;
    theRedSide = null;
    super.dispose();
  }

  void fetchRedSide(String user) async {
    try {
      theRedSide = await teto.fetchPlayer(user);
      late List<TetrioPlayer> states;
      try{
        states = await teto.getPlayer(theRedSide!.userId);
        redSideStates = <DropdownMenuItem<TetrioPlayer>>[];
      for (final TetrioPlayer state in states) {
        redSideStates!.add(DropdownMenuItem<TetrioPlayer>(
        value: state, child: Text(dateFormat.format(state.state))));
      }
      redSideStates!.add(DropdownMenuItem<TetrioPlayer>(
        value: theRedSide!, child: const Text("Most recent one")));
      }on Exception {
        states = [];
        redSideStates = null;
      }
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
  }

  void changeRedSide(TetrioPlayer user) {
    setState(() {theRedSide = user;});
  }

  void fetchGreenSide(String user) async {
    try {
      theGreenSide = await teto.fetchPlayer(user);
      late List<TetrioPlayer> states;
      greenSideStates = null;
      try{
        states = await teto.getPlayer(theGreenSide!.userId);
         greenSideStates = <DropdownMenuItem<TetrioPlayer>>[];
      for (final TetrioPlayer state in states) {
        greenSideStates!.add(DropdownMenuItem<TetrioPlayer>(
        value: state, child: Text(dateFormat.format(state.state))));
      }
      greenSideStates!.add(DropdownMenuItem<TetrioPlayer>(
        value: theGreenSide!, child: const Text("Most recent one")));
      }on Exception {
        states = [];
        greenSideStates = null;
      }
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
  }

  void changeGreenSide(TetrioPlayer user) {
    setState(() {theGreenSide = user;});
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${theGreenSide != null ? theGreenSide!.username.toUpperCase() : "???"} vs ${theRedSide != null ? theRedSide!.username.toUpperCase() : "???"}"),
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
                            child: PlayerSelector(
                              player: theGreenSide,
                              states: greenSideStates,
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
                              player: theRedSide,
                              states: redSideStates,
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
          body: theGreenSide != null && theRedSide != null
              ? ListView(
                  children: [
                    if (theGreenSide!.role != "banned" &&
                        theRedSide!.role != "banned")
                      Column(
                        children: [
                          CompareRegTimeThingy(
                              greenSide: theGreenSide!.registrationTime,
                              redSide: theRedSide!.registrationTime,
                              label: "Registred"),
                          CompareThingy(
                            label: "Level",
                            greenSide: theGreenSide!.level,
                            redSide: theRedSide!.level,
                            higherIsBetter: true,
                            fractionDigits: 2,
                          ),
                          if (!theGreenSide!.gameTime.isNegative &&
                              !theRedSide!.gameTime.isNegative)
                            CompareThingy(
                              greenSide: theGreenSide!.gameTime.inMicroseconds /
                                  1000000 /
                                  60 /
                                  60,
                              redSide: theRedSide!.gameTime.inMicroseconds /
                                  1000000 /
                                  60 /
                                  60,
                              label: "Hours Played",
                              higherIsBetter: true,
                              fractionDigits: 2,
                            ),
                          if (theGreenSide!.gamesPlayed >= 0 &&
                              theRedSide!.gamesPlayed >= 0)
                            CompareThingy(
                              label: "Online Games",
                              greenSide: theGreenSide!.gamesPlayed,
                              redSide: theRedSide!.gamesPlayed,
                              higherIsBetter: true,
                            ),
                          if (theGreenSide!.gamesWon >= 0 &&
                              theRedSide!.gamesWon >= 0)
                            CompareThingy(
                              label: "Games Won",
                              greenSide: theGreenSide!.gamesWon,
                              redSide: theRedSide!.gamesWon,
                              higherIsBetter: true,
                            ),
                          CompareThingy(
                            label: "Friends",
                            greenSide: theGreenSide!.friendCount,
                            redSide: theRedSide!.friendCount,
                            higherIsBetter: true,
                          ),
                        ],
                      )
                    else
                      CompareBoolThingy(
                          greenSide: theGreenSide!.role == "banned",
                          redSide: theRedSide!.role == "banned",
                          label: "Banned",
                          trueIsBetter: false),
                    const Divider(),
                    theGreenSide!.tlSeason1.gamesPlayed > 0 &&
                            theRedSide!.tlSeason1.gamesPlayed > 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text("Tetra League",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 &&
                                  theRedSide!.tlSeason1.gamesPlayed > 9)
                                CompareThingy(
                                  label: "TR",
                                  greenSide: theGreenSide!.tlSeason1.rating,
                                  redSide: theRedSide!.tlSeason1.rating,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              CompareThingy(
                                label: "Games Played",
                                greenSide: theGreenSide!.tlSeason1.gamesPlayed,
                                redSide: theRedSide!.tlSeason1.gamesPlayed,
                                higherIsBetter: true,
                              ),
                              CompareThingy(
                                label: "Games Won",
                                greenSide: theGreenSide!.tlSeason1.gamesWon,
                                redSide: theRedSide!.tlSeason1.gamesWon,
                                higherIsBetter: true,
                              ),
                              CompareThingy(
                                label: "WR %",
                                greenSide:
                                    theGreenSide!.tlSeason1.winrate * 100,
                                redSide: theRedSide!.tlSeason1.winrate * 100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 &&
                                  theRedSide!.tlSeason1.gamesPlayed > 9)
                                CompareThingy(
                                  label: "Glicko",
                                  greenSide: theGreenSide!.tlSeason1.glicko!,
                                  redSide: theRedSide!.tlSeason1.glicko!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 &&
                                  theRedSide!.tlSeason1.gamesPlayed > 9)
                                CompareThingy(
                                  label: "RD",
                                  greenSide: theGreenSide!.tlSeason1.rd!,
                                  redSide: theRedSide!.tlSeason1.rd!,
                                  fractionDigits: 3,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.standing > 0 &&
                                  theRedSide!.tlSeason1.standing > 0)
                                CompareThingy(
                                  label: "№ in LB",
                                  greenSide: theGreenSide!.tlSeason1.standing,
                                  redSide: theRedSide!.tlSeason1.standing,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.standingLocal > 0 &&
                                  theRedSide!.tlSeason1.standingLocal > 0)
                                CompareThingy(
                                  label: "№ in local LB",
                                  greenSide:
                                      theGreenSide!.tlSeason1.standingLocal,
                                  redSide: theRedSide!.tlSeason1.standingLocal,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.apm != null &&
                                  theRedSide!.tlSeason1.apm != null)
                                CompareThingy(
                                  label: "APM",
                                  greenSide: theGreenSide!.tlSeason1.apm!,
                                  redSide: theRedSide!.tlSeason1.apm!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.pps != null &&
                                  theRedSide!.tlSeason1.pps != null)
                                CompareThingy(
                                  label: "PPS",
                                  greenSide: theGreenSide!.tlSeason1.pps!,
                                  redSide: theRedSide!.tlSeason1.pps!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.vs != null &&
                                  theRedSide!.tlSeason1.vs != null)
                                CompareThingy(
                                  label: "VS",
                                  greenSide: theGreenSide!.tlSeason1.vs!,
                                  redSide: theRedSide!.tlSeason1.vs!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                            ],
                          )
                        : CompareBoolThingy(
                            greenSide: theGreenSide!.tlSeason1.gamesPlayed > 0,
                            redSide: theRedSide!.tlSeason1.gamesPlayed > 0,
                            label: "Played Tetra League",
                            trueIsBetter: false),
                    const Divider(),
                    if (theGreenSide!.tlSeason1.apm != null &&
                        theRedSide!.tlSeason1.apm != null &&
                        theGreenSide!.tlSeason1.pps != null &&
                        theRedSide!.tlSeason1.pps != null &&
                        theGreenSide!.tlSeason1.vs != null &&
                        theRedSide!.tlSeason1.vs != null)
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
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.app,
                            redSide: theRedSide!.tlSeason1.nerdStats!.app,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "VS/APM",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.vsapm,
                            redSide: theRedSide!.tlSeason1.nerdStats!.vsapm,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/S",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.dss,
                            redSide: theRedSide!.tlSeason1.nerdStats!.dss,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "DS/P",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.dsp,
                            redSide: theRedSide!.tlSeason1.nerdStats!.dsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "APP + DS/P",
                            greenSide:
                                theGreenSide!.tlSeason1.nerdStats!.appdsp,
                            redSide: theRedSide!.tlSeason1.nerdStats!.appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Cheese",
                            greenSide:
                                theGreenSide!.tlSeason1.nerdStats!.cheese,
                            redSide: theRedSide!.tlSeason1.nerdStats!.cheese,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Garbage Eff.",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.gbe,
                            redSide: theRedSide!.tlSeason1.nerdStats!.gbe,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Weighted APP",
                            greenSide:
                                theGreenSide!.tlSeason1.nerdStats!.nyaapp,
                            redSide: theRedSide!.tlSeason1.nerdStats!.nyaapp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Area",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.area,
                            redSide: theRedSide!.tlSeason1.nerdStats!.area,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Est. of TR",
                            greenSide: theGreenSide!.tlSeason1.estTr!.esttr,
                            redSide: theRedSide!.tlSeason1.estTr!.esttr,
                            fractionDigits: 2,
                            higherIsBetter: true,
                          ),
                          if (theGreenSide!.tlSeason1.gamesPlayed > 9 &&
                              theGreenSide!.tlSeason1.gamesPlayed > 9)
                            CompareThingy(
                              label: "Acc. of Est.",
                              greenSide: theGreenSide!.tlSeason1.esttracc!,
                              redSide: theRedSide!.tlSeason1.esttracc!,
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
                                            RadarEntry(
                                                value: theGreenSide!
                                                        .tlSeason1.apm! *
                                                    apmWeight),
                                            RadarEntry(
                                                value: theGreenSide!
                                                        .tlSeason1.pps! *
                                                    ppsWeight),
                                            RadarEntry(
                                                value: theGreenSide!
                                                        .tlSeason1.vs! *
                                                    vsWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.app *
                                                    appWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.dss *
                                                    dssWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.dsp *
                                                    dspWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.appdsp *
                                                    appdspWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.vsapm *
                                                    vsapmWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.cheese *
                                                    cheeseWeight),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                        .nerdStats!.gbe *
                                                    gbeWeight),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(
                                                value:
                                                    theRedSide!.tlSeason1.apm! *
                                                        1),
                                            RadarEntry(
                                                value:
                                                    theRedSide!.tlSeason1.pps! *
                                                        45),
                                            RadarEntry(
                                                value:
                                                    theRedSide!.tlSeason1.vs! *
                                                        0.444),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.app *
                                                    185),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.dss *
                                                    175),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.dsp *
                                                    450),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.appdsp *
                                                    140),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.vsapm *
                                                    60),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.cheese *
                                                    1.25),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                        .nerdStats!.gbe *
                                                    315),
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
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                    .playstyle!.opener),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                    .playstyle!.stride),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                    .playstyle!.infds),
                                            RadarEntry(
                                                value: theGreenSide!.tlSeason1
                                                    .playstyle!.plonk),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(
                                              115, 244, 67, 54),
                                          borderColor: Colors.red,
                                          dataEntries: [
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                    .playstyle!.opener),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                    .playstyle!.stride),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                    .playstyle!.infds),
                                            RadarEntry(
                                                value: theRedSide!.tlSeason1
                                                    .playstyle!.plonk),
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
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text("Win Chance",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ),
                              CompareThingy(
                                label: "By Glicko",
                                greenSide: getWinrateByTR(
                                        theGreenSide!.tlSeason1.glicko!,
                                        theGreenSide!.tlSeason1.rd!,
                                        theRedSide!.tlSeason1.glicko!,
                                        theRedSide!.tlSeason1.rd!) *
                                    100,
                                redSide: getWinrateByTR(
                                        theRedSide!.tlSeason1.glicko!,
                                        theRedSide!.tlSeason1.rd!,
                                        theGreenSide!.tlSeason1.glicko!,
                                        theGreenSide!.tlSeason1.rd!) *
                                    100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                            ],
                          )
                        ],
                      )
                  ],
                )
              : const Text("Please enter valid nicknames"),
        ),
      ),
    );
  }
}

class PlayerSelector extends StatelessWidget {
  final TetrioPlayer? player;
  final List<DropdownMenuItem<TetrioPlayer>>? states;
  final Function fetch;
  final Function change;
  final Function updateState;
  const PlayerSelector(
      {super.key,
      required this.player,
      required this.updateState,
      required this.fetch, this.states, required this.change, });

  @override
  Widget build(BuildContext context) {
    final TextEditingController playerController = TextEditingController();
    if (player != null) playerController.text = player!.username;
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
        if (player != null && states == null)
          Text(
            player!.toString(),
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
          if (player != null && states != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DropdownButton(
                items: states,
                value: player,
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
