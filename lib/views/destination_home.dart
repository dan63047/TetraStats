import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/achievement.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/news.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/singleplayer_stream.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/widgets/badges_thingy.dart';
import 'package:tetra_stats/widgets/distinguishment_thingy.dart';
import 'package:tetra_stats/widgets/error_thingy.dart';
import 'package:tetra_stats/widgets/fake_distinguishment_thingy.dart';
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/nerd_stats_thingy.dart';
import 'package:tetra_stats/widgets/news_thingy.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/tl_rating_thingy.dart';
import 'package:tetra_stats/widgets/tl_records_thingy.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';
import 'package:tetra_stats/widgets/zenith_thingy.dart';

class DestinationHome extends StatefulWidget{
  final String searchFor;
  final Future<FetchResults> dataFuture;
  final BoxConstraints constraints;
  final bool noSidebar;

  const DestinationHome({super.key, required this.searchFor, required this.dataFuture, required this.constraints, this.noSidebar = false});

  @override
  State<DestinationHome> createState() => _DestinationHomeState();
}

Cards rightCard = Cards.overview;
CardMod cardMod = CardMod.info;
Map<Cards, List<ButtonSegment<CardMod>>> modeButtons = {
  Cards.overview: [
    ButtonSegment<CardMod>(
      value: CardMod.info,
      label: Text(t.general),
    ),
  ],
  Cards.tetraLeague: [
    ButtonSegment<CardMod>(
        value: CardMod.info,
        label: Text(t.homeNavigation.standing),
      ),
    ButtonSegment<CardMod>(
        value: CardMod.ex, // yeah i misusing my own Enum shut the fuck up
        label: Text(t.homeNavigation.seasons),
      ),
    ButtonSegment<CardMod>(
        value: CardMod.records,
        label: Text(t.homeNavigation.mathces),
      ),
    ],
  Cards.quickPlay: [
    ButtonSegment<CardMod>(
        value: CardMod.info,
        label: Text(t.homeNavigation.normal),
    ),
    ButtonSegment<CardMod>(
        value: CardMod.records,
        label: Text(t.records),
    ),
    ButtonSegment<CardMod>(
        value: CardMod.ex,
        label: Text(t.homeNavigation.expert),
    ),
    ButtonSegment<CardMod>(
        value: CardMod.exRecords,
        label: Text(t.homeNavigation.expertRecords),
    )
  ],
  Cards.blitz: [
    ButtonSegment<CardMod>(
          value: CardMod.info,
          label: Text(t.homeNavigation.pb),
    ),
    ButtonSegment<CardMod>(
        value: CardMod.records,
        label: Text(t.recent),
    )
  ],
  Cards.sprint: [
    ButtonSegment<CardMod>(
          value: CardMod.info,
          label: Text(t.homeNavigation.pb),
    ),
    ButtonSegment<CardMod>(
        value: CardMod.records,
        label: Text(t.recent),
    )
  ]
};

class ZenithCard extends StatelessWidget {
  final RecordSingle? record;
  final bool old;
  final double width;
  final List<Achievement> achievements;

  const ZenithCard(this.record, this.old, this.achievements, {this.width = double.infinity});

  Widget splitsCard(){
    return Card(
      child: Center(
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
                  Positioned(left: 25, top: 20, child: Text(t.stats.totalTime.widgetTitle, style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(getMoreNormalTime(record!.stats.finalTime), style: const TextStyle(
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
                    TableRow(
                      children: [
                        Text(t.stats.floor),
                        Text(t.stats.split, textAlign: TextAlign.right),
                        Text(t.stats.total, textAlign: TextAlign.right),
                      ]
                    ),
                    for (int i = 0; i < record!.stats.zenith!.splits.length; i++) TableRow(
                      children: [
                        Text((i+1).toString()),
                        Text(record!.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record!.stats.zenith!.splits[i]-(i-1 != -1 ? record!.stats.zenith!.splits[i-1] : Duration.zero)) : "--:--.---", textAlign: TextAlign.right),
                        Text(record!.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record!.stats.zenith!.splits[i]) : "--:--.---", textAlign: TextAlign.right),
                      ]
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(t.gamemodes["zenith"]!, style: Theme.of(context).textTheme.titleLarge),
                  //Text("Leaderboard reset in ${countdown(postSeasonLeft)}", textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        ZenithThingy(zenith: record, old: old, width: width),
        if (record != null) width > 600 ? Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    FinesseThingy(record!.stats.finesse, record!.stats.finessePercentage),
                    LineclearsThingy(record!.stats.clears, record!.stats.lines, record!.stats.holds, record!.stats.tSpins, showMoreClears: true)
                  ],
                ),
              ),
            ),
            Expanded(
              child: splitsCard()
            ),
          ],
        ) : Column(
          children: [
            Card(
              child: Center(
                child: Column(
                  children: [
                    FinesseThingy(record!.stats.finesse, record!.stats.finessePercentage),
                    LineclearsThingy(record!.stats.clears, record!.stats.lines, record!.stats.holds, record!.stats.tSpins, showMoreClears: true)
                  ],
                ),
              ),
            ),
            splitsCard(),
          ],
        ),
        if (record != null) Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: Theme.of(context).textTheme.titleLarge),
              const Spacer()
            ],
          ),
        ),
        if (record != null) NerdStatsThingy(nerdStats: record!.aggregateStats.nerdStats, width: width),
        if (record != null) Graphs(record!.aggregateStats.apm, record!.aggregateStats.pps, record!.aggregateStats.vs, record!.aggregateStats.nerdStats, record!.aggregateStats.playstyle),
        if (achievements.isNotEmpty) Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.relatedAchievements, style: Theme.of(context).textTheme.titleLarge),
              const Spacer()
            ],
          ),
        ),
        if (achievements.isNotEmpty) Wrap(
          direction: Axis.horizontal,
          children: [
            for (Achievement achievement in achievements) FractionallySizedBox(widthFactor: 1/((width/600).ceil()), child: AchievementSummary(achievement: achievement)),
          ],
        ),
      ],
    );
  }
}

