import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/main_view.dart';
import 'package:tetra_stats/widgets/stat_sell_num.dart';
//import 'package:tetra_stats/widgets/tl_thingy.dart';

final DateFormat dateFormat =
    DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
double pfpHeight = 128;

class RankView extends StatefulWidget {
  final List rank;
  const RankView({Key? key, required this.rank}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RankState();
}

class RankState extends State<RankView> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.rank[0].rank.toUpperCase()),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0, pfpHeight, 0, 0),
                                  child: Image.asset(
                                      "res/tetrio_tl_alpha_ranks/${widget.rank[0].rank}.png",
                                      fit: BoxFit.fitHeight,
                                      height: 128),
                                ),
                              ],
                            ),
                            Flexible(
                                child: Column(
                              children: [
                                Text(
                                    "Values for ${widget.rank[0].rank.toUpperCase()} rank",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                                Text(
                                    "${widget.rank[1]["entries"].length} players",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                              ],
                            )),
                          ],
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          spacing: 25,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          clipBehavior: Clip.hardEdge, // hard WHAT???
                          children: [
                            StatCellNum(
                              playerStat: widget.rank[1]["totalGamesPlayed"],
                              playerStatLabel: "Total games\nplayed",
                              isScreenBig: bigScreen,
                              higherIsBetter: true,
                            ),
                            StatCellNum(
                              playerStat: widget.rank[1]["totalGamesWon"],
                              playerStatLabel: "Total games\nwon",
                              isScreenBig: bigScreen,
                              higherIsBetter: true,
                            ),
                            StatCellNum(
                                playerStat: (widget.rank[1]["totalGamesWon"] /
                                        widget.rank[1]["totalGamesPlayed"]) *
                                    100,
                                playerStatLabel: t.statCellNum.winrate,
                                fractionDigits: 3,
                                isScreenBig: bigScreen,
                                higherIsBetter: true)
                          ],
                        ),
                      ],
                    )),
                    SliverToBoxAdapter(
                        child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: const [
                        Tab(text: "Chart"),
                        Tab(text: "Entries"),
                        Tab(text: "Minimums"),
                        Tab(text: "Averages"),
                        Tab(text: "Maximums"),
                        Tab(text: "Other"),
                      ],
                    )),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Text("Chart",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Entries",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView.builder(
                              itemCount: widget.rank[1]["entries"]!.length,
                              itemBuilder: (context, index) {
                                bool bigScreen =
                                    MediaQuery.of(context).size.width > 768;
                                return ListTile(
                                  title: Text(
                                      widget.rank[1]["entries"][index].username,
                                      style: const TextStyle(
                                          fontFamily:
                                              "Eurostile Round Extended")),
                                  subtitle: Text(
                                      "${f2.format(widget.rank[1]["entries"][index].apm)} APM, ${f2.format(widget.rank[1]["entries"][index].pps)} PPS, ${f2.format(widget.rank[1]["entries"][index].vs)} VS, ${f2.format(widget.rank[1]["entries"][index].nerdStats.app)} APP, ${f2.format(widget.rank[1]["entries"][index].nerdStats.vsapm)} VS/APM"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "${f2.format(widget.rank[1]["entries"][index].rating)} TR",
                                          style: bigScreen
                                              ? const TextStyle(fontSize: 28)
                                              : null),
                                      Image.asset(
                                          "res/tetrio_tl_alpha_ranks/${widget.rank[1]["entries"][index].rank}.png",
                                          height: bigScreen ? 48 : 16),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainView(
                                            player: widget
                                                .rank[1]["entries"][index]
                                                .userId),
                                        maintainState: false,
                                      ),
                                    );
                                  },
                                );
                              }),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("Lowest Values",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[1]["lowestTR"],
                                  label: "Tetra Rating",
                                  id: widget.rank[1]["lowestTRid"],
                                  username: widget.rank[1]["lowestTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGlicko"],
                                  label: "Glicko",
                                  id: widget.rank[1]["lowestGlickoID"],
                                  username: widget.rank[1]["lowestGlickoNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestRD"],
                                  label: "Rating Deviation",
                                  id: widget.rank[1]["lowestRdID"],
                                  username: widget.rank[1]["lowestRdNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGamesPlayed"],
                                  label: "Games Played",
                                  id: widget.rank[1]["lowestGamesPlayedID"],
                                  username: widget.rank[1]
                                      ["lowestGamesPlayedNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["lowestGamesWon"],
                                  label: "Games Won",
                                  id: widget.rank[1]["lowestGamesWonID"],
                                  username: widget.rank[1]
                                      ["lowestGamesWonNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["lowestWinrate"] * 100,
                                  label: "Winrate Percentage",
                                  id: widget.rank[1]["lowestWinrateID"],
                                  username: widget.rank[1]["lowestWinrateNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestAPM"],
                                  label: "Attack Per Minute",
                                  id: widget.rank[1]["lowestAPMid"],
                                  username: widget.rank[1]["lowestAPMnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestPPS"],
                                  label: "Pieces Per Second",
                                  id: widget.rank[1]["lowestPPSid"],
                                  username: widget.rank[1]["lowestPPSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestVS"],
                                  label: "Versus Score",
                                  id: widget.rank[1]["lowestVSid"],
                                  username: widget.rank[1]["lowestVSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["lowestAPP"],
                                  label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAPPid"],
                                  username: widget.rank[1]["lowestAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["lowestVSAPM"],
                                  label: "VS / APM",
                                  id: widget.rank[1]["lowestVSAPMid"],
                                  username: widget.rank[1]["lowestVSAPMnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestDSS"],
                                  label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestDSSid"],
                                  username: widget.rank[1]["lowestDSSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestDSPid"],
                                  username: widget.rank[1]["lowestDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestAPPDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAPPDSPid"],
                                  username: widget.rank[1]["lowestAPPDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestCheese"],
                                  label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestCheeseID"],
                                  username: widget.rank[1]["lowestCheeseNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["lowestGBE"],
                                  label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestGBEid"],
                                  username: widget.rank[1]["lowestGBEnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestNyaAPP"],
                                  label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestNyaAPPid"],
                                  username: widget.rank[1]["lowestNyaAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestArea"],
                                  label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestAreaID"],
                                  username: widget.rank[1]["lowestAreaNick"],
                                  approximate: false,
                                  fractionDigits: 1),
                            _ListEntry(
                                  value: widget.rank[1]["lowestEstTR"],
                                  label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestEstTRid"],
                                  username: widget.rank[1]["lowestEstTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["lowestEstAcc"],
                                  label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["lowestEstAccID"],
                                  username: widget.rank[1]["lowestEstAccNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestOpener"],
                                  label: "Opener",
                                  id: widget.rank[1]["lowestOpenerID"],
                                  username: widget.rank[1]["lowestOpenerNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestPlonk"],
                                  label: "Plonk",
                                  id: widget.rank[1]["lowestPlonkID"],
                                  username: widget.rank[1]["lowestPlonkNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestStride"],
                                  label: "Stride",
                                  id: widget.rank[1]["lowestStrideID"],
                                  username: widget.rank[1]["lowestStrideNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["lowestInfDS"],
                                  label: "InfDS",
                                  id: widget.rank[1]["lowestInfDSid"],
                                  username: widget.rank[1]["lowestInfDSnick"],
                                  approximate: false,
                                  fractionDigits: 3)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Average Values",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[0].rating,
                                  label: "Tetra Rating",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[0].glicko,
                                  label: "Glicko",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[0].rd,
                                  label: "Rating Deviation",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[0].gamesPlayed,
                                  label: "Games Played",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 0),
                              _ListEntry(
                                  value: widget.rank[0].gamesWon,
                                  label: "Games Won",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 0),
                              _ListEntry(
                                  value: widget.rank[0].winrate*100,
                                  label: "Winrate",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[0].apm,
                                  label: "Attack per Minute",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[0].pps,
                                  label: "Pieces per Second",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[0].vs,
                                  label: "Versus Score",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["avgAPP"],
                                  label: "Attack Per Piece",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["avgAPP"],
                                  label: "VS / APM",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["avgDSS"],
                                  label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgAPPDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgCheese"],
                                  label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["avgGBE"],
                                  label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgNyaAPP"],
                                  label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgArea"],
                                  label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 1),
                            _ListEntry(
                                  value: widget.rank[1]["avgEstTR"],
                                  label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["avgEstAcc"],
                                  label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "),
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgOpener"],
                                  label: "Opener",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgPlonk"],
                                  label: "Plonk",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgStride"],
                                  label: "Stride",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["avgInfDS"],
                                  label: "InfDS",
                                  id: "",
                                  username: "",
                                  approximate: true,
                                  fractionDigits: 3),
                            ]
                            )
                          )
                        ],
                    ),
                    Column(
                      children: [
                        Text("Highest Values",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        Expanded(
                          child: ListView(
                            children: [
                              _ListEntry(
                                  value: widget.rank[1]["highestTR"],
                                  label: "Tetra Rating",
                                  id: widget.rank[1]["highestTRid"],
                                  username: widget.rank[1]["highestTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestGlicko"],
                                  label: "Glicko",
                                  id: widget.rank[1]["highestGlickoID"],
                                  username: widget.rank[1]["highestGlickoNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestRD"],
                                  label: "Rating Deviation",
                                  id: widget.rank[1]["highestRdID"],
                                  username: widget.rank[1]["highestRdNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestGamesPlayed"],
                                  label: "Games Played",
                                  id: widget.rank[1]["highestGamesPlayedID"],
                                  username: widget.rank[1]
                                      ["highestGamesPlayedNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["highestGamesWon"],
                                  label: "Games Won",
                                  id: widget.rank[1]["highestGamesWonID"],
                                  username: widget.rank[1]
                                      ["highestGamesWonNick"],
                                  approximate: false),
                              _ListEntry(
                                  value: widget.rank[1]["highestWinrate"] * 100,
                                  label: "Winrate Percentage",
                                  id: widget.rank[1]["highestWinrateID"],
                                  username: widget.rank[1]
                                      ["highestWinrateNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestAPM"],
                                  label: "Attack Per Minute",
                                  id: widget.rank[1]["highestAPMid"],
                                  username: widget.rank[1]["highestAPMnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestPPS"],
                                  label: "Pieces Per Second",
                                  id: widget.rank[1]["highestPPSid"],
                                  username: widget.rank[1]["highestPPSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                              _ListEntry(
                                  value: widget.rank[1]["highestVS"],
                                  label: "Versus Score",
                                  id: widget.rank[1]["highestVSid"],
                                  username: widget.rank[1]["highestVSnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                                  _ListEntry(
                                  value: widget.rank[1]["highestAPP"],
                                  label: t.statCellNum.app.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAPPid"],
                                  username: widget.rank[1]["highestAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                              _ListEntry(
                                  value: widget.rank[1]["highestVSAPM"],
                                  label: "VS / APM",
                                  id: widget.rank[1]["highestVSAPMid"],
                                  username: widget.rank[1]["highestVSAPMnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestDSS"],
                                  label: t.statCellNum.dss.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestDSSid"],
                                  username: widget.rank[1]["highestDSSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestDSPid"],
                                  username: widget.rank[1]["highestDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestAPPDSP"],
                                  label: t.statCellNum.dsp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAPPDSPid"],
                                  username: widget.rank[1]["highestAPPDSPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestCheese"],
                                  label: t.statCellNum.cheese.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestCheeseID"],
                                  username: widget.rank[1]["highestCheeseNick"],
                                  approximate: false,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["highestGBE"],
                                  label: t.statCellNum.gbe.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestGBEid"],
                                  username: widget.rank[1]["highestGBEnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestNyaAPP"],
                                  label: t.statCellNum.nyaapp.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestNyaAPPid"],
                                  username: widget.rank[1]["highestNyaAPPnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestArea"],
                                  label: t.statCellNum.area.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestAreaID"],
                                  username: widget.rank[1]["highestAreaNick"],
                                  approximate: false,
                                  fractionDigits: 1),
                            _ListEntry(
                                  value: widget.rank[1]["highestEstTR"],
                                  label: t.statCellNum.estOfTR.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestEstTRid"],
                                  username: widget.rank[1]["highestEstTRnick"],
                                  approximate: false,
                                  fractionDigits: 2),
                            _ListEntry(
                                  value: widget.rank[1]["highestEstAcc"],
                                  label: t.statCellNum.accOfEst.replaceAll(RegExp(r'\n'), " "),
                                  id: widget.rank[1]["highestEstAccID"],
                                  username: widget.rank[1]["highestEstAccNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestOpener"],
                                  label: "Opener",
                                  id: widget.rank[1]["highestOpenerID"],
                                  username: widget.rank[1]["highestOpenerNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestPlonk"],
                                  label: "Plonk",
                                  id: widget.rank[1]["highestPlonkID"],
                                  username: widget.rank[1]["highestPlonkNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestStride"],
                                  label: "Stride",
                                  id: widget.rank[1]["highestStrideID"],
                                  username: widget.rank[1]["highestStrideNick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            _ListEntry(
                                  value: widget.rank[1]["highestInfDS"],
                                  label: "InfDS",
                                  id: widget.rank[1]["highestInfDSid"],
                                  username: widget.rank[1]["highestInfDSnick"],
                                  approximate: false,
                                  fractionDigits: 3),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ))));
  }
}

class _ListEntry extends StatelessWidget {
  final num value;
  final String label;
  final String id;
  final String username;
  final bool approximate;
  final int? fractionDigits;
  const _ListEntry(
      {required this.value,
      required this.label,
      this.fractionDigits,
      required this.id,
      required this.username,
      required this.approximate});

  @override
  Widget build(BuildContext context) {
    NumberFormat f = NumberFormat.decimalPatternDigits(
        locale: LocaleSettings.currentLocale.languageCode,
        decimalDigits: fractionDigits ?? 0);
    return ListTile(
      title: Text(label),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(f.format(value),
              style: const TextStyle(fontSize: 22, height: 0.9)),
          if (id.isNotEmpty) Text('for player $username')
        ],
      ),
      onTap: id.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainView(player: id),
                  maintainState: false,
                ),
              );
            }
          : null,
    );
  }
}
