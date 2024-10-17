import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/news.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/singleplayer_stream.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetra_league_beta_stream.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/main_view_tiles.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class DestinationHome extends StatefulWidget{
  final String searchFor;
  final Future<FetchResults> dataFuture;
  final Future<News>? newsFuture;
  final BoxConstraints constraints;

  const DestinationHome({super.key, required this.searchFor, required this.dataFuture, this.newsFuture, required this.constraints});

  @override
  State<DestinationHome> createState() => _DestinationHomeState();
}

class FetchResults{
  bool success;
  TetrioPlayer? player;
  List<TetraLeague> states;
  Summaries? summaries;
  Cutoffs? cutoffs;
  Exception? exception;

  FetchResults(this.success, this.player, this.states, this.summaries, this.cutoffs, this.exception);
}

class RecordSummary extends StatelessWidget{
  final RecordSingle? record;
  final bool hideRank;
  final bool? betterThanRankAverage;
  final MapEntry? closestAverage;
  final bool? betterThanClosestAverage;
  final String? rank;

  const RecordSummary({super.key, required this.record, this.betterThanRankAverage, this.closestAverage, this.betterThanClosestAverage, this.rank, this.hideRank = false});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (closestAverage != null && record != null) Padding(padding: const EdgeInsets.only(right: 8.0),
        child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage!.key}.png", height: 96))
        else !hideRank ? Image.asset("res/tetrio_tl_alpha_ranks/z.png", height: 96) : Container(),
        if (record != null) Column(
          crossAxisAlignment: hideRank ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          RichText(
            textAlign: hideRank ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              text: switch(record!.gamemode){
                "40l" => get40lTime(record!.stats.finalTime.inMicroseconds),
                "blitz" => NumberFormat.decimalPattern().format(record!.stats.score),
                "5mblast" => get40lTime(record!.stats.finalTime.inMicroseconds),
                "zenith" => "${f2.format(record!.stats.zenith!.altitude)} m",
                "zenithex" => "${f2.format(record!.stats.zenith!.altitude)} m",
                _ => record!.stats.score.toString()
              },
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white, height: 0.9),
              ),
            ),
          RichText(
            textAlign: hideRank ? TextAlign.center : TextAlign.start,
            text: TextSpan(
            text: "",
            style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
            children: [
              if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                "40l" => readableTimeDifference(record!.stats.finalTime, sprintAverages[rank]!),
                "blitz" => readableIntDifference(record!.stats.score, blitzAverages[rank]!),
                _ => record!.stats.score.toString()
              }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
              ))
              else if ((rank == null || rank == "z") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                "40l" => readableTimeDifference(record!.stats.finalTime, closestAverage!.value),
                "blitz" => readableIntDifference(record!.stats.score, closestAverage!.value),
                _ => record!.stats.score.toString()
              }, verdict: betterThanClosestAverage??false ? t.verdictBetter : t.verdictWorse, rank: closestAverage!.key.toUpperCase())}\n", style: TextStyle(
                color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
              )),
              if (record!.rank != -1) TextSpan(text: "№ ${intf.format(record!.rank)}", style: TextStyle(color: getColorOfRank(record!.rank))),
              if (record!.rank != -1 && record!.countryRank != -1) const TextSpan(text: " • "),
              if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} local", style: TextStyle(color: getColorOfRank(record!.countryRank))),
              const TextSpan(text: "\n"),
              TextSpan(text: timestamp(record!.timestamp)),
            ]
            ),
          ),
        ],
      ) else if (hideRank) RichText(text: const TextSpan(
        text: "---",
        style: TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      )
      ],
    );
  }
  
}

class LeagueCard extends StatelessWidget{
  final TetraLeague league;
  final bool showSeasonNumber;