class RecordCard extends StatelessWidget {
  final RecordSingle? record;
  final List<Achievement> achievements;
  final bool? betterThanRankAverage;
  final MapEntry? closestAverage;
  final bool? betterThanClosestAverage;
  final String? rank;
  final double width;

  const RecordCard(this.record, this.achievements, this.betterThanRankAverage, this.closestAverage, this.betterThanClosestAverage, this.rank, {this.width = double.infinity});
  
  Widget result(){
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (closestAverage != null) Padding(padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage!.key}.png", height: 96)
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                RichText(text: TextSpan(
                    text: switch(record!.gamemode){
                      "40l" => get40lTime(record!.stats.finalTime.inMicroseconds),
                      "blitz" => NumberFormat.decimalPattern().format(record!.stats.score),
                      "5mblast" => get40lTime(record!.stats.finalTime.inMicroseconds),
                      _ => record!.stats.score.toString()
                    },
                    style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                RichText(text: TextSpan(
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
                    else if ((rank == null || rank == "z" || rank == "x+") && closestAverage != null) TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                      "40l" => readableTimeDifference(record!.stats.finalTime, closestAverage!.value),
                      "blitz" => readableIntDifference(record!.stats.score, closestAverage!.value),
                      _ => record!.stats.score.toString()
                    }, verdict: betterThanClosestAverage??false ? t.verdictBetter : t.verdictWorse, rank: closestAverage!.key.toUpperCase())}\n", style: TextStyle(
                      color: betterThanClosestAverage??false ? Colors.greenAccent : Colors.redAccent
                    )),
                    if (record!.rank != -1) TextSpan(text: "№ ${intf.format(record!.rank)}", style: TextStyle(color: getColorOfRank(record!.rank))),
                    if (record!.rank != -1) const TextSpan(text: " • "),
                    if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} ${t.localStanding}", style: TextStyle(color: getColorOfRank(record!.countryRank))),
                    if (record!.countryRank != -1) const TextSpan(text: " • "),
                    TextSpan(text: timestamp(record!.timestamp)),
                  ]
                  ),
                ),
              ],
            ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Table(
                  defaultColumnWidth:const IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      Text(switch(record!.gamemode){
                        "40l" => record!.stats.piecesPlaced.toString(),
                        "blitz" => record!.stats.level.toString(),
                        "5mblast" => NumberFormat.decimalPattern().format(record!.stats.spp),
                        _ => "What if "
                      }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(switch(record!.gamemode){
                        "40l" => " ${t.stats.pieces.full}",
                        "blitz" => " ${t.stats.level.full}",
                        "5mblast" => " ${t.stats.spp.short}",
                        _ => " i wanted to"
                      }, textAlign: TextAlign.left, style: const TextStyle(fontSize: 21)),
                    ]),
                    TableRow(children: [
                      Text(f2.format(record!.stats.pps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(" ${t.stats.pps.short}", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                    ]),
                    TableRow(children: [
                      Text(switch(record!.gamemode){
                        "40l" => f2.format(record!.stats.kpp),
                        "blitz" => f2.format(record!.stats.spp),
                        "5mblast" => record!.stats.piecesPlaced.toString(),
                        _ => "but god said"
                      }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(switch(record!.gamemode){
                        "40l" => " ${t.stats.kpp.short}",
                        "blitz" => " ${t.stats.spp.short}",
                        "5mblast" => " ${t.stats.pieces.short}",
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
                      Text(intf.format(record!.stats.inputs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(" ${t.stats.kp.short}", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                    ]),
                    TableRow(children: [
                      Text(f2.format(record!.stats.kps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(" ${t.stats.kps.short}", textAlign: TextAlign.left, style: TextStyle(fontSize: 21)),
                    ]),
                    TableRow(children: [
                      Text(switch(record!.gamemode){
                        "40l" => " ",
                        "blitz" => record!.stats.piecesPlaced.toString(),
                        "5mblast" => record!.stats.piecesPlaced.toString(),
                        _ => "but god said"
                      }, textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                      Text(switch(record!.gamemode){
                        "40l" => " ",
                        "blitz" => " ${t.stats.pieces.short}",
                        "5mblast" => " ${t.stats.pieces.short}",
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
    );
  }

  Widget hjsdj(){
    return Card(
      child: Center(
        child: Column(
          children: [
            FinesseThingy(record!.stats.finesse, record!.stats.finessePercentage),
            LineclearsThingy(record!.stats.clears, record!.stats.lines, record!.stats.holds, record!.stats.tSpins),
            if (record!.gamemode == 'blitz') Text("${f2.format(record!.stats.kpp)} ${t.stats.kpp.short}")
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      return Card(
        child: Center(child: Text(t.noRecord, style: TextStyle(fontSize: 42))),
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
                  Text(switch(record!.gamemode){
                    "40l" => t.gamemodes["40l"]!,
                    "blitz" => t.gamemodes["blitz"]!,
                    "5mblast" => t.gamemodes["5mblast"]!,
                    _ => record!.gamemode
                  }, style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [result(), hjsdj()],
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            for (Achievement achievement in achievements) FractionallySizedBox(widthFactor: 1/((width/600).ceil()), child: AchievementSummary(achievement: achievement)),
          ],
        ),
      ]
    );
  }
}

class FetchResults{
  bool success;
  TetrioPlayer? player;
  List<TetraLeague> states;
  Summaries? summaries;
  News? news;
  Cutoffs? cutoffs;
  CutoffsTetrio? averages;
  PlayerLeaderboardPosition? playerPos;
  bool isTracked;
  Exception? exception;

  FetchResults(this.success, this.player, this.states, this.summaries, this.news, this.cutoffs, this.averages, this.playerPos, this.isTracked, this.exception);
}

class RecordSummary extends StatelessWidget{
  final RecordSingle? record;
  final bool hideRank;
  final bool old;
  final bool? betterThanRankAverage;
  final MapEntry? closestAverage;
  final bool? betterThanClosestAverage;
  final String? rank;
  final double width;

  const RecordSummary({super.key, required this.record, this.betterThanRankAverage, this.closestAverage, this.old = false, this.betterThanClosestAverage, this.rank, this.hideRank = false, this.width = double.infinity});
  
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
              style: TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: old ? Colors.grey : Colors.white, height: 0.9),
              ),
            ),
          RichText(
            textAlign: hideRank ? TextAlign.center : TextAlign.start,
            text: TextSpan(
            style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
            children: [
              if (rank != null && rank != "z") TextSpan(text: "${t.verdictGeneral(n: switch(record!.gamemode){
                "40l" => readableTimeDifference(record!.stats.finalTime, sprintAverages[rank]!),
                "blitz" => readableIntDifference(record!.stats.score, blitzAverages[rank]!),
                _ => record!.stats.score.toString()
              }, verdict: betterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                color: betterThanRankAverage??false ? Colors.greenAccent : Colors.redAccent
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
              if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} ${t.localStanding}", style: TextStyle(color: getColorOfRank(record!.countryRank))),
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

class AchievementSummary extends StatelessWidget{
  final Achievement? achievement;

  const AchievementSummary({this.achievement});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(achievement?.name??"---", style: Theme.of(context).textTheme.titleSmall!.copyWith(color: achievement?.v == null ? Colors.grey : Colors.white), textAlign: TextAlign.center),
            const Divider(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 512.0,
                      maxHeight: 512.0,
                      //minWidth: 256,
                      minHeight: 64.0,
                    ),
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft.add(Alignment(0.286 * (((achievement?.k??1) - 1) % 8), 0.286 * (((achievement?.k??0) - 1) / 8).floor())),
                        heightFactor: 0.125,
                        widthFactor: 0.125,
                        child: Image.asset("res/icons/achievements.png", width: 2048, height: 2048, scale: 1, color: achievement?.v == null ? Colors.grey : achievementColors[min(achievement!.rank!, 6)]),
                      ),
                    ),
                  ),
                ),
                //ClipRect(clipper: Rect.fromLTRB(0, 0, 64, 64), child: ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: achievement?.v == null ? "---" : switch(achievement!.vt){
                            1 => intf.format(achievement!.v),
                            2 => get40lTime((achievement!.v! * 1000).floor()),
                            3 => get40lTime((achievement!.v!.abs() * 1000).floor()),
                            4 => "${f2.format(achievement!.v!)} m",
                            5 => "№ ${intf.format(achievement!.pos!+1)}",
                            6 => intf.format(achievement!.v!.abs()),
                            _ => "lol"
                          },
                          style: TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: achievement?.v == null ? Colors.grey : Colors.white, height: 0.9),
                          ),
                        ),
                      if (achievement != null) RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                        style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                        children: [
                          if (achievement!.object.isNotEmpty) TextSpan(text: "${achievement!.object}\n"),
                          if (achievement!.vt == 4) TextSpan(text: "${t.stats.floor} ${achievement?.a != null ? achievement!.a! : "-"}"),
                          if (achievement!.vt == 4) TextSpan(text: " • "),
                          if (achievement!.vt != 5) TextSpan(text: (achievement?.pos != null && !achievement!.pos!.isNegative) ? "№ ${intf.format(achievement!.pos!+1)}" : "№ ---", style: TextStyle(color: achievement?.pos != null ? getColorOfRank(achievement!.pos!+1) : Colors.grey)),
                          if (achievement!.vt != 5) TextSpan(text: " • ", style: TextStyle(color: achievement?.pos != null ? getColorOfRank(achievement!.pos!+1) : Colors.grey)),
                          TextSpan(text: t.stats.top(percentage: achievement?.pos != null ? percentagef4.format(achievement!.pos! / achievement!.total!) : "---"), style: TextStyle(color: achievement?.pos != null ? getColorOfRank(achievement!.pos!+1) : Colors.grey)),
                        ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(achievement?.t != null ? timestamp(achievement!.t!) : "---", style: const TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
  
}

class LeagueCard extends StatelessWidget{
  final TetraLeague league;
  final CutoffTetrio? averages;
  final bool showSeasonNumber;
  final double width;

  const LeagueCard({super.key, required this.league, this.averages, this.showSeasonNumber = false, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showSeasonNumber) width > 600.0 ? Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("${t.season} ${league.season}", style: Theme.of(context).textTheme.titleSmall),
                  Spacer(),
                  Text(
                    "${seasonStarts.elementAtOrNull(league.season - 1) != null ? timestamp(seasonStarts[league.season - 1]) : "---"} — ${seasonEnds.elementAtOrNull(league.season - 1) != null ? timestamp(seasonEnds[league.season - 1]) : "---"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                ],
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${t.season} ${league.season}", style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    "${seasonStarts.elementAtOrNull(league.season - 1) != null ? timestamp(seasonStarts[league.season - 1]) : "---"} — ${seasonEnds.elementAtOrNull(league.season - 1) != null ? timestamp(seasonEnds[league.season - 1]) : "---"}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                ],
              )
              else Text(t.gamemodes["league"]!, style: Theme.of(context).textTheme.titleSmall),
              const Divider(),
              TLRatingThingy(userID: league.id, tlData: league, showPositions: true),
              const Divider(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                style: const TextStyle(fontFamily: "Eurostile Round", color: Colors.grey),
                children: [
                  TextSpan(text: "${league.apm != null ? f2.format(league.apm) : "-.--"} ${t.stats.apm.short}", style: TextStyle(color: league.apm != null ? getStatColor(league.apm!, averages?.apm, true) : null)),
                  TextSpan(text: " • "),
                  TextSpan(text: "${league.pps != null ? f2.format(league.pps) : "-.--"} ${t.stats.pps.short}", style: TextStyle(color: league.pps != null ? getStatColor(league.pps!, averages?.pps, true) : null)),
                  TextSpan(text: " • "),
                  TextSpan(text: "${league.vs != null ? f2.format(league.vs) : "-.--"} ${t.stats.vs.short}", style: TextStyle(color: league.vs != null ? getStatColor(league.vs!, averages?.vs, true) : null)),
                  TextSpan(text: " • "),
                  TextSpan(text: "${league.nerdStats != null ? f2.format(league.nerdStats!.app) : "-.--"} ${t.stats.app.short}", style: TextStyle(color: league.nerdStats != null ? getStatColor(league.nerdStats!.app, averages?.nerdStats?.app, true) : null)),
                  TextSpan(text: " • "),
                  TextSpan(text: "${league.nerdStats != null ? f2.format(league.nerdStats!.vsapm) : "-.--"} ${t.stats.vsapm.short}", style: TextStyle(color: league.nerdStats != null ? getStatColor(league.nerdStats!.vsapm, averages?.nerdStats?.vsapm, true) : null)),
                ]
              )),
            ],
          ),
        ),
      ),
    );
  }

}

class _DestinationHomeState extends State<DestinationHome> with SingleTickerProviderStateMixin {
  //Duration postSeasonLeft = seasonStart.difference(DateTime.now());
  late MapEntry? closestAverageBlitz;
  late bool blitzBetterThanClosestAverage;
  late MapEntry? closestAverageSprint;
  late bool sprintBetterThanClosestAverage;
  late AnimationController _transition;
  late final Animation<Offset> _offsetAnimation;
  bool? sprintBetterThanRankAverage;
  bool? blitzBetterThanRankAverage;

  Widget getOverviewCard(Summaries summaries, CutoffTetrio? averages, double width){
    return LayoutGrid(
        areas: width > 600 ? '''
          h h
          t t
          1 2
          3 4
          5 6
        ''' : '''
          t
          1
          2
          3
          4
          5
          6
        ''',
        columnSizes: width > 600 ? [auto, auto] : [auto],
        rowSizes: width > 600 ? [auto, auto, auto, auto, auto] : [auto, auto, auto, auto, auto, auto, auto],
        columnGap: 0,
        rowGap: 0,
        children: [
          if (width > 600) Card(
            child: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(t.homeNavigation.overview, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ).inGridArea('h'),
          LeagueCard(league: summaries.league, averages: averages).inGridArea('t'),
          Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(t.gamemodes['40l']!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                    const Divider(),
                    RecordSummary(record: summaries.sprint, betterThanClosestAverage: sprintBetterThanClosestAverage, betterThanRankAverage: sprintBetterThanRankAverage, closestAverage: closestAverageSprint, rank: summaries.league.percentileRank),
                    const Divider(),
                    Text("${summaries.sprint != null ? intf.format(summaries.sprint!.stats.piecesPlaced) : "---"} P • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.pps) : "-.--"} PPS • ${summaries.sprint != null ? f2.format(summaries.sprint!.stats.kpp) : "-.--"} KPP", style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center)
                  ],
                ),
              ),
            ).inGridArea('1'),
          Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(t.gamemodes['blitz']!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                    const Divider(),
                    RecordSummary(record: summaries.blitz, betterThanClosestAverage: blitzBetterThanClosestAverage, betterThanRankAverage: blitzBetterThanRankAverage, closestAverage: closestAverageBlitz, rank: summaries.league.percentileRank),
                    const Divider(),
                    Text("Level ${summaries.blitz != null ? intf.format(summaries.blitz!.stats.level): "--"} • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.spp) : "-.--"} SPP • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.pps) : "-.--"} PPS", style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ).inGridArea('2'),
          Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(t.gamemodes['zenith']!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                    const Divider(),
                    RecordSummary(record: summaries.zenith != null ? summaries.zenith : summaries.zenithCareerBest, hideRank: true, old: summaries.zenith == null),
                    const Divider(),
                    Text(t.overallPB(pb: (summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 18).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 18).v!) : "-.--"), style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ).inGridArea('3'),
          Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(t.gamemodes['zenithex']!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                    const Divider(),
                    RecordSummary(record: summaries.zenithEx != null ? summaries.zenithEx : summaries.zenithExCareerBest, hideRank: true, old: summaries.zenith == null),
                    const Divider(),
                    Text(t.overallPB(pb: (summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 19).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 19).v!) : "-.--"), style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ).inGridArea('4'),
          Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text(t.gamemodes['zen']!, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center)),
                    Text("${t.stats.level.full} ${intf.format(summaries.zen.level)}", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white)),
                    Text("${t.stats.score} ${intf.format(summaries.zen.score)}"),
                    Text(t.stats.levelUpRequirement(p: intf.format(summaries.zen.scoreRequirement)), style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ).inGridArea('5'),
          Card(
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
                      Positioned(left: 25, top: 20, child: Text(t.stats.finesse.widgetTitle, style: TextStyle(fontFamily: "Eurostile Round Extended"))),
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
                        Text("${t.stats.piecesTotal}:"),
                        const Spacer(),
                        Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 1).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 1).v!) : "---"),
                      ],
                    ),
                    Row(
                      children: [
                        Text(" - ${t.stats.piecesWithPerfectFinesse}:"),
                        const Spacer(),
                        Text((summaries.achievements.isNotEmpty && summaries.achievements.firstWhere((e) => e.k == 4).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 4).v!) : "---"),
                      ],
                    )
                  ],
                ),
              ),
            ).inGridArea('6'),
        ],
      );
  }

  Widget getTetraLeagueCard(TetraLeague data, Cutoffs? cutoffs, CutoffTetrio? averages, List<TetraLeague> states, PlayerLeaderboardPosition? lbPos, double width, List<Achievement> achievements){
    TetraLeague toSee;
    TetraLeague? toCompare;
    if (currentRangeValues.start.round() == 0){
      toSee = data;
    }else{
      toSee = states[currentRangeValues.start.round()-1];
    }
    if (currentRangeValues.end.round() == 1){
      toCompare = states.length >= 2 ? states.elementAtOrNull(2) : null;
    }else{
      toCompare = states[currentRangeValues.end.round()-1];
    }
    return Column(
      children: [
        if (toCompare != null) Card(
          child: RangeSlider(values: currentRangeValues, max: states.length.toDouble(),
            labels: RangeLabels(
                currentRangeValues.start.round().toString(),
                currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  currentRangeValues = values;
                });
              },
            ),
        ),
        Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.gamemodes["league"]!, style: Theme.of(context).textTheme.titleLarge),
                  if (toCompare != null) Text(t.comparingWith(newDate: timestamp(toSee.timestamp), oldDate: timestamp(toCompare.timestamp)), textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        TetraLeagueThingy(league: toSee, toCompare: toCompare, cutoffs: cutoffs, averages: averages, lbPos: lbPos, width: width),
        // Center(
        //   child: Card(
        //     child: ElevatedButton.icon(
        //       onPressed: (){teto.fetchAndsaveTLHistory(data.id, 1).then((_) => setState((){}));},
        //       icon: const Icon(Icons.query_stats),
        //       label: Text(t.graphsDestination.fetchAndsaveTLHistory),
        //       style: const ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))))
        //     )
        //   ),
        // ),
        if (data.nerdStats != null) Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.nerdStats, style: Theme.of(context).textTheme.titleLarge),
              const Spacer()
            ],
          ),
        ),
        if (data.nerdStats != null) NerdStatsThingy(nerdStats: toSee.nerdStats!, oldNerdStats: toCompare?.nerdStats, averages: averages, lbPos: lbPos, width: width),
        if (data.nerdStats != null) Graphs(toSee.apm!, toSee.pps!, toSee.vs!, toSee.nerdStats!, toSee.playstyle!),
        Card(
          //surfaceTintColor: rankColors[data.rank],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(t.relatedAchievements, style: Theme.of(context).textTheme.titleLarge),
              const Spacer()
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            for (Achievement achievement in achievements) FractionallySizedBox(widthFactor: 1/((width/600).ceil()), child: AchievementSummary(achievement: achievement)),
          ],
        ),
      ],
    );
  }

  Widget getPreviousSeasonsList(Map<int, TetraLeague> pastLeague, double width){
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
                  Text(t.previousSeasons, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                  //Text("${t.seasonStarts} ${countdown(postSeasonLeft)}", textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
        for (var key in pastLeague.keys) Card(
          child: LeagueCard(league: pastLeague[key]!, showSeasonNumber: true, width: width),
        )
      ],
    );
  }

  Widget getListOfRecords(String recentStream, String topStream, BoxConstraints constraints){
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.records, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 42)),
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
                TabBar(
                  tabs: [
                    Tab(text: t.recent),
                    Tab(text: t.top),
                  ],
                ),
                SizedBox(
                  height: constraints.maxHeight - 192,
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
                              return SingleChildScrollView(
                                child: Column(
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
                                        "blitz" => t.stats.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                        "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                        "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.stats.qpWithMods(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                        "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.stats.qpWithMods(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                        String() => "huh",
                                      },
                                    style: Theme.of(context).textTheme.displayLarge),
                                    subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                    trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                  )
                                  ],
                                ),
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
                              return SingleChildScrollView(
                                child: Column(
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
                                        "blitz" => t.stats.blitzScore(p: NumberFormat.decimalPattern().format(snapshot.data!.records[i].stats.score)),
                                        "5mblast" => get40lTime(snapshot.data!.records[i].stats.finalTime.inMicroseconds),
                                        "zenith" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.stats.qpWithMods(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                        "zenithex" => "${f2.format(snapshot.data!.records[i].stats.zenith!.altitude)} m${(snapshot.data!.records[i].extras as ZenithExtras).mods.isNotEmpty ? " (${t.stats.qpWithMods(n: (snapshot.data!.records[i].extras as ZenithExtras).mods.length)})" : ""}",
                                        String() => "huh",
                                      },
                                    style: Theme.of(context).textTheme.displayLarge),
                                    subtitle: Text(timestamp(snapshot.data!.records[i].timestamp), style: const TextStyle(color: Colors.grey, height: 0.85)),
                                    trailing: SpTrailingStats(snapshot.data!.records[i], snapshot.data!.records[i].gamemode)
                                  )
                                  ],
                                ),
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

  Widget getRecentTLrecords(BoxConstraints constraints, String userID){
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
                  Text(t.recent, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
        ),
        TLRecords(userID),
      ],
    );
  }

  @override
  initState(){
    _transition = AnimationController(vsync: this, duration: Durations.long4);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _transition,
      curve: Curves.elasticIn,
    ));

    super.initState();
  }

  Widget rigthCard(AsyncSnapshot<FetchResults> snapshot, List<Achievement> sprintAchievements, List<Achievement> blitzAchievements, List<Achievement> tlAchievements, List<Achievement> qpAchievements, List<Achievement> qpExAchievements, double width){
    return switch (rightCard){
      Cards.overview => getOverviewCard(snapshot.data!.summaries!, (snapshot.data!.averages != null && snapshot.data!.summaries!.league.rank != "z") ? snapshot.data!.averages!.data[snapshot.data!.summaries!.league.rank] : (snapshot.data!.averages != null && snapshot.data!.summaries!.league.percentileRank != "z") ? snapshot.data!.averages!.data[snapshot.data!.summaries!.league.percentileRank] : null, width),
      Cards.tetraLeague => switch (cardMod){
        CardMod.info => getTetraLeagueCard(snapshot.data!.summaries!.league, snapshot.data!.cutoffs, (snapshot.data!.averages != null && snapshot.data!.summaries!.league.rank != "z") ? snapshot.data!.averages!.data[snapshot.data!.summaries!.league.rank] : (snapshot.data!.averages != null && snapshot.data!.summaries!.league.percentileRank != "z") ? snapshot.data!.averages!.data[snapshot.data!.summaries!.league.percentileRank] : null, snapshot.data!.states, snapshot.data!.playerPos, width, tlAchievements),
        CardMod.ex => getPreviousSeasonsList(snapshot.data!.summaries!.pastLeague, width),
        CardMod.records => getRecentTLrecords(widget.constraints, snapshot.data!.player!.userId),
        _ => const Center(child: Text("huh?"))
      },
      Cards.quickPlay => switch (cardMod){
        CardMod.info => ZenithCard(snapshot.data?.summaries?.zenith != null ? snapshot.data!.summaries!.zenith : snapshot.data!.summaries?.zenithCareerBest, snapshot.data!.summaries?.zenith == null, qpAchievements, width: width),
        CardMod.records => getListOfRecords("zenith/recent", "zenith/top", widget.constraints),
        CardMod.ex => ZenithCard(snapshot.data?.summaries?.zenithEx != null ? snapshot.data!.summaries!.zenithEx : snapshot.data!.summaries?.zenithExCareerBest, snapshot.data!.summaries?.zenithEx == null, qpExAchievements, width: width),
        CardMod.exRecords => getListOfRecords("zenithex/recent", "zenithex/top", widget.constraints),
      },
      Cards.sprint => switch (cardMod){
        CardMod.info => RecordCard(snapshot.data?.summaries!.sprint, sprintAchievements, sprintBetterThanRankAverage, closestAverageSprint, sprintBetterThanClosestAverage, snapshot.data!.summaries!.league.rank, width: width),
        CardMod.records => getListOfRecords("40l/recent", "40l/top", widget.constraints),
        _ => const Center(child: Text("huh?"))
      },
      Cards.blitz => switch (cardMod){
        CardMod.info => RecordCard(snapshot.data?.summaries!.blitz, blitzAchievements, blitzBetterThanRankAverage, closestAverageBlitz, blitzBetterThanClosestAverage, snapshot.data!.summaries!.league.rank, width: width),
        CardMod.records => getListOfRecords("blitz/recent", "blitz/top", widget.constraints),
        _ => const Center(child: Text("huh?"))
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.noSidebar ? widget.constraints.maxWidth : widget.constraints.maxWidth - 80;
    bool screenIsBig = width >= 768;
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
            if (!snapshot.data!.success) return ErrorThingy(data: snapshot.data!);
            blitzBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.blitz != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.blitz!.stats.score > blitzAverages[snapshot.data!.summaries!.league.rank]! : null;
            sprintBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.sprint != null && snapshot.data!.summaries!.league.rank != "x+") ? snapshot.data!.summaries!.sprint!.stats.finalTime < sprintAverages[snapshot.data!.summaries!.league.rank]! : null;
              if (snapshot.data!.summaries!.sprint != null) {
              closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.sprint!.stats.finalTime).abs() < (b -snapshot.data!.summaries!.sprint!.stats.finalTime).abs() ? a : b));
              sprintBetterThanClosestAverage = snapshot.data!.summaries!.sprint!.stats.finalTime < closestAverageSprint!.value;
            } else {
              closestAverageSprint = sprintAverages.entries.last;
              sprintBetterThanClosestAverage = false;
            }
            if (snapshot.data!.summaries!.blitz != null){
              closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-snapshot.data!.summaries!.blitz!.stats.score).abs() < (b -snapshot.data!.summaries!.blitz!.stats.score).abs() ? a : b));
              blitzBetterThanClosestAverage = snapshot.data!.summaries!.blitz!.stats.score > closestAverageBlitz!.value;
            } else {
              closestAverageBlitz = blitzAverages.entries.last;
              blitzBetterThanClosestAverage = false;
            }
            List<Achievement> tlAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? <Achievement>[
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 10),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 12),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 13),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 14),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 15),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 47),
            ] : [];
            List<Achievement> qpAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? <Achievement>[
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 16),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 17),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 18),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 20),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 21),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 22),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 23),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 24),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 25),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 26),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 27),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 28),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 29),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 30),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 33),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 41),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 43),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 44),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 45),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 46),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 51),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 54),
            ] : [];
            List<Achievement> qpExAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? <Achievement>[
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 19),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 31),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 32),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 34),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 40),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 49),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 50),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 53),
            ] : [];
            List<Achievement> sprintAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? <Achievement>[
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 5),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 7),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 8),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 9),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 36),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 37),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 38),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 48),
            ] : [];
            List<Achievement> blitzAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? <Achievement>[
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 6),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 39),
              snapshot.data!.summaries!.achievements.firstWhere((e) => e.k == 52),
            ] : [];
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
              child: screenIsBig ? Row(
                children: [
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: [
                        UserThingy(player: snapshot.data!.player!, initIsTracking: snapshot.data!.isTracked, showStateTimestamp: false, setState: setState),
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
                        Expanded(
                          child: NewsThingy(snapshot.data!.news!)
                        )
                        ],
                      ),
                  ),
                  SizedBox(
                    width: width - 450,
                    child: Column(
                      children: [
                        SizedBox(
                          height: rightCard != Cards.overview ? widget.constraints.maxHeight - 64 : widget.constraints.maxHeight - 32,
                          child: SlideTransition(
                            position: _offsetAnimation,
                            child: SingleChildScrollView(
                              child: rigthCard(snapshot, sprintAchievements, blitzAchievements, tlAchievements, qpAchievements, qpExAchievements, width - 450),
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
                            ButtonSegment<Cards>(
                                value: Cards.overview,
                                tooltip: t.homeNavigation.overview,
                                icon: Icon(Icons.calendar_view_day)),
                            ButtonSegment<Cards>(
                                value: Cards.tetraLeague,
                                tooltip: t.gamemodes["league"],
                                icon: SvgPicture.asset("res/icons/league.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.quickPlay,
                                tooltip: t.gamemodes["zenith"],
                                icon: SvgPicture.asset("res/icons/qp.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.sprint,
                                tooltip: t.gamemodes["40l"],
                                icon: SvgPicture.asset("res/icons/40l.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
                            ButtonSegment<Cards>(
                                value: Cards.blitz,
                                tooltip: t.gamemodes["blitz"],
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
              ) : SingleChildScrollView(
                child: Column(
                  children: [
                  UserThingy(player: snapshot.data!.player!, initIsTracking: snapshot.data!.isTracked, showStateTimestamp: false, setState: setState),
                  if (snapshot.data!.player!.badges.isNotEmpty) BadgesThingy(badges: snapshot.data!.player!.badges),
                  if (snapshot.data!.player!.distinguishment != null) DistinguishmentThingy(snapshot.data!.player!.distinguishment!),
                  if (snapshot.data!.player!.role == "bot") FakeDistinguishmentThingy(bot: true, botMaintainers: snapshot.data!.player!.botmaster),
                  if (snapshot.data!.player!.role == "banned") FakeDistinguishmentThingy(banned: true)
                  else if (snapshot.data!.player!.badstanding == true) FakeDistinguishmentThingy(badStanding: true),
                  rigthCard(snapshot, sprintAchievements, blitzAchievements, tlAchievements, qpAchievements, qpExAchievements, width),
                  if (rightCard == Cards.overview) Card(
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
                  if (rightCard == Cards.overview) NewsThingy(snapshot.data!.news!)
                ],
                )
              ),
            );
          }
        }
        return const Text("End of FutureBuilder<FetchResults>");
      },
    );
  }
}
