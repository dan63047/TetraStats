import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");
final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
final NumberFormat f3 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 3);
late RangeValues _currentRangeValues;
TetraLeagueAlpha? oldTl;
late TetraLeagueAlpha currentTl;
late List<TetrioPlayer> sortedStates;

class TLThingy extends StatefulWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  final List<TetrioPlayer> states;
  final bool showTitle;
  final bool bot;
  final double? topTR;
  const TLThingy({super.key, required this.tl, required this.userID, required this.states, this.showTitle = true, this.bot=false, this.topTR});

  @override
  State<TLThingy> createState() => _TLThingyState();
}

class _TLThingyState extends State<TLThingy> {
  
@override
  void initState() {
    _currentRangeValues = const RangeValues(0, 1);
    sortedStates = widget.states.reversed.toList();
    try{
      oldTl = sortedStates[1].tlSeason1;
    }on RangeError{
      oldTl = null;
    }
    currentTl = widget.tl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
  final t = Translations.of(context);
    return LayoutBuilder(builder: (context, constraints) {
    bool bigScreen = constraints.maxWidth > 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: (currentTl.gamesPlayed > 0)
                ? [
                    if (widget.showTitle) Text(t.tetraLeague, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                    if (oldTl != null) Text(t.comparingWith(newDate: dateFormat.format(currentTl.timestamp), oldDate: dateFormat.format(oldTl!.timestamp)),
                    textAlign: TextAlign.center,),
                    if (oldTl != null) RangeSlider(values: _currentRangeValues, max: widget.states.length.toDouble(),
                    labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                     onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                          if (values.start.round() == 0){
                            currentTl = widget.tl;
                          }else{
                            currentTl = sortedStates[values.start.round()-1].tlSeason1;
                          }
                          if (values.end.round() == 0){
                            oldTl = widget.tl;
                          }else{
                            oldTl = sortedStates[values.end.round()-1].tlSeason1;
                          }
                        });
                      },
                    ),
                    if (currentTl.gamesPlayed >= 10)
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          widget.userID == "5e32fc85ab319c2ab1beb07c" // he love her so much, you can't even imagine
                              ? Image.asset("res/icons/kagari.png", height: 128) // Btw why she wearing Kazamatsuri high school uniform?
                              : Image.asset("res/tetrio_tl_alpha_ranks/${currentTl.rank}.png", height: 128),
                          Column(
                            children: [
                              Text("${f2.format(currentTl.rating)} TR", style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                              if (oldTl != null) Text(
                                "${fDiff.format(currentTl.rating - oldTl!.rating)} TR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: currentTl.rating - oldTl!.rating < 0 ?
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
                                        TextSpan(text: "${t.top} ${f2.format(currentTl.percentile * 100)}% (${currentTl.percentileRank.toUpperCase()})"),
                                        if (currentTl.bestRank != "z") const TextSpan(text: " • "),
                                        if (currentTl.bestRank != "z") TextSpan(text: "${t.topRank}: ${currentTl.bestRank.toUpperCase()}"),
                                        if (widget.topTR != null) TextSpan(text: " (${f2.format(widget.topTR)} TR)"),
                                        TextSpan(text: " • Glicko: ${f2.format(currentTl.glicko!)}±"),
                                        TextSpan(text: f2.format(currentTl.rd!), style: currentTl.decaying ? TextStyle(color: currentTl.rd! > 98 ? Colors.red : Colors.yellow) : null),
                                        if (currentTl.decaying) WidgetSpan(child: Icon(Icons.trending_up, color: currentTl.rd! > 98 ? Colors.red : Colors.yellow,), alignment: PlaceholderAlignment.middle, baseline: TextBaseline.alphabetic) 
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (currentTl.gamesPlayed >= 10 && currentTl.rd! < 100 && currentTl.nextAt >=0 && currentTl.prevAt >= 0) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfLinearGauge(
                        minimum: currentTl.nextAt.toDouble(),
                        maximum: currentTl.prevAt.toDouble(),
                        interval: currentTl.prevAt.toDouble() - currentTl.nextAt.toDouble(), 
                        ranges: [LinearGaugeRange(startValue: currentTl.standing.toDouble() <= currentTl.prevAt.toDouble() ? currentTl.standing.toDouble() : currentTl.prevAt.toDouble(), endValue: currentTl.prevAt.toDouble(), color: Colors.cyanAccent,)],
                        markerPointers: [LinearShapePointer(value: currentTl.standing.toDouble() <= currentTl.prevAt.toDouble() ? currentTl.standing.toDouble() : currentTl.prevAt.toDouble(), position: LinearElementPosition.inside, shapeType: LinearShapePointerType.triangle, color: Colors.white, height: 20),
                        LinearWidgetPointer(offset: 4, position: LinearElementPosition.outside, value: currentTl.standing.toDouble() <= currentTl.prevAt.toDouble() ? currentTl.standing.toDouble() : currentTl.prevAt.toDouble(), child: Text(NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(currentTl.standing)))],
                        isAxisInversed: true,
                        isMirrored: true,
                        showTicks: true,
                        showLabels: true
                        ),
                    ),
                    if (currentTl.gamesPlayed < 10)
                      Text(t.gamesUntilRanked(left: 10 - currentTl.gamesPlayed),
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
                          if (currentTl.apm != null) StatCellNum(playerStat: currentTl.apm!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.apm, higherIsBetter: true, oldPlayerStat: oldTl?.apm),
                          if (currentTl.pps != null) StatCellNum(playerStat: currentTl.pps!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.pps, higherIsBetter: true, oldPlayerStat: oldTl?.pps),
                          if (currentTl.vs != null) StatCellNum(playerStat: currentTl.vs!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.vs, higherIsBetter: true, oldPlayerStat: oldTl?.vs),
                          if (currentTl.standingLocal > 0) StatCellNum(playerStat: currentTl.standingLocal, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.lbpc, higherIsBetter: false, oldPlayerStat: oldTl?.standingLocal),
                          StatCellNum(playerStat: currentTl.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesPlayed, higherIsBetter: true, oldPlayerStat: oldTl?.gamesPlayed),
                          StatCellNum(playerStat: currentTl.gamesWon, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesWonTL, higherIsBetter: true, oldPlayerStat: oldTl?.gamesWon),
                          StatCellNum(playerStat: currentTl.winrate * 100, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.winrate, higherIsBetter: true, oldPlayerStat: oldTl != null ? oldTl!.winrate*100 : null),
                        ],
                      ),
                    ),
                    if (currentTl.nerdStats != null)
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
                                          value: currentTl.nerdStats!.app,
                                          enableAnimation: true,
                                          needleLength: 0.9,
                                          needleStartWidth: 2,
                                          needleEndWidth: 15,
                                          knobStyle: const KnobStyle(color: Colors.transparent),
                                          gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                                        ],
                                      annotations: [GaugeAnnotation(
                                        widget: TextButton(child: Text(f3.format(currentTl.nerdStats!.app),
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
                                                  Text("${t.exactValue}: ${currentTl.nerdStats!.app}")
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
                                      if (oldTl != null && oldTl!.gamesPlayed > 0) GaugeAnnotation(widget: Text(fDiff.format(currentTl.nerdStats!.app - oldTl!.nerdStats!.app), style: TextStyle(
                                          color: currentTl.nerdStats!.app - oldTl!.nerdStats!.app < 0 ?
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
                                          value: currentTl.nerdStats!.vsapm,
                                          enableAnimation: true,
                                          needleLength: 0.9,
                                          needleStartWidth: 2,
                                          needleEndWidth: 15,
                                          knobStyle: const KnobStyle(color: Colors.transparent),
                                          gradient: const LinearGradient(colors: [Colors.transparent, Colors.white], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.5, 1]),)
                                        ],
                                      annotations: [GaugeAnnotation(
                                        widget: TextButton(child: Text(f3.format(currentTl.nerdStats!.vsapm),
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
                                                  Text("${t.exactValue}: ${currentTl.nerdStats!.vsapm}")
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
                                      if (oldTl != null && oldTl!.gamesPlayed > 0) GaugeAnnotation(widget: Text(fDiff.format(currentTl.nerdStats!.vsapm - oldTl!.nerdStats!.vsapm), style: TextStyle(
                                          color: currentTl.nerdStats!.vsapm - oldTl!.nerdStats!.vsapm < 0 ?
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
                                StatCellNum(playerStat: currentTl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dss,
                                alertWidgets: [Text(t.statCellNum.dssDescription),
                                    Text("${t.formula}: (VS / 100) - (APM / 60)"),
                                    Text("${t.exactValue}: ${currentTl.nerdStats!.dss}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dss,),
                                StatCellNum(playerStat: currentTl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dsp,
                                alertWidgets: [Text(t.statCellNum.dspDescription),
                                    Text("${t.formula}: DS/S / PPS"),
                                    Text("${t.exactValue}: ${currentTl.nerdStats!.dsp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.dsp,),
                                StatCellNum(playerStat: currentTl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.appdsp,
                                alertWidgets: [Text(t.statCellNum.appdspDescription),
                                    Text("${t.formula}: APP + DS/P"),
                                    Text("${t.exactValue}: ${currentTl.nerdStats!.appdsp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.appdsp,),
                                StatCellNum(playerStat: currentTl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.cheese,
                                alertWidgets: [Text(t.statCellNum.cheeseDescription),
                                    Text("${t.formula}: (DS/P * 150) + ((VS/APM - 2) * 50) + (0.6 - APP) * 125"),
                                    Text("${t.exactValue}: ${currentTl.nerdStats!.cheese}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.cheese,),
                                StatCellNum(playerStat: currentTl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.gbe,
                                alertWidgets: [Text(t.statCellNum.gbeDescription),
                                    Text("${t.formula}: APP * DS/P * 2"),
                                    Text("${t.exactValue}: ${currentTl.nerdStats!.gbe}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.gbe,),
                                StatCellNum(playerStat: currentTl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.nyaapp,
                                alertWidgets: [Text(t.statCellNum.nyaappDescription),
                                    Text("${t.formula}: APP - 5 * tan(radians((Cheese Index / -30) + 1))"),
                                    Text("${t.exactValue}:  ${currentTl.nerdStats!.nyaapp}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.nyaapp,),
                                StatCellNum(playerStat: currentTl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: t.statCellNum.area,
                                alertWidgets: [Text(t.statCellNum.areaDescription),
                                    Text("${t.formula}: APM * 1 + PPS * 45 + VS * 0.444 + APP * 185 + DS/S * 175 + DS/P * 450 + Garbage Effi * 315"),
                                    Text("${t.exactValue}:  ${currentTl.nerdStats!.area}"),],
                                    okText: t.popupActions.ok,
                                    higherIsBetter: true,
                                    oldPlayerStat: oldTl?.nerdStats?.area,)
                              ])
                        ],
                      ),
                    if (currentTl.estTr != null)
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
                                    f2.format(currentTl.estTr!.esttr),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              if (currentTl.rating >= 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${bigScreen ? t.statCellNum.accOfEst : t.statCellNum.accOfEstShort}:",
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      fDiff.format(currentTl.esttracc!),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (currentTl.nerdStats != null) Graphs(currentTl.apm!, currentTl.pps!, currentTl.vs!, currentTl.nerdStats!, currentTl.playstyle!)
                  ]
                : [
                    Text(widget.bot ? t.botTL : t.neverPlayedTL, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28)),
                  ],
          );
        },
      );
    });
  }
}