  const LeagueCard({super.key, required this.league, this.showSeasonNumber = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showSeasonNumber) Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("Season ${league.season}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                  Spacer(),
                  Text(
                    "${seasonStarts.elementAtOrNull(league.season - 1) != null ? timestamp(seasonStarts[league.season - 1]) : "---"} — ${seasonEnds.elementAtOrNull(league.season - 1) != null ? timestamp(seasonEnds[league.season - 1]) : "---"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                ],
              )
              else Text("Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
              const Divider(),
              TLRatingThingy(userID: "", tlData: league, showPositions: true),
              const Divider(),
              Text("${league.apm != null ? f2.format(league.apm) : "-.--"} APM • ${league.pps != null ? f2.format(league.pps) : "-.--"} PPS • ${league.vs != null ? f2.format(league.vs) : "-.--"} VS • ${league.nerdStats != null ? f2.format(league.nerdStats!.app) : "-.--"} APP • ${league.nerdStats != null ? f2.format(league.nerdStats!.vsapm) : "-.--"} VS/APM", style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }

}

class _DestinationHomeState extends State<DestinationHome> with SingleTickerProviderStateMixin {
  Cards rightCard = Cards.overview;
  CardMod cardMod = CardMod.info;
  //Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  late Map<Cards, List<ButtonSegment<CardMod>>> modeButtons;
  late MapEntry? closestAverageBlitz;
  late bool blitzBetterThanClosestAverage;
  late MapEntry? closestAverageSprint;
  late bool sprintBetterThanClosestAverage;
  late AnimationController _transition;
  late final Animation<Offset> _offsetAnimation;
  bool? sprintBetterThanRankAverage;
  bool? blitzBetterThanRankAverage;

  Widget getOverviewCard(Summaries summaries){
    return Column(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Overview", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                ],
              ),
            ),
          ),
        ),
        LeagueCard(league: summaries.league),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("40 Lines", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(),
                      RecordSummary(record: summaries.sprint, betterThanClosestAverage: sprintBetterThanClosestAverage, betterThanRankAverage: sprintBetterThanRankAverage, closestAverage: closestAverageSprint, rank: summaries.league.percentileRank),
                      const Divider(),
                      Text("${summaries.sprint != null ? intf.format(summaries.sprint!.stats.piecesPlaced) : "---"} P • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.pps) : "---"} PPS • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.kpp) : "---"} KPP", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Blitz", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(),
                      RecordSummary(record: summaries.blitz, betterThanClosestAverage: blitzBetterThanClosestAverage, betterThanRankAverage: blitzBetterThanRankAverage, closestAverage: closestAverageBlitz, rank: summaries.league.percentileRank),
                      const Divider(),
                      Text("Level ${summaries.blitz != null ? intf.format(summaries.blitz!.stats.level): "--"} • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.spp) : "-.--"} SPP • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.pps) : "---"} PPS", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("QP", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(),
                      RecordSummary(record: summaries.zenith, hideRank: true),
                      const Divider(),
                      Text("Overall PB: ${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 18).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 18).v!) : "-.--"} m", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("QP Expert", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      const Divider(),
                      RecordSummary(record: summaries.zenithEx, hideRank: true,),
                      const Divider(),
                      Text("Overall PB: ${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 19).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 19).v!) : "-.--"} m", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Zen", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28, height: 0.9)),
                      Text("Level ${intf.format(summaries.zen.level)}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white)),
                      Text("Score ${intf.format(summaries.zen.score)}"),
                      Text("Level up requirement: ${intf.format(summaries.zen.scoreRequirement)}", style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        const Text("f", style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 65,
                          height: 1.2,
                        )),
                        const Positioned(left: 25, top: 20, child: Text("inesse", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("${(summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 4).v != null && summaries.achievements.firstWhere((e) => e.k == 1).v != null) ?
                          f3.format(summaries.achievements.firstWhere((e) => e.k == 4).v!/summaries.achievements.firstWhere((e) => e.k == 1).v! * 100) : "--.---"}%", style: const TextStyle(
                            //shadows: textShadow,
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          )),
                        )
                      ],
                      ),
                      Row(
                        children: [
                          const Text("Total pieces placed:"),
                          const Spacer(),
                          Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 1).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 1).v!) : "---"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(" - Placed with perfect finesse:"),
                          const Spacer(),
                          Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 4).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 4).v!) : "---"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (summaries.achievements.isNotEmpty) Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              children: [
                if (summaries.achievements.firstWhere((e) => e.k == 16).v != null) Row(
                  children: [
                    const Text("Total height climbed in QP"),
                    const Spacer(),
                    Text("${f2.format(summaries.achievements.firstWhere((e) => e.k == 16).v!)} m"),
                  ],
                ),
                if (summaries.achievements.firstWhere((e) => e.k == 17).v != null) Row(
                  children: [
                    const Text("KO's in QP"),
                    const Spacer(),
                    Text(intf.format(summaries.achievements.firstWhere((e) => e.k == 17).v!)),
                  ],
                )
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget getTetraLeagueCard(TetraLeague data, Cutoffs? cutoffs, List<TetraLeague> states){
    TetraLeague? toCompare = states.length >= 2 ? states.elementAtOrNull(states.length-2) : null;
    return Column(
      children: [
        Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.tetraLeague, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${states.last.timestamp} ${states.last.tr}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        TetraLeagueThingy(league: data, toCompare: toCompare, cutoffs: cutoffs),
        if (data.nerdStats != null) Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              const Spacer()
            ],
          ),
        ),
        if (data.nerdStats != null) NerdStatsThingy(nerdStats: data.nerdStats!, oldNerdStats: toCompare?.nerdStats),
        if (data.nerdStats != null) GraphsThingy(nerdStats: data.nerdStats!, playstyle: data.playstyle!, apm: data.apm!, pps: data.pps!, vs: data.vs!)
      ],
    );
  }

