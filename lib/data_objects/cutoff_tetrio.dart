// ignore_for_file: hash_and_equals

class CutoffTetrio {
  late int pos;
  late double percentile;
  late double tr;
  late double targetTr;
  late double apm;
  late double pps;
  late double vs;
  late int count;
  late double countPercentile;

  CutoffTetrio.fromJson(Map<String, dynamic> json, int total){
    pos = json['pos'];
    percentile = json['percentile'].toDouble();
    tr = json['tr'].toDouble();
    targetTr = json['targettr'].toDouble();
    apm = json['apm'].toDouble();
    pps = json['pps'].toDouble();
    vs = json['vs'].toDouble();
    count = json['count'];
    countPercentile = count / total;
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