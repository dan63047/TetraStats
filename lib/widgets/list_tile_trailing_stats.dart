import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/numers_formats.dart';

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
    const TextStyle style = TextStyle(height: 1.0, fontWeight: FontWeight.w100, fontSize: 14);
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      columnWidths: const {
        0: FixedColumnWidth(54),
        2: FixedColumnWidth(54),
      },
        children: [
        TableRow(children: [Text(f2.format(yourAPM), textAlign: TextAlign.right, style: style), const Text(" :", style: style), Text(f2.format(notyourAPM), textAlign: TextAlign.right, style: style), Text(" ${t.stats.apm.short}", textAlign: TextAlign.right, style: style)]),
        TableRow(children: [Text(f2.format(yourPPS), textAlign: TextAlign.right, style: style), const Text(" :", style: style), Text(f2.format(notyourPPS), textAlign: TextAlign.right, style: style), Text(" ${t.stats.pps.short}", textAlign: TextAlign.right, style: style)]),
        TableRow(children: [Text(f2.format(yourVS), textAlign: TextAlign.right, style: style), const Text(" :", style: style), Text(f2.format(notyourVS), textAlign: TextAlign.right, style: style), Text(" ${t.stats.vs.short}", textAlign: TextAlign.right, style: style)]),
      ],
    );
  }
}