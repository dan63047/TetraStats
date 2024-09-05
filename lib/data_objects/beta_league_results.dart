// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_leaderboard_entry.dart';
import 'package:tetra_stats/data_objects/beta_league_round.dart';

class BetaLeagueResults{
  List<BetaLeagueLeaderboardEntry> leaderboard = [];
  List<List<BetaLeagueRound>> rounds = [];

  BetaLeagueResults({required this.leaderboard, required this.rounds});

  BetaLeagueResults.fromJson(Map<String, dynamic> json){
    for (var lbEntry in json['leaderboard']) {
      leaderboard.add(BetaLeagueLeaderboardEntry.fromJson(lbEntry));
    }
    for (var roundEntry in json['rounds']){
      List<BetaLeagueRound> round = [];
      for (var r in roundEntry) {
        round.add(BetaLeagueRound.fromJson(r));
      }
      rounds.add(round);
    }
  }
}
