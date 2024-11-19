import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/record_extras.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/gauget_thingy.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class ZenithThingy extends StatelessWidget{
  final RecordSingle? zenith;
  final bool old;
  final double width;

  const ZenithThingy({super.key, required this.zenith, this.old = false, this.width = double.infinity});

  List<TableRow> secondColumn(){
    return [
      TableRow(children: [
        Text(intf.format(zenith!.stats.kills), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" KO's", style: TextStyle(fontSize: 21))
      ]),
      TableRow(children: [
        Text(zenith!.stats.topBtB.toString(), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" B2B", style: TextStyle(fontSize: 21))
      ]),
      TableRow(children: [
        Text(zenith!.stats.garbage.maxspike_nomult.toString(), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" Top spike", style: TextStyle(fontSize: 21))
      ]),
      if (width <= 600) TableRow(children: [
        Text(f2.format(zenith!.stats.zenith!.peakrank), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
        const Text(" Peak CSP", style: TextStyle(fontSize: 21)),
      ])
    ];
  }

  List<TableRow> noRecordSecondColumn(){
    return [
      const TableRow(children: [
        Text("---", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
        Text(" KO's", style: TextStyle(fontSize: 21, color: Colors.grey))
      ]),
      const TableRow(children: [
        Text("---", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
        Text(" B2B", style: TextStyle(fontSize: 21, color: Colors.grey))
      ]),
      const TableRow(children: [
        Text("---", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
        Text(" Top spike", style: TextStyle(fontSize: 21, color: Colors.grey))
      ]),
      if (width <= 600) TableRow(children: [
        Text("-.--", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21, color: Colors.grey)),
        const Text(" Peak CSP", style: TextStyle(fontSize: 21, color: Colors.grey)),
      ])
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: zenith != null ? "${f2.format(zenith!.stats.zenith!.altitude)} m" : "--- m",
                        style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, fontWeight: FontWeight.w500, color: (zenith != null && !old) ? Colors.white : Colors.grey),
                      ),
                    ),
                    if (zenith != null) RichText(
                      text: TextSpan(
                        text: "",
                        style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                        children: [
                          if (zenith!.rank != -1) TextSpan(text: "№ ${intf.format(zenith!.rank)}", style: TextStyle(color: getColorOfRank(zenith!.rank))),
                          if (zenith!.rank != -1) const TextSpan(text: " • "),
                          if (zenith!.countryRank != -1) TextSpan(text: "№ ${intf.format(zenith!.countryRank)} local", style: TextStyle(color: getColorOfRank(zenith!.countryRank))),
                          if (zenith!.countryRank != -1) const TextSpan(text: " • "),
                          TextSpan(text: timestamp(zenith!.timestamp)),
                        ]
                      ),
                    ),
                  ],
                ),
                if (zenith != null && (zenith!.extras as ZenithExtras).mods.isNotEmpty) Container(width: 16.0),
                if (zenith != null && (zenith!.extras as ZenithExtras).mods.isNotEmpty) for (String mod in (zenith!.extras as ZenithExtras).mods) Image.asset("res/icons/${mod}.png", height: 64.0) 
              ],
            ),
            if (zenith != null) Row(
              children: [
                Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        Text(f2.format(zenith!.aggregateStats.apm), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" APM", style: TextStyle(fontSize: 21)),
                      ]),
                      TableRow(children: [
                        Text(f2.format(zenith!.aggregateStats.pps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" PPS", style: TextStyle(fontSize: 21)),
                      ]),
                      TableRow(children: [
                        Text(f2.format(zenith!.aggregateStats.vs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" VS", style: TextStyle(fontSize: 21)),
                      ]),
                      if (width <= 600) TableRow(children: [
                        Text(f2.format(zenith!.stats.cps), textAlign: TextAlign.right, style: const TextStyle(fontSize: 21)),
                        const Text(" CSP", style: TextStyle(fontSize: 21)),
                      ]),
                      if (width <= 400) ...secondColumn().reversed
                    ],
                  ),
                ),
              ),
              if (width > 600) GaugetThingy(value: zenith!.stats.cps, min: 0, max: 12, tickInterval: 3, label: "Climb\nSpeed", subString: "Peak: ${f2.format(zenith!.stats.zenith!.peakrank)}", sideSize: 128, fractionDigits: 2, moreIsBetter: true),
              if (width > 400) Expanded(
                child: Center(
                  child: Table(
                    defaultColumnWidth:const IntrinsicColumnWidth(),
                    children: secondColumn(),
                  ),
                ),
              )
              ],
            ) else Row(
              children: [
                Expanded(
                  child: Center(
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        const TableRow(children: [
                          Text("-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
                          Text(" APM", style: TextStyle(fontSize: 21, color: Colors.grey)),
                        ]),
                        const TableRow(children: [
                          Text("-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
                          Text(" PPS", style: TextStyle(fontSize: 21, color: Colors.grey)),
                        ]),
                        const TableRow(children: [
                          Text("-.--", textAlign: TextAlign.right, style: TextStyle(fontSize: 21, color: Colors.grey)),
                          Text(" VS", style: TextStyle(fontSize: 21, color: Colors.grey)),
                        ]),
                        if (width <= 600) TableRow(children: [
                          Text("-.--", textAlign: TextAlign.right, style: const TextStyle(fontSize: 21, color: Colors.grey)),
                          const Text(" CSP", style: TextStyle(fontSize: 21, color: Colors.grey)),
                        ])
                      ],
                    ),
                  ),
                ),
                if (width > 600) GaugetThingy(value: null, min: 0, max: 12, tickInterval: 3, label: "Climb\nSpeed", subString: "Peak: ---", sideSize: 128, fractionDigits: 0, moreIsBetter: true),
                if (width > 400) Expanded(
                  child: Center(
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: noRecordSecondColumn(),
                    ),
                  ),
                )
              ],
            )
          ]
        ),
      )
    );
  }
}