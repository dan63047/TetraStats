// ignore_for_file: hash_and_equals

class ZenithResults{
  late double altitude;
  late double rank;
  late double peakrank;
  late double avgrankpts;
  late int floor;
  late double targetingfactor;
  late double targetinggrace;
  late double totalbonus;
  late int revives;
  late int revivesTotal;
  late bool speedrun;
  late bool speedrunSeen;
  late List<Duration> splits;

  ZenithResults.fromJson(Map<String, dynamic> json){
    altitude = json['altitude'].toDouble();
    rank = json['rank'].toDouble();
    peakrank = json['peakrank'].toDouble();
    avgrankpts = json['avgrankpts'].toDouble();
    floor = json['floor'];
    targetingfactor = json['targetingfactor'].toDouble();
    targetinggrace = json['targetinggrace'].toDouble();
    totalbonus = json['totalbonus'].toDouble();
    revives = json['revives'];
    revivesTotal = json['revivesTotal'];
    speedrun = json['speedrun'];
    speedrunSeen = json['speedrun_seen'];
    splits = [];
    for (int ms in json['splits']) {
      splits.add(Duration(milliseconds: ms));
    }
  }
}
