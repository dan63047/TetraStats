// ignore_for_file: hash_and_equals

import 'dart:math';

import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';

class TetrioPlayerFromLeaderboard {
  late String userId;
  late String username;
  late String role;
  late double xp;
  String? country;
  late DateTime timestamp;
  late int gamesPlayed;
  late int gamesWon;
  late double tr;
  late double gxe;
  late double? glicko;
  late double? rd;
  late String rank;
  late String? bestRank;
  late double apm;
  late double pps;
  late double vs;
  late bool decaying;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;
  late int gamesPlayedTotal;
  late int gamesWonTotal;
  late Duration playtime;
  late int ar;

  TetrioPlayerFromLeaderboard(
    this.userId,
    this.username,
    this.role,
    this.xp,
    this.country,
    this.timestamp,
    this.gamesPlayed,
    this.gamesWon,
    this.tr,
    this.gxe,
    this.glicko,
    this.rd,
    this.rank,
    this.bestRank,
    this.apm,
    this.pps,
    this.vs,
    this.decaying,
    this.gamesPlayedTotal,
    this.gamesWonTotal,
    this.playtime,
    this.ar){
      nerdStats =  NerdStats(apm, pps, vs);
      estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
      playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
    }

  double get winrate => gamesWon / gamesPlayed;
  double get winrateTotal => gamesWonTotal / gamesWonTotal;
  double get level => pow((xp / 500), 0.6) + (xp / (5000 + (max(0, xp - 4 * pow(10, 6)) / 5000))) + 1;
  double get esttracc => estTr.esttr - tr;
  double get s1tr => gxe * 250;

  TetrioPlayerFromLeaderboard.fromJson(Map<String, dynamic> json, DateTime ts) {
    userId = json['_id'];
    username = json['username'];
    role = json['role'];
    xp = json['xp'].toDouble();
    country = json['country'];
    timestamp = ts;
    gamesPlayed = json['league']['gamesplayed'] as int;
    gamesWon = json['league']['gameswon'] as int;
    tr = json['league']['tr'] != null ? json['league']['tr'].toDouble() : 0;
    gxe = json['league']['gxe']?.toDouble();
    glicko = json['league']['glicko']?.toDouble();
    rd = json['league']['rd']?.toDouble();
    rank = json['league']['rank'];
    bestRank = json['league']['bestrank'];
    apm = json['league']['apm'] != null ? json['league']['apm'].toDouble() : 0.00;
    pps = json['league']['pps'] != null ? json['league']['pps'].toDouble() : 0.00;
    vs = json['league']['vs'] != null ? json['league']['vs'].toDouble(): 0.00;
    decaying = json['league']['decaying'];
    gamesPlayedTotal = json['gamesplayed'] as int;
    gamesWonTotal = json['gameswon'] as int;
    playtime = Duration(microseconds: (json['gametime'].toDouble() * 1000000).floor());
    ar = json['ar'];
    nerdStats =  NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  num getStatByEnum(Stats stat){
    switch (stat) {
      case Stats.tr:
        return tr;
      case Stats.glicko:
        return glicko??-1;
      case Stats.gxe:
        return gxe;
      case Stats.s1tr:
        return s1tr;
      case Stats.rd:
        return rd??-1;
      case Stats.gp:
        return gamesPlayed;
      case Stats.gw:
        return gamesWon;
      case Stats.wr:
        return winrate*100;
      case Stats.apm:
        return apm;
      case Stats.pps:
        return pps;
      case Stats.vs:
        return vs;
      case Stats.app:
        return nerdStats.app;
      case Stats.dss:
        return nerdStats.dss;
      case Stats.dsp:
        return nerdStats.dsp;
      case Stats.appdsp:
        return nerdStats.appdsp;
      case Stats.vsapm:
        return nerdStats.vsapm;
      case Stats.cheese:
        return nerdStats.cheese;
      case Stats.gbe:
        return nerdStats.gbe;
      case Stats.nyaapp:
        return nerdStats.nyaapp;
      case Stats.area:
        return nerdStats.area;
      case Stats.eTR:
        return estTr.esttr;
      case Stats.acceTR:
        return esttracc;
      case Stats.acceTRabs:
        return esttracc.abs();
      case Stats.opener:
        return playstyle.opener;
      case Stats.plonk:
        return playstyle.plonk;
      case Stats.infDS:
        return playstyle.infds;
      case Stats.stride:
        return playstyle.stride;
      case Stats.stridemMinusPlonk:
        return playstyle.stride - playstyle.plonk;
      case Stats.openerMinusInfDS:
        return playstyle.opener - playstyle.infds;
    }
  }
}
