// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_results.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/tetrio_multiplayer_replay.dart';
import 'package:tetra_stats/data_objects/tetrio_prisecter.dart';

class BetaRecord{
  late String id;
  late String replayID;
  late bool stub;
  late String gamemode;
  late DateTime ts;
  late String enemyUsername;
  late String enemyID;
  late BetaLeagueResults results;
  late LeagueExtras extras;
  late Prisecter prisecter;
  RawReplay? replay;

  BetaRecord({required this.id, required this.replayID, required this.gamemode, required this.ts, required this.enemyUsername, required this.enemyID, required this.results});

  BetaRecord.fromJson(Map<String, dynamic> json, {RawReplay? r}){
    replay = r;
    id = json['_id'] ?? json['id'] ?? 'none';
    replayID = json['replayid'] ?? json['id'] ?? 'none';
    stub = json['stub'] ?? false;
    gamemode = json['gamemode'] ?? 'custom';
    ts = DateTime.parse(json['ts']);
    enemyUsername = json['otherusers'] != null ? json['otherusers'][0]['username'] : json['replay']['leaderboard'][1]['username'];
    enemyID = json['otherusers'] != null ? json['otherusers'][0]['id'] : json['replay']['leaderboard'][1]['id'];
    results = BetaLeagueResults.fromJson(json['results'] ?? json['replay']);
    prisecter = json['p'] != null ? Prisecter.fromJson(json['p']) : Prisecter(ts.millisecondsSinceEpoch, 0, 0);
    if (json['extras'] != null) extras = LeagueExtras.fromJson(json['extras']);
  }
}
