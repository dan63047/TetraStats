// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/tetra_league_alpha_record.dart';

class TetraLeagueAlphaStream{
  late String userId;
  late List<TetraLeagueAlphaRecord> records;

  TetraLeagueAlphaStream({required this.userId, required this.records});

  TetraLeagueAlphaStream.fromJson(List<dynamic> json, String userID) {
    userId = userID;
    records = [];
    for (var value in json) {records.add(TetraLeagueAlphaRecord.fromJson(value));}
  }
}
