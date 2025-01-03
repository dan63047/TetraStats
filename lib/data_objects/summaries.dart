// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/achievement.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';

class Summaries {
  late String id;
  RecordSingle? sprint;
  RecordSingle? blitz;
  RecordSingle? zenith;
  RecordSingle? zenithCareerBest; // leaderboard best, not overall
  RecordSingle? zenithEx;
  RecordSingle? zenithExCareerBest; // leaderboard best, not overall
  late List<Achievement> achievements;
  late TetraLeague league;
  Map<int, TetraLeague> pastLeague = {};
  late TetrioZen zen;

  Summaries(this.id, this.league, this.zen);

  Summaries.fromJson(Map<String, dynamic> json, String i) {
    id = i;
    if (json['40l']['record'] != null)
      sprint = RecordSingle.fromJson(json['40l']['record'], json['40l']['rank'],
          json['40l']['rank_local']);
    if (json['blitz']['record'] != null)
      blitz = RecordSingle.fromJson(json['blitz']['record'],
          json['blitz']['rank'], json['blitz']['rank_local']);
    if (json['zenith']['record'] != null)
      zenith = RecordSingle.fromJson(json['zenith']['record'],
          json['zenith']['rank'], json['zenith']['rank_local']);
    if (json['zenith']['best']['record'] != null)
      zenithCareerBest = RecordSingle.fromJson(
          json['zenith']['best']['record'], json['zenith']['best']['rank'], -1);
    if (json['zenithex']['record'] != null)
      zenithEx = RecordSingle.fromJson(json['zenithex']['record'],
          json['zenithex']['rank'], json['zenithex']['rank_local']);
    if (json['zenithex']['best']['record'] != null)
      zenithExCareerBest = RecordSingle.fromJson(
          json['zenithex']['best']['record'],
          json['zenithex']['best']['rank'],
          -1);
    achievements = [
      for (var achievement in json['achievements'])
        Achievement.fromJson(achievement)
    ];
    league =
        TetraLeague.fromJson(json['league'], DateTime.now(), currentSeason, i);
    if (json['league']['past'] != null && json['league']['past'].isNotEmpty)
      for (var key in json['league']['past'].keys) {
        pastLeague[int.parse(key)] = TetraLeague.fromJson(
            json['league']['past'][key],
            null,
            int.parse(json['league']['past'][key]['season']),
            i);
      }
    zen = TetrioZen.fromJson(json['zen']);
  }
}
