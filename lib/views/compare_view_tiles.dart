// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/aggregate_stats.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';
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
  bool tlOnly = false;
  List<TetrioPlayer> players = [];
  List<Summaries> summaries = [];
  List<String> nicknames = [];
  Map<String, List<String>> TitesForStats = {
    t.general: [
      t.stats.registrationDate,
      t.stats.xp.short,
      t.stats.gametime,
      t.stats.ogp,
      t.stats.ogw,
      t.stats.followers,
    ],
    t.gamemodes["league"]!: [
      t.stats.tr.full,
      t.stats.glicko.full,
      t.stats.rd.full,
      t.stats.glixare.full,
      t.stats.s1tr.full,
      t.stats.placement,
      t.stats.gp.full,
      t.stats.gw.full,
      t.stats.winrate.full,
      t.stats.apm.full,
      t.stats.pps.full,
      t.stats.vs.full,
      t.nerdStats,
      t.stats.app.full,
      t.stats.vsapm.full,
      t.stats.dss.full,
      t.stats.dsp.full,
      t.stats.appdsp.full,
      t.stats.cheese.full,
      t.stats.gbe.full,
      t.stats.nyaapp.full,
      t.stats.area.full,
      t.playstyles,
      t.stats.opener.full,
      t.stats.plonk.full,
      t.stats.stride.full,
      t.stats.infds.full
    ],
    t.gamemodes["zenith"]!:[
      t.stats.altitude.full,
      t.stats.placement,
      t.stats.apm.full,
      t.stats.pps.full,
      t.stats.vs.full,
      t.stats.kos.full,
      t.stats.b2b.full,
      t.stats.climbSpeed.full,
      t.stats.peakClimbSpeed.full,
      t.stats.totalTime.full,
      t.stats.finesse.full,
      t.nerdStats,
      t.stats.app.full,
      t.stats.vsapm.full,
      t.stats.dss.full,
      t.stats.dsp.full,
      t.stats.appdsp.full,
      t.stats.cheese.full,
      t.stats.gbe.full,
      t.stats.nyaapp.full,
      t.stats.area.full,
      t.playstyles,
      t.stats.opener.full,
      t.stats.plonk.full,
      t.stats.stride.full,
      t.stats.infds.full
    ],
    t.gamemodes["zenithex"]!:[
      t.stats.altitude.full,
      t.stats.placement,
      t.stats.apm.full,
      t.stats.pps.full,
      t.stats.vs.full,
      t.stats.kos.full,
      t.stats.b2b.full,
      t.stats.climbSpeed.full,
      t.stats.peakClimbSpeed.full,
      t.stats.totalTime.full,
      t.stats.finesse.full,
      t.nerdStats,
      t.stats.app.full,
      t.stats.vsapm.full,
      t.stats.dss.full,
      t.stats.dsp.full,
      t.stats.appdsp.full,
      t.stats.cheese.full,
      t.stats.gbe.full,
      t.stats.nyaapp.full,
      t.stats.area.full,
      t.playstyles,
      t.stats.opener.full,
      t.stats.plonk.full,
      t.stats.stride.full,
      t.stats.infds.full
    ],
    t.gamemodes["40l"]!: [
      t.stats.totalTime.short,
      t.stats.pieces.full,
      t.stats.kp.full,
      t.stats.kpp.full,
      t.stats.pps.full,
      t.stats.kps.full,
      t.stats.finesse.full,
      t.stats.finesseFaults.full,
      "",
      t.stats.lineClears.quad,
      t.stats.lineClears.triple,
      t.stats.lineClears.double,
      t.stats.lineClears.single,
      "",
      "${t.stats.tSpins} ${t.stats.lineClears.triple}",
      "${t.stats.tSpins} ${t.stats.lineClears.double}",
      "${t.stats.tSpins} ${t.stats.lineClears.single}",
      "${t.stats.tSpins} ${t.stats.lineClears.zero}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.double}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.single}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.zero}"
    ],
    t.gamemodes["blitz"]!: [
      t.stats.score,
      t.stats.pieces.full,
      t.stats.lines,
      t.stats.level.full,
      t.stats.kp.full,
      t.stats.kpp.full,
      t.stats.pps.full,
      t.stats.kps.full,
      t.stats.finesse.full,
      t.stats.finesseFaults.full,
      "",
      t.stats.lineClears.quad,
      t.stats.lineClears.triple,
      t.stats.lineClears.double,
      t.stats.lineClears.single,
      "",
      "${t.stats.tSpins} ${t.stats.lineClears.triple}",
      "${t.stats.tSpins} ${t.stats.lineClears.double}",
      "${t.stats.tSpins} ${t.stats.lineClears.single}",
      "${t.stats.tSpins} ${t.stats.lineClears.zero}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.double}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.single}",
      "${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.zero}"
    ],
    t.gamemodes["zen"]!: [
      t.stats.score,
      t.stats.level.full
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
    RecordSingle? zenithRun = s.zenith != null ? s.zenith : s.zenithCareerBest;
    bool oldZenithRun = s.zenith == null;
    RecordSingle? zenithExRun = s.zenithEx != null ? s.zenithEx : s.zenithExCareerBest;
    bool oldZenithExRun = s.zenithEx == null;
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
        zenithRun?.stats.zenith?.altitude,
        zenithRun?.rank,
        zenithRun?.aggregateStats.apm,
        zenithRun?.aggregateStats.pps,
        zenithRun?.aggregateStats.vs,
        zenithRun?.stats.kills,
        zenithRun?.stats.topBtB,
        zenithRun?.stats.cps,
        zenithRun?.stats.zenith?.peakrank,
        zenithRun?.stats.finalTime,
        zenithRun?.stats.finessePercentage,
        "",
        zenithRun?.aggregateStats.nerdStats.app,
        zenithRun?.aggregateStats.nerdStats.vsapm,
        zenithRun?.aggregateStats.nerdStats.dss,
        zenithRun?.aggregateStats.nerdStats.dsp,
        zenithRun?.aggregateStats.nerdStats.appdsp,
        zenithRun?.aggregateStats.nerdStats.cheese,
        zenithRun?.aggregateStats.nerdStats.gbe,
        zenithRun?.aggregateStats.nerdStats.nyaapp,
        zenithRun?.aggregateStats.nerdStats.area,
        "",
        zenithRun?.aggregateStats.playstyle.opener,
        zenithRun?.aggregateStats.playstyle.plonk,
        zenithRun?.aggregateStats.playstyle.stride,
        zenithRun?.aggregateStats.playstyle.infds,
      ]);
    rawValues[3].add([
      zenithExRun?.stats.zenith?.altitude,
      zenithExRun?.rank,
      zenithExRun?.aggregateStats.apm,
      zenithExRun?.aggregateStats.pps,
      zenithExRun?.aggregateStats.vs,
      zenithExRun?.stats.kills,
      zenithExRun?.stats.topBtB,
      zenithExRun?.stats.cps,
      zenithExRun?.stats.zenith?.peakrank,
      zenithExRun?.stats.finalTime,
      zenithExRun?.stats.finessePercentage,
      "",
      zenithExRun?.aggregateStats.nerdStats.app,
      zenithExRun?.aggregateStats.nerdStats.vsapm,
      zenithExRun?.aggregateStats.nerdStats.dss,
      zenithExRun?.aggregateStats.nerdStats.dsp,
      zenithExRun?.aggregateStats.nerdStats.appdsp,
      zenithExRun?.aggregateStats.nerdStats.cheese,
      zenithExRun?.aggregateStats.nerdStats.gbe,
      zenithExRun?.aggregateStats.nerdStats.nyaapp,
      zenithExRun?.aggregateStats.nerdStats.area,
      "",
      zenithExRun?.aggregateStats.playstyle.opener,
      zenithExRun?.aggregateStats.playstyle.plonk,
      zenithExRun?.aggregateStats.playstyle.stride,
      zenithExRun?.aggregateStats.playstyle.infds,
    ]);;
    rawValues[4].add([
      s.sprint?.stats.finalTime,
      s.sprint?.stats.piecesPlaced,
      s.sprint?.stats.inputs,
      s.sprint?.stats.kpp,
      s.sprint?.stats.pps,
      s.sprint?.stats.kps,
      s.sprint?.stats.finessePercentage,
      s.sprint?.stats.finesse?.faults,
      "",
      s.sprint?.stats.clears.quads,
      s.sprint?.stats.clears.triples,
      s.sprint?.stats.clears.doubles,
      s.sprint?.stats.clears.singles,
      "",
      s.sprint?.stats.clears.tSpinTriples,
      s.sprint?.stats.clears.tSpinDoubles,
      s.sprint?.stats.clears.tSpinSingles,
      s.sprint?.stats.clears.tSpinZeros,
      s.sprint?.stats.clears.tSpinMiniDoubles,
      s.sprint?.stats.clears.tSpinMiniSingles,
      s.sprint?.stats.clears.tSpinMiniZeros
    ]);
    rawValues[5].add(
      [
      s.blitz?.stats.score,
      s.blitz?.stats.piecesPlaced,
      s.blitz?.stats.lines,
      s.blitz?.stats.level,
      s.blitz?.stats.inputs,
      s.blitz?.stats.kpp,
      s.blitz?.stats.pps,
      s.blitz?.stats.kps,
      s.blitz?.stats.finessePercentage,
      s.blitz?.stats.finesse?.faults,
      "",
      s.blitz?.stats.clears.quads,
      s.blitz?.stats.clears.triples,
      s.blitz?.stats.clears.doubles,
      s.blitz?.stats.clears.singles,
      "",
      s.blitz?.stats.clears.tSpinTriples,
      s.blitz?.stats.clears.tSpinDoubles,
      s.blitz?.stats.clears.tSpinSingles,
      s.blitz?.stats.clears.tSpinZeros,
      s.blitz?.stats.clears.tSpinMiniDoubles,
      s.blitz?.stats.clears.tSpinMiniSingles,
      s.blitz?.stats.clears.tSpinMiniZeros
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
      RichText(text: TextSpan(text: zenithRun != null ? "${f2.format(zenithRun.stats.zenith!.altitude)} m" : "---", style: TextStyle(fontFamily: "Eurostile Round"), children: [if (zenithRun != null && oldZenithRun) TextSpan(text: " (${zenithRun.revolution})", style: TextStyle(color: Colors.grey))])),
      Text(zenithRun != null ? "№ "+intf.format(zenithRun.rank) : "---"),
      Text(zenithRun != null ? f2.format(zenithRun.aggregateStats.apm) : "---"),
      Text(zenithRun != null ? f2.format(zenithRun.aggregateStats.pps) : "---"),
      Text(zenithRun != null ? f2.format(zenithRun.aggregateStats.vs) : "---"),
      Text(zenithRun != null ? intf.format(zenithRun.stats.kills) : "---"),
      Text(zenithRun != null ? intf.format(zenithRun.stats.topBtB) : "---"),
      Text(zenithRun != null ? f4.format(zenithRun.stats.cps) : "---"),
      Text(zenithRun != null ? f4.format(zenithRun.stats.zenith!.peakrank) : "---"),
      Text(zenithRun != null ? getMoreNormalTime(zenithRun.stats.finalTime) : "---"),
      Text(zenithRun != null ? f2.format(zenithRun.stats.finessePercentage*100)+"%" : "---"),
      Text(""),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.app) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.vsapm) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.dss) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.dsp) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.appdsp) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.cheese) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.gbe) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.nyaapp) : "---"),
      Text(zenithRun?.aggregateStats.nerdStats != null ? f4.format(zenithRun!.aggregateStats.nerdStats.area) : "---"),
      Text(""),
      Text(zenithRun?.aggregateStats.playstyle != null ? f4.format(zenithRun!.aggregateStats.playstyle.opener) : "---"),
      Text(zenithRun?.aggregateStats.playstyle != null ? f4.format(zenithRun!.aggregateStats.playstyle.plonk) : "---"),
      Text(zenithRun?.aggregateStats.playstyle != null ? f4.format(zenithRun!.aggregateStats.playstyle.stride) : "---"),
      Text(zenithRun?.aggregateStats.playstyle != null ? f4.format(zenithRun!.aggregateStats.playstyle.infds) : "---"),
    ]);
    formattedValues[3].add([
      RichText(text: TextSpan(text: zenithExRun != null ? "${f2.format(zenithExRun.stats.zenith!.altitude)} m" : "---", style: TextStyle(fontFamily: "Eurostile Round"), children: [if (zenithExRun != null && oldZenithExRun) TextSpan(text: " (${zenithExRun.revolution})", style: TextStyle(color: Colors.grey))])),
      Text(zenithExRun != null ? "№ "+intf.format(zenithExRun.rank) : "---"),
      Text(zenithExRun != null ? f2.format(zenithExRun.aggregateStats.apm) : "---"),
      Text(zenithExRun != null ? f2.format(zenithExRun.aggregateStats.pps) : "---"),
      Text(zenithExRun != null ? f2.format(zenithExRun.aggregateStats.vs) : "---"),
      Text(zenithExRun != null ? intf.format(zenithExRun.stats.kills) : "---"),
      Text(zenithExRun != null ? intf.format(zenithExRun.stats.topBtB) : "---"),
      Text(zenithExRun != null ? f4.format(zenithExRun.stats.cps) : "---"),
      Text(zenithExRun != null ? f4.format(zenithExRun.stats.zenith!.peakrank) : "---"),
      Text(zenithExRun != null ? getMoreNormalTime(zenithExRun.stats.finalTime) : "---"),
      Text(zenithExRun != null ? f2.format(zenithExRun.stats.finessePercentage*100)+"%" : "---"),
      Text(""),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.app) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.vsapm) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.dss) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.dsp) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.appdsp) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.cheese) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.gbe) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.nyaapp) : "---"),
      Text(zenithExRun?.aggregateStats.nerdStats != null ? f4.format(zenithExRun!.aggregateStats.nerdStats.area) : "---"),
      Text(""),
      Text(zenithExRun?.aggregateStats.playstyle != null ? f4.format(zenithExRun!.aggregateStats.playstyle.opener) : "---"),
      Text(zenithExRun?.aggregateStats.playstyle != null ? f4.format(zenithExRun!.aggregateStats.playstyle.plonk) : "---"),
      Text(zenithExRun?.aggregateStats.playstyle != null ? f4.format(zenithExRun!.aggregateStats.playstyle.stride) : "---"),
      Text(zenithExRun?.aggregateStats.playstyle != null ? f4.format(zenithExRun!.aggregateStats.playstyle.infds) : "---"),
    ]);
    formattedValues[4].add([
      Text(s.sprint != null ? getMoreNormalTime(s.sprint!.stats.finalTime) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.piecesPlaced) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.inputs) : "---"),
      Text(s.sprint != null ? f4.format(s.sprint!.stats.kpp) : "---"),
      Text(s.sprint != null ? f4.format(s.sprint!.stats.pps) : "---"),
      Text(s.sprint != null ? f4.format(s.sprint!.stats.kps) : "---"),
      Text(s.sprint != null ? percentage.format(s.sprint!.stats.finessePercentage) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.finesse?.faults) : "---"),
      Text(""),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.quads) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.triples) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.doubles) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.singles) : "---"),
      Text(""),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinTriples) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinDoubles) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinSingles) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinZeros) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinMiniDoubles) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinMiniSingles) : "---"),
      Text(s.sprint != null ? intf.format(s.sprint!.stats.clears.tSpinMiniZeros) : "---"),
    ]);
    formattedValues[5].add([
      Text(s.blitz != null ? intf.format(s.blitz!.stats.score) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.piecesPlaced) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.lines) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.level) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.inputs) : "---"),
      Text(s.blitz != null ? f4.format(s.blitz!.stats.kpp) : "---"),
      Text(s.blitz != null ? f4.format(s.blitz!.stats.pps) : "---"),
      Text(s.blitz != null ? f4.format(s.blitz!.stats.kps) : "---"),
      Text(s.blitz != null ? percentage.format(s.blitz!.stats.finessePercentage) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.finesse?.faults) : "---"),
      Text(""),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.quads) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.triples) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.doubles) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.singles) : "---"),
      Text(""),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinTriples) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinDoubles) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinSingles) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinZeros) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinMiniDoubles) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinMiniSingles) : "---"),
      Text(s.blitz != null ? intf.format(s.blitz!.stats.clears.tSpinMiniZeros) : "---"),
    ]);
    formattedValues[6].add([
        Text(intf.format(s.zen.score)),
        Text(intf.format(s.zen.level))
      ]);
  }

  addAverages(Summaries s){
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
        summaries.reduce((curr, next) => (curr.league.rd??-1) < (next.league.rd??-1) ? curr : next).league.rd,
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
        summaries.reduce((curr, next) => (curr.sprint?.stats.finessePercentage??-1) > (next.sprint?.stats.finessePercentage??-1) ? curr : next).sprint?.stats.finessePercentage,
        summaries.reduce((curr, next) => (curr.sprint?.stats.finesse?.faults??-1) < (next.sprint?.stats.finesse?.faults??-1) ? curr : next).sprint?.stats.finesse?.faults,
        null,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.quads??-1) > (next.sprint?.stats.clears.quads??-1) ? curr : next).sprint?.stats.clears.quads,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.triples??-1) > (next.sprint?.stats.clears.triples??-1) ? curr : next).sprint?.stats.clears.triples,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.doubles??-1) > (next.sprint?.stats.clears.doubles??-1) ? curr : next).sprint?.stats.clears.doubles,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.singles??-1) > (next.sprint?.stats.clears.singles??-1) ? curr : next).sprint?.stats.clears.singles,
        null,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinTriples??-1) > (next.sprint?.stats.clears.tSpinTriples??-1) ? curr : next).sprint?.stats.clears.tSpinTriples,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinDoubles??-1) > (next.sprint?.stats.clears.tSpinDoubles??-1) ? curr : next).sprint?.stats.clears.tSpinDoubles,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinSingles??-1) > (next.sprint?.stats.clears.tSpinSingles??-1) ? curr : next).sprint?.stats.clears.tSpinSingles,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinZeros??-1) > (next.sprint?.stats.clears.tSpinZeros??-1) ? curr : next).sprint?.stats.clears.tSpinZeros,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinMiniDoubles??-1) > (next.sprint?.stats.clears.tSpinMiniDoubles??-1) ? curr : next).sprint?.stats.clears.tSpinMiniDoubles,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinMiniSingles??-1) > (next.sprint?.stats.clears.tSpinMiniSingles??-1) ? curr : next).sprint?.stats.clears.tSpinMiniSingles,
        summaries.reduce((curr, next) => (curr.sprint?.stats.clears.tSpinMiniZeros??-1) > (next.sprint?.stats.clears.tSpinMiniZeros??-1) ? curr : next).sprint?.stats.clears.tSpinMiniZeros,
      ],
      [
        summaries.reduce((curr, next) => (curr.blitz?.stats.score??-1) > (next.blitz?.stats.score??-1) ? curr : next).blitz?.stats.score,
        summaries.reduce((curr, next) => (curr.blitz?.stats.piecesPlaced??-1) < (next.blitz?.stats.piecesPlaced??-1) ? curr : next).blitz?.stats.piecesPlaced,
        summaries.reduce((curr, next) => (curr.blitz?.stats.lines??-1) < (next.blitz?.stats.lines??-1) ? curr : next).blitz?.stats.lines,
        summaries.reduce((curr, next) => (curr.blitz?.stats.level??-1) < (next.blitz?.stats.level??-1) ? curr : next).blitz?.stats.level,
        summaries.reduce((curr, next) => (curr.blitz?.stats.inputs??-1) < (next.blitz?.stats.inputs??-1) ? curr : next).blitz?.stats.inputs,
        summaries.reduce((curr, next) => (curr.blitz?.stats.kpp??-1) < (next.blitz?.stats.kpp??-1) ? curr : next).blitz?.stats.kpp,
        summaries.reduce((curr, next) => (curr.blitz?.stats.pps??-1) > (next.blitz?.stats.pps??-1) ? curr : next).blitz?.stats.pps,
        summaries.reduce((curr, next) => (curr.blitz?.stats.kps??-1) > (next.blitz?.stats.kps??-1) ? curr : next).blitz?.stats.kps,
        summaries.reduce((curr, next) => (curr.blitz?.stats.finessePercentage??-1) > (next.blitz?.stats.finessePercentage??-1) ? curr : next).blitz?.stats.finessePercentage,
        summaries.reduce((curr, next) => (curr.blitz?.stats.finesse?.faults??-1) < (next.blitz?.stats.finesse?.faults??-1) ? curr : next).blitz?.stats.finesse?.faults,
        null,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.quads??-1) > (next.blitz?.stats.clears.quads??-1) ? curr : next).blitz?.stats.clears.quads,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.triples??-1) > (next.blitz?.stats.clears.triples??-1) ? curr : next).blitz?.stats.clears.triples,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.doubles??-1) > (next.blitz?.stats.clears.doubles??-1) ? curr : next).blitz?.stats.clears.doubles,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.singles??-1) > (next.blitz?.stats.clears.singles??-1) ? curr : next).blitz?.stats.clears.singles,
        null,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinTriples??-1) > (next.blitz?.stats.clears.tSpinTriples??-1) ? curr : next).blitz?.stats.clears.tSpinTriples,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinDoubles??-1) > (next.blitz?.stats.clears.tSpinDoubles??-1) ? curr : next).blitz?.stats.clears.tSpinDoubles,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinSingles??-1) > (next.blitz?.stats.clears.tSpinSingles??-1) ? curr : next).blitz?.stats.clears.tSpinSingles,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinZeros??-1) > (next.blitz?.stats.clears.tSpinZeros??-1) ? curr : next).blitz?.stats.clears.tSpinZeros,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinMiniDoubles??-1) > (next.blitz?.stats.clears.tSpinMiniDoubles??-1) ? curr : next).blitz?.stats.clears.tSpinMiniDoubles,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinMiniSingles??-1) > (next.blitz?.stats.clears.tSpinMiniSingles??-1) ? curr : next).blitz?.stats.clears.tSpinMiniSingles,
        summaries.reduce((curr, next) => (curr.blitz?.stats.clears.tSpinMiniZeros??-1) > (next.blitz?.stats.clears.tSpinMiniZeros??-1) ? curr : next).blitz?.stats.clears.tSpinMiniZeros,
      ],
      [
        summaries.reduce((curr, next) => curr.zen.score > next.zen.score ? curr : next).zen.score,
        summaries.reduce((curr, next) => curr.zen.level > next.zen.level ? curr : next).zen.level,
      ]
    ];
  }

  void getSummariesForInit() async {
    summaries.add(await teto.fetchSummaries(widget.initPlayer.userId));
    nicknames.add(players[0].username);
    addvaluesEntrys(players.first, summaries.first);
    best = recalculateBestEntries();
    setState(() {
      
    });
  }

  void addPlayer(String nickname) async {
    if (nickname.startsWith("\$avg")){
      await addRankAverages(nickname.substring(4).toLowerCase());
    }else{
      players.add(await teto.fetchPlayer(nickname));
      summaries.add(await teto.fetchSummaries(players.last.userId));
      addvaluesEntrys(players.last, summaries.last);
      nicknames.add(players.last.username);
    }
    best = recalculateBestEntries();
    setState(() {
      
    });
  }

  Future<void> addRankAverages(String rank) async {
     try{
        var average = (await teto.fetchTLLeaderboard()).getRankData(rank)[0];
        Summaries summary = Summaries("avg${rank.toUpperCase()}", average, TetrioZen(level: 0, score: 0));
        players.add(TetrioPlayer(
          userId: "avg${rank}",
          username: "Avg ${rank.toUpperCase()} rank",
          role: "rank",
          state: summary.league.timestamp,
          registrationTime: summary.league.timestamp,
          badges: [],
          friendCount: -1,
          gamesPlayed: -1,
          gamesWon: -1,
          gameTime: Duration(seconds: -1),
          xp: -1,
          supporterTier: 0,
          verified: false,
          connections: null
        ));
        summaries.add(summary);
        nicknames.add("Avg ${rank.toUpperCase()} rank");
        addAverages(summary);
        return setState(() {tlOnly = true;});
      }on Exception {
        //if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.snackBarMessages.compareViewWrongValue(value: rank))));
        return;
      }
  }

  void removePlayer(String id) async {
    int p = players.indexWhere((e) => e.userId == id);
    players.removeAt(p);
    summaries.removeAt(p);
    nicknames.removeAt(p);
    if (id.startsWith("avg")){
      rawValues[1].removeAt(p);
      formattedValues[1].removeAt(p);
    }else
    for (int i = 0; i < 7; i++){
      rawValues[i].removeAt(p);
      formattedValues[i].removeAt(p);
    }  
    if (players.isNotEmpty) best = recalculateBestEntries();
    setState(() {
      if (players.any((e) => e.userId.startsWith("avg")) == false) tlOnly = false;
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
          tooltip: t.goBackButton,
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
                          child: Text(t.comparison, style: TextStyle(fontSize: 28)),
                        ),
                      ),
                    ),
                    for (var p in players) SizedBox(
                      width: 300.0,
                      child: HeaderCard(p, removePlayer),
                    ),
                    SizedBox(width: 300, child: AddNewColumnCard(addPlayer))
                  ]
                ),
                if (tlOnly) SizedBox(
                  width: 300+300*summaries.length.toDouble(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 300.0,
                            child: Card(
                              child: Column(children: [
                                for (String title in TitesForStats[TitesForStats.keys.elementAt(1)]!) Text(title),
                              ]),
                            ),
                          ),
                          for (int k = 0; k < formattedValues[1].length; k++) SizedBox(
                            width: 300.0,
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int l = 0; l < formattedValues[1][k].length; l++) Container(decoration: (rawValues[1].length > 1 && rawValues[1][k][l] != null && best[1][l] == rawValues[1][k][l]) ? BoxDecoration(boxShadow: [BoxShadow(color: Colors.cyanAccent.withAlpha(96), spreadRadius: 0, blurRadius: 4)]) : null, child: formattedValues[1][k][l]),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      VsGraphs(stats: [for (var s in summaries) if (s.league.nerdStats != null) AggregateStats.precalculated(s.league.apm!, s.league.pps!, s.league.vs!, s.league.nerdStats!, s.league.playstyle!)], nicknames: [for (int i = 0; i < summaries.length; i++)  if (summaries[i].league.nerdStats != null) nicknames[i]]),
                    ],
                  ),
                )
                else for (int i = 0; i < formattedValues.length; i++) SizedBox(
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
                      if (i == 1) VsGraphs(stats: [for (var s in summaries) if (s.league.nerdStats != null) AggregateStats.precalculated(s.league.apm!, s.league.pps!, s.league.vs!, s.league.nerdStats!, s.league.playstyle!)], nicknames: [for (int i = 0; i < summaries.length; i++)  if (summaries[i].league.nerdStats != null) nicknames[i]]),
                      if (i == 2) VsGraphs(stats: [for (var s in summaries) if ((s.zenith != null || s.zenithCareerBest != null) && (s.zenith?.aggregateStats??s.zenithCareerBest!.aggregateStats).apm > 0.00) s.zenith?.aggregateStats??s.zenithCareerBest!.aggregateStats], nicknames: [for (int i = 0; i < summaries.length; i++) if ((summaries[i].zenith != null || summaries[i].zenithCareerBest != null) && (summaries[i].zenith?.aggregateStats??summaries[i].zenithCareerBest!.aggregateStats).apm > 0.00) nicknames[i]]),
                      if (i == 3) VsGraphs(stats: [for (var s in summaries) if ((s.zenithEx != null || s.zenithExCareerBest != null) && (s.zenithEx?.aggregateStats??s.zenithExCareerBest!.aggregateStats).apm > 0.00) s.zenithEx?.aggregateStats??s.zenithExCareerBest!.aggregateStats], nicknames: [for (int i = 0; i < summaries.length; i++) if ((summaries[i].zenithEx != null || summaries[i].zenithExCareerBest != null) && (summaries[i].zenithEx?.aggregateStats??summaries[i].zenithExCareerBest!.aggregateStats).apm > 0.00) nicknames[i]]),
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
  final Function removePlayer;

  const HeaderCard(this.player, this.removePlayer);

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
                else SizedBox(height: 120.0, width: 300.0),
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
                Positioned(
                  right: 0,
                  child: IconButton(onPressed: (){
                    removePlayer(player.userId);
                  }, icon: Icon(Icons.close, shadows: textShadow,))
                )
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
  // TODO: make spinner while awaiting for data
  // TODO: show error if failed to retrieve data
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
                    Text(t.enterUsername),
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
                            return RadarChartTitle(text: t.stats.graphs.attack, angle: 0, positionPercentageOffset: 0.05);
                          case 1:
                            return RadarChartTitle(text: t.stats.graphs.speed, angle: 0, positionPercentageOffset: 0.05);
                          case 2:
                            return RadarChartTitle(text: t.stats.graphs.defense, angle: angle + 180, positionPercentageOffset: 0.05);
                          case 3:
                            return RadarChartTitle(text: t.stats.graphs.cheese, angle: 0, positionPercentageOffset: 0.05);
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