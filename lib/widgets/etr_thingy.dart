import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class EtrThingy extends StatelessWidget{
  final EstTr etr;
  final double? tr;
  final bool wide;
  const EtrThingy(this.etr, this.tr, this.wide, {super.key});

  @override
  Widget build(BuildContext context) {
    String rawEtr = f2.format(etr.esttr);
    String rawEtrAcc = comparef2.format(etr.esttr - (tr??-1));
    List<String> splitEtr = rawEtr.split(f2.symbols.DECIMAL_SEP);
    List<String> splitEtrAcc = rawEtrAcc.split(comparef2.symbols.DECIMAL_SEP);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(t.stats.etr.full, style: const TextStyle(height: 0.1),),
            RichText(
              text: TextSpan(
                text: splitEtr[0],
                style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: wide ? 36 : 30, fontWeight: FontWeight.w500, color: Colors.white),
                children: [TextSpan(text: f2.symbols.DECIMAL_SEP+splitEtr[1], style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                ),
              ),
            RichText(text: TextSpan(
              text: "",
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.5),
              children: [
                // if (oldTl?.estTr?.esttr != null) TextSpan(text: comparef.format(currentTl.estTr!.esttr - oldTl!.estTr!.esttr), style: TextStyle(
                //   color: oldTl!.estTr!.esttr > currentTl.estTr!.esttr ? Colors.redAccent : Colors.greenAccent
                // ),),
                // if (oldTl?.estTr?.esttr != null) const TextSpan(text: " • "),
                // if (widget.lbPositions?.estTr != null) TextSpan(text: widget.lbPositions!.estTr!.position >= 1000 ? "${t.top} ${f2.format(widget.lbPositions!.estTr!.percentage*100)}%" : "№${widget.lbPositions!.estTr!.position}", style: TextStyle(color: getColorOfRank(widget.lbPositions!.estTr!.position))),
                // if (widget.lbPositions?.estTr != null || oldTl?.estTr?.esttr != null) const TextSpan(text: " • "),
                TextSpan(text: "Glicko: ${f2.format(etr.estglicko)}")
              ]
              ),
            ),
          ],),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text(t.stats.etracc.full, style: const TextStyle(height: 0.1),),
            RichText(
              text: TextSpan(
                text: (tr != null) ? splitEtrAcc[0] : "---",
                style: TextStyle(fontFamily: "Eurostile Round", fontSize: wide ? 36 : 30, fontWeight: FontWeight.w500, color: Colors.white),
                children: [
                  TextSpan(text: (tr != null) ? comparef2.symbols.DECIMAL_SEP+splitEtrAcc[1] : comparef2.symbols.DECIMAL_SEP+"---", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))
                ]
                ),
              ),
            // if ((oldTl?.esttracc != null || widget.lbPositions != null) && currentTl.bestRank != "z") RichText(text: TextSpan(
            //   text: "",
            //   style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.5),
            //   children: [
            //     if (oldTl?.esttracc != null) TextSpan(text: comparef.format(currentTl.esttracc! - oldTl!.esttracc!), style: TextStyle(
            //       color: oldTl!.esttracc! > currentTl.esttracc! ? Colors.redAccent : Colors.greenAccent
            //     ),),
            //     if (oldTl?.esttracc != null && widget.lbPositions?.accOfEst != null) const TextSpan(text: " • "),
            //     if (widget.lbPositions?.accOfEst != null) TextSpan(text: widget.lbPositions!.accOfEst!.position >= 1000 ? "${t.top} ${f2.format(widget.lbPositions!.accOfEst!.percentage*100)}%" : "№${widget.lbPositions!.accOfEst!.position}", style: TextStyle(color: getColorOfRank(widget.lbPositions!.accOfEst!.position)))
            //   ]
            //   ),
            // ),
          ],),
        ],),
      ),
    );
  }
}