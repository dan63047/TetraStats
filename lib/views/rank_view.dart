import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

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
                            child: Text("${widget.rank.toUpperCase()} rank data", style: TextStyle(fontSize: 28)),
                          ))),
                      Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("res/tetrio_tl_alpha_ranks/${widget.rank}.png",fit: BoxFit.fitHeight,height: 128),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Supposed to be", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${intf.format(widget.cutoffTetrio.targetTr)} — ${intf.format(widget.nextRankTargetTR)}", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Padding(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("LB pos range", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${percentage.format(widget.cutoffTetrio.percentile)} — ${percentage.format(widget.nextRankPercentile)}", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("(${percentage.format(percentileGap)} gap)", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey, fontSize: 14))
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Supposed to be", style: Theme.of(context).textTheme.displayLarge),
                                  Text("${intf.format(supposedToBePlayers)} players", style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Padding(
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
                              Divider(),
                              Text("Average Stats", style: Theme.of(context).textTheme.displayLarge),
                              Text("${f2.format(widget.cutoffTetrio.apm)} APM • ${f2.format(widget.cutoffTetrio.pps)} PPS • ${f2.format(widget.cutoffTetrio.vs)} VS", style: Theme.of(context).textTheme.displayLarge),
                              Divider(),
                              Center(child: Text("Average Nerd Stats", style: Theme.of(context).textTheme.displayLarge)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Attack Per Piece", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.app), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("VS / APM", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.vsapm), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Downstack Per Second", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.dss), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Downstack Per Piece", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.dsp), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("APP + DSP", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.appdsp), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cheese Index", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f2.format(widget.cutoffTetrio.nerdStats?.cheese), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Garbage Efficiency", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.gbe), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Weighted APP", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f3.format(widget.cutoffTetrio.nerdStats?.nyaapp), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Area", style: Theme.of(context).textTheme.displayLarge),
                                  Text(f1.format(widget.cutoffTetrio.nerdStats?.area), style: Theme.of(context).textTheme.displayLarge)
                                ],
                              ),
                        
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth - 350,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    SegmentedButton<CardMod>(
                      showSelectedIcon: false,
                      selected: <CardMod>{cardMod},
                      segments: <ButtonSegment<CardMod>>[
                        ButtonSegment<CardMod>(
                          value: CardMod.graph,
                          label: Text("Graph"),
                        ),
                        ButtonSegment<CardMod>(
                          value: CardMod.graph,
                          label: Text("Minimums"),
                        ),
                        ButtonSegment<CardMod>(
                          value: CardMod.graph,
                          label: Text("Maximums"),
                        )
                      ],
                      onSelectionChanged: (p0) {
                        setState(() {
                          cardMod = p0.first;
                          //_transition.;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          );
        },),
      ),
    );
  }
}