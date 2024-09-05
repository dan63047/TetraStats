// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_results.dart';

class BetaRecord{
  late String id;
  late String replayID;
  late String gamemode;
  late DateTime ts;
  late String enemyUsername;
  late String enemyID;
  late BetaLeagueResults results;

  BetaRecord({required this.id, required this.replayID, required this.gamemode, required this.ts, required this.enemyUsername, required this.enemyID, required this.results});

  BetaRecord.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    replayID = json['replayid'];
    gamemode = json['gamemode'];
    ts = DateTime.parse(json['ts']);
    enemyUsername = json['otherusers'][0]['username'];
    enemyID = json['otherusers'][0]['id'];
    results = BetaLeagueResults.fromJson(json['results']);
  }
}
