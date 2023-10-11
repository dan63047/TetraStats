import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");

class TLThingy extends StatelessWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  final TetraLeagueAlpha? oldTl;
  final bool showTitle;
  final double? topTR;
  const TLThingy({Key? key, required this.tl, required this.userID, this.oldTl, this.showTitle = true, this.topTR}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
    final NumberFormat f3 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 3);
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: (tl.gamesPlayed > 0)
                ? [
                    if (showTitle) Text(t.tetraLeague, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
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
                              Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(text: "${t.top} ${f2.format(tl.percentile * 100)}% (${tl.percentileRank.toUpperCase()})"),
                                        if (tl.bestRank != "z") const TextSpan(text: " • "),
                                        if (tl.bestRank != "z") TextSpan(text: "${t.topRank}: ${tl.bestRank.toUpperCase()}"),
                                        if (topTR != null) TextSpan(text: " (${f2.format(topTR)} TR)"),
                                        TextSpan(text: " • Glicko: ${f2.format(tl.glicko!)}±"),
                                        TextSpan(text: f2.format(tl.rd!), style: tl.decaying ? TextStyle(color: tl.rd! > 98 ? Colors.red : Colors.yellow) : null),
                                        if (tl.decaying) WidgetSpan(child: Icon(Icons.trending_up, color: tl.rd! > 98 ? Colors.red : Colors.yellow,), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic) 
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (tl.gamesPlayed >= 10 && tl.rd! < 100 && tl.nextAt >=0 && tl.prevAt >= 0) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfLinearGauge(
                        minimum: tl.nextAt.toDouble(),
                        maximum: tl.prevAt.toDouble(),
                        interval: tl.prevAt.toDouble() - tl.nextAt.toDouble(), 
                        ranges: [LinearGaugeRange(startValue: tl.standing.toDouble() <= tl.prevAt.toDouble() ? tl.standing.toDouble() : tl.prevAt.toDouble(), endValue: tl.prevAt.toDouble(), color: Colors.cyanAccent,)],
                        markerPointers: [LinearShapePointer(value: tl.standing.toDouble() <= tl.prevAt.toDouble() ? tl.standing.toDouble() : tl.prevAt.toDouble(), position: LinearElementPosition.inside, shapeType: LinearShapePointerType.triangle, color: Colors.white, height: 20),
                        LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: tl.standing.toDouble() <= tl.prevAt.toDouble() ? tl.standing.toDouble() : tl.prevAt.toDouble(), child: Text(NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(tl.standing)))],
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
                                      title: GaugeTitle(text: t.statCellNum.app),
                                      axes: [RadialAxis(
                                      startAngle: 180,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 2.1,
                                      centerY: 0.5,
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
                                              title: Text(t.statCellNum.app,
                                                  style: const TextStyle(
                                                      fontFamily: "Eurostile Round Extended")),
                                              content:  SingleChildScrollView(
                                                child: ListBody(children: [
                                                  Text(t.statCellNum.appDescription),
                                                  Text("${t.exactValue}: ${tl.nerdStats!.app}")
                                                ]),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(t.popupActions.ok),
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
                                      centerY: 0.5,
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
                                                  Text(t.statCellNum.vsapmDescription),
                                                  Text("${t.exactValue}: ${tl.nerdStats!.vsapm}")
                                                ]),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(t.popupActions.ok),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                      },), verticalAlignment: GaugeAlignment.far, positionFactor: 0.05),
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
                                StatCellNum(playerStat: tl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dss,
                                alertWidgets: [Text(t.statCellNum.dssDescription),
                                    Text("${t.formula}: (VS / 100) - (APM / 60)"),
                                    Text("${t.exactValue}: ${tl.nerdStats!.dss}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dss,),
                                StatCellNum(playerStat: tl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dsp,
                                alertWidgets: [Text(t.statCellNum.dspDescription),
                                    Text("${t.formula}: DS/S / PPS"),
                                    Text("${t.exactValue}: ${tl.nerdStats!.dsp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dsp,),
                                StatCellNum(playerStat: tl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.appdsp,
                                alertWidgets: [Text(t.statCellNum.appdspDescription),
                                    Text("${t.formula}: APP + DS/P"),
                                    Text("${t.exactValue}: ${tl.nerdStats!.appdsp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.appdsp,),
                                StatCellNum(playerStat: tl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.cheese,
                                alertWidgets: [Text(t.statCellNum.cheeseDescription),
                                    Text("${t.formula}: (DS/P * 150) + ((VS/APM - 2) * 50) + (0.6 - APP) * 125"),
                                    Text("${t.exactValue}: ${tl.nerdStats!.cheese}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.cheese,),
                                StatCellNum(playerStat: tl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.gbe,
                                alertWidgets: [Text(t.statCellNum.gbeDescription),
                                    Text("${t.formula}: ((APP * DS/S) / PPS) * 2"),
                                    Text("${t.exactValue}: ${tl.nerdStats!.gbe}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.gbe,),
                                StatCellNum(playerStat: tl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.nyaapp,
                                alertWidgets: [Text(t.statCellNum.nyaappDescription),
                                    Text("${t.formula}: APP - 5 * tan(radians((Cheese Index / -30) + 1))"),
                                    Text("${t.exactValue}:  ${tl.nerdStats!.nyaapp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.nyaapp,),
                                StatCellNum(playerStat: tl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: t.statCellNum.area,
                                alertWidgets: [Text(t.statCellNum.areaDescription),
                                    Text("${t.formula}: APM * 1 + PPS * 45 + VS * 0.444 + APP * 185 + DS/S * 175 + DS/P * 450 + Garbage Effi * 315"),
                                    Text("${t.exactValue}:  ${tl.nerdStats!.area}"),],
                                    okText: t.popupActions.ok,
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
                                  Text(
                                    "${bigScreen ? t.statCellNum.estOfTR : t.statCellNum.estOfTRShort}:",
                                    style: const TextStyle(fontSize: 24),
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
                                    Text(
                                      "${bigScreen ? t.statCellNum.accOfEst : t.statCellNum.accOfEstShort}:",
                                      style: const TextStyle(fontSize: 24),
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
                        alignment: WrapAlignment.center,
                        spacing: 25,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
                            child: SizedBox(
                              height: 310,
                              width: 310,
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
                                        return RadarChartTitle(text: 'APM', angle: angle, positionPercentageOffset: 0.05);
                                      case 1:
                                        return RadarChartTitle(text: 'PPS', angle: angle, positionPercentageOffset: 0.05);
                                      case 2:
                                        return RadarChartTitle(text: 'VS', angle: angle, positionPercentageOffset: 0.05);
                                      case 3:
                                        return RadarChartTitle(text: 'APP', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 4:
                                        return RadarChartTitle(text: 'DS/S', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 5:
                                        return RadarChartTitle(text: 'DS/P', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 6:
                                        return RadarChartTitle(text: 'APP+DS/P', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 7:
                                        return RadarChartTitle(text: 'VS/APM', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 8:
                                        return RadarChartTitle(text: 'Cheese', angle: angle, positionPercentageOffset: 0.05);
                                      case 9:
                                        return RadarChartTitle(text: 'Gb Eff.', angle: angle, positionPercentageOffset: 0.05);
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
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
                            child: SizedBox(
                              height: 310,
                              width: 310,
                              child: RadarChart(
                                RadarChartData(
                                  radarShape: RadarShape.polygon,
                                  tickCount: 4,
                                  ticksTextStyle: const TextStyle(color: Colors.white24, fontSize: 10),
                                  radarBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  gridBorderData: const BorderSide(color: Colors.white24, width: 1),
                                  tickBorderData: const BorderSide(color: Colors.transparent, width: 1),
                                  titleTextStyle: const TextStyle(height: 1.1),
                                  radarTouchData: RadarTouchData(),
                                  getTitle: (index, angle) {
                                    switch (index) {
                                      case 0:
                                        return RadarChartTitle(text: 'Opener\n${f2.format(tl.playstyle!.opener)}', angle: 0, positionPercentageOffset: 0.05);
                                      case 1:
                                        return RadarChartTitle(text: 'Stride\n${f2.format(tl.playstyle!.stride)}', angle: 0, positionPercentageOffset: 0.05);
                                      case 2:
                                        return RadarChartTitle(text: 'Inf Ds\n${f2.format(tl.playstyle!.infds)}', angle: angle + 180, positionPercentageOffset: 0.05);
                                      case 3:
                                        return RadarChartTitle(text: 'Plonk\n${f2.format(tl.playstyle!.plonk)}', angle: 0, positionPercentageOffset: 0.05);
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
                    Text(t.neverPlayedTL, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)),
                  ],
          );
        },
      );
    });
  }
}