  Widget getPreviousSeasonsList(Map<int, TetraLeague> pastLeague){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Previous Seasons", style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        for (var key in pastLeague.keys) Card(
          child: LeagueCard(league: pastLeague[key]!, showSeasonNumber: true),
        )
      ],
    );
  }

  Widget getListOfRecords(String recentStream, String topStream, BoxConstraints constraints){
    return Column(
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Records", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: DefaultTabController(length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Recent"),
                    Tab(text: "Top"),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      FutureBuilder<SingleplayerStream>(
                        future: teto.fetchStream(widget.searchFor, recentStream),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData){
                              return Column(
                                children: [
                                  for (int i = 0; i < snapshot.data!.records.length; i++) ListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: snapshot.data!.records[i]))),
                                  leading: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => "40L",
                                      "blitz" => "BLZ",
                                      "5mblast" => "5MB",
                                      "zenith" => "QP",
                                      "zenithex" => "QPE",
                                      String() => "huh",
                                    },
                                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
                                  ),
                                  title: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                      "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      String() => "huh",
                                    },
                                  style: const TextStyle(fontSize: 18)),
                                  subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                  trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                )
                                ],
                              );
                            }
                            if (snapshot.hasError){ return FutureError(snapshot); }
                          }
                        return const Text("what?");
                        },
                      ),
                      FutureBuilder<SingleplayerStream>(
                        future: teto.fetchStream(widget.searchFor, topStream),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData){
                              return Column(
                                children: [
                                  for (int i = 0; i < snapshot.data!.records.length; i++) ListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: snapshot.data!.records[i]))),
                                  leading: Text(
                                    "#${i+1}",
                                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
                                  ),
                                  title: Text(
                                    switch (snapshot.data!.records[i].gamemode){
                                      "40l" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                      "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                      "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.withModsPlural(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                      String() => "huh",
                                    },
                                  style: const TextStyle(fontSize: 18)),
                                  subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                  trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                )
                                ],
                              );
                            }
                            if (snapshot.hasError){ return FutureError(snapshot); }
                          }
                        return const Text("what?");
                        },
                      ),
                    ]
                  ),
                )
              ],
            ),
          ) 
        ),
      ],
    );
  }

  Widget getRecentTLrecords(BoxConstraints constraints){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.recent, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                ],
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder<TetraLeagueBetaStream>(
            future: teto.fetchTLStream(widget.searchFor),
            builder: (context, snapshot) {
              switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData){
                  return SizedBox(height: constraints.maxHeight - 145, child: TLRecords(userID: widget.searchFor, changePlayer: (){}, data: snapshot.data!.records, wasActiveInTL: snapshot.data!.records.isNotEmpty, oldMathcesHere: false));
                }
                if (snapshot.hasError){ return FutureError(snapshot); }
              }
            return const Text("what?");
            },
          ),
        ),
      ],
    );
  }

  Widget getZenithCard(RecordSingle? record){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.quickPlay, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
                  //Text("Leaderboard reset in ${countdown(postSeasonLeft)}", textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        ZenithThingy(zenith: record),
        if (record != null) Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    FinesseThingy(record.stats.finesse, record.stats.finessePercentage),
                    LineclearsThingy(record.stats.clears, record.stats.lines, record.stats.holds, record.stats.tSpins, showMoreClears: true),
                    if (record.gamemode == 'blitz') Text("${f2.format(record.stats.kpp)} KPP")
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: SizedBox(
                  width: 300,
                  height: 318,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          const Text("T", style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 65,
                            height: 1.2,
                          )),
                          const Positioned(left: 25, top: 20, child: Text("otal time", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(getMoreNormalTime(record.stats.finalTime), style: const TextStyle(
                              shadows: textShadow,
                              fontFamily: "Eurostile Round Extended",
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                            )),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 300.0,
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(36)
                          },
                          children: [
                            const TableRow(
                              children: [
                                Text("Floor"),
                                Text("Split", textAlign: TextAlign.right),
                                Text("Total", textAlign: TextAlign.right),
                              ]
                            ),
                            for (int i = 0; i < record.stats.zenith!.splits.length; i++) TableRow(
                              children: [
                                Text((i+1).toString()),
                                Text(record.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record.stats.zenith!.splits[i]-(i-1 != -1 ? record.stats.zenith!.splits[i-1] : Duration.zero)) : "--:--.---", textAlign: TextAlign.right),
                                Text(record.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record.stats.zenith!.splits[i]) : "--:--.---", textAlign: TextAlign.right),
                              ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (record != null) Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
              const Spacer()
            ],
          ),
        ),
        if (record != null) NerdStatsThingy(nerdStats: record.aggregateStats.nerdStats),
        if (record != null) GraphsThingy(nerdStats: record.aggregateStats.nerdStats, playstyle: record.aggregateStats.playstyle, apm: record.aggregateStats.apm, pps: record.aggregateStats.pps, vs: record.aggregateStats.vs)
      ],
    );
  }

  Widget getRecordCard(RecordSingle? record, bool? betterThanRankAverage, MapEntry? closestAverage, bool? betterThanClosestAverage, String? rank){
    if (record == null) {
      return const Card(
        child: Center(child: Text("No record", style: TextStyle(fontSize: 42))),
      );
    }
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(switch(record.gamemode){
                    "40l" => t.sprint,
                    "blitz" => t.blitz,
                    "5mblast" => "5,000,000 Blast",
                    _ => record.gamemode
                  }, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42))
                ],
              ),
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (closestAverage != null) Padding(padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage.key}.png", height: 96)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    RichText(text: TextSpan(
                        text: switch(record.gamemode){
                          "40l" => get40lTime(record.stats.finalTime.inMicroseconds),
                          "blitz" => NumberFormat.decimalPattern().format(record.stats.score),
                          "5mblast" => get40lTime(record.stats.finalTime.inMicroseconds),
                          _ => record.stats.score.toString()
                        },
                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    RichText(text: TextSpan(
                      text: "",
                      style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                      children: [
                        if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                          "40l" => readableTimeDifference(record.stats.finalTime, sprintAverages[rank]!),
                          "blitz" => readableIntDifference(record.stats.score, blitzAverages[rank]!),
                          _ => record.stats.score.toString()
                        }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank.toUpperCase())}\n", style: TextStyle(
                          color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                        ))
                        else if ((rank == null || rank == "z" || rank == "x+") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record.gamemode){
                          "40l" => readableTimeDifference(record.stats.finalTime, closestAverage.value),
                          "blitz" => readableIntDifference(record.stats.score, closestAverage.value),
                          _ => record.stats.score.toString()
                        }, verdict: betterThanClosestAverage??false ? t.verdictBetter : t.verdictWorse, rank: closestAverage.key.toUpperCase())}\n", style: TextStyle(
                          color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                        )),
                        if (record.rank != -1) TextSpan(text: "№ ${intf.format(record.rank)}", style: TextStyle(color: getColorOfRank(record.rank))),
                        if (record.rank != -1) const TextSpan(text: " • "),
                        if (record.countryRank != -1) TextSpan(text: "№ ${intf.format(record.countryRank)} local", style: TextStyle(color: getColorOfRank(record.countryRank))),
                        if (record.countryRank != -1) const TextSpan(text: " • "),
                        TextSpan(text: timestamp(record.timestamp)),
                      ]
                      ),
                    ),
                  ],
                ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Table(
                      defaultColumnWidth:const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => record.stats.piecesPlaced.toString(),
                            "blitz" => record.stats.level.toString(),
                            "5mblast" => NumberFormat.decimalPattern().format(record.stats.spp),
                            _ => "What if "
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " Pieces",
                            "blitz" => " Level",
                            "5mblast" => " SPP",
                            _ => " i wanted to"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(f2.format(record.stats.pps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" PPS", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => f2.format(record.stats.kpp),
                            "blitz" => f2.format(record.stats.spp),
                            "5mblast" => record.stats.piecesPlaced.toString(),
                            _ => "but god said"
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " KPP",
                            "blitz" => " SPP",
                            "5mblast" => " Pieces",
                            _ => " no"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Table(
                      defaultColumnWidth:const IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          Text(intf.format(record.stats.inputs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" Key presses", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(f2.format(record.stats.kps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          const Text(" KPS", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                        ]),
                        TableRow(children: [
                          Text(switch(record.gamemode){
                            "40l" => " ",
                            "blitz" => record.stats.piecesPlaced.toString(),
                            "5mblast" => record.stats.piecesPlaced.toString(),
                            _ => "but god said"
                          }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                          Text(switch(record.gamemode){
                            "40l" => " ",
                            "blitz" => " Pieces",
                            "5mblast" => " Pieces",
                            _ => " no"
                          }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                        ])
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Card(
          child: Center(
            child: Column(
              children: [
                FinesseThingy(record.stats.finesse, record.stats.finessePercentage),
                LineclearsThingy(record.stats.clears, record.stats.lines, record.stats.holds, record.stats.tSpins),
                if (record.gamemode == 'blitz') Text("${f2.format(record.stats.kpp)} KPP")
              ],
            ),
          ),
        )
      ]
    );
  }

  @override
  initState(){
    modeButtons = {
      Cards.overview: [
        const ButtonSegment<CardMod>(
          value: CardMod.info,
          label: Text('General'),
        ),
      ],
      Cards.tetraLeague: [
        const ButtonSegment<CardMod>(
            value: CardMod.info,
            label: Text('Standing'),
          ),
        const ButtonSegment<CardMod>(
            value: CardMod.ex, // yeah i misusing my own Enum shut the fuck up
            label: Text('Previous Seasons'),
          ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Recent Matches'),
          ),
        ],
      Cards.quickPlay: [
        const ButtonSegment<CardMod>(
            value: CardMod.info,
            label: Text('Normal'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.ex,
            label: Text('Expert'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.exRecords,
            label: Text('Expert Records'),
        )
      ],
      Cards.blitz: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        )
      ],
      Cards.sprint: [
        const ButtonSegment<CardMod>(
              value: CardMod.info,
              label: Text('PB'),
        ),
        const ButtonSegment<CardMod>(
            value: CardMod.records,
            label: Text('Records'),
        )
      ]
    };

    _transition = AnimationController(vsync: this, duration: Durations.long4);

    // _transition.addListener((){
    //   setState(() {
        
    //   });
    // });

    _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _transition,
    curve: Curves.elasticIn,
  ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchResults>(
      future: widget.dataFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          if (snapshot.hasError){ return FutureError(snapshot); }
          if (snapshot.hasData){
            if (!snapshot.data!.success) return FetchResultError(snapshot.data!);
            blitzBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.blitz != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.blitz!.stats.score > blitzAverages[snapshot.data!.summaries!.league.rank]! : null;
            sprintBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.sprint != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.sprint!.stats.finalTime < sprintAverages[snapshot.data!.summaries!.league.rank]! : null;
              if (snapshot.data!.summaries!.sprint != null) {
              closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.sprint!.stats.finalTime).abs() < (b -snapshot.data!.summaries!.sprint!.stats.finalTime).abs() ? a : b));
              sprintBetterThanClosestAverage = snapshot.data!.summaries!.sprint!.stats.finalTime < closestAverageSprint!.value;
            }
            if (snapshot.data!.summaries!.blitz != null){
              closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.blitz!.stats.score).abs() < (b -snapshot.data!.summaries!.blitz!.stats.score).abs() ? a : b));
              blitzBetterThanClosestAverage = snapshot.data!.summaries!.blitz!.stats.score > closestAverageBlitz!.value;
            }
            return TweenAnimationBuilder(
              duration: Durations.long4,
              tween: Tween<double>(begin: 0, end: 1),
              curve: Easing.standard,
              builder: (context, value, child) {
                return Container(
                  transform: Matrix4.translationValues(0, 600-value*600, 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: [
                        NewUserThingy(player: snapshot.data!.player!, showStateTimestamp: false, setState: setState),
                        if (snapshot.data!.player!.badges.isNotEmpty) BadgesThingy(badges: snapshot.data!.player!.badges),
                        if (snapshot.data!.player!.distinguishment != null) DistinguishmentThingy(snapshot.data!.player!.distinguishment!),
                        if (snapshot.data!.player!.role == "bot") FakeDistinguishmentThingy(bot: true, botMaintainers: snapshot.data!.player!.botmaster),
                        if (snapshot.data!.player!.role == "banned") FakeDistinguishmentThingy(banned: true)
                        else if (snapshot.data!.player!.badstanding == true) FakeDistinguishmentThingy(badStanding: true),
                        if (snapshot.data!.player!.bio != null) Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Spacer(), 
                                  Text(t.bio, style: const TextStyle(fontFamily: "Eurostile Round Extended")),
                                  const Spacer()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: MarkdownBody(data: snapshot.data!.player!.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center)),
                              )
                            ],
                          ),
                        ),
                          //if (testNews != null && testNews!.news.isNotEmpty)
                        Expanded(
                          child: FutureBuilder<News>(
                            future: widget.newsFuture,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return const Card(child: Center(child: CircularProgressIndicator()));
                                case ConnectionState.done:
                                  if (snapshot.hasData){
                                    return NewsThingy(snapshot.data!);
                                  }else if (snapshot.hasError){ return FutureError(snapshot); }
                              }
                              return const Text("what?");
                            }
                          ),
                        )
                        ],
                      ),
                  ),
                  SizedBox(
                    width: widget.constraints.maxWidth - 450 - 80,
                    child: Column(
                      children: [
                        SizedBox(
                          height: rightCard != Cards.overview ? widget.constraints.maxHeight - 64 : widget.constraints.maxHeight - 32,
                          child: SingleChildScrollView(
                            child: SlideTransition(
                              position: _offsetAnimation,
                              child: switch (rightCard){
                                Cards.overview => getOverviewCard(snapshot.data!.summaries!),
                                Cards.tetraLeague => switch (cardMod){
                                  CardMod.info => getTetraLeagueCard(snapshot.data!.summaries!.league, snapshot.data!.cutoffs, snapshot.data!.states),
                                  CardMod.ex => getPreviousSeasonsList(snapshot.data!.summaries!.pastLeague),
                                  CardMod.records => getRecentTLrecords(widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                                Cards.quickPlay => switch (cardMod){
                                  CardMod.info => getZenithCard(snapshot.data?.summaries!.zenith),
                                  CardMod.records => getListOfRecords("zenith/recent", "zenith/top", widget.constraints),
                                  CardMod.ex => getZenithCard(snapshot.data?.summaries!.zenithEx),
                                  CardMod.exRecords => getListOfRecords("zenithex/recent", "zenithex/top", widget.constraints),
                                },
                                Cards.sprint => switch (cardMod){
                                  CardMod.info => getRecordCard(snapshot.data?.summaries!.sprint, sprintBetterThanRankAverage, closestAverageSprint, sprintBetterThanClosestAverage, snapshot.data!.summaries!.league.rank),
                                  CardMod.records => getListOfRecords("40l/recent", "40l/top", widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                                Cards.blitz => switch (cardMod){
                                  CardMod.info => getRecordCard(snapshot.data?.summaries!.blitz, blitzBetterThanRankAverage, closestAverageBlitz, blitzBetterThanClosestAverage, snapshot.data!.summaries!.league.rank),
                                  CardMod.records => getListOfRecords("blitz/recent", "blitz/top", widget.constraints),
                                  _ => const Center(child: Text("huh?"))
                                },
                              },
                            ),
                          ),
                        ),
                        if (modeButtons[rightCard]!.length > 1) SegmentedButton<CardMod>(
                          showSelectedIcon: false,
                          selected: <CardMod>{cardMod},
                          segments: modeButtons[rightCard]!,
                          onSelectionChanged: (p0) {
                            setState(() {
                              cardMod = p0.first;
                              //_transition.;
                            });
                          },
                        ),
                        SegmentedButton<Cards>(
                          showSelectedIcon: false,
                          segments: <ButtonSegment<Cards>>[
                            const ButtonSegment<Cards>(
                                value: Cards.overview,
                                //label: Text('Overview'),
                                icon: Icon(Icons.calendar_view_day)),
                            ButtonSegment<Cards>(
                                value: Cards.tetraLeague,
                                //label: Text('Tetra League'),
                                icon: SvgPicture.asset("res/icons/league.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.quickPlay,
                                //label: Text('Quick Play'),
                                icon: SvgPicture.asset("res/icons/qp.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.sprint,
                                //label: Text('40 Lines'),
                                icon: SvgPicture.asset("res/icons/40l.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.blitz,
                                //label: Text('Blitz'),
                                icon: SvgPicture.asset("res/icons/blitz.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                          ],
                          selected: <Cards>{rightCard},
                          onSelectionChanged: (Set<Cards> newSelection) {
                            setState(() {
                              cardMod = CardMod.info;
                              rightCard = newSelection.first;
                            });})
                      ],
                    )
                  )
                ],
              ),
            );
          }
        }
        return const Text("End of FutureBuilder<FetchResults>");
      },
    );
  }
}
