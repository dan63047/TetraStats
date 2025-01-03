// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';

class AggregateStats{
  late double apm;
  late double pps;
  late double vs;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;

  AggregateStats(this.apm, this.pps, this.vs){
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  AggregateStats.precalculated(this.apm, this.pps, this.vs, this.nerdStats, this.playstyle);

  AggregateStats.fromJson(Map<String, dynamic> json){
    apm = json['apm'] != null ? json['apm'].toDouble() : 0.00;
    pps = json['apm'] != null ? json['pps'].toDouble() : 0.00;
    vs = json['apm'] != null ? json['vsscore'].toDouble() : 0.00;
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }
}
