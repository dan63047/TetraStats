import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player_from_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/views/rank_view.dart';
import 'package:tetra_stats/widgets/future_error.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors; 

class FetchCutoffsResults{
  late bool success;
  CutoffsTetrio? cutoffs;
  Exception? exception;

  FetchCutoffsResults(this.success, this.cutoffs, this.exception);
}

class DestinationCutoffs extends StatefulWidget{
  final BoxConstraints constraints;

  const DestinationCutoffs({super.key, required this.constraints});

  @override
  State<DestinationCutoffs> createState() => _DestinationCutoffsState();
}

class _DestinationCutoffsState extends State<DestinationCutoffs> {

  Future<CutoffsTetrio> fetch() async {
    TetrioPlayerFromLeaderboard top1;
    CutoffsTetrio cutoffs;
    List<dynamic> requests = await Future.wait([
      teto.fetchCutoffsTetrio(),
      teto.fetchTopOneFromTheLeaderboard(),
    ]);
    cutoffs = requests[0];
    top1 = requests[1];
    cutoffs.data["top1"] = CutoffTetrio(
      pos: 1,
      percentile: 0.00,
      tr: top1.tr,
      targetTr: 25000,
      apm: top1.apm,
      pps: top1.pps,
      vs: top1.vs,
      count: 1,
      countPercentile: 0.0 
      );
    return cutoffs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CutoffsTetrio>(
      future: fetch(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Center(child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            Text(t.cutoffsDestination.title, style: Theme.of(context).textTheme.titleLarge),
                            Text(t.cutoffsDestination.relevance(timestamp: timestamp(snapshot.data!.timestamp))),
                          ],
                        ),
                      )),
                    ), 
                    Padding(
                      padding: const EdgeInsets.only(bottom:4.0),
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Text(t.cutoffsDestination.actual),
                                      ),
                                      Text(t.cutoffsDestination.target)
                                    ]  
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                                    child: SfLinearGauge(
                                      minimum: 0.00000000,
                                      maximum: 25000.0000,
                                      showTicks: false,
                                      showLabels: false,
                                      ranges: [
                                        for (var cutoff in snapshot.data!.data.keys) LinearGaugeRange(
                                          position: LinearElementPosition.outside,
                                          startValue: snapshot.data!.data[cutoff]!.tr,
                                          startWidth: 20.0,
                                          endWidth: 20.0,
                                          endValue: switch (cutoff){
                                            "top1" => 25000.00,
                                            "x+" => snapshot.data!.data["top1"]!.tr,
                                            _ => snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr
                                          },
                                          color: cutoff != "top1" ? rankColors[cutoff] : Colors.grey.shade800,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys) LinearGaugeRange(
                                          position: LinearElementPosition.inside,
                                          startValue: snapshot.data!.data[cutoff]!.targetTr,
                                          endValue: switch (cutoff){
                                            "top1" => 25000.00,
                                            "x+" => snapshot.data!.data["top1"]!.targetTr,
                                            _ => snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr
                                          },
                                          color: cutoff != "top1" ? rankColors[cutoff] : null,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys.skip(1)) if (snapshot.data!.data[cutoff]!.tr < snapshot.data!.data[cutoff]!.targetTr) LinearGaugeRange(
                                          position: LinearElementPosition.cross,
                                          startValue: snapshot.data!.data[cutoff]!.tr,
                                          endValue: snapshot.data!.data[cutoff]!.targetTr,
                                          color: Colors.green,
                                        ),
                                        for (var cutoff in snapshot.data!.data.keys.skip(1)) if (snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr)LinearGaugeRange(
                                          position: LinearElementPosition.cross,
                                          startValue: snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.targetTr,
                                          endValue: snapshot.data!.data[ranks[ranks.indexOf(cutoff)+1]]!.tr,
                                          color: Colors.red,
                                        ),
                                      ],
                                      markerPointers: [
                                        for (var cutoff in snapshot.data!.data.keys) LinearWidgetPointer(child: Container(child: Text(intf.format(snapshot.data!.data[cutoff]!.tr), style: TextStyle(fontSize: 12)), transform: Matrix4.compose(Vector3(0, 35, 0), Quaternion.axisAngle(Vector3(0, 0, 1), -1), Vector3(1, 1, 1)), height: 45.0), value: snapshot.data!.data[cutoff]!.tr, position: LinearElementPosition.outside, offset: 20),
                                        for (var cutoff in snapshot.data!.data.keys) LinearWidgetPointer(child: Container(child: Text(intf.format(snapshot.data!.data[cutoff]!.targetTr), textAlign: ui.TextAlign.right, style: TextStyle(fontSize: 12)), transform: Matrix4.compose(Vector3(-15, 0, 0), Quaternion.axisAngle(Vector3(0, 0, 1), -1), Vector3(1, 1, 1)), height: 45.0, transformAlignment: Alignment.topRight), value: snapshot.data!.data[cutoff]!.targetTr, position: LinearElementPosition.inside, offset: 6)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(color: Colors.grey.shade900),
                        columnWidths: const {
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(155),
                          2: FixedColumnWidth(140),
                          3: FixedColumnWidth(160),
                          4: FixedColumnWidth(150),
                          5: FixedColumnWidth(90),
                          6: FixedColumnWidth(130),
                          7: FixedColumnWidth(120),
                          8: FixedColumnWidth(125),
                          9: FixedColumnWidth(70),
                          },
                        children: [
                          TableRow(
                            children: [
                              Text(t.rank, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.cutoffsDestination.cutoffTR, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.cutoffsDestination.targetTR, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 24, fontWeight: FontWeight.w100, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(t.cutoffsDestination.state, textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.stats.apm.short, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.stats.pps.short, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.stats.vs.short, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(t.cutoffsDestination.advanced, textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(t.cutoffsDestination.players(n: intf.format(snapshot.data!.total)), textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(child: Text(t.cutoffsDestination.moreInfo, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500)), onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => RankView(rank: "", nextRankTR: snapshot.data!.data["top1"]!.tr, nextRankPercentile: 0.00, nextRankTargetTR: 25000.00, totalPlayers: snapshot.data!.total, cutoffTetrio: CutoffTetrio(apm: 0, pps: 0, vs: 0, pos: 0, percentile: 1, count: snapshot.data!.total, countPercentile: 1, tr: snapshot.data!.data["d"]!.tr, targetTr: snapshot.data!.data['d']!.targetTr)),
                                  ),
                                  );
                                },),
                              ),
                            ]
                          ),
                          for (String rank in snapshot.data!.data.keys) if (rank != "top1") TableRow(
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [rankColors[rank]!.withAlpha(200), rankColors[rank]!.withAlpha(100)])),
                            children: [
                              Container(decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withAlpha(132), blurRadius: 32.0, blurStyle: BlurStyle.inner)]), child: Image.asset("res/tetrio_tl_alpha_ranks/$rank.png", height: 48)),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(f2.format(snapshot.data!.data[rank]!.tr), textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(f2.format(snapshot.data!.data[rank]!.targetTr), textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 24, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                  style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow),
                                  children: [
                                    if (rank == "x+") TextSpan(text: t.cutoffsDestination.NumberOne(tr: f2.format(snapshot.data!.data["top1"]!.tr)), style: const TextStyle(color: Colors.white60, shadows: null))
                                    else TextSpan(text: snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr ? t.cutoffsDestination.inflated(tr: f2.format(snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr - snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr)) : t.cutoffsDestination.notInflated, style: TextStyle(color: snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr > snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr ? Colors.white :Colors.white60, shadows: null)),
                                    TextSpan(text: "\n", style: const TextStyle(color: Colors.white60, shadows: null)),
                                    if (rank == "d") TextSpan(text: t.cutoffsDestination.wellDotDotDot, style: const TextStyle(color: Colors.white60, shadows: null))
                                    else TextSpan(text: snapshot.data!.data[rank]!.tr < snapshot.data!.data[rank]!.targetTr ? t.cutoffsDestination.deflated(tr: f2.format(snapshot.data!.data[rank]!.targetTr - snapshot.data!.data[rank]!.tr)) : t.cutoffsDestination.notDeflated, style: TextStyle(color: snapshot.data!.data[rank]!.tr < snapshot.data!.data[rank]!.targetTr ? Colors.white : Colors.white60, shadows: null))
                                  ]
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(snapshot.data?.data[rank]?.apm != null ? f2.format(snapshot.data!.data[rank]!.apm) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.apm != null ? Colors.white : Colors.grey, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(snapshot.data?.data[rank]?.pps != null ? f2.format(snapshot.data!.data[rank]!.pps) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.pps != null ? Colors.white : Colors.grey, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(snapshot.data?.data[rank]?.vs != null ? f2.format(snapshot.data!.data[rank]!.vs) : "-.--", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 28, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.vs != null ? Colors.white : Colors.grey, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("${snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.pps != null ? f3.format(snapshot.data!.data[rank]!.apm! / (snapshot.data!.data[rank]!.pps! * 60)) : "-.---"} ${t.stats.app.short}\n${snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.vs != null ? f3.format(snapshot.data!.data[rank]!.vs! / snapshot.data!.data[rank]!.apm!) : "-.---"} ${t.stats.vsapm.short}", textAlign: TextAlign.right, style: TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: snapshot.data?.data[rank]?.apm != null && snapshot.data?.data[rank]?.pps != null && snapshot.data?.data[rank]?.vs != null ? Colors.white : Colors.grey, shadows: textShadow)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                  style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white, shadows: textShadow),
                                  children: [
                                    TextSpan(text: intf.format(snapshot.data!.data[rank]!.count)),
                                    TextSpan(text: " (${f2.format(snapshot.data!.data[rank]!.countPercentile * 100)}%)", style: const TextStyle(color: Colors.white60, shadows: null)),
                                    TextSpan(text: "\n(${t.cutoffsDestination.fromPlace(n: intf.format(snapshot.data!.data[rank]!.pos))})", style: const TextStyle(color: Colors.white60, shadows: null))
                                  ]
                                ))
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(child: Text(t.cutoffsDestination.viewButton, textAlign: TextAlign.right, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w500)), onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(maintainState: true,
                                    builder: (context) => RankView(rank: rank, nextRankTR: rank == "x+" ? snapshot.data!.data["top1"]!.tr : snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.tr, nextRankPercentile: rank == "x+" ? 0.00 : snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.percentile, nextRankTargetTR: rank == "x+" ? 25000.00 : snapshot.data!.data[ranks[ranks.indexOf(rank)+1]]!.targetTr, totalPlayers: snapshot.data!.total, cutoffTetrio: snapshot.data!.data[rank]!),
                                  ),
                                  );
                                },),
                              ),
                            ]
                          )
                        ],
                      ),
                    )
                  ] 
                ),
              );
            }
            if (snapshot.hasError){ return FutureError(snapshot); }
          }
        return Text("huh?");
      }
    );
  }
}
