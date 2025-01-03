import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/clears.dart';
import 'package:tetra_stats/gen/strings.g.dart';

class LineclearsThingy extends StatelessWidget{
  final Clears clears;
  final int lines;
  final int holds;
  final int tSpins;
  final bool showMoreClears;

  const LineclearsThingy(this.clears, this.lines, this.holds, this.tSpins, {super.key, this.showMoreClears = false});
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.stats.linesCleared(n: lines), style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended"), textAlign: TextAlign.center),
              if (showMoreClears) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.lineClears.penta), Text(clears.pentas.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.lineClears.quad), Text(clears.quads.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.lineClears.triple), Text(clears.triples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.lineClears.double), Text(clears.doubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.lineClears.single), Text(clears.singles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("\n${t.stats.pcs}"), Text("\n${clears.allClears.toString()}")]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.stats.holds), Text(holds.toString())]),
            ],
          ),
        ),
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.stats.tspinsTotal(n: tSpins), style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended"), textAlign: TextAlign.center),
              if (showMoreClears) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.penta}"), Text(clears.tSpinPentas.toString())]),
              if (showMoreClears) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.quad}"), Text(clears.tSpinQuads.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.triple}"), Text(clears.tSpinTriples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.double}"), Text(clears.tSpinDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.single}"), Text(clears.tSpinSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.tSpins} ${t.stats.lineClears.zero}"), Text(clears.tSpinZeros.toString())]),
              if (showMoreClears) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.quad}"), Text(clears.tSpinMiniQuads.toString())]),
              if (showMoreClears) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.triple}"), Text(clears.tSpinMiniTriples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.double}"), Text(clears.tSpinMiniDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.single}"), Text(clears.tSpinMiniSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${t.stats.mini} ${t.stats.tSpins} ${t.stats.lineClears.zero}"), Text(clears.tSpinMiniZeros.toString())]),
            ],
          ),
        ),
      ],
    );
  }
}