// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/aggregate_stats.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/results_stats.dart';

class RecordSingle {
  late String? userId;
  late String replayId;
  late String ownId;
  late String gamemode;
  late DateTime timestamp;
  late ResultsStats stats;
  late int rank;
  late int countryRank;
  late AggregateStats aggregateStats;
  late RecordExtras extras;

  RecordSingle({required this.userId, required this.replayId, required this.ownId, required this.timestamp, required this.stats, required this.rank, required this.countryRank, required this.aggregateStats});

  RecordSingle.fromJson(Map<String, dynamic> json, int ran, int cran) {
    ownId = json['_id'];
    gamemode = json['gamemode'];
    stats = ResultsStats.fromJson(json['results']['stats']);
    replayId = json['replayid'];
    timestamp = DateTime.parse(json['ts']);
    if (json['user'] != null) userId = json['user']['id'];
    rank = ran;
    countryRank = cran;
    aggregateStats = AggregateStats.fromJson(json['results']['aggregatestats']);
    var ex = json['extras'] as Map<String, dynamic>;
    switch (ex.keys.firstOrNull){
      case "zenith":
        extras = ZenithExtras.fromJson(json['extras']['zenith']);
      default:
      break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = ownId;
    data['results']['stats'] = stats.toJson();
    data['ismulti'] = false;
    data['replayid'] = replayId;
    data['ts'] = timestamp;
    data['user_id'] = userId;
    return data;
  }
}
