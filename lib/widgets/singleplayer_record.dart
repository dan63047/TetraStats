import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/destination_home.dart';

class SingleplayerRecord extends StatelessWidget {
  final RecordSingle? record;
  final String? rank;
  final bool hideTitle;

  /// Widget that displays data from [record]
  const SingleplayerRecord({super.key, required this.record, this.rank, this.hideTitle = false});

  @override
  Widget build(BuildContext context) {
    if (record == null) return Center(child: Text(t.noRecord, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)));
    late MapEntry closestAverageBlitz;
    late bool blitzBetterThanClosestAverage;
    bool? blitzBetterThanRankAverage = (rank != null && rank != "z") ? record!.stats.score > blitzAverages[rank]! : null;
    late MapEntry closestAverageSprint;
    late bool sprintBetterThanClosestAverage;
    bool? sprintBetterThanRankAverage = (rank != null && rank != "z") ? record!.stats.finalTime < sprintAverages[rank]! : null;
    if (record!.gamemode == "40l") {
      closestAverageSprint = sprintAverages.entries.singleWhere((element) => element.value == sprintAverages.values.reduce((a, b) => (a-record!.stats.finalTime).abs() < (b -record!.stats.finalTime).abs() ? a : b));
      sprintBetterThanClosestAverage = record!.stats.finalTime < closestAverageSprint.value;
    }else if (record!.gamemode == "blitz"){
      closestAverageBlitz = blitzAverages.entries.singleWhere((element) => element.value == blitzAverages.values.reduce((a, b) => (a-record!.stats.score).abs() < (b -record!.stats.score).abs() ? a : b));
      blitzBetterThanClosestAverage = record!.stats.score > closestAverageBlitz.value;
    }
    return RecordCard(record, [], record!.gamemode == "40l" ? sprintBetterThanRankAverage : blitzBetterThanRankAverage, record!.gamemode == "40l" ? closestAverageSprint : closestAverageBlitz, record!.gamemode == "40l" ? sprintBetterThanClosestAverage : blitzBetterThanClosestAverage, rank);
  }
}