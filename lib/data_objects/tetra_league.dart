// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';

class TetraLeague {
  late String id;
  late DateTime timestamp;
  late int gamesPlayed;
  late int gamesWon;
  late String bestRank;
  late bool decaying;
  late double tr;
  late double gxe;
  late String rank;
  double? glicko;
  double? rd;
  late String percentileRank;
  late double percentile;
  late int standing;
  late int standingLocal;
  String? nextRank;
  late int nextAt;
  String? prevRank;
  late int prevAt;
  double? apm;
  double? pps;
  double? vs;
  NerdStats? nerdStats;
  EstTr? estTr;
  Playstyle? playstyle;
  late int season;

  TetraLeague(
      {required this.id,
      required this.timestamp,
      required this.gamesPlayed,
      required this.gamesWon,
      required this.bestRank,
      required this.decaying,
      required this.tr,
      required this.gxe,
      required this.rank,
      this.glicko,
      this.rd,
      required this.percentileRank,
      required this.percentile,
      required this.standing,
      required this.standingLocal,
      this.nextRank,
      required this.nextAt,
      this.prevRank,
      required this.prevAt,
      this.apm,
      this.pps,
      this.vs,
      required this.season}) {
    nerdStats = (apm != null && pps != null && vs != null)
        ? NerdStats(apm!, pps!, vs!)
        : null;
    estTr = (nerdStats != null)
        ? EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp,
            nerdStats!.gbe)
        : null;
    playstyle = (nerdStats != null)
        ? Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm,
            nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank)
        : null;
  }

  double get winrate => gamesWon / gamesPlayed;
  double get s1tr => gxe * 250;

  TetraLeague.fromJson(
      Map<String, dynamic> json, DateTime? ts, int s, String i) {
    timestamp = ts != null ? ts : seasonEnds[s - 1];
    season = s;
    id = i;
    gamesPlayed = json['gamesplayed'] ?? 0;
    gamesWon = json['gameswon'] ?? 0;
    tr = json['tr'] != null
        ? json['tr'].toDouble()
        : json['rating'] != null
            ? json['rating'].toDouble()
            : -1;
    glicko = json['glicko']?.toDouble();
    rd = json['rd'] != null ? json['rd']!.toDouble() : noTrRd;
    gxe = json['gxe'] != null ? json['gxe'].toDouble() : -1;
    rank = json['rank'] != null ? json['rank']!.toString() : 'z';
    bestRank = json['bestrank'] != null ? json['bestrank']!.toString() : 'z';
    apm = json['apm']?.toDouble();
    pps = json['pps']?.toDouble();
    vs = json['vs']?.toDouble();
    decaying = switch (json['decaying'].runtimeType) {
      int => json['decaying'] == 1,
      bool => json['decaying'],
      _ => false
    };
    standing = json['standing'] ?? json['placement'] ?? -1;
    percentile = json['percentile'] != null
        ? json['percentile'].toDouble()
        : rankCutoffs[rank];
    standingLocal = json['standing_local'] ?? -1;
    prevRank = json['prev_rank'];
    prevAt = json['prev_at'] ?? -1;
    nextRank = json['next_rank'];
    nextAt = json['next_at'] ?? -1;
    percentileRank = json['percentile_rank'] ?? rank;
    nerdStats = (apm != null && pps != null && vs != null)
        ? NerdStats(apm!, pps!, vs!)
        : null;
    estTr = (nerdStats != null)
        ? EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp,
            nerdStats!.gbe)
        : null;
    playstyle = (nerdStats != null)
        ? Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm,
            nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank)
        : null;
  }

  @override
  bool operator ==(covariant TetraLeague other) =>
      gamesPlayed == other.gamesPlayed && rd == other.rd;

  bool lessStrictCheck(covariant TetraLeague other) =>
      gamesPlayed == other.gamesPlayed && glicko == other.glicko;

  double? get esttracc => (estTr != null) ? estTr!.esttr - tr : null;

  TetrioPlayerFromLeaderboard convertToPlayerFromLeaderboard(String id) =>
      TetrioPlayerFromLeaderboard(
          id,
          "",
          "user",
          -1,
          null,
          timestamp,
          gamesPlayed,
          gamesWon,
          tr,
          gxe,
          glicko ?? 0,
          rd ?? noTrRd,
          rank,
          bestRank,
          apm ?? 0,
          pps ?? 0,
          vs ?? 0,
          decaying);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id + timestamp.millisecondsSinceEpoch.toRadixString(16);
    if (gamesPlayed > 0) data['gamesplayed'] = gamesPlayed;
    if (gamesWon > 0) data['gameswon'] = gamesWon;
    if (tr >= 0) data['tr'] = tr;
    if (glicko != null) data['glicko'] = glicko;
    if (gxe != -1) data['gxe'] = gxe;
    if (rd != null && rd != noTrRd) data['rd'] = rd;
    if (rank != 'z') data['rank'] = rank;
    if (bestRank != 'z') data['bestrank'] = bestRank;
    if (apm != null) data['apm'] = apm;
    if (pps != null) data['pps'] = pps;
    if (vs != null) data['vs'] = vs;
    if (decaying) data['decaying'] = decaying ? 1 : 0;
    if (standing >= 0) data['standing'] = standing;
    data['percentile'] = percentile;
    if (standingLocal >= 0) data['standing_local'] = standingLocal;
    if (prevRank != null) data['prev_rank'] = prevRank;
    if (prevAt >= 0) data['prev_at'] = prevAt;
    if (nextRank != null) data['next_rank'] = nextRank;
    if (nextAt >= 0) data['next_at'] = nextAt;
    data['percentile_rank'] = percentileRank;
    data['season'] = season;
    return data;
  }
}
