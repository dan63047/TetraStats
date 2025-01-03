// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/leaderboard_position.dart';

class PlayerLeaderboardPosition{
  late LeaderboardPosition? apm;
  late LeaderboardPosition? pps;
  late LeaderboardPosition? vs;
  late LeaderboardPosition? gamesPlayed;
  late LeaderboardPosition? gamesWon;
  late LeaderboardPosition? winrate;
  late LeaderboardPosition? glixare;
  late LeaderboardPosition? app;
  late LeaderboardPosition? vsapm;
  late LeaderboardPosition? dss;
  late LeaderboardPosition? dsp;
  late LeaderboardPosition? appdsp;
  late LeaderboardPosition? cheese;
  late LeaderboardPosition? gbe;
  late LeaderboardPosition? nyaapp;
  late LeaderboardPosition? area;
  late LeaderboardPosition? estTr;
  late LeaderboardPosition? accOfEst;

  PlayerLeaderboardPosition({
    required this.apm,
    required this.pps,
    required this.vs,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.winrate,
    required this.glixare,
    required this.app,
    required this.vsapm,
    required this.dss,
    required this.dsp,
    required this.appdsp,
    required this.cheese,
    required this.gbe,
    required this.nyaapp,
    required this.area,
    required this.estTr,
    required this.accOfEst
  });
  
  PlayerLeaderboardPosition.fromSearchResults(List<LeaderboardPosition?> results){
    apm = results[0];
    pps = results[1];
    vs = results[2];
    gamesPlayed = results[3];
    gamesWon = results[4];
    winrate = results[5];
    glixare = results[6];
    app = results[7];
    vsapm = results[8];
    dss = results[9];
    dsp = results[10];
    appdsp = results[11];
    cheese = results[12];
    gbe = results[13];
    nyaapp = results[14];
    area = results[15];
    estTr = results[16];
    accOfEst = results[17];
  }
}
