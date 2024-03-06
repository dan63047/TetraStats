import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class StatCellNum extends StatelessWidget {
  const StatCellNum(
      {super.key,
      required this.playerStat,
      required this.playerStatLabel,
      required this.isScreenBig,
      this.alertWidgets,
      this.fractionDigits,
      this.oldPlayerStat,
      required this.higherIsBetter,
      this.okText, this.alertTitle, this.pos});

  final num playerStat;
  final num? oldPlayerStat;
  final bool higherIsBetter;
  final String playerStatLabel;
  final String? okText;
  final bool isScreenBig;
  final String? alertTitle;
  final List<Widget>? alertWidgets;
  final int? fractionDigits;
  final LeaderboardPosition? pos;

  @override
  Widget build(BuildContext context) {
    NumberFormat comparef = NumberFormat("+#,###.###;-#,###.###")..maximumFractionDigits = fractionDigits ?? 0;
    NumberFormat fractionf = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits ?? 0)..maximumIntegerDigits = 0;
    num fraction = playerStat.isNegative ? 1 - (playerStat - playerStat.floor()) : playerStat - playerStat.floor();
    int integer = playerStat.isNegative ? (playerStat + fraction).toInt() : (playerStat - fraction).toInt();
    // String valueAsString = fractionDigits == null ? f.format(playerStat.floor()) : f.format(playerStat);
    // var exploded = valueAsString.split(".");
    return Column(
      children: [
        RichText(
          text: TextSpan(text: intf.format(integer),
          children: [
            TextSpan(text: fractionf.format(fraction).substring(1), style: const TextStyle(fontSize: 16))
          ],
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            //fontWeight: FontWeight.bold,
            fontSize: isScreenBig ? 32 : 24,
            color: Colors.white
            )
          )
        ),
        if (oldPlayerStat != null || pos != null) RichText(text: TextSpan(
          text: "",
          style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
          children: [
            if (oldPlayerStat != null) TextSpan(text: comparef.format(playerStat - oldPlayerStat!), style: TextStyle(
              color: higherIsBetter ?
              oldPlayerStat! > playerStat ? Colors.redAccent : Colors.greenAccent :
              oldPlayerStat! < playerStat ? Colors.redAccent : Colors.greenAccent
            ),),
            if (oldPlayerStat != null && pos != null) const TextSpan(text: " • "),
            if (pos != null) TextSpan(text: pos!.position >= 1000 ? "Top ${f2.format(pos!.percentage*100)}%" : "№${pos!.position}")
          ]
          ),
        ), 
        alertWidgets == null
            ? Text(
                playerStatLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Eurostile Round",
                  fontSize: 16,
                  height: 1.1
                ),
              )
            : TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(alertTitle??playerStatLabel.replaceAll(RegExp(r'\n'), " "),
                                style: const TextStyle(
                                    fontFamily: "Eurostile Round Extended")),
                            content: SingleChildScrollView(
                              child: ListBody(children: alertWidgets!),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(okText??"OK"),
                                onPressed: () {Navigator.of(context).pop();}
                              )
                      ],
                    )
                  );
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Text(
                  playerStatLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Eurostile Round",
                    fontSize: 16,
                    height: 1.1
                  ),
                )),
      ],
    );
  }
}
