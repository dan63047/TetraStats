// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/vs_graphs.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:window_manager/window_manager.dart';

enum Mode{
  player,
  stats,
  averages
}
final DateFormat dateFormat = DateFormat.yMd(LocaleSettings.currentLocale.languageCode).add_Hm();
var numbersReg = RegExp(r'\d+(\.\d*)*');
late String oldWindowTitle;

class CompareView extends StatefulWidget {
  final TetrioPlayer initPlayer;
  const CompareView(this.initPlayer);

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  late ScrollController _scrollController;
  List<TetrioPlayer> players = [];
  List<Summaries> summaries = [];
  TextStyle _expansionTileTitleTextStyle = TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 24.0);

  @override
  void initState() {
    _scrollController = ScrollController();
    players = [widget.initPlayer];
    getSummariesForInit();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
    }
    super.initState();
  }

  @override
  void dispose(){
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void getSummariesForInit() async {
    summaries.add(await teto.fetchSummaries(widget.initPlayer.userId));
    setState(() {
      
    });
  }

  void addPlayer(String nickname) async {
    players.add(await teto.fetchPlayer(nickname));
    summaries.add(await teto.fetchSummaries(players.last.userId));
    setState(() {
      
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Fuck go back',
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              SizedBox(
                height: 175.0,
                width: 300.0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(90.0, 18.0, 5.0, 0),
                    child: Text("Comparison", style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
              for (var p in players) SizedBox(
                width: 300.0,
                child: HeaderCard(p),
              ),
              SizedBox(width: 300, child: AddNewColumnCard(addPlayer))
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 300.0,
                child: Card(
                  child: Column(children: [
                    Text("Registration Date"),
                    Text("XP"),
                    Text("Time Played"),
                    Text("Online Games Played"),
                    Text("Online Games Won"),
                    Text("Followers"),
                  ]),
                ),
              ),
              for (var p in players) SizedBox(
                width: 300.0,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(timestamp(p.registrationTime!)),
                      RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])),
                      Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)),
                      Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white)),
                      Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white)),
                      Text(intf.format(p.friendCount))
                    ],
                  ),
                ),
              ),
            ]
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Tetra League", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Tetra Rating"),
                          Text("Glicko"),
                          Text("RD"),
                          Text("GLIXARE"),
                          Text("S1-like TR"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Games Played"),
                          Text("Games Won"),
                          Text("Winrate"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.league.tr.isNegative ? "---" : f4.format(s.league.tr)),
                            Text(s.league.glicko!.isNegative ? "---" : f4.format(s.league.glicko)),
                            Text(s.league.rd!.isNegative ? "---" : f4.format(s.league.rd), style: TextStyle(color: s.league.rd!.isNegative ? Colors.grey : Colors.white)),
                            Text(s.league.gxe.isNegative ? "---" : f4.format(s.league.gxe)),
                            Text(s.league.s1tr.isNegative ? "---" : f4.format(s.league.s1tr)),
                            Text(s.league.standing.isNegative ? "---" : "№ "+intf.format(s.league.standing)),
                            Text(s.league.standingLocal.isNegative ? "---" : "№ "+intf.format(s.league.standingLocal)),
                           // RichText(text: s.league.standingLocal.isNegative ? TextSpan(text: "---", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(s.league.standingLocal), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (in ${s.league.})", style: TextStyle(color: Colors.grey))]))
                            Text(intf.format(s.league.gamesPlayed)),
                            Text(intf.format(s.league.gamesWon)),
                            Text(s.league.winrate.isNaN ? "---" : f4.format(s.league.winrate*100)+"%"),
                            Text(s.league.apm != null ? f2.format(s.league.apm) : "---"),
                            Text(s.league.pps != null ? f2.format(s.league.pps) : "---"),
                            Text(s.league.vs != null ? f2.format(s.league.vs) : "---"),
                            Text(""),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.app) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.vsapm) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dss) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dsp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.appdsp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.cheese) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.gbe) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.nyaapp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.area) : "---"),
                            Text(""),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.opener) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.plonk) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.stride) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              ],
            ),
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Quick Play", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Altitude"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("KO's"),
                          Text("Top B2B"),
                          Text("Climb Speed"),
                          Text("Peak Climb Speed"),
                          Text("Time Spend"),
                          Text("Finesse"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.altitude) : "---"),
                            Text(s.zenith != null ? "№ "+intf.format(s.zenith!.rank) : "---"),
                            Text((s.zenith != null && !s.zenith!.countryRank.isNegative) ? "№ "+intf.format(s.zenith!.countryRank) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.apm) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.pps) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.vs) : "---"),
                            Text(s.zenith != null ? intf.format(s.zenith!.stats.kills) : "---"),
                            Text(s.zenith != null ? intf.format(s.zenith!.stats.topBtB) : "---"),
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.cps) : "---"),
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.peakrank) : "---"),
                            Text(s.zenith != null ? getMoreNormalTime(s.zenith!.stats.finalTime) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.stats.finessePercentage*100)+"%" : "---"),
                            Text(""),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.app) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.vsapm) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.dss) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.dsp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.appdsp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.cheese) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.gbe) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.nyaapp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.area) : "---"),
                            Text(""),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.opener) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.plonk) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.stride) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              ],
            ),
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Quick Play Expert", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Altitude"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("KO's"),
                          Text("Top B2B"),
                          Text("Climb Speed"),
                          Text("Peak Climb Speed"),
                          Text("Time Spend"),
                          Text("Finesse"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.zenith!.altitude) : "---"),
                            Text(s.zenithEx != null ? "№ "+intf.format(s.zenithEx!.rank) : "---"),
                            Text((s.zenithEx != null && !s.zenithEx!.countryRank.isNegative) ? "№ "+intf.format(s.zenithEx!.countryRank) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.apm) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.pps) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.vs) : "---"),
                            Text(s.zenithEx != null ? intf.format(s.zenithEx!.stats.kills) : "---"),
                            Text(s.zenithEx != null ? intf.format(s.zenithEx!.stats.topBtB) : "---"),
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.cps) : "---"),
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.zenith!.peakrank) : "---"),
                            Text(s.zenithEx != null ? getMoreNormalTime(s.zenithEx!.stats.finalTime) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.stats.finessePercentage*100)+"%" : "---"),
                            Text(""),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.app) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.vsapm) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.dss) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.dsp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.appdsp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.cheese) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.gbe) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.nyaapp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.area) : "---"),
                            Text(""),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.opener) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.plonk) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.stride) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              ],
            ),
          )
        ]),
            ],
          ),
        ),
      ),
    );
  }
}


