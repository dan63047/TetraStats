import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';

class LineclearsThingy extends StatelessWidget{
  final Clears clears;
  final int lines;
  final int holds;
  final int tSpins;

  const LineclearsThingy(this.clears, this.lines, this.holds, this.tSpins, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        Container(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.numOfGameActions.lineClears(n: lines), style: TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended")),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Quads"), Text(clears.quads.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Triples"), Text(clears.triples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Doubles"), Text(clears.doubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Singles"), Text(clears.singles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("\n${t.numOfGameActions.pc}"), Text("\n${clears.allClears.toString()}")]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.numOfGameActions.hold), Text(holds.toString())]),
            ],
          ),
        ),
        Container(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.numOfGameActions.tspinsTotal(n: tSpins), style: TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended")),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("T-spins triples"), Text(clears.tSpinTriples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("T-spins doubles"), Text(clears.tSpinDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("T-spins singles"), Text(clears.tSpinSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("T-spins zeros"), Text(clears.tSpinZeros.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Mini T-spins doubles"), Text(clears.tSpinMiniDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Mini T-spins singles"), Text(clears.tSpinMiniSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Mini T-spins zeros"), Text(clears.tSpinMiniZeros.toString())]),
            ],
          ),
        ),
      ],
    );
  }
}