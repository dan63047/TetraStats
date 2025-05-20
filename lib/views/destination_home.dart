import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sankey_flutter/sankey_helpers.dart';
import 'package:sankey_flutter/sankey_link.dart';
import 'package:sankey_flutter/sankey_node.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/achievement.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/minomuncher.dart';
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
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
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
import 'package:tetra_stats/widgets/gauget_thingy.dart';
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
				value: CardMod.exRecords, // yeah i misusing my own Enum shut the fuck up
				label: Text("Analysis"),
		),
		ButtonSegment<CardMod>(
				value: CardMod.ex,
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
										0: FixedColumnWidth(42)
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
									Text(t.gamemodes["zenith"]!, style: width > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall),
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
				if (record != null) Card(child: Center(child: Padding(
					padding: const EdgeInsets.only(bottom: 4.0),
					child: Text(t.nerdStats, style: width > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
				))),
				if (record != null) NerdStatsThingy(nerdStats: record!.aggregateStats.nerdStats, width: width),
				if (record != null) Graphs(record!.aggregateStats.apm, record!.aggregateStats.pps, record!.aggregateStats.vs, record!.aggregateStats.nerdStats, record!.aggregateStats.playstyle),
				if (achievements.isNotEmpty) Card(child: Center(child: Padding(
					padding: const EdgeInsets.only(bottom: 4.0),
					child: Text(t.relatedAchievements, style: width > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
				))),
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
		TextStyle tableTextStyle = TextStyle(fontSize: width > 768.0 ? 21 : 18);
		return Card(
			child: Column(
				children: [
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							if (closestAverage != null) Padding(padding: const EdgeInsets.only(right: 8.0),
							child: Tooltip(message: "${t.rankView.avgForRank(rank: closestAverage!.key.toUpperCase())}: ${
								switch(record!.gamemode){
									"40l" => get40lTime(closestAverage!.value.inMicroseconds),
									"blitz" => NumberFormat.decimalPattern().format(closestAverage!.value),
									_ => closestAverage!.value.toString()
								}
							}", child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage!.key}.png", height: 96))
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
										if (record!.rank != -1) const TextSpan(text: " • "),
										if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} ${t.localStanding}", style: TextStyle(color: getColorOfRank(record!.countryRank))),
										if (record!.countryRank != -1) TextSpan(text: width > 600.0 ? " • " : "\n"),
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
											}, textAlign: TextAlign.right, style: tableTextStyle),
											Text(switch(record!.gamemode){
												"40l" => " ${t.stats.pieces.full}",
												"blitz" => " ${t.stats.level.full}",
												"5mblast" => " ${t.stats.spp.short}",
												_ => " i wanted to"
											}, textAlign: TextAlign.left, style: tableTextStyle),
										]),
										TableRow(children: [
											Text(f2.format(record!.stats.pps), textAlign: TextAlign.right, style: tableTextStyle),
											Text(" ${t.stats.pps.short}", textAlign: TextAlign.left, style: tableTextStyle),
										]),
										TableRow(children: [
											Text(switch(record!.gamemode){
												"40l" => f2.format(record!.stats.kpp),
												"blitz" => f2.format(record!.stats.spp),
												"5mblast" => record!.stats.piecesPlaced.toString(),
												_ => "but god said"
											}, textAlign: TextAlign.right, style: tableTextStyle),
											Text(switch(record!.gamemode){
												"40l" => " ${t.stats.kpp.short}",
												"blitz" => " ${t.stats.spp.short}",
												"5mblast" => " ${t.stats.pieces.short}",
												_ => " no"
											}, textAlign: TextAlign.left, style: tableTextStyle),
										])
									],
								),
							),
							Expanded(
								child: Table(
									defaultColumnWidth:const IntrinsicColumnWidth(),
									children: [
										TableRow(children: [
											Text(intf.format(record!.stats.inputs), textAlign: TextAlign.right, style: tableTextStyle),
											Text(" ${t.stats.kp.short}", textAlign: TextAlign.left, style: tableTextStyle),
										]),
										TableRow(children: [
											Text(f2.format(record!.stats.kps), textAlign: TextAlign.right, style: tableTextStyle),
											Text(" ${t.stats.kps.short}", textAlign: TextAlign.left, style: tableTextStyle),
										]),
										TableRow(children: [
											Text(switch(record!.gamemode){
												"40l" => " ",
												"blitz" => record!.stats.piecesPlaced.toString(),
												"5mblast" => record!.stats.piecesPlaced.toString(),
												_ => "but god said"
											}, textAlign: TextAlign.right, style: tableTextStyle),
											Text(switch(record!.gamemode){
												"40l" => " ",
												"blitz" => " ${t.stats.pieces.short}",
												"5mblast" => " ${t.stats.pieces.short}",
												_ => " no"
											}, textAlign: TextAlign.left, style: tableTextStyle),
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
				child: Tooltip(message: "${t.rankView.avgForRank(rank: closestAverage!.key.toUpperCase())}: ${
					switch(record!.gamemode){
						"40l" => get40lTime(closestAverage!.value.inMicroseconds),
						"blitz" => NumberFormat.decimalPattern().format(closestAverage!.value),
						_ => closestAverage!.value.toString()
					}
				}", child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverage!.key}.png", height: 96)))
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
												alignment: Alignment.topLeft.add(Alignment(0.286 * (((achievement?.k??1) - 1) % 8), 0.286 * ((((achievement?.k??0) - 1) / 8).floor() % 8))),
												heightFactor: 0.125,
												widthFactor: 0.125,
												child: Image.asset("res/icons/achievements${(achievement?.k??1).floor() ~/ 64}.png", width: 2048, height: 2048, scale: 1, color: achievement?.v == null ? Colors.grey : achievementColors[min(achievement!.rank!, 6)]),
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

class NickStat{
	String nick;
	num stat;
	NickStat(this.nick, this.stat);
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
										RecordSummary(record: summaries.sprint, betterThanClosestAverage: sprintBetterThanClosestAverage, betterThanRankAverage: sprintBetterThanRankAverage, closestAverage: closestAverageSprint, rank: summaries.league.rank),
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
										RecordSummary(record: summaries.blitz, betterThanClosestAverage: blitzBetterThanClosestAverage, betterThanRankAverage: blitzBetterThanRankAverage, closestAverage: closestAverageBlitz, rank: summaries.league.rank),
										const Divider(),
										Text("${t.stats.level.full} ${summaries.blitz != null ? intf.format(summaries.blitz!.stats.level): "--"} • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.spp) : "-.--"} SPP • ${summaries.blitz != null ? f2.format(summaries.blitz!.stats.pps) : "-.--"} PPS", style: const TextStyle(color: Colors.grey))
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
										Text(t.overallPB(pb: (summaries.achievements.firstWhere((e) => e.k == 18, orElse: () => Achievement(k: 18, rt: 0, vt: 0, min: 0, deci: 0, name: "", object: "", category: "", hidden: true, art: 1, nolb: true, desc: "", n: "", a: 0)).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 18).v!) : "-.--"), style: const TextStyle(color: Colors.grey))
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
										Text(t.overallPB(pb: (summaries.achievements.firstWhere((e) => e.k == 19, orElse: () => Achievement(k: 19, rt: 0, vt: 0, min: 0, deci: 0, name: "", object: "", category: "", hidden: true, art: 1, nolb: true, desc: "", n: "", a: 0)).v != null) ? f2.format(summaries.achievements.firstWhere((e) => e.k == 19).v!) : "-.--"), style: const TextStyle(color: Colors.grey))
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
												Text((summaries.achievements.firstWhere((e) => e.k == 1, orElse: () => Achievement(k: 1, rt: 0, vt: 0, min: 0, deci: 0, name: "", object: "", category: "", hidden: true, art: 1, nolb: true, desc: "", n: "", a: 0)).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 1).v!) : "---"),
											],
										),
										Row(
											children: [
												Text(" - ${t.stats.piecesWithPerfectFinesse}:"),
												const Spacer(),
												Text((summaries.achievements.firstWhere((e) => e.k == 4, orElse: () => Achievement(k: 4, rt: 0, vt: 0, min: 0, deci: 0, name: "", object: "", category: "", hidden: true, art: 1, nolb: true, desc: "", n: "", a: 0)).v != null) ? intf.format(summaries.achievements.firstWhere((e) => e.k == 4).v!) : "---"),
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
		if (currentRangeValues.end.round() <= 1){
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
									Text(t.gamemodes["league"]!, style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall),
									if (toCompare != null) Padding(
										padding: const EdgeInsets.only(top: 4.0),
										child: Text(t.comparingWith(newDate: timestamp(toSee.timestamp), oldDate: timestamp(toCompare.timestamp)), textAlign: TextAlign.center, style: widget.constraints.maxWidth > 768.0 ? null : TextStyle(fontSize: 12.0)),
									)
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
				if (data.nerdStats != null) Card(child: Center(child: Padding(
					padding: const EdgeInsets.only(bottom: 4.0),
					child: Text(t.nerdStats, style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
				))),
				if (data.nerdStats != null) NerdStatsThingy(nerdStats: toSee.nerdStats!, oldNerdStats: toCompare?.nerdStats, averages: averages, lbPos: lbPos, width: width, rank: toSee.rank != "z" ? toSee.rank.toUpperCase() : toSee.percentileRank.toUpperCase()),
				if (data.nerdStats != null) Graphs(toSee.apm!, toSee.pps!, toSee.vs!, toSee.nerdStats!, toSee.playstyle!),
				Card(child: Center(child: Text(t.relatedAchievements, style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center))),
				Wrap(
					direction: Axis.horizontal,
					children: [
						for (Achievement achievement in achievements) FractionallySizedBox(widthFactor: 1/((width/600).ceil()), child: AchievementSummary(achievement: achievement)),
					],
				),
			],
		);
	}

	Widget getFreyhoeAnalysis(double width){
		return FutureBuilder<MinomuncherData>(
			future: teto.fetchMinoMuncherStats("bozo"),
			builder: (context, snapshot) {
				switch (snapshot.connectionState){
				case ConnectionState.none:
				case ConnectionState.waiting:
				case ConnectionState.active:
					return const Center(child: CircularProgressIndicator());
				case ConnectionState.done:
					if (snapshot.hasData){
						List<ClearsChartData> clearTypeList = [snapshot.data!.clearTypes];
						List<LinearGaugeRange> apmRanges = [
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.openerAPM,
                startWidth: 25,
                endWidth: 25,
                color: Colors.yellow.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.APM,
                startWidth: 25,
                endWidth: 25,
                color: Colors.red.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.midgameAPM,
                startWidth: 25,
                endWidth: 25,
                color: Colors.green.shade300,
                position: LinearElementPosition.cross
              )
						];
						List<LinearGaugeRange> ppsRanges = [
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.openerPPS,
                startWidth: 25,
                endWidth: 25,
                color: Colors.yellow.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.PPS,
                startWidth: 25,
                endWidth: 25,
                color: Colors.red.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.midgamePPS,
                startWidth: 25,
                endWidth: 25,
                color: Colors.green.shade300,
                position: LinearElementPosition.cross
              )
						];
            List<LinearGaugeRange> aplRanges = [
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.cheeseAPL,
                startWidth: 25,
                endWidth: 25,
                color: Colors.yellow.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.upstackAPL,
                startWidth: 25,
                endWidth: 25,
                color: Colors.green.shade300,
                position: LinearElementPosition.cross
              ),
              LinearGaugeRange(
                startValue: 0,
                endValue: snapshot.data!.downstackAPL,
                startWidth: 25,
                endWidth: 25,
                color: Colors.red.shade300,
                position: LinearElementPosition.cross
              )
            ];
						apmRanges.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
						ppsRanges.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
            aplRanges.sort((a, b) => a.endValue > b.endValue ? -1 : 1);
            List<SankeyNode> sankeyNodes = [
              SankeyNode(id: 0, label: 'Incoming Attack'),
              SankeyNode(id: 1, label: 'Cheese'),
              SankeyNode(id: 2, label: 'Clean'),
              SankeyNode(id: 3, label: 'Cancelled'),
              SankeyNode(id: 4, label: 'CheeseTanked'),
              SankeyNode(id: 5, label: 'CleanTanked'),
            ];
            List<SankeyLink> sankeyLinks = [
              SankeyLink(source: sankeyNodes[0], target: sankeyNodes[1], value: snapshot.data!.cheeseLinesRecieved * 100),
              SankeyLink(source: sankeyNodes[0], target: sankeyNodes[2], value: snapshot.data!.cleanLinesRecieved * 100),
              SankeyLink(source: sankeyNodes[1], target: sankeyNodes[3], value: snapshot.data!.cheeseLinesCancelled * 100),
              SankeyLink(source: sankeyNodes[1], target: sankeyNodes[4], value: snapshot.data!.cheeseLinesTanked * 100),
              SankeyLink(source: sankeyNodes[2], target: sankeyNodes[3], value: snapshot.data!.cheeseLinesCancelled * 100),
              SankeyLink(source: sankeyNodes[2], target: sankeyNodes[4], value: snapshot.data!.cleanLinesTankedAsCheese * 100),
              SankeyLink(source: sankeyNodes[2], target: sankeyNodes[5], value: snapshot.data!.cleanLinesTankedAsClean * 100)
            ];
            Map<String, Color> nodeColors = generateDefaultNodeColorMap(sankeyNodes);
            SankeyDataSet sankeyDataSet = SankeyDataSet(nodes: sankeyNodes, links: sankeyLinks);
            final sankey = generateSankeyLayout(
              width: 800,
              height: 400,
              nodeWidth: 20,
              nodePadding: 15,
            );
            sankeyDataSet.layout(sankey);
            const EdgeInsets paddings = const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0);
						return Column(
							children: [
								Text("Just a design mockup. WIP"),
								Card(
									child: Padding(
										padding: const EdgeInsets.only(bottom: 4.0),
										child: Center(
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Text("Analysis", style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleMedium),
													Padding(
														padding: const EdgeInsets.only(top: 4.0),
														child: Text("via MinoMuncher by Freyhoe", textAlign: TextAlign.center, style: TextStyle(fontSize: widget.constraints.maxWidth > 768.0 ? null : 12.0, color: Colors.grey)),
													)
												],
											),
										),
									),
								),
								Card(
									child: Padding(
										padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
										child: Center(
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													SfLinearGauge(
														minimum: 0,
														maximum: 300,
														interval: 25, 
														ranges: apmRanges,
														markerPointers: [
															LinearWidgetPointer(value: 0, child: Container(width: 36.0, child: Text("APM")), markerAlignment: LinearMarkerAlignment.end)
														],
														isMirrored: false,
														showTicks: true,
														showLabels: false
													),
													SizedBox(height: 8.0),
													SfLinearGauge(
														minimum: 0,
														maximum: 4.00,
														interval: .25, 
														ranges: ppsRanges,
														markerPointers: [
															LinearWidgetPointer(value: 0, child: Container(width: 36.0, child: Text("PPS")), markerAlignment: LinearMarkerAlignment.end)
														],
														isMirrored: false,
														showTicks: true,
														showLabels: false
													),
													SizedBox(height: 8.0),
													Wrap(
														direction: Axis.horizontal,
														crossAxisAlignment: WrapCrossAlignment.center,
														spacing: 20,
														children: [
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
																	),
																	Text("Midgame: ${f2.format(snapshot.data!.midgameAPM)} APM, ${f2.format(snapshot.data!.midgamePPS)} PPS")
																],
															),
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.red.shade300)),
																	),
																	Text("Overall: ${f2.format(snapshot.data!.APM)} APM, ${f2.format(snapshot.data!.PPS)} PPS")
																],
															),
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.yellow.shade300)),
																	),
																	Text("Opener: ${f2.format(snapshot.data!.openerAPM)} APM, ${f2.format(snapshot.data!.openerPPS)} PPS")
																],
															),
														],
													),
												],
											),
										),
									),
								),
                Card(
									child: Padding(
										padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
										child: Center(
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
                          Text("Attack Per Line", style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
													SizedBox(height: 8.0),
                          SfLinearGauge(
														minimum: 0,
														maximum: 2,
														interval: .25, 
														ranges: aplRanges,
														showTicks: true,
													),
													SizedBox(height: 8.0),
													Wrap(
														direction: Axis.horizontal,
														crossAxisAlignment: WrapCrossAlignment.center,
														spacing: 20,
														children: [
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
																	),
																	Text("Upstack: ${f3.format(snapshot.data!.upstackAPL)} APL")
																],
															),
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.red.shade300)),
																	),
																	Text("Downstack: ${f3.format(snapshot.data!.downstackAPL)} APL")
																],
															),
                              Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.yellow.shade300)),
																	),
																	Text("Cheese: ${f3.format(snapshot.data!.cheeseAPL)} APL")
																],
															),
														],
													),
												],
											),
										),
									),
								),
                Card(
									child: Padding(
										padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
										child: Center(
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													SfLinearGauge(
														minimum: 0,
														maximum: snapshot.data!.iEfficiency+snapshot.data!.tEfficiency+snapshot.data!.allspinEfficiency,
														ranges: <LinearGaugeRange>[
                              LinearGaugeRange(
                                startValue: 0,
                                endValue: snapshot.data!.iEfficiency,
                                startWidth: 25,
                                endWidth: 25,
                                color: Colors.blue.shade300,
                                position: LinearElementPosition.cross
                              ),
                              LinearGaugeRange(
                                startValue: snapshot.data!.iEfficiency,
                                endValue: snapshot.data!.iEfficiency+snapshot.data!.tEfficiency,
                                startWidth: 25,
                                endWidth: 25,
                                color: Colors.purple.shade300,
                                position: LinearElementPosition.cross
                              ),
                              LinearGaugeRange(
                                startValue: snapshot.data!.iEfficiency+snapshot.data!.tEfficiency,
                                endValue: snapshot.data!.iEfficiency+snapshot.data!.tEfficiency+snapshot.data!.allspinEfficiency,
                                startWidth: 25,
                                endWidth: 25,
                                color: Colors.green.shade300,
                                position: LinearElementPosition.cross
                              )
                            ],
														isMirrored: false,
														showTicks: true,
														showLabels: false
													),
													SizedBox(height: 8.0),
													Wrap(
														direction: Axis.horizontal,
														crossAxisAlignment: WrapCrossAlignment.center,
														spacing: 20,
														children: [
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.blue.shade300)),
																	),
																	Text("Quad efficiency: ${percentage.format(snapshot.data!.iEfficiency)}")
																],
															),
															Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.purple.shade300)),
																	),
																	Text("T-spin efficiency: ${percentage.format(snapshot.data!.tEfficiency)}")
																],
															),
                              Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Padding(
																		padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																		child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: Colors.green.shade300)),
																	),
																	Text("Allspin efficiency: ${percentage.format(snapshot.data!.allspinEfficiency)}")
																],
															),
														],
													),
												],
											),
										),
									),
								),
								Card(
									child: Padding(
										padding: paddings,
										child: Column(
											children: [
												SfCartesianChart(
													primaryXAxis: CategoryAxis(isVisible: false),
													primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
													title: ChartTitle(text: "Clear Types", textStyle: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
													legend: Legend(
														isVisible: true,
														position: LegendPosition.left,
														itemPadding: 2,
														legendItemBuilder: (legendText, series, point, seriesIndex) {
															return Container(
																height: 20,
																width: 210,
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																	children: [
																		Row(
																			mainAxisSize: MainAxisSize.min,
																		children: [
																				Padding(
																					padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
																					child: Container(width: 10.0, height: 10.0, decoration: BoxDecoration(color: lineClearsColors[seriesIndex])),
																				),
																			Text("${snapshot.data!.clearTypes.clearName[seriesIndex]}:"),
																		],
																		),
																		Text("${intf.format(point.y)} · ${percentage2f2.format(point.y!/snapshot.data!.clearTypes.total)}")
																	],
																),
															);
														}, 
													),
													series: width > 580 ? <CartesianSeries>[
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.perfectClear,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[0]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.allspin,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[1]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.single,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[2]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinSingle,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[3]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.double,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[4]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinDouble,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[5]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.triple,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[6]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinTriple,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[7]
														),
														StackedBar100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.quad,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[8]
														),
													] : <CartesianSeries>[
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.perfectClear,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[0]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.allspin,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[1]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.single,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[2]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinSingle,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[3]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.double,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[4]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinDouble,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[5]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.triple,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[6]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.tspinTriple,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[7]
														),
														StackedColumn100Series<ClearsChartData, String>(
															dataSource: clearTypeList,
															xValueMapper: (ClearsChartData data, _) => data.nick,
															yValueMapper: (ClearsChartData data, _) => data.quad,
															pointColorMapper: (ClearsChartData data, _) => lineClearsColors[8]
														),
													]
												),
											],
										),
									)
								),
								Card(
									child: Padding(
										padding: paddings,
										child: Column(
											children: [
												SfCartesianChart(
													primaryXAxis: CategoryAxis(),
													primaryYAxis: NumericAxis(numberFormat: percentage),
													tooltipBehavior: TooltipBehavior(
														enable: true,
														color: Colors.black,
														borderColor: Colors.white,
														animationDuration: 0,
														builder: (dynamic data, dynamic point, dynamic series,
															int pointIndex, int seriesIndex) {
																return Padding(
																	padding: const EdgeInsets.all(8.0),
																	child: Text(
																		"${percentage.format(data.value)}",
																		style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20),
																	),
																);
														}
													),
													title: ChartTitle(text: "Well Column Distribution", textStyle: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
													series: <CartesianSeries>[
														ColumnSeries<WellsData, int>(
																dataSource: snapshot.data!.wellColumns,
																xValueMapper: (WellsData data, _) => data.well,
																yValueMapper: (WellsData data, _) => data.value
														)
													]
												),
											],
										),
									)
								),
                Card(
									child: Padding(
										padding: paddings,
										child: Column(
										  children: [
                        Text("Surge", style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
                        Center(child: SizedBox(width: 0.0, height: 16.0)),
                        SizedBox(
                          height: 330,
                          width: 330,
                          child: MyRadarChart(
                          RadarChartData(
                            radarShape: RadarShape.circle,
                            tickCount: 4,
                            radarBackgroundColor: Colors.black.withAlpha(170),
                            radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                            gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                            tickBorderData: const BorderSide(color: Colors.white24, width: 1),
                            getTitle: (index, angle) {
                              switch (index) {
                                case 0: return RadarChartTitle(text: "APM\n${f2.format(snapshot.data!.surgeAPM)}", positionPercentageOffset: 0.05);
                                case 1: return RadarChartTitle(text: "PPS\n${f2.format(snapshot.data!.surgePPS)}", positionPercentageOffset: 0.05, angle: 60.0);
                                case 2: return RadarChartTitle(text: "Length\n${f2.format(snapshot.data!.surgeLength)}", positionPercentageOffset: 0.05, angle: -60.0);
                                case 3: return RadarChartTitle(text: "Rate\n${percentage.format(snapshot.data!.surgeRate)}", positionPercentageOffset: 0.05);
                                case 4: return RadarChartTitle(text: "Secs/DS\n${f2.format(snapshot.data!.surgeDS)}", positionPercentageOffset: 0.05, angle: 60.0);
                                case 5: return RadarChartTitle(text: "Allspin\n${percentage.format(snapshot.data!.surgeAllspin)}", positionPercentageOffset: 0.05, angle: -60.0);
                                default: return const RadarChartTitle(text: '');
                              }
                            },
                            dataSets: [
                              RadarDataSet(
                                fillColor: Theme.of(context).colorScheme.primary.withAlpha(170),
                                borderColor: Theme.of(context).colorScheme.primary,
                                dataEntries: [
                                  RadarEntry(value: snapshot.data!.surgeAPM/120),
                                  RadarEntry(value: snapshot.data!.surgePPS),
                                  RadarEntry(value: snapshot.data!.surgeLength/3),
                                  RadarEntry(value: snapshot.data!.surgeRate/10),
                                  RadarEntry(value: snapshot.data!.surgeDS/10),
                                  RadarEntry(value: snapshot.data!.surgeAllspin)
                                ],
                              ),
                              RadarDataSet(
                                fillColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                dataEntries: [
                                  RadarEntry(value: 1),
                                  RadarEntry(value: 0),
                                  RadarEntry(value: 0),
                                  RadarEntry(value: 0),
                                  RadarEntry(value: 0),
                                  RadarEntry(value: 0)
                                ],
                              ),
                            ]
                          )
                          ),
                        ),
                        Center(child: SizedBox(width: 0.0, height: 16.0)),
										  ],
										),
									)
								),
                Card(
									child: Padding(
										padding: paddings,
										child: Column(
										  children: [
                        Text("Incoming Attack Sankey Chart", style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall),
										    SankeyDiagramWidget(
                          data: sankeyDataSet,
                          nodeColors: nodeColors,
                          size: const Size(800.0, 400.0),
                          showLabels: true,
                        ),
										  ],
										)
									)
								),
							],
						);
					}
					if (snapshot.hasError){ return SizedBox(height: 720.0, child: FutureError(snapshot)); }
				}
			return const Text("what?");
			},
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
									Text(t.previousSeasons, style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
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
									Text(t.recent, style: widget.constraints.maxWidth > 768.0 ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleSmall),
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
				CardMod.exRecords => getFreyhoeAnalysis(width),
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
						blitzBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.blitz != null) ? snapshot.data!.summaries!.blitz!.stats.score > blitzAverages[snapshot.data!.summaries!.league.rank]! : null;
						sprintBetterThanRankAverage = (snapshot.data!.summaries!.league.rank != "z" && snapshot.data!.summaries!.sprint != null) ? snapshot.data!.summaries!.sprint!.stats.finalTime < sprintAverages[snapshot.data!.summaries!.league.rank]! : null;
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
						List<Achievement> tlAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? snapshot.data!.summaries!.achievements.where((e) => e.category == "league").toList() : [];
						List<Achievement> qpAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? snapshot.data!.summaries!.achievements.where((e) => e.category == "zenith" && !e.object.contains("Expert Mode")).toList() : [];
						List<Achievement> qpExAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? snapshot.data!.summaries!.achievements.where((e) => e.category == "zenith" && e.object.contains("Expert Mode")).toList() : [];
						List<Achievement> sprintAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? snapshot.data!.summaries!.achievements.where((e) => e.category == "solo" && !e.object.contains("BLITZ")).toList() : [];
						List<Achievement> blitzAchievements = snapshot.data!.summaries!.achievements.isNotEmpty ? snapshot.data!.summaries!.achievements.where((e) => e.category == "solo" && e.object.contains("BLITZ")).toList() : [];
						tlAchievements.sort((a, b) => a.o! - b.o!);
						qpAchievements.sort((a, b) => a.o! - b.o!);
						qpExAchievements.sort((a, b) => a.o! - b.o!);
						sprintAchievements.sort((a, b) => a.o! - b.o!);
						blitzAchievements.sort((a, b) => a.o! - b.o!);
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
																child: MarkdownBody(data: snapshot.data!.player!.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center), onTapLink: (String text, String? href, String title){launchInBrowser(Uri.parse(href!));}),
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
												if (modeButtons[rightCard]!.length > 1 && widget.constraints.maxWidth >= 1030.00) SegmentedButton<CardMod>(
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
												if (widget.constraints.maxWidth >= 1030.00) SegmentedButton<Cards>(
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
									if (rightCard == Cards.overview && snapshot.data?.player?.bio != null) Card(
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
													child: MarkdownBody(data: snapshot.data!.player!.bio!, styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center), onTapLink: (String text, String? href, String title){launchInBrowser(Uri.parse(href!));}),
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
