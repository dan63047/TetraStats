// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_stats.dart';

class BetaLeagueRound{
  late String id;
  late String username;
  late bool active;
  late int naturalorder;
  late bool alive;
  late Duration lifetime;
  late BetaLeagueStats stats;

  BetaLeagueRound({required this.id, required this.username, required this.active, required this.naturalorder, required this.alive, required this.lifetime, required this.stats});

  BetaLeagueRound.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    active = json['active'];
    naturalorder = json['naturalorder'];
    alive = json['alive'];
    lifetime = Duration(milliseconds: json['lifetime']);
    stats = BetaLeagueStats.fromJson(json['stats']);
  }
}
