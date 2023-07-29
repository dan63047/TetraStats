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
                                      "${f2.format(widget.rank[1]["entries"][index].apm)} APM, ${f2.format(widget.rank[1]["entries"][index].pps)} PPS, ${f2.format(widget.rank[1]["entries"][index].vs)} VS, ${f2.format(widget.rank[1]["entries"][index].app)} APP, ${f2.format(widget.rank[1]["entries"][index].vsapm)} VS/APM"),
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
                                  fractionDigits: 2)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [],
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
                                  fractionDigits: 2)
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
