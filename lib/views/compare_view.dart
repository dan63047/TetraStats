import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';

TetrioPlayer? theGreenSide;
TetrioPlayer? theRedSide;
final TetrioService teto = TetrioService();

class CompareView extends StatefulWidget {
  final TetrioPlayer greenSide;
  final TetrioPlayer? redSide;
  const CompareView({Key? key, required this.greenSide, required this.redSide}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    theGreenSide = widget.greenSide;
    theRedSide = widget.redSide;
    _scrollController = ScrollController();
    super.initState();
  }

  void fetchRedSide(String user) async {
    try {
      theRedSide = await teto.fetchPlayer(user, false);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
  }

  void fetchGreenSide(String user) async {
    try {
      theGreenSide = await teto.fetchPlayer(user, false);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Falied to assign $user")));
    }
    setState(() {});
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: PlayerSelector(player: theGreenSide, change: fetchGreenSide, updateState: _justUpdate),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text("VS"),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: PlayerSelector(player: theRedSide, change: fetchRedSide, updateState: _justUpdate),
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
                    CompareThingy(
                      label: "Level",
                      greenSide: theGreenSide!.level,
                      redSide: theRedSide!.level,
                      higherIsBetter: true,
                      fractionDigits: 2,
                    ),
                    if (theGreenSide!.gamesPlayed >= 0 && theRedSide!.gamesPlayed >= 0)
                      CompareThingy(
                        label: "Online Games",
                        greenSide: theGreenSide!.gamesPlayed,
                        redSide: theRedSide!.gamesPlayed,
                        higherIsBetter: true,
                      ),
                    if (theGreenSide!.gamesWon >= 0 && theRedSide!.gamesWon >= 0)
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
                    const Divider(),
                    theGreenSide!.tlSeason1.gamesPlayed > 0 && theRedSide!.tlSeason1.gamesPlayed > 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 && theRedSide!.tlSeason1.gamesPlayed > 9)
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
                                greenSide: theGreenSide!.tlSeason1.winrate * 100,
                                redSide: theRedSide!.tlSeason1.winrate * 100,
                                fractionDigits: 2,
                                higherIsBetter: true,
                              ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 && theRedSide!.tlSeason1.gamesPlayed > 9)
                                CompareThingy(
                                  label: "Glicko",
                                  greenSide: theGreenSide!.tlSeason1.glicko!,
                                  redSide: theRedSide!.tlSeason1.glicko!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.gamesPlayed > 9 && theRedSide!.tlSeason1.gamesPlayed > 9)
                                CompareThingy(
                                  label: "RD",
                                  greenSide: theGreenSide!.tlSeason1.rd!,
                                  redSide: theRedSide!.tlSeason1.rd!,
                                  fractionDigits: 3,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.standing > 0 && theRedSide!.tlSeason1.standing > 0)
                                CompareThingy(
                                  label: "№ in LB",
                                  greenSide: theGreenSide!.tlSeason1.standing,
                                  redSide: theRedSide!.tlSeason1.standing,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.standingLocal > 0 && theRedSide!.tlSeason1.standingLocal > 0)
                                CompareThingy(
                                  label: "№ in local LB",
                                  greenSide: theGreenSide!.tlSeason1.standingLocal,
                                  redSide: theRedSide!.tlSeason1.standingLocal,
                                  higherIsBetter: false,
                                ),
                              if (theGreenSide!.tlSeason1.apm != null && theRedSide!.tlSeason1.apm != null)
                                CompareThingy(
                                  label: "APM",
                                  greenSide: theGreenSide!.tlSeason1.apm!,
                                  redSide: theRedSide!.tlSeason1.apm!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.pps != null && theRedSide!.tlSeason1.pps != null)
                                CompareThingy(
                                  label: "PPS",
                                  greenSide: theGreenSide!.tlSeason1.pps!,
                                  redSide: theRedSide!.tlSeason1.pps!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                              if (theGreenSide!.tlSeason1.vs != null && theRedSide!.tlSeason1.vs != null)
                                CompareThingy(
                                  label: "VS",
                                  greenSide: theGreenSide!.tlSeason1.vs!,
                                  redSide: theRedSide!.tlSeason1.vs!,
                                  fractionDigits: 2,
                                  higherIsBetter: true,
                                ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                            child: Row(children: [
                              Expanded(
                                  child: Text(
                                theGreenSide!.tlSeason1.gamesPlayed > 0 ? "Yes" : "No",
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.start,
                              )),
                              Column(
                                children: const [
                                  Text(
                                    "Played Tetra League",
                                    style: TextStyle(fontSize: 22),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "---",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Expanded(
                                  child: Text(
                                theRedSide!.tlSeason1.gamesPlayed > 0 ? "Yes" : "No",
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              )),
                            ]),
                          ),
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
                            child: Text("Nerd Stats", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
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
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.appdsp,
                            redSide: theRedSide!.tlSeason1.nerdStats!.appdsp,
                            fractionDigits: 3,
                            higherIsBetter: true,
                          ),
                          CompareThingy(
                            label: "Cheese",
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.cheese,
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
                            greenSide: theGreenSide!.tlSeason1.nerdStats!.nyaapp,
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
                          if (theGreenSide!.tlSeason1.gamesPlayed > 9 && theGreenSide!.tlSeason1.gamesPlayed > 9)
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
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                          fillColor: const Color.fromARGB(117, 105, 240, 175),
                                          borderColor: Colors.greenAccent,
                                          dataEntries: [
                                            RadarEntry(value: theGreenSide!.tlSeason1.apm! * 1),
                                            RadarEntry(value: theGreenSide!.tlSeason1.pps! * 45),
                                            RadarEntry(value: theGreenSide!.tlSeason1.vs! * 0.444),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.app * 185),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.dss * 175),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.dsp * 450),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.appdsp * 140),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.vsapm * 60),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.cheese * 1.25),
                                            RadarEntry(value: theGreenSide!.tlSeason1.nerdStats!.gbe * 315),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(117, 255, 82, 82),
                                          borderColor: Colors.redAccent,
                                          dataEntries: [
                                            RadarEntry(value: theRedSide!.tlSeason1.apm! * 1),
                                            RadarEntry(value: theRedSide!.tlSeason1.pps! * 45),
                                            RadarEntry(value: theRedSide!.tlSeason1.vs! * 0.444),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.app * 185),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.dss * 175),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.dsp * 450),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.appdsp * 140),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.vsapm * 60),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.cheese * 1.25),
                                            RadarEntry(value: theRedSide!.tlSeason1.nerdStats!.gbe * 315),
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
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                          fillColor: const Color.fromARGB(117, 105, 240, 175),
                                          borderColor: Colors.greenAccent,
                                          dataEntries: [
                                            RadarEntry(value: theGreenSide!.tlSeason1.playstyle!.opener),
                                            RadarEntry(value: theGreenSide!.tlSeason1.playstyle!.stride),
                                            RadarEntry(value: theGreenSide!.tlSeason1.playstyle!.infds),
                                            RadarEntry(value: theGreenSide!.tlSeason1.playstyle!.plonk),
                                          ],
                                        ),
                                        RadarDataSet(
                                          fillColor: const Color.fromARGB(117, 255, 82, 82),
                                          borderColor: Colors.redAccent,
                                          dataEntries: [
                                            RadarEntry(value: theRedSide!.tlSeason1.playstyle!.opener),
                                            RadarEntry(value: theRedSide!.tlSeason1.playstyle!.stride),
                                            RadarEntry(value: theRedSide!.tlSeason1.playstyle!.infds),
                                            RadarEntry(value: theRedSide!.tlSeason1.playstyle!.plonk),
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
                                child: Text("Win Chance", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
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
  final Function change;
  final Function updateState;
  const PlayerSelector({super.key, required this.player, required this.change, required this.updateState});

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
            change(value);
          },
        ),
        if (player != null) Text(player!.toString())
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
  const CompareThingy({super.key, required this.greenSide, required this.redSide, required this.label, required this.higherIsBetter, this.fractionDigits});

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
              child: Text(
            f.format(greenSide),
            style: const TextStyle(
              fontSize: 22,
            ),
            textAlign: TextAlign.start,
          )),
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Text(
                verdict(greenSide, redSide, fractionDigits != null ? fractionDigits! + 2 : 0),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
              child: Text(
            f.format(redSide),
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }
}
