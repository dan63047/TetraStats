import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/calc_view.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");
final NumberFormat f2 = NumberFormat.decimalPatternDigits(decimalDigits: 2);
final NumberFormat f3 = NumberFormat.decimalPatternDigits(decimalDigits: 3);

class TLThingy extends StatelessWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  final TetraLeagueAlpha? oldTl;
  const TLThingy({Key? key, required this.tl, required this.userID, this.oldTl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: (tl.gamesPlayed > 0)
                ? [
                    Text(t.tetraLeague, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (oldTl != null) Text(t.comparingWith(date: dateFormat.format(oldTl!.timestamp))),
                    if (tl.gamesPlayed >= 10)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          userID == "5e32fc85ab319c2ab1beb07c" // he love her so much, you can't even imagine
                              ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
                              : Image.asset("res/tetrio_tl_alpha_ranks/${tl.rank}.png", height: 128),
                          Column(
                            children: [
                              Text("${f2.format(tl.rating)} TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              if (oldTl != null) Text(
                                "${fDiff.format(tl.rating - oldTl!.rating)} TR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: tl.rating - oldTl!.rating < 0 ?
                                  Colors.red :
                                  Colors.green
                                ),
                              ),
                              Text(
                                "${t.top} ${f2.format(tl.percentile * 100)}% (${tl.percentileRank.toUpperCase()}) • ${t.topRank}: ${tl.bestRank.toUpperCase()} • Glicko: ${f2.format(tl.glicko!)}±${f2.format(tl.rd!)}${tl.decaying ? ' • ${t.decaying}' : ''}",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (tl.gamesPlayed >= 10 && tl.rd! < 100) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfLinearGauge(
                        minimum: tl.nextAt.toDouble(),
                        maximum: tl.prevAt.toDouble(),
                        interval: tl.prevAt.toDouble() - tl.nextAt.toDouble(), 
                        ranges: [LinearGaugeRange(startValue: tl.standing.toDouble(), endValue: tl.prevAt.toDouble(), color: Colors.cyanAccent,)],
                        //barPointers: [LinearBarPointer(value: 80)],
                        isAxisInversed: true,
                        isMirrored: true,
                        showTicks: true,
                        showLabels: true
                        ),
                    ),
                    if (tl.gamesPlayed < 10)
                      Text(t.gamesUntilRanked(left: 10 - tl.gamesPlayed),
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: bigScreen ? 42 : 28,
                            overflow: TextOverflow.visible,
                          )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          if (tl.apm != null) StatCellNum(playerStat: tl.apm!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.apm, higherIsBetter: true, oldPlayerStat: oldTl?.apm),
                          if (tl.pps != null) StatCellNum(playerStat: tl.pps!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.pps, higherIsBetter: true, oldPlayerStat: oldTl?.pps),
                          if (tl.vs != null) StatCellNum(playerStat: tl.vs!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.vs, higherIsBetter: true, oldPlayerStat: oldTl?.vs),
                          if (tl.standing > 0) StatCellNum(playerStat: tl.standing, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.lbp, higherIsBetter: false, oldPlayerStat: oldTl?.standing),
                          if (tl.standingLocal > 0) StatCellNum(playerStat: tl.standingLocal, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.lbpc, higherIsBetter: false, oldPlayerStat: oldTl?.standingLocal),
                          StatCellNum(playerStat: tl.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesPlayed, higherIsBetter: true, oldPlayerStat: oldTl?.gamesPlayed),
                          StatCellNum(playerStat: tl.gamesWon, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesWonTL, higherIsBetter: true, oldPlayerStat: oldTl?.gamesWon),
                          StatCellNum(playerStat: tl.winrate * 100, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.winrate, higherIsBetter: true, oldPlayerStat: oldTl != null ? oldTl!.winrate*100 : null),
                        ],
                      ),
                    ),
                    if (tl.nerdStats != null)
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
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 120,
                                    child: SfRadialGauge(
                                      title: const GaugeTitle(text: "Attack Per Piece"),
                                      axes: [RadialAxis(
                                      startAngle: 180,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 2.1,
                                      centerY: 0.4,
                                      minimum: 0,
                                      maximum: 1,
                                      ranges: [
                                        GaugeRange(startValue: 0, endValue: 0.2, color: Colors.red),
                                        GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.yellow),
                                        GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.green),
                                        GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.blue),
                                        GaugeRange(startValue: 0.8, endValue: 1, color: Colors.purple),
                                      ],
                                      pointers: [
                                        NeedlePointer(
                                          value: tl.nerdStats!.app,
                                          enableAnimation: true,
                                          needleLength: 0.9,
                                          needleStartWidth: 2,
                                          needleEndWidth: 15,
                                          knobStyle: const KnobStyle(color: Colors.transparent),
                                          gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                                        ],
                                      annotations: [GaugeAnnotation(
                                        widget: TextButton(child: Text(f3.format(tl.nerdStats!.app),
                                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, color: Colors.white)),
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text("Attack Per Piece",
                                                  style: TextStyle(
                                                      fontFamily: "Eurostile Round Extended")),
                                              content:  SingleChildScrollView(
                                                child: ListBody(children: [
                                                  const Text("Main efficiency metric. Tells how many attack you producing per piece"),
                                                  Text("Raw value: ${tl.nerdStats!.app}")
                                                ]),
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
                                      },), verticalAlignment: GaugeAlignment.far, positionFactor: 0.05,),
                                      if (oldTl != null) GaugeAnnotation(widget: Text(fDiff.format(tl.nerdStats!.app - oldTl!.nerdStats!.app), style: TextStyle(
                                          color: tl.nerdStats!.app - oldTl!.nerdStats!.app < 0 ?
                                          Colors.red :
                                          Colors.green
                                        ),), positionFactor: 0.05,)],
                                      )],),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 120,
                                    child: SfRadialGauge(
                                      title: const GaugeTitle(text: "VS / APM"),
                                      axes: [RadialAxis(
                                      startAngle: 180,
                                      endAngle: 360,
                                      showTicks: false,
                                      showLabels: false,
                                      radiusFactor: 2.1,
                                      centerY: 0.4,
                                      minimum: 1.8,
                                      maximum: 2.4,
                                      ranges: [
                                        GaugeRange(startValue: 1.8, endValue: 2.0, color: Colors.green),
                                        GaugeRange(startValue: 2.0, endValue: 2.2, color: Colors.blue),
                                        GaugeRange(startValue: 2.2, endValue: 2.4, color: Colors.purple),
                                      ],
                                      pointers: [
                                        NeedlePointer(
                                          value: tl.nerdStats!.vsapm,
                                          enableAnimation: true,
                                          needleLength: 0.9,
                                          needleStartWidth: 2,
                                          needleEndWidth: 15,
                                          knobStyle: const KnobStyle(color: Colors.transparent),
                                          gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                                        ],
                                      annotations: [GaugeAnnotation(
                                        widget: TextButton(child: Text(f3.format(tl.nerdStats!.vsapm),
                                        style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 36, color: Colors.white)),
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text("VS / APM",
                                                  style: TextStyle(
                                                      fontFamily: "Eurostile Round Extended")),
                                              content: SingleChildScrollView(
                                                child: ListBody(children: [
                                                  const Text("Basically, tells how much and how efficient you using garbage in your attacks"),
                                                  Text("Raw value: ${tl.nerdStats!.vsapm}")
                                                ]),
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
                                      },), verticalAlignment: GaugeAlignment.far, positionFactor: 0.05,),
                                      if (oldTl != null) GaugeAnnotation(widget: Text(fDiff.format(tl.nerdStats!.vsapm - oldTl!.nerdStats!.vsapm), style: TextStyle(
                                          color: tl.nerdStats!.vsapm - oldTl!.nerdStats!.vsapm < 0 ?
                                          Colors.red :
                                          Colors.green
                                        ),), positionFactor: 0.05,)],
                                      )],),
                                  ),]),
                          ),
                          Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              spacing: 25,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                StatCellNum(playerStat: tl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Second",
                                alertWidgets: [const Text("Downstack per Second measures how many garbage lines you clear in a second."),
                                    const Text("Formula: (VS / 100) - (APM / 60)"),
                                    Text("Raw value: ${tl.nerdStats!.dss}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dss,),
                                StatCellNum(playerStat: tl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Downstack\nPer Piece",
                                alertWidgets: [const Text("Downstack per Piece measures how many garbage lines you clear per piece."),
                                    const Text("Formula: DS/S / PPS"),
                                    Text("Raw value: ${tl.nerdStats!.dsp}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dsp,),
                                StatCellNum(playerStat: tl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "APP + DS/P",
                                alertWidgets: [const Text("Just a sum of Attack per Piece and Downstack per Piece."),
                                    const Text("Formula: APP + DS/P"),
                                    Text("Raw value: ${tl.nerdStats!.appdsp}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.appdsp,),
                                StatCellNum(playerStat: tl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: "Cheese\nIndex",
                                alertWidgets: [const Text("Cheese Index is an approximation how much clean / cheese garbage player sends. Lower = more clean. Higher = more cheese.\nInvented by kerrmunism"),
                                    const Text("Formula: (DS/P * 150) + ((VS/APM - 2) * 50) + (0.6 - APP) * 125"),
                                    Text("Raw value: ${tl.nerdStats!.cheese}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.cheese,),
                                StatCellNum(playerStat: tl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Garbage\nEfficiency",
                                alertWidgets: [const Text("Garbage Efficiency measures how well player uses their garbage. Higher = better or they use their garbage more. Lower = they mostly send their garbage back at cheese or rarely clear garbage.\nInvented by Zepheniah and Dragonboy."),
                                    const Text("Formula: ((APP * DS/S) / PPS) * 2"),
                                    Text("Raw value: ${tl.nerdStats!.gbe}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.gbe,),
                                StatCellNum(playerStat: tl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: "Weighted\nAPP",
                                alertWidgets: [const Text("Essentially, a measure of your ability to send cheese while still maintaining a high APP.\nInvented by Wertj."),
                                    const Text("Formula: APP - 5 * tan(radians((Cheese Index / -30) + 1))"),
                                    Text("Raw value:  ${tl.nerdStats!.nyaapp}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.nyaapp,),
                                StatCellNum(playerStat: tl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: "Area",
                                alertWidgets: [const Text("How much space your shape takes up on the graph, if you exclude the cheese and vs/apm sections"),
                                    const Text("Formula: APM * 1 + PPS * 45 + VS * 0.444 + APP * 185 + DS/S * 175 + DS/P * 450 + Garbage Effi * 315"),
                                    Text("Raw value:  ${tl.nerdStats!.area}"),],
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.area,)
                              ])
                        ],
                      ),
                    if (tl.estTr != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                        child: SizedBox(
                          width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Est. of TR:",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    f2.format(tl.estTr!.esttr),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              if (tl.rating >= 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Accuracy:",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      fDiff.format(tl.esttracc!),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (tl.nerdStats != null)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: RadarChart(
                                RadarChartData(
                                  radarShape: RadarShape.polygon,
                                  tickCount: 4,
                                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                                  radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                  tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  getTitle: (index, angle) {
                                    switch (index) {
                                      case 0:
                                        return RadarChartTitle(
                                          text: 'APM',
                                          angle: angle,
                                        );
                                      case 1:
                                        return RadarChartTitle(
                                          text: 'PPS',
                                          angle: angle,
                                        );
                                      case 2:
                                        return RadarChartTitle(text: 'VS', angle: angle);
                                      case 3:
                                        return RadarChartTitle(text: 'APP', angle: angle + 180);
                                      case 4:
                                        return RadarChartTitle(text: 'DS/S', angle: angle + 180);
                                      case 5:
                                        return RadarChartTitle(text: 'DS/P', angle: angle + 180);
                                      case 6:
                                        return RadarChartTitle(text: 'APP+DS/P', angle: angle + 180);
                                      case 7:
                                        return RadarChartTitle(text: 'VS/APM', angle: angle + 180);
                                      case 8:
                                        return RadarChartTitle(text: 'Cheese', angle: angle);
                                      case 9:
                                        return RadarChartTitle(text: 'Gb Eff.', angle: angle);
                                      default:
                                        return const RadarChartTitle(text: '');
                                    }
                                  },
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: [
                                        RadarEntry(value: tl.apm! * apmWeight),
                                        RadarEntry(value: tl.pps! * ppsWeight),
                                        RadarEntry(value: tl.vs! * vsWeight),
                                        RadarEntry(value: tl.nerdStats!.app * appWeight),
                                        RadarEntry(value: tl.nerdStats!.dss * dssWeight),
                                        RadarEntry(value: tl.nerdStats!.dsp * dspWeight),
                                        RadarEntry(value: tl.nerdStats!.appdsp * appdspWeight),
                                        RadarEntry(value: tl.nerdStats!.vsapm * vsapmWeight),
                                        RadarEntry(value: tl.nerdStats!.cheese * cheeseWeight),
                                        RadarEntry(value: tl.nerdStats!.gbe * gbeWeight),
                                      ],
                                    ),
                                    RadarDataSet(
                                      fillColor: Colors.transparent,
                                      borderColor: Colors.transparent,
                                      dataEntries: [
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                      ],
                                    )
                                  ],
                                ),
                                swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                                swapAnimationCurve: Curves.linear, // Optional
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: RadarChart(
                                RadarChartData(
                                  radarShape: RadarShape.polygon,
                                  tickCount: 4,
                                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                                  radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                  tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  getTitle: (index, angle) {
                                    switch (index) {
                                      case 0:
                                        return RadarChartTitle(
                                          text: 'Opener',
                                          angle: angle,
                                        );
                                      case 1:
                                        return RadarChartTitle(
                                          text: 'Stride',
                                          angle: angle,
                                        );
                                      case 2:
                                        return RadarChartTitle(text: 'Inf Ds', angle: angle + 180);
                                      case 3:
                                        return RadarChartTitle(text: 'Plonk', angle: angle);
                                      default:
                                        return const RadarChartTitle(text: '');
                                    }
                                  },
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: [
                                        RadarEntry(value: tl.playstyle!.opener),
                                        RadarEntry(value: tl.playstyle!.stride),
                                        RadarEntry(value: tl.playstyle!.infds),
                                        RadarEntry(value: tl.playstyle!.plonk),
                                      ],
                                    ),
                                    RadarDataSet(
                                      fillColor: Colors.transparent,
                                      borderColor: Colors.transparent,
                                      dataEntries: [
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                        const RadarEntry(value: 0),
                                      ],
                                    ),
                                    RadarDataSet(
                                      fillColor: Colors.transparent,
                                      borderColor: Colors.transparent,
                                      dataEntries: [
                                        const RadarEntry(value: 1),
                                        const RadarEntry(value: 1),
                                        const RadarEntry(value: 1),
                                        const RadarEntry(value: 1),
                                      ],
                                    )
                                  ],
                                ),
                                swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                                swapAnimationCurve: Curves.linear, // Optional
                              ),
                            ),
                          ),
                        ],
                      )
                  ]
                : [
                    const Text("That user never played Tetra League", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                  ],
          );
        },
      );
    });
  }
}
