import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/future_error.dart';

class RankView extends StatefulWidget {
  final String rank;
  final double nextRankTR;
  final double nextRankPercentile;
  final double nextRankTargetTR;
  final int totalPlayers;
  final CutoffTetrio cutoffTetrio;

  const RankView({super.key, required this.rank, required this.nextRankTR, required this.nextRankPercentile, required this.nextRankTargetTR, required this.totalPlayers, required this.cutoffTetrio});

  @override
  State<RankView> createState() => _RankState();
}

enum CardMod{
  graph,
  minimums,
  maximums
}

class _RankState extends State<RankView> {
  CardMod cardMod = CardMod.graph;

  Future<List> getRanksAverages(String rank) async {
    var lb = await teto.fetchTLLeaderboard();
    return lb.getRankData(rank);
  }

  Widget partOfTheWidget(List<dynamic>? data){
    return Column(
      children: [
        Divider(),
          Text("Average Stats", style: Theme.of(context).textTheme.displayLarge),
          Text("${f2.format(data != null ? data[0].apm : widget.cutoffTetrio.apm)} APM • ${f2.format(data != null ? data[0].pps : widget.cutoffTetrio.pps)} PPS • ${f2.format(data != null ? data[0].vs : widget.cutoffTetrio.vs)} VS", style: Theme.of(context).textTheme.displayLarge),
          Divider(),
          Center(child: Text("Average Nerd Stats", style: Theme.of(context).textTheme.displayLarge)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attack Per Piece", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgAPP"] : widget.cutoffTetrio.nerdStats?.app), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("VS / APM", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgVSAPM"] : widget.cutoffTetrio.nerdStats?.vsapm), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Downstack Per Second", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgDSS"] : widget.cutoffTetrio.nerdStats?.dss), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Downstack Per Piece", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgDSP"] : widget.cutoffTetrio.nerdStats?.dsp), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("APP + DSP", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgAPPDSP"] : widget.cutoffTetrio.nerdStats?.appdsp), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cheese Index", style: Theme.of(context).textTheme.displayLarge),
              Text(f2.format(data != null ? data[1]["avgCheese"] : widget.cutoffTetrio.nerdStats?.cheese), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Garbage Efficiency", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgGBE"] : widget.cutoffTetrio.nerdStats?.gbe), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weighted APP", style: Theme.of(context).textTheme.displayLarge),
              Text(f3.format(data != null ? data[1]["avgNyaAPP"] : widget.cutoffTetrio.nerdStats?.nyaapp), style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Area", style: Theme.of(context).textTheme.displayLarge),
              Text(f1.format(data != null ? data[1]["avgArea"] : widget.cutoffTetrio.nerdStats?.area), style: Theme.of(context).textTheme.displayLarge)
            ],
          ), 
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double percentileGap = widget.cutoffTetrio.percentile - widget.nextRankPercentile;
    int supposedToBePlayers = (widget.totalPlayers * percentileGap).floor();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Fuck go back',
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(
                width: 350.0,
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(child: Center(child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 5.0, 10.0),
                            child: Text(widget.rank == "" ? "Everyone" : "${widget.rank.toUpperCase()} rank data", style: TextStyle(fontSize: 28)),
                          ))),
                      Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("res/tetrio_tl_alpha_ranks/${widget.rank == "" ? "z" : widget.rank}.png",fit: BoxFit.fitHeight,height: 128),
                                Text("${intf.format(widget.cutoffTetrio.count)} players", style: Theme.of(context).textTheme.titleSmall,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("TR range", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${f2.format(widget.cutoffTetrio.tr)} — ${f2.format(widget.nextRankTR)}", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("(${f2.format(widget.nextRankTR - widget.cutoffTetrio.tr)} TR gap)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                              ),
                              if (widget.rank != "") Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Supposed to be", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${intf.format(widget.cutoffTetrio.targetTr)} — ${intf.format(widget.nextRankTargetTR)}", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              if (widget.rank != "") Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("(${intf.format(widget.nextRankTargetTR - widget.cutoffTetrio.targetTr)} TR gap)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                              ),
                              if (widget.nextRankTargetTR < widget.nextRankTR) Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Inflation gap", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.redAccent)),
                                  Text("${f2.format(widget.nextRankTR - widget.nextRankTargetTR)} TR", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.redAccent))
                                ],
                              ),
                              if (widget.cutoffTetrio.tr < widget.cutoffTetrio.targetTr) Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Deflation gap", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.greenAccent)),
                                  Text("${f2.format(widget.cutoffTetrio.targetTr - widget.cutoffTetrio.tr)} TR", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.greenAccent))
                                ],
                              ),
                              if (widget.rank != "") Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("LB pos range", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${percentage.format(widget.cutoffTetrio.percentile)} — ${percentage.format(widget.nextRankPercentile)}", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              if (widget.rank != "") Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("(${percentage.format(percentileGap)} gap)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                              ),
                              if (widget.rank != "") Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Supposed to be", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${intf.format(supposedToBePlayers)} players", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              if (widget.rank != "") Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    if (widget.cutoffTetrio.count > supposedToBePlayers) Text("(overpopulated by a ${intf.format(widget.cutoffTetrio.count - supposedToBePlayers)} players)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                    else if (widget.cutoffTetrio.count < supposedToBePlayers) Text("(underpopulated by a ${intf.format(supposedToBePlayers - widget.cutoffTetrio.count)} players)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                    else Text("(cute)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                              ),
                              if (widget.rank == "") FutureBuilder<List<dynamic>>(
                                future: getRanksAverages(widget.rank),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState){
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return const Center(child: CircularProgressIndicator());
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      if (snapshot.hasData){
                                        return partOfTheWidget(snapshot.data);
                                      }
                                      if (snapshot.hasError) return FutureError(snapshot);
                                  }
                                  return Text("End of the FutureBuilder");
                                },
                              )
                              else partOfTheWidget(null)                   
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
              SizedBox(
                width: constraints.maxWidth - 350,
                child: FutureBuilder<List<dynamic>>(
                  future: getRanksAverages(widget.rank),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      if (snapshot.hasError){ return FutureError(snapshot); }
                      if (snapshot.hasData){
                        return SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.0,
                                child: Card(
                                  child: Column(
                                    children: [
                                      Text("Cheese Index", style: TextStyle(fontSize: 28, color: Colors.transparent)),
                                      Divider(),
                                      RankViewEntry("Tetra Rating", null, null),
                                      RankViewEntry("Glicko", null, null, differentBG: true),
                                      RankViewEntry("RD", null, null),
                                      RankViewEntry("Glixare", null, null, differentBG: true),
                                      RankViewEntry("S1 TR", null, null),
                                      RankViewEntry("Games Played", null, null, differentBG: true),
                                      RankViewEntry("Games Won", null, null),
                                      RankViewEntry("Winrate", null, null, differentBG: true),
                                      RankViewEntry("Attack Per Minute", null, null),
                                      RankViewEntry("Pieces Per Second", null, null, differentBG: true),
                                      RankViewEntry("Versus Score", null, null),
                                      RankViewEntry("Attack Per Piece", null, null, differentBG: true),
                                      RankViewEntry("VS / APM", null, null),
                                      RankViewEntry("Downstack Per Second", null, null, differentBG: true),
                                      RankViewEntry("Downstack Per Piece", null, null),
                                      RankViewEntry("APP + DS/P", null, null, differentBG: true),
                                      RankViewEntry("Cheese Index", null, null),
                                      RankViewEntry("Garbage Efficiency", null, null, differentBG: true),
                                      RankViewEntry("Weighted APP", null, null),
                                      RankViewEntry("Area", null, null, differentBG: true),
                                      RankViewEntry("Estimated TR", null, null),
                                      RankViewEntry("Est. TR Accuracy", null, null, differentBG: true),
                                      RankViewEntry("Opener", null, null),
                                      RankViewEntry("Plonk", null, null, differentBG: true),
                                      RankViewEntry("Stride", null, null),
                                      RankViewEntry("Infinite Downstack", null, null, differentBG: true),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Text("Minimums", style: TextStyle(fontSize: 28)),
                                      Divider(),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestTR"])} TR", snapshot.data![1]["lowestTRnick"], snapshot.data![1]["lowestTRid"]),
                                      RankViewEntry(f4.format(snapshot.data![1]["lowestGlicko"]), snapshot.data![1]["lowestGlickoNick"], snapshot.data![1]["lowestGlickoID"], differentBG: true),
                                      RankViewEntry(f4.format(snapshot.data![1]["lowestRD"]), snapshot.data![1]["lowestRdNick"], snapshot.data![1]["lowestRdID"]),
                                      RankViewEntry(f4.format(snapshot.data![1]["lowestGlixare"]), snapshot.data![1]["lowestGlixareNick"], snapshot.data![1]["lowestGlixareID"], differentBG: true),
                                      RankViewEntry(f2.format(snapshot.data![1]["lowestS1tr"]), snapshot.data![1]["lowestS1trNick"], snapshot.data![1]["lowestS1trID"]),
                                      RankViewEntry(intf.format(snapshot.data![1]["lowestGamesPlayed"]), snapshot.data![1]["lowestGamesPlayedNick"], snapshot.data![1]["lowestGamesPlayedID"], differentBG: true),
                                      RankViewEntry(intf.format(snapshot.data![1]["lowestGamesWon"]), snapshot.data![1]["lowestGamesWonNick"], snapshot.data![1]["lowestGamesWonID"]),
                                      RankViewEntry(percentage.format(snapshot.data![1]["lowestWinrate"]), snapshot.data![1]["lowestWinrateNick"], snapshot.data![1]["lowestWinrateID"], differentBG: true),
                                      RankViewEntry("${f2.format(snapshot.data![1]["lowestAPM"])} APM", snapshot.data![1]["lowestAPMnick"], snapshot.data![1]["lowestAPMid"]),
                                      RankViewEntry("${f2.format(snapshot.data![1]["lowestPPS"])} PPS", snapshot.data![1]["lowestPPSnick"], snapshot.data![1]["lowestPPSid"], differentBG: true),
                                      RankViewEntry("${f2.format(snapshot.data![1]["lowestVS"])} VS", snapshot.data![1]["lowestVSnick"], snapshot.data![1]["lowestVSid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestAPP"])} APP", snapshot.data![1]["lowestAPPnick"], snapshot.data![1]["lowestAPPid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestVSAPM"])} VS/APM", snapshot.data![1]["lowestVSAPMnick"], snapshot.data![1]["lowestVSAPMid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestDSS"])} DS/S", snapshot.data![1]["lowestDSSnick"], snapshot.data![1]["lowestDSSid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestDSP"])} DS/P", snapshot.data![1]["lowestDSPnick"], snapshot.data![1]["lowestDSPid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestAPPDSP"])} APP+DS/P", snapshot.data![1]["lowestAPPDSPnick"], snapshot.data![1]["lowestAPPDSPid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestCheese"])} Cheese", snapshot.data![1]["lowestCheeseNick"], snapshot.data![1]["lowestCheeseID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestGBE"])} Gbe", snapshot.data![1]["lowestGBEnick"], snapshot.data![1]["lowestGBEid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestNyaAPP"])} wAPP", snapshot.data![1]["lowestNyaAPPnick"], snapshot.data![1]["lowestNyaAPPid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestArea"])} Area", snapshot.data![1]["lowestAreaNick"], snapshot.data![1]["lowestAreaID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestEstTR"])} eTR", snapshot.data![1]["lowestEstTRnick"], snapshot.data![1]["lowestEstTRid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestEstAcc"])} ±eTR", snapshot.data![1]["lowestEstAccNick"], snapshot.data![1]["lowestEstAccID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestOpener"])}", snapshot.data![1]["lowestOpenerNick"], snapshot.data![1]["lowestOpenerID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestPlonk"])}", snapshot.data![1]["lowestPlonkNick"], snapshot.data![1]["lowestPlonkID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestStride"])}", snapshot.data![1]["lowestStrideNick"], snapshot.data![1]["lowestStrideID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["lowestInfDS"])}", snapshot.data![1]["lowestInfDSnick"], snapshot.data![1]["lowestInfDSid"], differentBG: true)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Text("Maximums", style: TextStyle(fontSize: 28)),
                                      Divider(),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestTR"])} TR", snapshot.data![1]["highestTRnick"], snapshot.data![1]["highestTRid"]),
                                      RankViewEntry(f4.format(snapshot.data![1]["highestGlicko"]), snapshot.data![1]["highestGlickoNick"], snapshot.data![1]["highestGlickoID"], differentBG: true),
                                      RankViewEntry(f4.format(snapshot.data![1]["highestRD"]), snapshot.data![1]["highestRdNick"], snapshot.data![1]["highestRdID"]),
                                      RankViewEntry(f4.format(snapshot.data![1]["highestGlixare"]), snapshot.data![1]["highestGlixareNick"], snapshot.data![1]["highestGlixareID"], differentBG: true),
                                      RankViewEntry(f2.format(snapshot.data![1]["highestS1tr"]), snapshot.data![1]["highestS1trNick"], snapshot.data![1]["highestS1trID"]),
                                      RankViewEntry(intf.format(snapshot.data![1]["highestGamesPlayed"]), snapshot.data![1]["highestGamesPlayedNick"], snapshot.data![1]["highestGamesPlayedID"], differentBG: true),
                                      RankViewEntry(intf.format(snapshot.data![1]["highestGamesWon"]), snapshot.data![1]["highestGamesWonNick"], snapshot.data![1]["highestGamesWonID"]),
                                      RankViewEntry(percentage.format(snapshot.data![1]["highestWinrate"]), snapshot.data![1]["highestWinrateNick"], snapshot.data![1]["highestWinrateID"], differentBG: true),
                                      RankViewEntry("${f2.format(snapshot.data![1]["highestAPM"])} APM", snapshot.data![1]["highestAPMnick"], snapshot.data![1]["highestAPMid"]),
                                      RankViewEntry("${f2.format(snapshot.data![1]["highestPPS"])} PPS", snapshot.data![1]["highestPPSnick"], snapshot.data![1]["highestPPSid"], differentBG: true),
                                      RankViewEntry("${f2.format(snapshot.data![1]["highestVS"])} VS", snapshot.data![1]["highestVSnick"], snapshot.data![1]["highestVSid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestAPP"])} APP", snapshot.data![1]["highestAPPnick"], snapshot.data![1]["highestAPPid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestVSAPM"])} VS/APM", snapshot.data![1]["highestVSAPMnick"], snapshot.data![1]["highestVSAPMid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestDSS"])} DS/S", snapshot.data![1]["highestDSSnick"], snapshot.data![1]["highestDSSid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestDSP"])} DS/P", snapshot.data![1]["highestDSPnick"], snapshot.data![1]["highestDSPid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestAPPDSP"])} APP+DS/P", snapshot.data![1]["highestAPPDSPnick"], snapshot.data![1]["highestAPPDSPid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestCheese"])} Cheese", snapshot.data![1]["highestCheeseNick"], snapshot.data![1]["highestCheeseID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestGBE"])} Gbe", snapshot.data![1]["highestGBEnick"], snapshot.data![1]["highestGBEid"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestNyaAPP"])} wAPP", snapshot.data![1]["highestNyaAPPnick"], snapshot.data![1]["highestNyaAPPid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestArea"])} Area", snapshot.data![1]["highestAreaNick"], snapshot.data![1]["highestAreaID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestEstTR"])} eTR", snapshot.data![1]["highestEstTRnick"], snapshot.data![1]["highestEstTRid"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestEstAcc"])} ±eTR", snapshot.data![1]["highestEstAccNick"], snapshot.data![1]["highestEstAccID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestOpener"])}", snapshot.data![1]["highestOpenerNick"], snapshot.data![1]["highestOpenerID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestPlonk"])}", snapshot.data![1]["highestPlonkNick"], snapshot.data![1]["highestPlonkID"], differentBG: true),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestStride"])}", snapshot.data![1]["highestStrideNick"], snapshot.data![1]["highestStrideID"]),
                                      RankViewEntry("${f4.format(snapshot.data![1]["highestInfDS"])}", snapshot.data![1]["highestInfDSnick"], snapshot.data![1]["highestInfDSid"], differentBG: true)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }
                    return const Text("End of FutureBuilder<List>");
                  }
                ),
              )
            ],
          );
        },),
      ),
    );
  }
}

class RankViewEntry extends StatelessWidget {
  final String formattedValue;
  final String? username;
  final String? userId;
  final bool differentBG;

  const RankViewEntry(this.formattedValue, this.username, this.userId, {this.differentBG = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: differentBG ? Colors.black26 : null),
      child: Center(
        child: Padding(
          padding: username != null ? EdgeInsets.only(bottom: 4.0) : EdgeInsets.all(0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
            text: formattedValue,
            style: Theme.of(context).textTheme.displayLarge,
            children: [
              TextSpan(text: username != null ? "\n(${username!.toUpperCase()})" : "\n", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
            ]
          )),
        ),
      ),
    );
  }
  
}