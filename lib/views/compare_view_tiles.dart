// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/aggregate_stats.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:transparent_image/transparent_image.dart';
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
  List<String> nicknames = [];
  Map<String, List<String>> TitesForStats = {
    "General": [
      "Registration Date",
      "XP",
      "Time Played",
      "Online Games Played",
      "Online Games Won",
      "Followers",
    ],
    "Tetra League": [
      "Tetra Rating",
      "Glicko",
      "RD",
      "GLIXARE",
      "S1-like TR",
      "Position",
      "Games Played",
      "Games Won",
      "Winrate",
      "Attack Per Minute",
      "Pieces Per Second",
      "Versus Score",
      "Nerd Stats",
      "Attack Per Piece",
      "VS / APM",
      "Downstack Per Second",
      "Downstack Per Piece",
      "APP + DSP",
      "Cheese Index",
      "Garbage Efficiency",
      "Weighted APP",
      "Area",
      "Playstyle",
      "Opener",
      "Plonk",
      "Stride",
      "Infinite Downstack"
    ],
    "Quick Play":[
      "Altitude",
      "Position",
      "Attack Per Minute",
      "Pieces Per Second",
      "Versus Score",
      "KO's",
      "Top B2B",
      "Climb Speed",
      "Peak Climb Speed",
      "Time Spend",
      "Finesse",
      "Nerd Stats",
      "Attack Per Piece",
      "VS / APM",
      "Downstack Per Second",
      "Downstack Per Piece",
      "APP + DSP",
      "Cheese Index",
      "Garbage Efficiency",
      "Weighted APP",
      "Area",
      "Playstyle",
      "Opener",
      "Plonk",
      "Stride",
      "Infinite Downstack",
    ],
    "Quick Play Expert": [
      "Altitude",
      "Position",
      "Attack Per Minute",
      "Pieces Per Second",
      "Versus Score",
      "KO's",
      "Top B2B",
      "Climb Speed",
      "Peak Climb Speed",
      "Time Spend",
      "Finesse",
      "Nerd Stats",
      "Attack Per Piece",
      "VS / APM",
      "Downstack Per Second",
      "Downstack Per Piece",
      "APP + DSP",
      "Cheese Index",
      "Garbage Efficiency",
      "Weighted APP",
      "Area",
      "Playstyle",
      "Opener",
      "Plonk",
      "Stride",
      "Infinite Downstack",
    ],
    "40 Lines": [
      "Time",
      "Pieces",
      "Inputs",
      "Key Presses Per Piece",
      "Pieces Per Second",
      "Key Presses Per Second",
      ""
      // TODO: line clears
      // TODO: spins
    ],
    "Blitz": [
      "Score",
      "Pieces",
      "Inputs",
      "Key Presses Per Piece",
      "Pieces Per Second",
      "Key Presses Per Second",
      ""
    ],
    "Zen": [
      "Score",
      "Level"
    ]
  };
  List<List<List<dynamic>>> rawValues = [[],[],[],[],[],[],[]];
  List<List<List<Widget>>> formattedValues = [[],[],[],[],[],[],[]]; //formattedValues[category][player][stat]
  List<List<dynamic>> best = [];
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

  addvaluesEntrys(TetrioPlayer p, Summaries s){
    rawValues[0].add([
        p.registrationTime,
        p.xp,
        p.gameTime,
        p.gamesPlayed,
        p.gamesWon,
        p.friendCount
      ]);
    rawValues[1].add(
      [
        s.league.tr,
        s.league.glicko,
        s.league.rd,
        s.league.gxe,
        s.league.s1tr,
        s.league.standing,
        s.league.gamesPlayed,
        s.league.gamesWon,
        s.league.winrate,
        s.league.apm,
        s.league.pps,
        s.league.vs,
        "",
        s.league.nerdStats?.app,
        s.league.nerdStats?.vsapm,
        s.league.nerdStats?.dss,
        s.league.nerdStats?.dsp,
        s.league.nerdStats?.appdsp,
        s.league.nerdStats?.cheese,
        s.league.nerdStats?.gbe,
        s.league.nerdStats?.nyaapp,
        s.league.nerdStats?.area,
        "",
        s.league.playstyle?.opener,
        s.league.playstyle?.plonk,
        s.league.playstyle?.stride,
        s.league.playstyle?.infds,
      ]
    );
    rawValues[2].add([
        s.zenith?.stats.zenith?.altitude,
        s.zenith?.rank,
        s.zenith?.aggregateStats.apm,
        s.zenith?.aggregateStats.pps,
        s.zenith?.aggregateStats.vs,
        s.zenith?.stats.kills,
        s.zenith?.stats.topBtB,
        s.zenith?.stats.cps,
        s.zenith?.stats.zenith?.peakrank,
        s.zenith?.stats.finalTime,
        s.zenith?.stats.finessePercentage,
        "",
        s.zenith?.aggregateStats.nerdStats.app,
        s.zenith?.aggregateStats.nerdStats.vsapm,
        s.zenith?.aggregateStats.nerdStats.dss,
        s.zenith?.aggregateStats.nerdStats.dsp,
        s.zenith?.aggregateStats.nerdStats.appdsp,
        s.zenith?.aggregateStats.nerdStats.cheese,
        s.zenith?.aggregateStats.nerdStats.gbe,
        s.zenith?.aggregateStats.nerdStats.nyaapp,
        s.zenith?.aggregateStats.nerdStats.area,
        "",
        s.zenith?.aggregateStats.playstyle.opener,
        s.zenith?.aggregateStats.playstyle.plonk,
        s.zenith?.aggregateStats.playstyle.stride,
        s.zenith?.aggregateStats.playstyle.infds,
      ]);
      rawValues[3].add([
        s.zenithEx?.stats.zenith?.altitude,
        s.zenithEx?.rank,
        s.zenithEx?.aggregateStats.apm,
        s.zenithEx?.aggregateStats.pps,
        s.zenithEx?.aggregateStats.vs,
        s.zenithEx?.stats.kills,
        s.zenithEx?.stats.topBtB,
        s.zenithEx?.stats.cps,
        s.zenithEx?.stats.zenith?.peakrank,
        s.zenithEx?.stats.finalTime,
        s.zenithEx?.stats.finessePercentage,
        "",
        s.zenithEx?.aggregateStats.nerdStats.app,
        s.zenithEx?.aggregateStats.nerdStats.vsapm,
        s.zenithEx?.aggregateStats.nerdStats.dss,
        s.zenithEx?.aggregateStats.nerdStats.dsp,
        s.zenithEx?.aggregateStats.nerdStats.appdsp,
        s.zenithEx?.aggregateStats.nerdStats.cheese,
        s.zenithEx?.aggregateStats.nerdStats.gbe,
        s.zenithEx?.aggregateStats.nerdStats.nyaapp,
        s.zenithEx?.aggregateStats.nerdStats.area,
        "",
        s.zenithEx?.aggregateStats.playstyle.opener,
        s.zenithEx?.aggregateStats.playstyle.plonk,
        s.zenithEx?.aggregateStats.playstyle.stride,
        s.zenithEx?.aggregateStats.playstyle.infds,
      ]);;
      rawValues[4].add([
        s.sprint?.stats.finalTime,
        s.sprint?.stats.piecesPlaced,
        s.sprint?.stats.inputs,
        s.sprint?.stats.kpp,
        s.sprint?.stats.pps,
        s.sprint?.stats.kps
      ]);
      rawValues[5].add(
        [
        s.blitz?.stats.score,
        s.blitz?.stats.piecesPlaced,
        s.blitz?.stats.inputs,
        s.blitz?.stats.kpp,
        s.blitz?.stats.pps,
        s.blitz?.stats.kps
      ]
      );
      rawValues[6].add([
        s.zen.score,
        s.zen.level
      ]);
      formattedValues[0].add([
        Text(timestamp(p.registrationTime)),
        RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])),
        Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)),
        Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white)),
        Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white)),
        Text(intf.format(p.friendCount))
      ]);
      formattedValues[1].add([
        Text(s.league.tr.isNegative ? "---" : f4.format(s.league.tr)),
        Text(s.league.glicko!.isNegative ? "---" : f4.format(s.league.glicko)),
        Text(s.league.rd!.isNegative ? "---" : f4.format(s.league.rd), style: TextStyle(color: s.league.rd!.isNegative ? Colors.grey : Colors.white)),
        Text(s.league.gxe.isNegative ? "---" : f4.format(s.league.gxe)),
        Text(s.league.s1tr.isNegative ? "---" : f4.format(s.league.s1tr)),
        Text(s.league.standing.isNegative ? "---" : "№ "+intf.format(s.league.standing)),
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
      ]);
      formattedValues[2].add([
        Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.altitude) : "---"),
        Text(s.zenith != null ? "№ "+intf.format(s.zenith!.rank) : "---"),
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
      ]);
      formattedValues[3].add([
        Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.altitude) : "---"),
        Text(s.zenith != null ? "№ "+intf.format(s.zenith!.rank) : "---"),
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
      ]);
      formattedValues[4].add([
        Text(s.sprint != null ? getMoreNormalTime(s.sprint!.stats.finalTime) : "---"),
        Text(s.sprint != null ? intf.format(s.sprint!.stats.piecesPlaced) : "---"),
        Text(s.sprint != null ? intf.format(s.sprint!.stats.inputs) : "---"),
        Text(s.sprint != null ? f4.format(s.sprint!.stats.kpp) : "---"),
        Text(s.sprint != null ? f4.format(s.sprint!.stats.pps) : "---"),
        Text(s.sprint != null ? f4.format(s.sprint!.stats.kps) : "---")
      ]);
      formattedValues[5].add([
        Text(s.blitz != null ? intf.format(s.sprint!.stats.score) : "---"),
        Text(s.blitz != null ? intf.format(s.blitz!.stats.piecesPlaced) : "---"),
        Text(s.blitz != null ? intf.format(s.blitz!.stats.inputs) : "---"),
        Text(s.blitz != null ? f4.format(s.blitz!.stats.kpp) : "---"),
        Text(s.blitz != null ? f4.format(s.blitz!.stats.pps) : "---"),
        Text(s.blitz != null ? f4.format(s.blitz!.stats.kps) : "---")
      ]);
      formattedValues[6].add([
        Text(intf.format(s.zen.score)),
        Text(intf.format(s.zen.level))
      ]);
  }

  List<List<dynamic>> recalculateBestEntries(){
    return [
      [
        players.reduce((curr, next) => curr.registrationTime.isBefore(next.registrationTime) ? curr : next).registrationTime,
        players.reduce((curr, next) => curr.xp > next.xp ? curr : next).xp,
        players.reduce((curr, next) => curr.gameTime.compareTo(next.gameTime) > 0 ? curr : next).gameTime,
        players.reduce((curr, next) => curr.gamesPlayed > next.gamesPlayed ? curr : next).gamesPlayed,
        players.reduce((curr, next) => curr.gamesWon > next.gamesWon ? curr : next).gamesWon,
        players.reduce((curr, next) => curr.friendCount > next.friendCount ? curr : next).friendCount,
      ],
      [
        summaries.reduce((curr, next) => curr.league.tr > next.league.tr ? curr : next).league.tr,
        summaries.reduce((curr, next) => (curr.league.glicko??-1) > (next.league.glicko??-1) ? curr : next).league.glicko,
        summaries.reduce((curr, next) => (curr.league.rd??-1) > (next.league.rd??-1) ? curr : next).league.rd,
        summaries.reduce((curr, next) => curr.league.gxe > next.league.gxe ? curr : next).league.gxe,
        summaries.reduce((curr, next) => curr.league.s1tr > next.league.s1tr ? curr : next).league.s1tr,
        summaries.reduce((curr, next) => curr.league.standing > next.league.standing ? curr : next).league.standing,
        summaries.reduce((curr, next) => curr.league.gamesPlayed > next.league.gamesPlayed ? curr : next).league.gamesPlayed,
        summaries.reduce((curr, next) => curr.league.gamesWon > next.league.gamesWon ? curr : next).league.gamesWon,
        summaries.reduce((curr, next) => curr.league.winrate > next.league.winrate ? curr : next).league.winrate,
        summaries.reduce((curr, next) => (curr.league.apm??0) > (next.league.apm??0) ? curr : next).league.apm,
        summaries.reduce((curr, next) => (curr.league.pps??0) > (next.league.pps??0) ? curr : next).league.pps,
        summaries.reduce((curr, next) => (curr.league.vs??0) > (next.league.vs??0) ? curr : next).league.vs,
        null,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.app??0) > (next.league.nerdStats?.app??0) ? curr : next).league.nerdStats?.app,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.vsapm??0) > (next.league.nerdStats?.vsapm??0) ? curr : next).league.nerdStats?.vsapm,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.dss??0) > (next.league.nerdStats?.dss??0) ? curr : next).league.nerdStats?.dss,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.dsp??0) > (next.league.nerdStats?.dsp??0) ? curr : next).league.nerdStats?.dsp,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.appdsp??0) > (next.league.nerdStats?.appdsp??0) ? curr : next).league.nerdStats?.appdsp,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.cheese??double.negativeInfinity) > (next.league.nerdStats?.cheese??double.negativeInfinity) ? curr : next).league.nerdStats?.cheese,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.gbe??0) > (next.league.nerdStats?.gbe??0) ? curr : next).league.nerdStats?.gbe,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.nyaapp??0) > (next.league.nerdStats?.nyaapp??0) ? curr : next).league.nerdStats?.nyaapp,
        summaries.reduce((curr, next) => (curr.league.nerdStats?.area??0) > (next.league.nerdStats?.area??0) ? curr : next).league.nerdStats?.area,
        null,
        summaries.reduce((curr, next) => (curr.league.playstyle?.opener??double.negativeInfinity) > (next.league.playstyle?.opener??double.negativeInfinity) ? curr : next).league.playstyle?.opener,
        summaries.reduce((curr, next) => (curr.league.playstyle?.plonk??double.negativeInfinity) > (next.league.playstyle?.plonk??double.negativeInfinity) ? curr : next).league.playstyle?.plonk,
        summaries.reduce((curr, next) => (curr.league.playstyle?.stride??double.negativeInfinity) > (next.league.playstyle?.stride??double.negativeInfinity) ? curr : next).league.playstyle?.stride,
        summaries.reduce((curr, next) => (curr.league.playstyle?.infds??double.negativeInfinity) > (next.league.playstyle?.infds??double.negativeInfinity) ? curr : next).league.playstyle?.infds
      ],
      [
        summaries.reduce((curr, next) => (curr.zenith?.stats.zenith?.altitude??-1) > (next.zenith?.stats.zenith?.altitude??-1) ? curr : next).zenith?.stats.zenith?.altitude??-1,
        summaries.reduce((curr, next) => (curr.zenith?.rank??-1) > (next.zenith?.rank??-1) ? curr : next).zenith?.rank,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.apm??-1) > (next.zenith?.aggregateStats.apm??-1) ? curr : next).zenith?.aggregateStats.apm,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.pps??-1) > (next.zenith?.aggregateStats.pps??-1) ? curr : next).zenith?.aggregateStats.pps,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.vs??-1) > (next.zenith?.aggregateStats.vs??-1) ? curr : next).zenith?.aggregateStats.vs,
        summaries.reduce((curr, next) => (curr.zenith?.stats.kills??-1) > (next.zenith?.stats.kills??-1) ? curr : next).zenith?.stats.kills,
        summaries.reduce((curr, next) => (curr.zenith?.stats.topBtB??-1) > (next.zenith?.stats.topBtB??-1) ? curr : next).zenith?.stats.topBtB,
        summaries.reduce((curr, next) => (curr.zenith?.stats.cps??-1) > (next.zenith?.stats.cps??-1) ? curr : next).zenith?.stats.cps,
        summaries.reduce((curr, next) => (curr.zenith?.stats.zenith?.peakrank??-1) > (next.zenith?.stats.zenith?.peakrank??-1) ? curr : next).zenith?.stats.zenith?.peakrank,
        summaries.reduce((curr, next) => (curr.zenith?.stats.finalTime != null) ? curr.zenith!.stats.finalTime.compareTo(next.zenith?.stats.finalTime??Duration.zero) > 1 ? curr : next : next).zenith?.stats.finalTime,
        summaries.reduce((curr, next) => (curr.zenith?.stats.finessePercentage??-1) > (next.zenith?.stats.finessePercentage??-1) ? curr : next).zenith?.stats.finessePercentage,
        null,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.app??0) > (next.zenith?.aggregateStats.nerdStats.app??0) ? curr : next).zenith?.aggregateStats.nerdStats.app,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.vsapm??0) > (next.zenith?.aggregateStats.nerdStats.vsapm??0) ? curr : next).zenith?.aggregateStats.nerdStats.vsapm,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.dss??0) > (next.zenith?.aggregateStats.nerdStats.dss??0) ? curr : next).zenith?.aggregateStats.nerdStats.dss,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.dsp??0) > (next.zenith?.aggregateStats.nerdStats.dsp??0) ? curr : next).zenith?.aggregateStats.nerdStats.dsp,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.appdsp??0) > (next.zenith?.aggregateStats.nerdStats.appdsp??0) ? curr : next).zenith?.aggregateStats.nerdStats.appdsp,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.cheese??double.negativeInfinity) > (next.zenith?.aggregateStats.nerdStats.cheese??double.negativeInfinity) ? curr : next).zenith?.aggregateStats.nerdStats.cheese,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.gbe??0) > (next.zenith?.aggregateStats.nerdStats.gbe??0) ? curr : next).zenith?.aggregateStats.nerdStats.gbe,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.nyaapp??0) > (next.zenith?.aggregateStats.nerdStats.nyaapp??0) ? curr : next).zenith?.aggregateStats.nerdStats.nyaapp,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.nerdStats.area??0) > (next.zenith?.aggregateStats.nerdStats.area??0) ? curr : next).zenith?.aggregateStats.nerdStats.area,
        null,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.playstyle.opener??double.negativeInfinity) > (next.zenith?.aggregateStats.playstyle.opener??double.negativeInfinity) ? curr : next).zenith?.aggregateStats.playstyle.opener,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.playstyle.plonk??double.negativeInfinity) > (next.zenith?.aggregateStats.playstyle.plonk??double.negativeInfinity) ? curr : next).zenith?.aggregateStats.playstyle.plonk,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.playstyle.stride??double.negativeInfinity) > (next.zenith?.aggregateStats.playstyle.stride??double.negativeInfinity) ? curr : next).zenith?.aggregateStats.playstyle.stride,
        summaries.reduce((curr, next) => (curr.zenith?.aggregateStats.playstyle.infds??double.negativeInfinity) > (next.zenith?.aggregateStats.playstyle.infds??double.negativeInfinity) ? curr : next).zenith?.aggregateStats.playstyle.infds
      ],
      [
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.zenith?.altitude??-1) > (next.zenithEx?.stats.zenith?.altitude??-1) ? curr : next).zenithEx?.stats.zenith?.altitude??-1,
        summaries.reduce((curr, next) => (curr.zenithEx?.rank??-1) > (next.zenithEx?.rank??-1) ? curr : next).zenithEx?.rank,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.apm??-1) > (next.zenithEx?.aggregateStats.apm??-1) ? curr : next).zenithEx?.aggregateStats.apm,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.pps??-1) > (next.zenithEx?.aggregateStats.pps??-1) ? curr : next).zenithEx?.aggregateStats.pps,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.vs??-1) > (next.zenithEx?.aggregateStats.vs??-1) ? curr : next).zenithEx?.aggregateStats.vs,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.kills??-1) > (next.zenithEx?.stats.kills??-1) ? curr : next).zenithEx?.stats.kills,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.topBtB??-1) > (next.zenithEx?.stats.topBtB??-1) ? curr : next).zenithEx?.stats.topBtB,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.cps??-1) > (next.zenithEx?.stats.cps??-1) ? curr : next).zenithEx?.stats.cps,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.zenith?.peakrank??-1) > (next.zenithEx?.stats.zenith?.peakrank??-1) ? curr : next).zenithEx?.stats.zenith?.peakrank,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.finalTime != null) ? curr.zenithEx!.stats.finalTime.compareTo(next.zenithEx?.stats.finalTime??Duration.zero) > 1 ? curr : next : next).zenithEx?.stats.finalTime,
        summaries.reduce((curr, next) => (curr.zenithEx?.stats.finessePercentage??-1) > (next.zenithEx?.stats.finessePercentage??-1) ? curr : next).zenithEx?.stats.finessePercentage,
        null,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.app??0) > (next.zenithEx?.aggregateStats.nerdStats.app??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.app,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.vsapm??0) > (next.zenithEx?.aggregateStats.nerdStats.vsapm??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.vsapm,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.dss??0) > (next.zenithEx?.aggregateStats.nerdStats.dss??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.dss,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.dsp??0) > (next.zenithEx?.aggregateStats.nerdStats.dsp??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.dsp,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.appdsp??0) > (next.zenithEx?.aggregateStats.nerdStats.appdsp??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.appdsp,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.cheese??double.negativeInfinity) > (next.zenithEx?.aggregateStats.nerdStats.cheese??double.negativeInfinity) ? curr : next).zenithEx?.aggregateStats.nerdStats.cheese,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.gbe??0) > (next.zenithEx?.aggregateStats.nerdStats.gbe??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.gbe,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.nyaapp??0) > (next.zenithEx?.aggregateStats.nerdStats.nyaapp??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.nyaapp,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.nerdStats.area??0) > (next.zenithEx?.aggregateStats.nerdStats.area??0) ? curr : next).zenithEx?.aggregateStats.nerdStats.area,
        null,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.playstyle.opener??double.negativeInfinity) > (next.zenithEx?.aggregateStats.playstyle.opener??double.negativeInfinity) ? curr : next).zenithEx?.aggregateStats.playstyle.opener,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.playstyle.plonk??double.negativeInfinity) > (next.zenithEx?.aggregateStats.playstyle.plonk??double.negativeInfinity) ? curr : next).zenithEx?.aggregateStats.playstyle.plonk,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.playstyle.stride??double.negativeInfinity) > (next.zenithEx?.aggregateStats.playstyle.stride??double.negativeInfinity) ? curr : next).zenithEx?.aggregateStats.playstyle.stride,
        summaries.reduce((curr, next) => (curr.zenithEx?.aggregateStats.playstyle.infds??double.negativeInfinity) > (next.zenithEx?.aggregateStats.playstyle.infds??double.negativeInfinity) ? curr : next).zenithEx?.aggregateStats.playstyle.infds
      ],
      [
        summaries.reduce((curr, next) => (curr.sprint?.stats.finalTime != null) ? curr.sprint!.stats.finalTime.compareTo(next.sprint?.stats.finalTime??Duration.zero) < 1 ? curr : next : next).sprint?.stats.finalTime,
        summaries.reduce((curr, next) => (curr.sprint?.stats.piecesPlaced??-1) < (next.sprint?.stats.piecesPlaced??-1) ? curr : next).sprint?.stats.piecesPlaced,
        summaries.reduce((curr, next) => (curr.sprint?.stats.inputs??-1) < (next.sprint?.stats.inputs??-1) ? curr : next).sprint?.stats.inputs,
        summaries.reduce((curr, next) => (curr.sprint?.stats.kpp??-1) < (next.sprint?.stats.kpp??-1) ? curr : next).sprint?.stats.kpp,
        summaries.reduce((curr, next) => (curr.sprint?.stats.pps??-1) > (next.sprint?.stats.pps??-1) ? curr : next).sprint?.stats.pps,
        summaries.reduce((curr, next) => (curr.sprint?.stats.kps??-1) > (next.sprint?.stats.kps??-1) ? curr : next).sprint?.stats.kps,
      ],
      [
        summaries.reduce((curr, next) => (curr.blitz?.stats.score??-1) > (next.blitz?.stats.score??-1) ? curr : next).blitz?.stats.score,
        summaries.reduce((curr, next) => (curr.blitz?.stats.piecesPlaced??-1) < (next.blitz?.stats.piecesPlaced??-1) ? curr : next).blitz?.stats.piecesPlaced,
        summaries.reduce((curr, next) => (curr.blitz?.stats.inputs??-1) < (next.blitz?.stats.inputs??-1) ? curr : next).blitz?.stats.inputs,
        summaries.reduce((curr, next) => (curr.blitz?.stats.kpp??-1) < (next.blitz?.stats.kpp??-1) ? curr : next).blitz?.stats.kpp,
        summaries.reduce((curr, next) => (curr.blitz?.stats.pps??-1) > (next.blitz?.stats.pps??-1) ? curr : next).blitz?.stats.pps,
        summaries.reduce((curr, next) => (curr.blitz?.stats.kps??-1) > (next.blitz?.stats.kps??-1) ? curr : next).blitz?.stats.kps,
      ],
      [
        summaries.reduce((curr, next) => curr.zen.score > next.zen.score ? curr : next).zen.score,
        summaries.reduce((curr, next) => curr.zen.level > next.zen.level ? curr : next).zen.level,
      ]
    ];
  }

  void getSummariesForInit() async {
    summaries.add(await teto.fetchSummaries(widget.initPlayer.userId));
    if (summaries[0].league.nerdStats != null) nicknames.add(players[0].username);
    addvaluesEntrys(players.first, summaries.first);
    best = recalculateBestEntries();
    setState(() {
      
    });
  }

  void addPlayer(String nickname) async {
    players.add(await teto.fetchPlayer(nickname));
    summaries.add(await teto.fetchSummaries(players.last.userId));
    addvaluesEntrys(players.last, summaries.last);
    best = recalculateBestEntries();
    if (summaries.last.league.nerdStats != null) nicknames.add(players.last.username);
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

  // void _justUpdate() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // final t = Translations.of(context);
    // bool bigScreen = MediaQuery.of(context).size.width > 768;
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
                for (int i = 0; i < formattedValues.length; i++) SizedBox(
                  width: 300+300*summaries.length.toDouble(),
                  child: ExpansionTile(
                    title: Text(TitesForStats.keys.elementAt(i), style: _expansionTileTitleTextStyle),
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 300.0,
                            child: Card(
                              child: Column(children: [
                                for (String title in TitesForStats[TitesForStats.keys.elementAt(i)]!) Text(title),
                              ]),
                            ),
                          ),
                          for (int k = 0; k < formattedValues[i].length; k++) SizedBox(
                            width: 300.0,
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int l = 0; l < formattedValues[i][k].length; l++) Container(decoration: (rawValues[0].length > 1 && rawValues[i][k][l] != null && best[i][l] == rawValues[i][k][l]) ? BoxDecoration(boxShadow: [BoxShadow(color: Colors.cyanAccent.withAlpha(96), spreadRadius: 0, blurRadius: 4)]) : null, child: formattedValues[i][k][l]),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      //VsGraphs(stats: [for (var s in summaries) if (s.league.nerdStats != null) AggregateStats.precalculated(s.league.apm!, s.league.pps!, s.league.vs!, s.league.nerdStats!, s.league.playstyle!)], nicknames: nicknames)
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

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

class VsGraphs extends StatelessWidget{
  final List<AggregateStats> stats;
  final List<String> nicknames;
  const VsGraphs({super.key, required this.stats, required this.nicknames});

  static const List<Color> colorsForGraphs = [
    Colors.cyanAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
  ];
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            children: [
              for (int i = 0; i < stats.length; i++) Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                    child: Container(width: 20.0, height: 10.0, decoration: BoxDecoration(color: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128), border: Border.all(color: colorsForGraphs[i%colorsForGraphs.length])),),
                  ),
                  Text(nicknames[i], style: TextStyle(fontFamily: "Eurostile Round Extended"))
                ],
              )
            ],
          ),
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
              child: MyRadarChart(
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
                        for (int i = 0; i < stats.length; i++) RadarDataSet(
                          fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                          borderColor: colorsForGraphs[i%colorsForGraphs.length],
                          dataEntries: [
                            RadarEntry(value: stats[i].apm * apmWeight),
                            RadarEntry(value: stats[i].pps * ppsWeight),
                            RadarEntry(value: stats[i].vs * vsWeight),
                            RadarEntry(value: stats[i].nerdStats.app * appWeight),
                            RadarEntry(value: stats[i].nerdStats.dss * dssWeight),
                            RadarEntry(value: stats[i].nerdStats.dsp * dspWeight),
                            RadarEntry(value: stats[i].nerdStats.appdsp * appdspWeight),
                            RadarEntry(value: stats[i].nerdStats.vsapm * vsapmWeight),
                            RadarEntry(value: stats[i].nerdStats.cheese * cheeseWeight),
                            RadarEntry(value: stats[i].nerdStats.gbe * gbeWeight),
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
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
            child: SizedBox(
              height: 310,
              width: 310,
              child: MyRadarChart(
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
                            return RadarChartTitle(text: 'Opener',angle: angle, positionPercentageOffset: 0.05);
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
                        for (int i = 0; i < stats.length; i++) RadarDataSet(
                          fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                          borderColor: colorsForGraphs[i%colorsForGraphs.length],
                          dataEntries: [
                            RadarEntry(value: stats[i].playstyle.opener),
                            RadarEntry(value: stats[i].playstyle.stride),
                            RadarEntry(value: stats[i].playstyle.infds),
                            RadarEntry(value: stats[i].playstyle.plonk),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          dataEntries: [
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 1),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                          ],
                        ),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                ),
              ),
              Padding( // sq graph
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
                child: SizedBox(
                  height: 310,
                  width: 310,
                  child: MyRadarChart(
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
                            return RadarChartTitle(text: t.graphs.attack, angle: 0, positionPercentageOffset: 0.05);
                          case 1:
                            return RadarChartTitle(text: t.graphs.speed, angle: 0, positionPercentageOffset: 0.05);
                          case 2:
                            return RadarChartTitle(text: t.graphs.defense, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 3:
                            return RadarChartTitle(text: t.graphs.cheese, angle: 0, positionPercentageOffset: 0.05);
                          default:
                            return const RadarChartTitle(text: '');
                        }
                      },
                      dataSets: [
                        for (int i = 0; i < stats.length; i++) RadarDataSet(
                          fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                          borderColor: colorsForGraphs[i%colorsForGraphs.length],
                          dataEntries: [
                            RadarEntry(value: stats[i].apm / 60 * 0.4),
                            RadarEntry(value: stats[i].pps / 3.75),
                            RadarEntry(value: stats[i].nerdStats.dss * 1.15),
                            RadarEntry(value: stats[i].nerdStats.cheese / 110),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          dataEntries: [
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 1.2),
                            const RadarEntry(value: 0),
                            const RadarEntry(value: 0),
                          ],
                        )
                      ],
                    )
                  )
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}