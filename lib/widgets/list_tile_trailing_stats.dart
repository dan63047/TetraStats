import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';

class TrailingStats extends StatelessWidget{
  final double yourAPM;
  final double yourPPS;
  final double yourVS;
  final double notyourAPM;
  final double notyourPPS;
  final double notyourVS;

  const TrailingStats(this.yourAPM, this.yourPPS, this.yourVS, this.notyourAPM, this.notyourPPS, this.notyourVS, {super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      columnWidths: const {
        0: FixedColumnWidth(42),
        2: FixedColumnWidth(42),
      },
        children: [
        TableRow(children: [Text(f2.format(yourAPM), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(f2.format(notyourAPM), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" APM", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
        TableRow(children: [Text(f2.format(yourPPS), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(f2.format(notyourPPS), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" PPS", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
        TableRow(children: [Text(f2.format(yourVS), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" :", style: TextStyle(height: 1.1)), Text(f2.format(notyourVS), textAlign: TextAlign.right, style: const TextStyle(height: 1.1)), const Text(" VS", textAlign: TextAlign.right, style: TextStyle(height: 1.1))]),
      ],
    );
  }
}