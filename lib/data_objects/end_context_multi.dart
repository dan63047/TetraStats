// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/handling.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';

class EndContextMulti {
  late String userId;
  late String username;
  late int naturalOrder;
  late int inputs;
  late int piecesPlaced;
  late Handling handling;
  late int points;
  late int wins;
  late double secondary;
  late List secondaryTracking;
  late double tertiary;
  late List tertiaryTracking;
  late double extra;
  late List extraTracking;
  late bool success;
  late NerdStats nerdStats;
  late List<NerdStats> nerdStatsTracking;
  late EstTr estTr;
  late List<EstTr> estTrTracking;
  late Playstyle playstyle;
  late List<Playstyle> playstyleTracking;

  EndContextMulti(
      {required this.userId,
      required this.username,
      required this.naturalOrder,
      required this.inputs,
      required this.piecesPlaced,
      required this.handling,
      required this.points,
      required this.wins,
      required this.secondary,
      required this.secondaryTracking,
      required this.tertiary,
      required this.tertiaryTracking,
      required this.extra,
      required this.extraTracking,
      required this.success}){
        nerdStats = NerdStats(secondary, tertiary, extra);
        nerdStatsTracking = [for (int i = 0; i < secondaryTracking.length; i++) NerdStats(secondaryTracking[i], tertiaryTracking[i], extraTracking[i])];
        estTr = EstTr(secondary, tertiary, extra, 16, noTrRd, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
        estTrTracking = [for (int i = 0; i < secondaryTracking.length; i++) EstTr(secondaryTracking[i], tertiaryTracking[i], extraTracking[i], 16, noTrRd, nerdStatsTracking[i].app, nerdStatsTracking[i].dss, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe)];
        playstyle = Playstyle(secondary, tertiary, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
        playstyleTracking = [for (int i = 0; i < secondaryTracking.length; i++) Playstyle(secondaryTracking[i], tertiaryTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].vsapm, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe, estTrTracking[i].srarea, estTrTracking[i].statrank)];
      }

  EndContextMulti.fromJson(Map<String, dynamic> json) {
    userId = json['id'] ?? json['user']['_id'];
    username = json['username'] ?? json['user']['username'];
    handling = json['handling'] != null ? Handling.fromJson(json['handling']) : Handling(arr: -1, das: -1, sdf: -1, dcd: 0, cancel: true, safeLock: true);
    success = json['success'];
    inputs = json['inputs'] ?? -1;
    piecesPlaced = json['piecesplaced'] ?? -1;
    naturalOrder = json['naturalorder'];
    wins = json['wins'];
    points = json['points']['primary'];
    secondary = json['points']['secondary'].toDouble();
    tertiary = json['points']['tertiary'].toDouble();
    secondaryTracking = json['points']['secondaryAvgTracking'] != null ? json['points']['secondaryAvgTracking'].map((e) => e.toDouble()).toList() : [];
    tertiaryTracking = json['points']['tertiaryAvgTracking'] != null ? json['points']['tertiaryAvgTracking'].map((e) => e.toDouble()).toList() : [];
    extra = json['points']['extra']['vs'].toDouble();
    extraTracking = json['points']['extraAvgTracking'] != null ? json['points']['extraAvgTracking']['aggregatestats___vsscore'].map((e) => e.toDouble()).toList() : [];
    nerdStats = NerdStats(secondary, tertiary, extra);
    nerdStatsTracking = [for (int i = 0; i < secondaryTracking.length; i++) NerdStats(secondaryTracking[i], tertiaryTracking[i], extraTracking[i])];
    estTr = EstTr(secondary, tertiary, extra, 16, noTrRd, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    estTrTracking = [for (int i = 0; i < secondaryTracking.length; i++) EstTr(secondaryTracking[i], tertiaryTracking[i], extraTracking[i], 16, noTrRd, nerdStatsTracking[i].app, nerdStatsTracking[i].dss, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe)];
    playstyle = Playstyle(secondary, tertiary, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
    playstyleTracking = [for (int i = 0; i < secondaryTracking.length; i++) Playstyle(secondaryTracking[i], tertiaryTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].vsapm, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe, estTrTracking[i].srarea, estTrTracking[i].statrank)];
  }

  @override
  bool operator == (covariant EndContextMulti other){
    if (userId != other.userId) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = {'_id': userId, 'username': username};
    data['handling'] = handling.toJson();
    data['success'] = success;
    data['inputs'] = inputs;
    data['piecesplaced'] = piecesPlaced;
    data['naturalorder'] = naturalOrder;
    data['wins'] = wins;
    data['points'] = {'primary': points, 'secondary': secondary, 'tertiary':tertiary, 'extra': {'vs': extra}, 'secondaryAvgTracking': secondaryTracking, 'tertiaryAvgTracking': tertiaryTracking, 'extraAvgTracking': {'aggregatestats___vsscore': extraTracking}};
    return data;
  }
}
