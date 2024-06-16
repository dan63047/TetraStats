import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/open_in_browser.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/singleplayer_record_view.dart';
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/sp_trailing_stats.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class SingleplayerRecord extends StatelessWidget {
  final RecordSingle? record;
  final SingleplayerStream? stream;
  final String? rank;
  final bool hideTitle;

  /// Widget that displays data from [record]
  const SingleplayerRecord({super.key, required this.record, this.stream, this.rank, this.hideTitle = false});

  Color getColorOfRank(int rank){
    if (rank == 1) return Colors.yellowAccent;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown[400]!;
    if (rank <= 9) return Colors.blueAccent;
    if (rank <= 99) return Colors.greenAccent;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (record == null) return Center(child: Text(t.noRecord, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)));
    late MapEntry closestAverageBlitz;
    late bool blitzBetterThanClosestAverage;
    bool? blitzBetterThanRankAverage = (rank != null && rank != "z") ? record!.endContext.score > blitzAverages[rank]! : null;
    late MapEntry closestAverageSprint;
    late bool sprintBetterThanClosestAverage;
    bool? sprintBetterThanRankAverage = (rank != null && rank != "z") ? record!.endContext.finalTime < sprintAverages[rank]! : null;
    if (record!.endContext.gameType == "40l") {
      closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-record!.endContext.finalTime).abs() < (b -record!.endContext.finalTime).abs() ? a : b));
      sprintBetterThanClosestAverage = record!.endContext.finalTime < closestAverageSprint.value;
    }else if (record!.endContext.gameType == "blitz"){
      closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-record!.endContext.score).abs() < (b -record!.endContext.score).abs() ? a : b));
      blitzBetterThanClosestAverage = record!.endContext.score > closestAverageBlitz.value;
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        bool bigScreen = constraints.maxWidth > 768;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (record!.endContext.gameType == "40l") Padding(padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverageSprint.key}.png", height: 96)
                    ),
                    if (record!.endContext.gameType == "blitz") Padding(padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset("res/tetrio_tl_alpha_ranks/${closestAverageBlitz.key}.png", height: 96)
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      if (record!.endContext.gameType == "40l" && !hideTitle) Text(t.sprint, style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
                      if (record!.endContext.gameType == "blitz" && !hideTitle) Text(t.blitz, style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
                      RichText(text: TextSpan(
                          text: record!.endContext.gameType == "40l" ? get40lTime(record!.endContext.finalTime.inMicroseconds) : NumberFormat.decimalPattern().format(record!.endContext.score),
                          style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 36 : 32, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      RichText(text: TextSpan(
                        text: "",
                        style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                        children: [
                          if (record!.endContext.gameType == "40l" && (rank != null && rank != "z")) TextSpan(text: "${t.verdictGeneral(n: readableTimeDifference(record!.endContext.finalTime, sprintAverages[rank]!), verdict: sprintBetterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                            color: sprintBetterThanRankAverage??false ? Colors.greenAccent : Colors.redAccent
                          ))
                          else if (record!.endContext.gameType == "40l" && (rank == null || rank == "z")) TextSpan(text: "${t.verdictGeneral(n: readableTimeDifference(record!.endContext.finalTime, closestAverageSprint.value), verdict: sprintBetterThanClosestAverage ? t.verdictBetter : t.verdictWorse, rank: closestAverageSprint.key.toUpperCase())}\n", style: TextStyle(
                            color: sprintBetterThanClosestAverage ? Colors.greenAccent : Colors.redAccent
                          ))
                          else if (record!.endContext.gameType == "blitz" && (rank != null && rank != "z")) TextSpan(text: "${t.verdictGeneral(n: readableIntDifference(record!.endContext.score, blitzAverages[rank]!), verdict: blitzBetterThanRankAverage??false ? t.verdictBetter : t.verdictWorse, rank: rank!.toUpperCase())}\n", style: TextStyle(
                            color: blitzBetterThanRankAverage??false ? Colors.greenAccent : Colors.redAccent
                          ))
                          else if (record!.endContext.gameType == "blitz" && (rank == null || rank == "z")) TextSpan(text: "${t.verdictGeneral(n: readableIntDifference(record!.endContext.score, closestAverageBlitz.value), verdict: blitzBetterThanClosestAverage ? t.verdictBetter : t.verdictWorse, rank: closestAverageBlitz.key.toUpperCase())}\n", style: TextStyle(
                            color: blitzBetterThanClosestAverage ? Colors.greenAccent : Colors.redAccent
                          )),
                          if (record!.rank != null) TextSpan(text: "№${record!.rank}", style: TextStyle(color: getColorOfRank(record!.rank!))),
                          if (record!.rank != null) const TextSpan(text: " • "),
                          TextSpan(text: timestamp(record!.timestamp)),
                        ]
                        ),
                      )
                    ],),
                  ],
                ),
                if (record!.endContext.gameType == "40l") Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      StatCellNum(playerStat: record!.endContext.piecesPlaced, playerStatLabel: t.statCellNum.pieces, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                      StatCellNum(playerStat: record!.endContext.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                      StatCellNum(playerStat: record!.endContext.kpp, playerStatLabel: t.statCellNum.kpp, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                    ],
                ),
                if (record!.endContext.gameType == "blitz") Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 20,
                    children: [
                      StatCellNum(playerStat: record!.endContext.level, playerStatLabel: t.statCellNum.level, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                      StatCellNum(playerStat: record!.endContext.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                      StatCellNum(playerStat: record!.endContext.spp, playerStatLabel: t.statCellNum.spp, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true)
                    ],
                ),
                FinesseThingy(record?.endContext.finesse, record?.endContext.finessePercentage),
                LineclearsThingy(record!.endContext.clears, record!.endContext.lines, record!.endContext.holds, record!.endContext.tSpins),
                if (record!.endContext.gameType == "40l") Text("${record!.endContext.inputs} KP • ${f2.format(record!.endContext.kps)} KPS"),
                if (record!.endContext.gameType == "blitz") Text("${record!.endContext.piecesPlaced} P • ${record!.endContext.inputs} KP • ${f2.format(record!.endContext.kpp)} KPP • ${f2.format(record!.endContext.kps)} KPS"),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 20,
                  children: [
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://tetr.io/#r:${record!.replayId}"));}, child: Text(t.openSPreplay)),
                    TextButton(onPressed: (){launchInBrowser(Uri.parse("https://inoue.szy.lol/api/replay/${record!.replayId}"));}, child: Text(t.downloadSPreplay)),
                  ],
                ),
                if (stream != null && stream!.records.length > 1) for(int i = 1; i < stream!.records.length; i++) ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleplayerRecordView(record: stream!.records[i]))),
                  leading: Text("#${i+1}",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, shadows: textShadow, height: 0.9)
                  ),
                  title: Text(
                    switch (stream!.records[i].endContext.gameType){
                      "40l" => get40lTime(stream!.records[i].endContext.finalTime.inMicroseconds),
                      "blitz" => t.blitzScore(p: NumberFormat.decimalPattern().format(stream!.records[i].endContext.score)),
                      "5mblast" => get40lTime(stream!.records[i].endContext.finalTime.inMicroseconds),
                      String() => "huh",
                    },
                  style: TextStyle(fontSize: 18)),
                  subtitle: Text(timestamp(stream!.records[i].timestamp), style: TextStyle(color: Colors.grey, height: 0.85)),
                  trailing: SpTrailingStats(stream!.records[i].endContext)
                )
              ]
            ),
          ),
        );
      }
    );
  }
}