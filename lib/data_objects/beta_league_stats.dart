// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';

class BetaLeagueStats{
  late double apm;
  late double pps;
  late double vs;
  late int garbageSent;
  late int garbageReceived;
  late int kills;
  late double altitude;
  late int rank;
  int? targetingFactor;
  int? targetingRace;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;

  BetaLeagueStats({required this.apm, required this.pps, required this.vs, required this.garbageSent, required this.garbageReceived, required this.kills, required this.altitude, required this.rank}){
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, 16, noTrRd, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  BetaLeagueStats.fromJson(Map<String, dynamic> json){
    apm = json['apm'] != null ? json['apm'].toDouble() : 0.00;
    pps = json['apm'] != null ? json['pps'].toDouble() : 0.00;
    vs = json['apm'] != null ? json['vsscore'].toDouble() : 0.00;
    garbageSent = json['garbagesent'];
    garbageReceived = json['garbagereceived'];
    kills = json['kills'];
    altitude = json['altitude'].toDouble();
    rank = json['rank'];
    targetingFactor = json['targetingfactor'];
    targetingRace = json['targetinggrace'];
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, 16, noTrRd, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }
}
