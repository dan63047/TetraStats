// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/record_single.dart';

class SingleplayerStream{
  late String userId;
  late String type;
  late List<RecordSingle> records;

  SingleplayerStream({required this.userId, required this.records, required this.type});

  SingleplayerStream.fromJson(List<dynamic> json, String userID, String tp) {
    userId = userID;
    type = tp;
    records = [];
    for (var value in json) {records.add(RecordSingle.fromJson(value, -1, -1));}
  }
}
