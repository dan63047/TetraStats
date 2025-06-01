import 'package:flutter/material.dart' hide Badge;
import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/leaderboard_position.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class EtrThingy extends StatelessWidget{
  final EstTr etr;
  final EstTr? oldEtr;
  final LeaderboardPosition? lbPosition;
  final double? tr;
  final double? oldTR;
  final bool wide;
  const EtrThingy(this.etr, this.tr, this.wide, {this.oldEtr, this.lbPosition, this.oldTR, super.key});

  @override
  Widget build(BuildContext context) {
    String rawEtr = f2.format(etr.esttr);
    double etrAcc = etr.esttr - (tr??-1);
    double? oldEtrAcc = (oldTR != null && oldEtr != null) ? oldEtr!.esttr - oldTR! : null;
    String rawEtrAcc = comparef2.format(etrAcc);
    List<String> splitEtr = rawEtr.split(f2.symbols.DECIMAL_SEP);
    List<String> splitEtrAcc = rawEtrAcc.split(comparef2.symbols.DECIMAL_SEP);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints.loose(Size(536.0, double.infinity)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Tooltip(
                message: "One very weird formula takes your APM, PPS and VS, and tries to guess your TR",
                child: Column(
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
                      if (oldEtr?.esttr != null) TextSpan(text: comparef.format(etr.esttr - oldEtr!.esttr), style: TextStyle(color: oldEtr!.esttr > etr.esttr ? Colors.redAccent : Colors.greenAccent)),
                      if (lbPosition != null && oldEtr?.esttr != null) const TextSpan(text: " • "),
                      if (lbPosition != null) TextSpan(text: lbPosition!.position >= 1000 ? "${t.top} ${f2.format(lbPosition!.percentage*100)}%" : "№${lbPosition!.position}", style: TextStyle(color: getColorOfRank(lbPosition!.position))),
                      if (oldEtr?.esttr != null) const TextSpan(text: " • "),
                      TextSpan(text: "Glicko: ${f2.format(etr.estglicko)}")
                    ]
                    ),
                  ),
                ],),
              ),
              Tooltip(
                message: "Shows the difference between your TR and Estimated TR",
                child: Column(
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
                  if (tr != null) RichText(text: TextSpan(
                    text: "",
                    style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.5),
                    children: [
                      if (oldEtrAcc != null) TextSpan(text: comparef.format(etrAcc - oldEtrAcc), style: TextStyle(color: oldEtrAcc > etrAcc ? Colors.redAccent : Colors.greenAccent),),
                      //if (oldTl?.esttracc != null && widget.lbPositions?.accOfEst != null) const TextSpan(text: " • "),
                      //if (widget.lbPositions?.accOfEst != null) TextSpan(text: widget.lbPositions!.accOfEst!.position >= 1000 ? "${t.top} ${f2.format(widget.lbPositions!.accOfEst!.percentage*100)}%" : "№${widget.lbPositions!.accOfEst!.position}", style: TextStyle(color: getColorOfRank(widget.lbPositions!.accOfEst!.position)))
                    ]
                    ),
                  ),
                ],),
              ),
            ],),
          ),
        ),
      ),
    );
  }
}