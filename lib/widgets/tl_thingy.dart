import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/utils/colors_functions.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/widgets/gauget_num.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
import 'package:tetra_stats/widgets/tl_progress_bar.dart';

var fDiff = NumberFormat("+#,###.###;-#,###.###");
var intFDiff = NumberFormat("+#,###;-#,###");
final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

class TLThingy extends StatefulWidget {
  final TetraLeagueAlpha tl;
  final String userID;
  final List<TetrioPlayer> states;
  final bool showTitle;
  final bool bot;
  final bool guest;
  final double? topTR;
  final PlayerLeaderboardPosition? lbPositions;
  final TetraLeagueAlpha? averages;
  final double? thatRankCutoff;
  final double? thatRankCutoffGlicko;
  final double? thatRankTarget;
  final double? nextRankCutoff;
  final double? nextRankCutoffGlicko;
  final double? nextRankTarget;
  const TLThingy({super.key, required this.tl, required this.userID, required this.states, this.showTitle = true, this.bot=false, this.guest=false, this.topTR, this.lbPositions, this.averages, this.nextRankCutoff, this.thatRankCutoff, this.thatRankCutoffGlicko, this.nextRankCutoffGlicko, this.nextRankTarget, this.thatRankTarget});

  @override
  State<TLThingy> createState() => _TLThingyState();
}

