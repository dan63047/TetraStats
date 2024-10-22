import 'package:tetra_stats/data_objects/nerd_stats.dart';

class CutoffTetrio {
  late int pos;
  late double percentile;
  late double tr;
  late double targetTr;
  late double? apm;
  late double? pps;
  late double? vs;
  NerdStats? nerdStats;
  late int count;
  late double countPercentile;

  CutoffTetrio({
    required this.pos,
    required this.percentile,
    required this.tr,
    required this.targetTr,
    required this.apm,
    required this.pps,
    required this.vs,
    required this.count,
    required this.countPercentile
  }){
    if (apm != null && pps != null && vs != null) nerdStats = NerdStats(apm!, pps!, vs!);
  }

  CutoffTetrio.fromJson(Map<String, dynamic> json, int total){
    pos = json['pos'];
    percentile = json['percentile'].toDouble();
    tr = json['tr'].toDouble();
    targetTr = json['targettr'].toDouble();
    apm = json['apm']?.toDouble();
    pps = json['pps']?.toDouble();
    vs = json['vs']?.toDouble();
    count = json['count'];
    countPercentile = count / total;
    if (apm != null && pps != null && vs != null) nerdStats = NerdStats(apm!, pps!, vs!);
  }
}

class CutoffsTetrio {
  late String id;
  late DateTime timestamp;
  late int total;
  Map<String, CutoffTetrio> data = {};

  CutoffsTetrio.fromJson(Map<String, dynamic> json){
    id = json['s'];
    timestamp = DateTime.parse(json['t']);
    total = json['data']['total'];
    json['data'].remove("total");
    for (String rank in json['data'].keys){
      data[rank] = CutoffTetrio.fromJson(json['data'][rank], total);
    }
  }
}