// Table(
//                 border: TableBorder(verticalInside: BorderSide(color: Colors.grey)),
//                 defaultColumnWidth: FixedColumnWidth(350),
//                 columnWidths: {
//                   0: FixedColumnWidth(200.000)
//                 },
//                 children: [
//                   TableRow(
//                     decoration: BoxDecoration(color: Color.fromARGB(255, 10, 10, 10)),
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Account Created")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(timestamp(p.registrationTime!)))
//                     ]
//                   ),
//                   TableRow(
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("XP")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])))
//                     ]
//                   ),
//                   TableRow(
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Time Played")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)))
//                     ]
//                   ),
//                   TableRow(
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Online Games Played")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white))),
//                     ]
//                   ),
//                   TableRow(
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Online Games Won")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white))),
//                     ]
//                   ),
//                   TableRow(
//                     children: [
//                       Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Followers")),
//                       for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(p.friendCount))),
//                     ]
//                   ),
//                 ],
//               )
// Table(
//                     border: TableBorder(verticalInside: BorderSide(color: Colors.grey)),
//                     defaultColumnWidth: FixedColumnWidth(350),
//                     columnWidths: {
//                       0: FixedColumnWidth(200.000)
//                     },
//                     children: [
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Tetra Rating")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.tr.isNegative ? "---" : f4.format(s.league.tr))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Glicko")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.glicko!.isNegative ? "---" : f4.format(s.league.glicko))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("RD")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.rd!.isNegative ? "---" : f4.format(s.league.rd))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("GLIXARE")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.gxe.isNegative ? "---" : f4.format(s.league.gxe))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("S1-like TR")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.s1tr.isNegative ? "---" : f4.format(s.league.s1tr))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Games Played")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(s.league.gamesPlayed))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Games Won")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(s.league.gamesWon))),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Winrate")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.winrate.isNaN ? "---" : f4.format(s.league.winrate*100)+"%")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Attack Per Minute")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.apm) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Pieces Per Second")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.pps) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Versus Score")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.vs) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Nerd Stats")),
//                           for (var _ in summaries) Container(),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Attack Per Piece")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.app) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("VS / APM")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.vsapm) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Downstack Per Second")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dss) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Downstack Per Piece")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dsp) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("APP + DSP")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.appdsp) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Cheese Index")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.cheese) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Garbage Efficiency")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.gbe) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Weighted APP")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.nyaapp) : "---")),
//                         ]
//                       ),
//                       TableRow(
//                         children: [
//                           Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Area")),
//                           for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.area) : "---")),
//                         ]
//                       ),
//                     ],
//                   )



