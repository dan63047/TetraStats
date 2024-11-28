
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show prefs;
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

import 'text_timestamp.dart';

class TLRatingThingy extends StatelessWidget{
  final String userID;
  final TetraLeague tlData;
  final TetraLeague? oldTl;
  final double? topTR;
  final bool? showPositions;
  final DateTime? lastMatchPlayed;

  const TLRatingThingy({super.key, required this.userID, required this.tlData, this.oldTl, this.topTR, this.lastMatchPlayed, this.showPositions});

  @override
  Widget build(BuildContext context) {
    bool oskKagariGimmick = prefs.getBool("oskKagariGimmick")??true;
    bool bigScreen = MediaQuery.of(context).size.width >= 768;
    String decimalSeparator = f4.symbols.DECIMAL_SEP;
    List<String> formatedTR = f4.format(tlData.tr).split(decimalSeparator);
    List<String> formatedGlicko = tlData.glicko != null ? f4.format(tlData.glicko).split(decimalSeparator) : ["---","--"];
    List<String> formatedPercentile = f4.format(tlData.percentile * 100).split(decimalSeparator);
    //DateTime now = DateTime.now();
    //bool beforeS1end = now.isBefore(seasonEnd);
    //int daysLeft = seasonEnd.difference(now).inDays;
    //int safeRD = min(100, (100 + ((tlData.rd! >= 100 && tlData.decaying) ? 7 : max(0, 7 - (lastMatchPlayed != null ? now.difference(lastMatchPlayed!).inDays : 7))) - daysLeft).toInt());
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
          crossAxisAlignment: bigScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: bigScreen ? TextAlign.start : TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 20, color: Colors.white, height: 0.9),
                children: (tlData.gamesPlayed > 9) ? switch(prefs.getInt("ratingMode")){
                  1 => [
                    TextSpan(text: formatedGlicko[0], style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (formatedGlicko.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedGlicko[1]),
                    TextSpan(text: " Glicko", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                  ],
                  2 => [
                    TextSpan(text: "${t.top} ${formatedPercentile[0]}", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (formatedPercentile.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedPercentile[1]),
                    TextSpan(text: " %", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                  ],
                  _ => [
                  TextSpan(text: formatedTR[0], style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                  if (formatedTR.elementAtOrNull(1) != null) TextSpan(text: decimalSeparator + formatedTR[1]),
                  TextSpan(text: " TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28))
                ],
                } : [TextSpan(text: "---\n", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28, color: Colors.grey)), TextSpan(text: t.gamesUntilRanked(left: 10-tlData.gamesPlayed), style: const TextStyle(color: Colors.grey, fontSize: 14)),]
              )
            ),
            if (oldTl != null) RichText(
              textAlign: TextAlign.center,
              softWrap: true,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: switch(prefs.getInt("ratingMode")){
                    1 => "${fDiff.format(tlData.glicko! - oldTl!.glicko!)} Glicko",
                    2 => "${fDiff.format(tlData.percentile * 100 - oldTl!.percentile * 100)} %",
                    _ => "${fDiff.format(tlData.tr - oldTl!.tr)} TR"
                  },
                  style: TextStyle(
                      color: getDifferenceColor(switch(prefs.getInt("ratingMode")){
                      1 => tlData.glicko! - oldTl!.glicko!,
                      2 => tlData.percentile - oldTl!.percentile,
                      _ => tlData.tr - oldTl!.tr
                    })
                    ),
                  ),
                  const TextSpan(text: " • ", style: TextStyle(color: Colors.grey)),
                  TextSpan(text: switch(prefs.getInt("ratingMode")){
                    1 => "${fDiff.format(tlData.tr - oldTl!.tr)} TR",
                    _ => "${fDiff.format(tlData.glicko! - oldTl!.glicko!)} Glicko"
                  },
                  style: TextStyle(
                      color: getDifferenceColor(switch(prefs.getInt("ratingMode")){
                      1 => tlData.tr - oldTl!.tr,
                      _ => tlData.glicko! - oldTl!.glicko!
                    })
                    ),
                  ),
                  const TextSpan(text: " • ", style: TextStyle(color: Colors.grey)),
                  TextSpan(
                    text: "${fDiff.format(tlData.rd! - oldTl!.rd!)} RD",
                    style: TextStyle(color: getDifferenceColor(oldTl!.rd! - tlData.rd!))
                  )
                ],
              ),
            ),
            if (tlData.gamesPlayed > 9) Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: prefs.getInt("ratingMode") == 2 ? "${f2.format(tlData.tr)} TR  • % ${t.rank}: ${tlData.percentileRank.toUpperCase()}" : "${t.top} ${f2.format(tlData.percentile * 100)}% (${tlData.percentileRank.toUpperCase()})"),
                      if (tlData.bestRank != "z") const TextSpan(text: " • "),
                      if (tlData.bestRank != "z") TextSpan(text: t.stats.topRank(rank: tlData.bestRank.toUpperCase())),
                      if (topTR != null) TextSpan(text: " (${f2.format(topTR)} TR)"),
                      TextSpan(text: " • ${prefs.getInt("ratingMode") == 1 ? "${f2.format(tlData.tr)} TR • RD: " : "Glicko: ${tlData.glicko != null ? f2.format(tlData.glicko) : "---"}±"}"),
                      TextSpan(text: f2.format(tlData.rd!), style: tlData.decaying ? TextStyle(color: tlData.rd! > 98 ? Colors.red : Colors.yellow) : null),
                      if (tlData.decaying) WidgetSpan(child: Icon(Icons.trending_up, color: tlData.rd! > 98 ? Colors.red : Colors.yellow,), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic),
                      //if (beforeS1end) tlData.rd! <= safeRD ? TextSpan(text: " (Safe)", style: TextStyle(color: Colors.greenAccent)) : TextSpan(text: " (> ${safeRD} RD !!!)", style: TextStyle(color: Colors.redAccent))
                    ],
                  ),
                ),
              ],
            ),
            if (showPositions == true) RichText(
              textAlign: bigScreen ? TextAlign.start : TextAlign.center,
              text: TextSpan(
              text: "",
              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
              children: [
                if (tlData.standing != -1) TextSpan(text: "№ ${intf.format(tlData.standing)}", style: TextStyle(color: getColorOfRank(tlData.standing))),
                if (tlData.standing != -1 || tlData.standingLocal != -1) const TextSpan(text: " • "),
                if (tlData.standingLocal != -1) TextSpan(text: "№ ${intf.format(tlData.standingLocal)} local", style: TextStyle(color: getColorOfRank(tlData.standingLocal))),
                if (tlData.standing != -1 && tlData.standingLocal != -1) const TextSpan(text: " • "),
                TextSpan(text: timestamp(tlData.timestamp)),
              ]
              ),
            ),
          ],
        ),
      ],
    );
  }
}