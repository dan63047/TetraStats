// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/end_context_multi.dart';

class TetraLeagueAlphaRecord{
  late String replayId;
  late String ownId;
  late DateTime timestamp;
  late bool replayAvalable;
  late List<EndContextMulti> endContext;

  TetraLeagueAlphaRecord({required this.replayId, required this.ownId, required this.timestamp, required this.endContext, required this.replayAvalable});

  TetraLeagueAlphaRecord.fromJson(Map<String, dynamic> json) {
    endContext = [EndContextMulti.fromJson(json['endcontext'][0]), EndContextMulti.fromJson(json['endcontext'][1])];
    replayId = json['replayid'];
    ownId = json['_id']??replayId;
    timestamp = DateTime.parse(json['ts']);
    replayAvalable = ownId != replayId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = ownId;
    data['endcontext'][0] = endContext[0].toJson();
    data['endcontext'][1] = endContext[1].toJson();
    data['replayid'] = replayId;
    data['ts'] = timestamp;
    return data;
  }

  @override
  bool operator ==(covariant TetraLeagueAlphaRecord other) => (ownId == other.ownId) || (replayId == other.replayId);

  @override
  String toString() {
    return "TetraLeagueAlphaRecord: ${endContext.first.userId} vs ${endContext.last.userId}";
  }
}
