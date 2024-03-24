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
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.numOfGameActions.lineClears(n: lines), style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended"), textAlign: TextAlign.center),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Quads"), Text(clears.quads.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Triples"), Text(clears.triples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Doubles"), Text(clears.doubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Singles"), Text(clears.singles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("\n${t.numOfGameActions.pc}"), Text("\n${clears.allClears.toString()}")]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t.numOfGameActions.hold), Text(holds.toString())]),
            ],
          ),
        ),
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.numOfGameActions.tspinsTotal(n: tSpins), style: const TextStyle(color: Colors.white, fontFamily: "Eurostile Round Extended"), textAlign: TextAlign.center),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("T-spins triples"), Text(clears.tSpinTriples.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("T-spins doubles"), Text(clears.tSpinDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("T-spins singles"), Text(clears.tSpinSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("T-spins zeros"), Text(clears.tSpinZeros.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Mini T-spins doubles"), Text(clears.tSpinMiniDoubles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Mini T-spins singles"), Text(clears.tSpinMiniSingles.toString())]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Mini T-spins zeros"), Text(clears.tSpinMiniZeros.toString())]),
            ],
          ),
        ),
      ],
    );
  }
}