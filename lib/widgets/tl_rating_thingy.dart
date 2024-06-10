import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show prefs;
import 'package:tetra_stats/utils/numers_formats.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");

class TLRatingThingy extends StatelessWidget{
  final String userID;
  final TetraLeagueAlpha tlData;
  final TetraLeagueAlpha? oldTl;
  final double? topTR;

  const TLRatingThingy({required this.userID, required this.tlData, this.oldTl, this.topTR});

  @override
  Widget build(BuildContext context) {
    bool oskKagariGimmick = prefs.getBool("oskKagariGimmick")??true;
    bool bigScreen = MediaQuery.of(context).size.width >= 768;
    int test = 0;
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        (userID == "5e32fc85ab319c2ab1beb07c" && oskKagariGimmick) // he love her so much, you can't even imagine
            ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
            : Image.asset("res/tetrio_tl_alpha_ranks/${tlData.rank}.png", height: 128),
        Column(
          children: [
            Text(
              switch(prefs.getInt("ratingMode")){
                1 => "${f2.format(tlData.glicko)} Glicko",
                2 => "Top ${tlData.percentile < 0.1 ? f3.format(tlData.percentile * 100) : f2.format(tlData.percentile * 100)}%",
                _ => "${(tlData.rating >= 24999 || tlData.rating < 100) ? f4.format(tlData.rating) : f2.format(tlData.rating)} TR",
              },
              style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)
            ),
            // Text("${f4.format(25000.0 - tlData.rating)} TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
            if (oldTl != null) Text(
              "${fDiff.format(tlData.rating - oldTl!.rating)} TR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tlData.rating - oldTl!.rating < 0 ?
                Colors.red :
                Colors.green
              ),
            ),
            Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: prefs.getInt("ratingMode") == 2 ? "${f2.format(tlData.rating)} TR  • % rank: ${tlData.percentileRank.toUpperCase()}" : "${t.top} ${f2.format(tlData.percentile * 100)}% (${tlData.percentileRank.toUpperCase()})"),
                      if (tlData.bestRank != "z") const TextSpan(text: " • "),
                      if (tlData.bestRank != "z") TextSpan(text: "${t.topRank}: ${tlData.bestRank.toUpperCase()}"),
                      if (topTR != null) TextSpan(text: " (${f2.format(topTR)} TR)"),
                      TextSpan(text: " • ${prefs.getInt("ratingMode") == 1 ? "${f2.format(tlData.rating)} TR • RD: " : "Glicko: ${f2.format(tlData.glicko!)}±"}"),
                      TextSpan(text: f2.format(tlData.rd!), style: tlData.decaying ? TextStyle(color: tlData.rd! > 98 ? Colors.red : Colors.yellow) : null),
                      if (tlData.decaying) WidgetSpan(child: Icon(Icons.trending_up, color: tlData.rd! > 98 ? Colors.red : Colors.yellow,), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic) 
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}