class _TLThingyState extends State<TLThingy> {
  late bool oskKagariGimmick;
  late TetraLeagueAlpha? oldTl;
  late TetraLeagueAlpha currentTl;
  late RangeValues _currentRangeValues;
  late List<TetrioPlayer> sortedStates;
  
@override
  void initState() {
    _currentRangeValues = const RangeValues(0, 1);
    sortedStates = widget.states.reversed.toList();
    oskKagariGimmick = prefs.getBool("oskKagariGimmick")??true;
    oldTl = sortedStates.elementAtOrNull(1)?.tlSeason1;
    currentTl = widget.tl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
  final t = Translations.of(context);
  NumberFormat fractionfEstTR = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2)..maximumIntegerDigits = 0;
  NumberFormat fractionfEstTRAcc = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 3)..maximumIntegerDigits = 0;
    if (currentTl.gamesPlayed == 0) return Center(child: Text(widget.guest ? t.anonTL : widget.bot ? t.botTL : t.neverPlayedTL, style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 28), textAlign: TextAlign.center,));
    return LayoutBuilder(builder: (context, constraints) {
    bool bigScreen = constraints.maxWidth >= 768;
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
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
                    (widget.userID == "5e32fc85ab319c2ab1beb07c" && oskKagariGimmick) // he love her so much, you can't even imagine
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
              if (currentTl.gamesPlayed > 9) TLProgress(
                tlData: currentTl,
                previousRankTRcutoff: widget.thatRankCutoff,
                previousGlickoCutoff: widget.thatRankCutoffGlicko,
                previousRank: widget.tl.prevRank,
                previousRankTRcutoffTarget: widget.thatRankTarget,
                nextRankTRcutoff: widget.nextRankCutoff,
                nextRankGlickoCutoff: widget.nextRankCutoffGlicko,
                nextRankTRcutoffTarget: widget.nextRankTarget,
                nextRank: widget.tl.nextRank
              ),
              if (currentTl.gamesPlayed < 10)
                Text(t.gamesUntilRanked(left: 10 - currentTl.gamesPlayed),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Eurostile Round",
                      fontSize: bigScreen ? 42 : 28,
                      overflow: TextOverflow.visible,
                    )),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 48),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    if (currentTl.apm != null) StatCellNum(playerStat: currentTl.apm!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.apm, higherIsBetter: true, oldPlayerStat: oldTl?.apm, pos: widget.lbPositions?.apm, averageStat: widget.averages?.apm),
                    if (currentTl.pps != null) StatCellNum(playerStat: currentTl.pps!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.pps, higherIsBetter: true, oldPlayerStat: oldTl?.pps, pos: widget.lbPositions?.pps, averageStat: widget.averages?.pps, smallDecimal: false),
                    if (currentTl.vs != null) StatCellNum(playerStat: currentTl.vs!, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.vs, higherIsBetter: true, oldPlayerStat: oldTl?.vs, pos: widget.lbPositions?.vs, averageStat: widget.averages?.vs),
                    if (currentTl.standingLocal > 0) StatCellNum(playerStat: currentTl.standingLocal, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.lbpc, higherIsBetter: false, oldPlayerStat: oldTl?.standingLocal),
                    StatCellNum(playerStat: currentTl.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesPlayed, higherIsBetter: true, oldPlayerStat: oldTl?.gamesPlayed, pos: widget.lbPositions?.gamesPlayed),
                    StatCellNum(playerStat: currentTl.gamesWon, isScreenBig: bigScreen, playerStatLabel: t.statCellNum.gamesWonTL, higherIsBetter: true, oldPlayerStat: oldTl?.gamesWon, pos: widget.lbPositions?.gamesWon),
                    StatCellNum(playerStat: currentTl.winrate * 100, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.winrate, higherIsBetter: true, oldPlayerStat: oldTl != null ? oldTl!.winrate*100 : null, pos: widget.lbPositions?.winrate, averageStat: widget.averages != null ?  widget.averages!.winrate * 100 : null),
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
                          GaugetNum(playerStat: currentTl.nerdStats!.app, playerStatLabel: t.statCellNum.app, higherIsBetter: true, minimum: 0, maximum: 1, ranges: [
                            GaugeRange(startValue: 0, endValue: 0.2, color: Colors.red),
                            GaugeRange(startValue: 0.2, endValue: 0.4, color: Colors.yellow),
                            GaugeRange(startValue: 0.4, endValue: 0.6, color: Colors.green),
                            GaugeRange(startValue: 0.6, endValue: 0.8, color: Colors.blue),
                            GaugeRange(startValue: 0.8, endValue: 1, color: Colors.purple),
                          ], alertWidgets: [
                            Text(t.statCellNum.appDescription),
                            Text("${t.exactValue}: ${currentTl.nerdStats!.app}")
                          ], oldPlayerStat: oldTl?.nerdStats?.app, pos: widget.lbPositions?.app,
                          averageStat: widget.averages?.nerdStats?.app),
                          GaugetNum(playerStat: currentTl.nerdStats!.vsapm, playerStatLabel: "VS / APM", higherIsBetter: true, minimum: 1.8, maximum: 2.4, ranges: [
                            GaugeRange(startValue: 1.8, endValue: 2.0, color: Colors.green),
                            GaugeRange(startValue: 2.0, endValue: 2.2, color: Colors.blue),
                            GaugeRange(startValue: 2.2, endValue: 2.4, color: Colors.purple),
                          ], alertWidgets: [
                            Text(t.statCellNum.vsapmDescription),
                            Text("${t.exactValue}: ${currentTl.nerdStats!.vsapm}")
                          ], oldPlayerStat: oldTl?.nerdStats?.vsapm, pos: widget.lbPositions?.vsapm,
                          averageStat: widget.averages?.nerdStats?.vsapm)
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          spacing: 25,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            StatCellNum(playerStat: currentTl.nerdStats!.dss, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dss,
                            pos: widget.lbPositions?.dss,
                            averageStat: widget.averages?.nerdStats?.dss, smallDecimal: false,
                            alertWidgets: [Text(t.statCellNum.dssDescription),
                                Text("${t.formula}: (VS / 100) - (APM / 60)"),
                                Text("${t.exactValue}: ${currentTl.nerdStats!.dss}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.dss,),
                            StatCellNum(playerStat: currentTl.nerdStats!.dsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.dsp,
                            pos: widget.lbPositions?.dsp,
                            averageStat: widget.averages?.nerdStats?.dsp, smallDecimal: false, 
                            alertWidgets: [Text(t.statCellNum.dspDescription),
                                Text("${t.formula}: DS/S / PPS"),
                                Text("${t.exactValue}: ${currentTl.nerdStats!.dsp}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.dsp,),
                            StatCellNum(playerStat: currentTl.nerdStats!.appdsp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.appdsp,
                            pos: widget.lbPositions?.appdsp,
                            averageStat: widget.averages?.nerdStats?.appdsp, smallDecimal: false,
                            alertWidgets: [Text(t.statCellNum.appdspDescription),
                                Text("${t.formula}: APP + DS/P"),
                                Text("${t.exactValue}: ${currentTl.nerdStats!.appdsp}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.appdsp,),
                            StatCellNum(playerStat: currentTl.nerdStats!.cheese, isScreenBig: bigScreen, fractionDigits: 2, playerStatLabel: t.statCellNum.cheese,
                            pos: widget.lbPositions?.cheese,
                            //averageStat: rankAverages?.nerdStats?.cheese, TODO: questonable
                            alertWidgets: [Text(t.statCellNum.cheeseDescription),
                                Text("${t.formula}: (DS/P * 150) + ((VS/APM - 2) * 50) + (0.6 - APP) * 125"),
                                Text("${t.exactValue}: ${currentTl.nerdStats!.cheese}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: false,
                                oldPlayerStat: oldTl?.nerdStats?.cheese,),
                            StatCellNum(playerStat: currentTl.nerdStats!.gbe, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.gbe,
                            pos: widget.lbPositions?.gbe,
                            averageStat: widget.averages?.nerdStats?.gbe, smallDecimal: false,
                            alertWidgets: [Text(t.statCellNum.gbeDescription),
                                Text("${t.formula}: APP * DS/P * 2"),
                                Text("${t.exactValue}: ${currentTl.nerdStats!.gbe}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.gbe,),
                            StatCellNum(playerStat: currentTl.nerdStats!.nyaapp, isScreenBig: bigScreen, fractionDigits: 3, playerStatLabel: t.statCellNum.nyaapp,
                            pos: widget.lbPositions?.nyaapp,
                            averageStat: widget.averages?.nerdStats?.nyaapp, smallDecimal: false,
                            alertWidgets: [Text(t.statCellNum.nyaappDescription),
                                Text("${t.formula}: APP - 5 * tan(radians((Cheese Index / -30) + 1))"),
                                Text("${t.exactValue}:  ${currentTl.nerdStats!.nyaapp}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.nyaapp,),
                            StatCellNum(playerStat: currentTl.nerdStats!.area, isScreenBig: bigScreen, fractionDigits: 1, playerStatLabel: t.statCellNum.area,
                            pos: widget.lbPositions?.area,
                            averageStat: widget.averages?.nerdStats?.area,
                            alertWidgets: [Text(t.statCellNum.areaDescription),
                                Text("${t.formula}: APM * 1 + PPS * 45 + VS * 0.444 + APP * 185 + DS/S * 175 + DS/P * 450 + Garbage Effi * 315"),
                                Text("${t.exactValue}:  ${currentTl.nerdStats!.area}"),],
                                okText: t.popupActions.ok,
                                higherIsBetter: true,
                                oldPlayerStat: oldTl?.nerdStats?.area,)
                          ]),
                    )
                  ],
                ),
              if (currentTl.estTr != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    //alignment: Alignment.center,
                    width: bigScreen ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.85,
                    height: 70,
                    constraints: const BoxConstraints(maxWidth: 768),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(t.statCellNum.estOfTR, style: const TextStyle(height: 0.1),),
                            RichText(
                              text: TextSpan(
                                text: intf.format(currentTl.estTr!.esttr.truncate()),
                                style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 36 : 30, fontWeight: FontWeight.w500, color: Colors.white),
                                children: [TextSpan(text: fractionfEstTR.format(currentTl.estTr!.esttr - currentTl.estTr!.esttr.truncate()).substring(1), style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))]
                                ),
                              ),
                            RichText(text: TextSpan(
                              text: "",
                              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.5),
                              children: [
                                if (oldTl?.estTr?.esttr != null) TextSpan(text: comparef.format(currentTl.estTr!.esttr - oldTl!.estTr!.esttr), style: TextStyle(
                                  color: oldTl!.estTr!.esttr > currentTl.estTr!.esttr ? Colors.redAccent : Colors.greenAccent
                                ),),
                                if (oldTl?.estTr?.esttr != null) const TextSpan(text: " • "),
                                if (widget.lbPositions?.estTr != null) TextSpan(text: widget.lbPositions!.estTr!.position >= 1000 ? "${t.top} ${f2.format(widget.lbPositions!.estTr!.percentage*100)}%" : "№${widget.lbPositions!.estTr!.position}", style: TextStyle(color: getColorOfRank(widget.lbPositions!.estTr!.position))),
                                if (widget.lbPositions?.estTr != null || oldTl?.estTr?.esttr != null) const TextSpan(text: " • "),
                                TextSpan(text: "Glicko: ${f2.format(currentTl.estTr!.estglicko)}")
                              ]
                              ),
                            ),
                          ],),
                        ),
                        Positioned(
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                            Text(t.statCellNum.accOfEst, style: const TextStyle(height: 0.1),),
                            RichText(
                              text: TextSpan(
                                text: (currentTl.esttracc != null && currentTl.bestRank != "z") ? intFDiff.format(currentTl.esttracc!.truncate()) : "---",
                                style: TextStyle(fontFamily: "Eurostile Round", fontSize: bigScreen ? 36 : 30, fontWeight: FontWeight.w500, color: Colors.white),
                                children: [
                                  TextSpan(text: (currentTl.esttracc != null && currentTl.bestRank != "z") ? fractionfEstTRAcc.format(currentTl.esttracc!.isNegative ? 1 - (currentTl.esttracc! - currentTl.esttracc!.truncate()) : (currentTl.esttracc! - currentTl.esttracc!.truncate())).substring(1) : ".---", style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, fontWeight: FontWeight.w100))
                                ]
                                ),
                              ),
                            if ((oldTl?.esttracc != null || widget.lbPositions != null) && currentTl.bestRank != "z") RichText(text: TextSpan(
                              text: "",
                              style: const TextStyle(fontFamily: "Eurostile Round", fontSize: 14, color: Colors.grey, height: 0.5),
                              children: [
                                if (oldTl?.esttracc != null) TextSpan(text: comparef.format(currentTl.esttracc! - oldTl!.esttracc!), style: TextStyle(
                                  color: oldTl!.esttracc! > currentTl.esttracc! ? Colors.redAccent : Colors.greenAccent
                                ),),
                                if (oldTl?.esttracc != null && widget.lbPositions?.accOfEst != null) const TextSpan(text: " • "),
                                if (widget.lbPositions?.accOfEst != null) TextSpan(text: widget.lbPositions!.accOfEst!.position >= 1000 ? "${t.top} ${f2.format(widget.lbPositions!.accOfEst!.percentage*100)}%" : "№${widget.lbPositions!.accOfEst!.position}", style: TextStyle(color: getColorOfRank(widget.lbPositions!.accOfEst!.position)))
                              ]
                              ),
                            ),
                          ],),
                        )
                      ],
                    ),
                  )
                ),
              if (currentTl.nerdStats != null) Graphs(currentTl.apm!, currentTl.pps!, currentTl.vs!, currentTl.nerdStats!, currentTl.playstyle!)
            ]
          );
        },
      );
    });
  }
}
