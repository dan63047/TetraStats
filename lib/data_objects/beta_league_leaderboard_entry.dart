// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_stats.dart';

class BetaLeagueLeaderboardEntry{
  late String id;
  late String username;
  late int naturalorder;
  late int wins;
  late BetaLeagueStats stats;

  BetaLeagueLeaderboardEntry({required this.id, required this.username, required this.naturalorder, required this.wins, required this.stats});
  
  BetaLeagueLeaderboardEntry.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    naturalorder = json['naturalorder'];
    wins = json['wins'];
    stats = BetaLeagueStats.fromJson(json['stats']);
  }
}
