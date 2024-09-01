import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/widgets/finesse_thingy.dart';
import 'package:tetra_stats/widgets/gauget_num.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/lineclears_thingy.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class ZenithThingy extends StatefulWidget{
  final RecordSingle? record;
  final bool switchable;
  final bool initEXvalue;
  final RecordSingle? recordEX;
  final Function? parentZenithToggle; 

  const ZenithThingy({super.key, this.record, this.recordEX, this.switchable = true, this.parentZenithToggle, this.initEXvalue = false});

  @override
  State<ZenithThingy> createState() => _ZenithThingyState();
}

class _ZenithThingyState extends State<ZenithThingy> {
  late RecordSingle? record;
  bool ex = false;

  @override
  void initState(){
    ex = widget.initEXvalue;

    super.initState();
    if (widget.switchable){
      record = (ex ? widget.recordEX : widget.record);
    }else{
      record = widget.record;
      ex = widget.record!.gamemode == "zenithex";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      bool bigScreen = constraints.maxWidth > 768;
      if (record == null) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
          children: [
            Text("${t.quickPlay}${ex ? " ${t.expert}" : ""}", style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
            RichText(text: TextSpan(
              text: "--- m",
              style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 36 : 32, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
            ),
            TextButton(onPressed: (){
              if (ex){
                ex = false;
              }else{
                ex = true;
              }
              setState(() {
                if (widget.parentZenithToggle != null) widget.parentZenithToggle!();
                record = ex ? widget.recordEX : widget.record;
              });
            }, child: Text(ex ? "Switch to normal" : "Switch to Expert")),
          ],
                ),
        );
      }
      return Padding(padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Text("${t.quickPlay}${ex ? " ${t.expert}" : ""}", style: const TextStyle(height: 0.1, fontFamily: "Eurostile Round Extended", fontSize: 18)),
            RichText(text: TextSpan(
              text: "${f2.format(record!.stats.zenith!.altitude)} m",
              style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 36 : 32, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            if ((record!.extras as ZenithExtras).mods.isNotEmpty) RichText(
              text: TextSpan(
                text: "",
                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.white),
                children: [
                  TextSpan(text: "${t.withMods}: "),
                  for (String mod in (record!.extras as ZenithExtras).mods) TextSpan(text: "${mod.toUpperCase()} "),
                ]
              ),
            ),
            RichText(
              text: TextSpan(
                text: "",
                style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey),
                children: [
                  if (record!.rank != -1) TextSpan(text: "№ ${intf.format(record!.rank)}", style: TextStyle(color: getColorOfRank(record!.rank))),
                  if (record!.rank != -1) const TextSpan(text: " • "),
                  if (record!.countryRank != -1) TextSpan(text: "№ ${intf.format(record!.countryRank)} local", style: TextStyle(color: getColorOfRank(record!.countryRank))),
                  if (record!.countryRank != -1) const TextSpan(text: " • "),
                  TextSpan(text: timestamp(widget.record!.timestamp)),
                ]
              ),
            ),
            if (widget.switchable) TextButton(onPressed: (){
              if (ex){
                ex = false;
              }else{
                ex = true;
              }
              setState(() {
                if (widget.parentZenithToggle != null) widget.parentZenithToggle!();
                record = ex ? widget.recordEX : widget.record;
              });
            }, child: Text(ex ? "Switch to normal" : "Switch to Expert")),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                StatCellNum(playerStat: record!.aggregateStats.apm, playerStatLabel: t.statCellNum.apm, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: true),
                StatCellNum(playerStat: record!.aggregateStats.pps, playerStatLabel: t.statCellNum.pps, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: false),
                StatCellNum(playerStat: record!.aggregateStats.vs, playerStatLabel: t.statCellNum.vs, fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true, smallDecimal: true),
                StatCellNum(playerStat: record!.stats.kills, playerStatLabel: "Kills", isScreenBig: bigScreen, higherIsBetter: true),
                StatCellNum(playerStat: record!.stats.cps, playerStatLabel: "CPS\n(Peak: ${f2.format(record!.stats.zenith!.peakrank)})", fractionDigits: 2, isScreenBig: bigScreen, higherIsBetter: true)
              ],
            ),
            FinesseThingy(record?.stats.finesse, record?.stats.finessePercentage),
            LineclearsThingy(record!.stats.clears, record!.stats.lines, record!.stats.holds, record!.stats.tSpins),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        const Text("T", style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 65,
                          height: 1.2,
                        )),
                        const Positioned(left: 25, top: 20, child: Text("otal time", style: TextStyle(fontFamily: "Eurostile Round Extended"))),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(getMoreNormalTime(record!.stats.finalTime), style: const TextStyle(
                            shadows: textShadow,
                            fontFamily: "Eurostile Round Extended",
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          )),
                        )
                      ],
                    ),
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(36)
                      },
                      children: [
                        const TableRow(
                          children: [
                            Text("Floor"),
                            Text("Split", textAlign: TextAlign.right),
                            Text("Total", textAlign: TextAlign.right),
                          ]
                        ),
                        for (int i = 0; i < record!.stats.zenith!.splits.length; i++) TableRow(
                          children: [
                            Text((i+1).toString()),
                            Text(record!.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record!.stats.zenith!.splits[i]-(i-1 != -1 ? record!.stats.zenith!.splits[i-1] : Duration.zero)) : "--:--.---", textAlign: TextAlign.right),
                            Text(record!.stats.zenith!.splits[i] != Duration.zero ? getMoreNormalTime(record!.stats.zenith!.splits[i]) : "--:--.---", textAlign: TextAlign.right),
                          ]
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(t.nerdStats, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    spacing: 35,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    //clipBehavior: Clip.hardEdge,
                    children: [
                      GaugetNum(playerStat: record!.aggregateStats.nerdStats.app, playerStatLabel: t.statCellNum.app, higherIsBetter: true, minimum: 0, maximum: 1, ranges: [
                        GaugeRange(startValue: 0, endValue: 0.2, color: Colors.red),
                        GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.yellow),
                        GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.green),
                        GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.blue),
                        GaugeRange(startValue: 0.8, endValue: 1, color: Colors.purple),
                      ], alertWidgets: [
                        Text(t.statCellNum.appDescription),
                        Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.app}")
                      ]),
                      GaugetNum(playerStat: record!.aggregateStats.nerdStats.vsapm, playerStatLabel: "VS / APM", higherIsBetter: true, minimum: 1.8, maximum: 2.4, ranges: [
                        GaugeRange(startValue: 1.8, endValue: 2.0, color: Colors.green),
                        GaugeRange(startValue: 2.0, endValue: 2.2, color: Colors.blue),
                        GaugeRange(startValue: 2.2, endValue: 2.4, color: Colors.purple),
                      ], alertWidgets: [
                        Text(t.statCellNum.vsapmDescription),
                        Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.vsapm}")
                      ])
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      spacing: 25,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      //clipBehavior: Clip.hardEdge,
                      children: [
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dss,
                        alertWidgets: [Text(t.statCellNum.dssDescription),
                            Text("${t.formula}: (VS / 100) - (APM / 60)"),
                            Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.dss}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: true,),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dsp,
                        alertWidgets: [Text(t.statCellNum.dspDescription),
                            Text("${t.formula}: DS/S / PPS"),
                            Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.dsp}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: true),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.appdsp,
                        alertWidgets: [Text(t.statCellNum.appdspDescription),
                            Text("${t.formula}: APP + DS/P"),
                            Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.appdsp}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: true),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.cheese,
                        alertWidgets: [Text(t.statCellNum.cheeseDescription),
                            Text("${t.formula}: (DS/P * 150) + ((VS/APM - 2) * 50) + (0.6 - APP) * 125"),
                            Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.cheese}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: false),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.gbe,
                        alertWidgets: [Text(t.statCellNum.gbeDescription),
                            Text("${t.formula}: APP * DS/P * 2"),
                            Text("${t.exactValue}: ${record!.aggregateStats.nerdStats.gbe}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: true),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.nyaapp,
                        alertWidgets: [Text(t.statCellNum.nyaappDescription),
                            Text("${t.formula}: APP - 5 * tan(radians((Cheese Index / -30) + 1))"),
                            Text("${t.exactValue}:  ${record!.aggregateStats.nerdStats.nyaapp}")],
                            okText: t.popupActions.ok,
                            higherIsBetter: true),
                        StatCellNum(playerStat: record!.aggregateStats.nerdStats.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: t.statCellNum.area,
                        alertWidgets: [Text(t.statCellNum.areaDescription),
                            Text("${t.formula}: APM * 1 + PPS * 45 + VS * 0.444 + APP * 185 + DS/S * 175 + DS/P * 450 + Garbage Effi * 315"),
                            Text("${t.exactValue}:  ${record!.aggregateStats.nerdStats.area}"),],
                            okText: t.popupActions.ok,
                            higherIsBetter: true)
                      ]),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Graphs(record!.aggregateStats.apm, record!.aggregateStats.pps, record!.aggregateStats.vs, record!.aggregateStats.nerdStats, record!.aggregateStats.playstyle),
            )
          ],
        ) 
      );
    });
  }
}