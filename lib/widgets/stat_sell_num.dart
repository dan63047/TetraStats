import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCellNum extends StatelessWidget {
  const StatCellNum(
      {super.key,
      required this.playerStat,
      required this.playerStatLabel,
      required this.isScreenBig,
      this.alertWidgets,
      this.fractionDigits, this.oldPlayerStat, required this.higherIsBetter});

  final num playerStat;
  final num? oldPlayerStat;
  final bool higherIsBetter;
  final String playerStatLabel;
  final bool isScreenBig;
  final List<Widget>? alertWidgets;
  final int? fractionDigits;

  @override
  Widget build(BuildContext context) {
    NumberFormat f =
        NumberFormat.decimalPatternDigits(decimalDigits: fractionDigits ?? 0);
    return Column(
      children: [
        Text(
          f.format(playerStat),
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            fontSize: isScreenBig ? 32 : 24,
          ),
        ),
        if (oldPlayerStat != null) Text(NumberFormat("+#,###.###;-#,###.###").format(playerStat - oldPlayerStat!), style: TextStyle(
          color: higherIsBetter ?
          oldPlayerStat! > playerStat ? Colors.red : Colors.green :
          oldPlayerStat! < playerStat ? Colors.red : Colors.green
        ),),
        alertWidgets == null
            ? Text(
                playerStatLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Eurostile Round",
                  fontSize: 16,
                ),
              )
            : TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(playerStatLabel,
                                style: const TextStyle(
                                    fontFamily: "Eurostile Round Extended")),
                            content: SingleChildScrollView(
                              child: ListBody(children: alertWidgets!),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Text(
                  playerStatLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Eurostile Round",
                    fontSize: 16,
                  ),
                )),
      ],
    );
  }
}
