import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/gauget_thingy.dart';
import 'package:tetra_stats/widgets/tl_progress_bar.dart';
import 'package:tetra_stats/widgets/tl_rating_thingy.dart';

class TetraLeagueThingy extends StatelessWidget{
  final TetraLeague league;
  final TetraLeague? toCompare;
  final Cutoffs? cutoffs;
  final CutoffTetrio? averages;
  final PlayerLeaderboardPosition? lbPos;
  final double width;

  const TetraLeagueThingy({super.key, required this.league, this.toCompare, this.cutoffs, this.averages, this.lbPos, this.width = double.infinity});

  List<TableRow> secondColumn(){
    return [
      TableRow(children: [
        //Text("APM: ", style: TextStyle(fontSize: 21)),
        Text(intf.format(league.gamesPlayed), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" Games", style: TextStyle(fontSize: 21)),
        if (toCompare != null) Text(" (${comparef2.format(league.gamesPlayed-toCompare!.gamesPlayed)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
        if (lbPos != null) Text(lbPos?.gamesPlayed != null ? (lbPos!.gamesPlayed!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.gamesPlayed!.percentage*100)}%)" : " (№ ${lbPos!.gamesPlayed!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.gamesPlayed != null ? getColorOfRank(lbPos!.gamesPlayed!.position) : null))
      ]),
      TableRow(children: [
        //Text("PPS: ", style: TextStyle(fontSize: 21)),
        Text(intf.format(league.gamesWon), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" Won", style: TextStyle(fontSize: 21)),
        if (toCompare != null) Text(" (${comparef2.format(league.gamesWon-toCompare!.gamesWon)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
        if (lbPos != null) Text(lbPos?.gamesWon != null ? (lbPos!.gamesWon!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.gamesWon!.percentage*100)}%)" : " (№ ${lbPos!.gamesWon!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.gamesWon != null ? getColorOfRank(lbPos!.gamesWon!.position) : null))
      ]),
      TableRow(children: [
        //Text("VS: ", style: TextStyle(fontSize: 21)),
        Tooltip(child: Text("${league.gxe.isNegative ? "---" : f3.format(league.gxe)}", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.gxe.isNegative ? Colors.grey : Colors.white)), message: "${f2.format(league.s1tr)} S1 TR"),
        Tooltip(child: Text(" GXE", style: TextStyle(fontSize: 21, color: league.gxe.isNegative ? Colors.grey : Colors.white)), message: "Glixare"),
        if (toCompare != null) Text(" (${comparef.format(league.gxe-toCompare!.gxe)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.gxe-toCompare!.gxe))),
        if (lbPos != null) Text(lbPos?.glixare != null ? (lbPos!.glixare!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.glixare!.percentage*100)}%)" : " (№ ${lbPos!.glixare!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.glixare != null ? getColorOfRank(lbPos!.glixare!.position) : null))
      ]),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      //surfaceTintColor: rankColors[league.rank],
      child: Column(
        children: [
          TLRatingThingy(userID: league.id, tlData: league, oldTl: toCompare, showPositions: true),
          if (league.gamesPlayed > 9) TLProgress(
            tlData: league,
            previousRankTRcutoff: cutoffs != null ? cutoffs!.tr[league.rank != "z" ? league.rank : league.percentileRank] : null,
            nextRankTRcutoff: cutoffs != null ? (league.rank != "z" ? league.rank == "x+" : league.percentileRank == "x+") ? 25000 : cutoffs!.tr[ranks.elementAtOrNull(ranks.indexOf(league.rank != "z" ? league.rank : league.percentileRank)+1)] : null,
            previousRankTRcutoffTarget: league.rank != "z" ? rankTargets[league.rank] : null,
            nextRankTRcutoffTarget: (league.rank != "z" && league.rank != "x+") ? rankTargets[ranks.elementAtOrNull(ranks.indexOf(league.rank)+1)] : null,
            previousGlickoCutoff: cutoffs != null ? cutoffs!.glicko[league.rank != "z" ? league.rank : league.percentileRank] : null,
            nextRankGlickoCutoff: cutoffs != null ? (league.rank != "z" ? league.rank == "x+" : league.percentileRank == "x+") ? 25000 : cutoffs!.glicko[ranks.elementAtOrNull(ranks.indexOf(league.rank != "z" ? league.rank : league.percentileRank)+1)] : null,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        Text(league.apm != null ? f2.format(league.apm) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.apm != null ? getStatColor(league.apm!, averages?.apm, true) : Colors.grey)),
                        Text(" APM", style: TextStyle(fontSize: 21, color: league.apm != null ? getStatColor(league.apm!, averages?.apm, true) : Colors.grey)),
                        if (toCompare != null) Text(" (${comparef2.format(league.apm!-toCompare!.apm!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.apm!-toCompare!.apm!))),
                        if (lbPos != null) Text(lbPos?.apm != null ? (lbPos!.apm!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.apm!.percentage*100)}%)" : " (№ ${lbPos!.apm!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.apm != null ? getColorOfRank(lbPos!.apm!.position) : null))
                      ]),
                      TableRow(children: [
                        Text(league.pps != null ? f2.format(league.pps) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.pps != null ? getStatColor(league.pps!, averages?.pps, true) : Colors.grey)),
                        Text(" PPS", style: TextStyle(fontSize: 21, color: league.pps != null ? getStatColor(league.pps!, averages?.pps, true) : Colors.grey)),
                        if (toCompare != null) Text(" (${comparef2.format(league.pps!-toCompare!.pps!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.pps!-toCompare!.pps!))),
                        if (lbPos != null) Text(lbPos?.pps != null ? (lbPos!.pps!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.pps!.percentage*100)}%)" : " (№ ${lbPos!.pps!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.pps != null ? getColorOfRank(lbPos!.pps!.position) : null))
                      ]),
                      TableRow(children: [
                        Text(league.vs != null ? f2.format(league.vs) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: league.vs != null ? getStatColor(league.vs!, averages?.vs, true) : Colors.grey)),
                        Text(" VS", style: TextStyle(fontSize: 21, color: league.vs != null ? getStatColor(league.vs!, averages?.vs, true) : Colors.grey)),
                        if (toCompare != null) Text(" (${comparef2.format(league.vs!-toCompare!.vs!)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.vs!-toCompare!.vs!))),
                        if (lbPos != null) Text(lbPos?.vs != null ? (lbPos!.vs!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.vs!.percentage*100)}%)" : " (№ ${lbPos!.vs!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.vs != null ? getColorOfRank(lbPos!.vs!.position) : null))
                      ]),
                      if (width <= 600) TableRow(children: [
                        Text(!league.winrate.isNegative ? percentage.format(league.winrate) : "---", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: !league.winrate.isNegative ? Colors.white : Colors.grey)),
                        Text(" WR", style: TextStyle(fontSize: 21, color: !league.winrate.isNegative ? Colors.white : Colors.grey)),
                        if (toCompare != null) Text(" (${comparef2.format((league.winrate-toCompare!.winrate)*100)})", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: getDifferenceColor(league.winrate-toCompare!.winrate))),
                        if (lbPos != null) Text(lbPos?.winrate != null ? (lbPos!.winrate!.position >= 1000 ? " (${t.top} ${f2.format(lbPos!.winrate!.percentage*100)}%)" : " (№ ${lbPos!.winrate!.position})") : "(№ ---)", style: TextStyle(color: lbPos?.winrate != null ? getColorOfRank(lbPos!.winrate!.position) : null))
                      ]),
                      if (width <= 400) ...secondColumn()
                    ],
                  ),
                ),
              ),
              if (width > 600) GaugetThingy(value: league.winrate, min: 0, max: 1, tickInterval: 0.25, label: "Winrate", sideSize: 128, fractionDigits: 2, moreIsBetter: true, oldValue: toCompare?.winrate, percentileFormat: true, lbPos: lbPos?.winrate),
              if (width > 400) Expanded(
                child: Center(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: secondColumn(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}