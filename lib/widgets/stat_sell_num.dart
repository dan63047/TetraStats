import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

class StatCellNum extends StatelessWidget {
  const StatCellNum(
      {super.key,
      required this.playerStat,
      required this.playerStatLabel,
      required this.isScreenBig,
      this.smallDecimal = false,
      this.alertWidgets,
      this.fractionDigits,
      this.oldPlayerStat,
      required this.higherIsBetter,
      this.okText, this.alertTitle, this.pos, this.averageStat});

  final num playerStat;
  final num? oldPlayerStat;
  final bool higherIsBetter;
  final String playerStatLabel;
  final String? okText;
  final bool isScreenBig;
  final bool smallDecimal;
  final String? alertTitle;
  final List<Widget>? alertWidgets;
  final int? fractionDigits;
  final LeaderboardPosition? pos;
  final num? averageStat;

  Color getStatColor(){
    if (averageStat == null) return Colors.white;
    num percentile = (higherIsBetter ? playerStat / averageStat! : averageStat! / playerStat).abs();
    if (percentile > 1.50) return Colors.purpleAccent;
    if (percentile > 1.20) return Colors.blueAccent;
    if (percentile > 0.90) return Colors.greenAccent;
    if (percentile > 0.70) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: fractionDigits ?? 0);
    NumberFormat comparef = NumberFormat("+#,###.###;-#,###.###")..maximumFractionDigits = fractionDigits ?? 0;
    String formated = f.format(playerStat);
    List<String> splited = formated.split(f.symbols.DECIMAL_SEP);
    return Column(
      children: [
        RichText(
          text: TextSpan(text: splited[0],
          children: [
            if ((fractionDigits??0) > 0 && splited.elementAtOrNull(1) != null) TextSpan(text: f.symbols.DECIMAL_SEP+splited[1], style: smallDecimal ? const TextStyle(fontFamily: "Eurostile Round", fontSize: 16) : null)
          ],
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            fontSize: isScreenBig ? 32 : 24,
            color: getStatColor()
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
            if (pos != null) TextSpan(text: pos!.position >= 1000 ? "${t.top} ${f2.format(pos!.percentage*100)}%" : "№${pos!.position}", style: TextStyle(color: getColorOfRank(pos!.position)))
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
                    padding: WidgetStateProperty.all(EdgeInsets.zero)),
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