class HeaderCard extends StatelessWidget{
  final TetrioPlayer player;

  const HeaderCard(this.player);

  String fontStyle(int length){
    if (length < 10) return "Eurostile Round Extended";
    else if (length < 13) return "Eurostile Round";
    else return "Eurostile Round Condensed";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Card(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                if (player.bannerRevision != null) FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${player.userId}&rv=${player.bannerRevision}" : "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                  height: 120.0,
                  fadeInCurve: Easing.standard, fadeInDuration: Durations.long4
                )
                else SizedBox(height: 120.0),
                Positioned(
                  top: 20.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: player.role == "banned"
                      ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: 128)
                      : player.avatarRevision != null
                        ? FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${player.userId}&rv=${player.avatarRevision}" : "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                          fit: BoxFit.fitHeight, height: 128, placeholder: kTransparentImage, fadeInCurve: Easing.emphasizedDecelerate, fadeInDuration: Durations.long4)
                        : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: 128),
                  )
                ),
              ],
            ),
            RichText(
              text: TextSpan(text: player.username, style: TextStyle(
                fontFamily: fontStyle(player.username.length),
                fontSize: 28,
                shadows: textShadow
                ),
              )
            ),
          ],
        ),
      ),
    );
  }}

class AddNewColumnCard extends StatefulWidget{
  final Function addPlayer;

  const AddNewColumnCard(this.addPlayer);

  @override
  State<AddNewColumnCard> createState() => _AddNewColumnCardState();
}

class _AddNewColumnCardState extends State<AddNewColumnCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState(){
    _animController = AnimationController(
      duration: Durations.medium3,
      vsync: this,
    );
    _anim = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: _animController,
      curve: Easing.standard
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 175.0,
      child: Card(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return _anim.value > 0.5 ? Opacity(
              opacity: _anim.value*2-1,
              child: Container(
                transform: Matrix4.translationValues(0, 100-(_anim.value as double)*100, 0),
                child: Column(
                  children: [
                    Text("Enter username:"),
                    TextField(
                      autofocus: true,
                      onSubmitted: (value){
                        widget.addPlayer(value);
                      },
                      onTapOutside: (event) {
                        setState((){_animController.animateBack(0);});
                      },
                    )
                  ],
                ),
              ),
            ) : Center(
              child: IconButton(
                visualDensity: VisualDensity.comfortable,
                onPressed: (){setState((){_animController.forward();});},
                icon: Opacity(opacity: 1-(_anim.value as double)*2, child: Transform.translate(offset: Offset.fromDirection(pi*1.5, (_anim.value as double)*50), child: Transform.rotate(angle: (_anim.value as double)*2, child: Icon(Icons.add)))),
                constraints: BoxConstraints.expand(),
              ),
            );
          }
        )
      )
    );
  }
}