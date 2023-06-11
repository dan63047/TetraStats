import 'package:flutter/material.dart';

class StatCellNum extends StatelessWidget {
  const StatCellNum({super.key, required this.playerStat, required this.playerStatLabel, required this.isScreenBig, this.snackBar, this.fractionDigits});

  final num playerStat;
  final String playerStatLabel;
  final bool isScreenBig;
  final String? snackBar;
  final int? fractionDigits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fractionDigits != null ? playerStat.toStringAsFixed(fractionDigits!) : playerStat.floor().toString(),
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            fontSize: isScreenBig ? 32 : 24,
          ),
        ),
        snackBar == null
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackBar!)));
                },
                style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
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
