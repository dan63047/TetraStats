// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/clears.dart';
import 'package:tetra_stats/data_objects/finesse.dart';
import 'package:tetra_stats/data_objects/zenith_results.dart';

class ResultsStats {
  late int topBtB;
  late int topCombo;
  late int holds;
  late int inputs;
  late int level;
  late int piecesPlaced;
  late int lines;
  late int score;
  double? seed;
  late Duration finalTime;
  late int tSpins;
  late Clears clears;
  late int kills;
  Finesse? finesse;
  ZenithResults? zenith; 

  double get pps => piecesPlaced / (finalTime.inMicroseconds / 1000000);
  double get kpp => inputs / piecesPlaced;
  double get spp => score / piecesPlaced;
  double get kps => inputs / (finalTime.inMicroseconds / 1000000);
  double get finessePercentage => finesse != null ? finesse!.perfectPieces / piecesPlaced : 0;
  double get cps => zenith != null ? zenith!.avgrankpts / (finalTime.inMilliseconds / 1000 * 60) : 0;

  ResultsStats(
      {
      required this.topBtB,
      required this.topCombo,
      required this.holds,
      required this.inputs,
      required this.level,
      required this.piecesPlaced,
      required this.lines,
      required this.score,
      required this.seed,
      required this.finalTime,
      required this.tSpins,
      required this.clears,
      required this.finesse});

  ResultsStats.fromJson(Map<String, dynamic> json) {
    seed = json['seed']?.toDouble();
    lines = json['lines'];
    inputs = json['inputs'];
    holds = json['holds'] ?? 0;
    finalTime = Duration(microseconds: (json['finaltime'].toDouble() * 1000).floor());
    score = json['score'];
    level = json['level'];
    topCombo = json['topcombo'];
    topBtB = json['topbtb'];
    tSpins = json['tspins'];
    piecesPlaced = json['piecesplaced'];
    clears = Clears.fromJson(json['clears']);
    kills = json['kills'];
    if (json.containsKey("finesse")) finesse = Finesse.fromJson(json['finesse']);
    if (json.containsKey("zenith")) zenith = ZenithResults.fromJson(json['zenith']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seed'] = seed;
    data['lines'] = lines;
    data['inputs'] = inputs;
    data['holds'] = holds;
    data['score'] = score;
    data['level'] = level;
    data['topcombo'] = topCombo;
    data['topbtb'] = topBtB;
    data['tspins'] = tSpins;
    data['piecesplaced'] = piecesPlaced;
    data['clears'] = clears.toJson();
    if (finesse != null) data['finesse'] = finesse!.toJson();
    data['finalTime'] = finalTime;
    return data;
  }
}
