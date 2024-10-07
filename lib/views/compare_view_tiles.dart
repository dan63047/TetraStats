// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/aggregate_stats.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart' show teto;
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';
import 'package:tetra_stats/utils/text_shadow.dart';
import 'package:tetra_stats/widgets/graphs.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/vs_graphs.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:window_manager/window_manager.dart';

enum Mode{
  player,
  stats,
  averages
}
final DateFormat dateFormat = DateFormat.yMd(LocaleSettings.currentLocale.languageCode).add_Hm();
var numbersReg = RegExp(r'\d+(\.\d*)*');
late String oldWindowTitle;

class CompareView extends StatefulWidget {
  final TetrioPlayer initPlayer;
  const CompareView(this.initPlayer);

  @override
  State<StatefulWidget> createState() => CompareState();
}

class CompareState extends State<CompareView> {
  late ScrollController _scrollController;
  List<TetrioPlayer> players = [];
  List<Summaries> summaries = [];
  List<String> nicknames = [];
  TextStyle _expansionTileTitleTextStyle = TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 24.0);

  @override
  void initState() {
    _scrollController = ScrollController();
    players = [widget.initPlayer];
    getSummariesForInit();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
    }
    super.initState();
  }

  @override
  void dispose(){
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  void getSummariesForInit() async {
    summaries.add(await teto.fetchSummaries(widget.initPlayer.userId));
    nicknames.add(players[0].username);
    setState(() {
      
    });
  }

  void addPlayer(String nickname) async {
    players.add(await teto.fetchPlayer(nickname));
    summaries.add(await teto.fetchSummaries(players.last.userId));
    nicknames.add(players.last.username);
    setState(() {
      
    });
  }

  double getWinrateByTR(double yourGlicko, double yourRD, double notyourGlicko,double notyourRD) {
    return ((1 /
      (1 + pow(10,
        (notyourGlicko - yourGlicko) /
          (400 * sqrt(1 + (3 * pow(0.0057564273, 2) *
            (pow(yourRD, 2) + pow(notyourRD, 2)) / pow(pi, 2)
          )))
        )
      )
    ));
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Fuck go back',
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              SizedBox(
                height: 175.0,
                width: 300.0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(90.0, 18.0, 5.0, 0),
                    child: Text("Comparison", style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
              for (var p in players) SizedBox(
                width: 300.0,
                child: HeaderCard(p),
              ),
              SizedBox(width: 300, child: AddNewColumnCard(addPlayer))
            ]
          ),
          Row(
            children: [
              SizedBox(
                width: 300.0,
                child: Card(
                  child: Column(children: [
                    Text("Registration Date"),
                    Text("XP"),
                    Text("Time Played"),
                    Text("Online Games Played"),
                    Text("Online Games Won"),
                    Text("Followers"),
                  ]),
                ),
              ),
              for (var p in players) SizedBox(
                width: 300.0,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(timestamp(p.registrationTime!)),
                      RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])),
                      Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)),
                      Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white)),
                      Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white)),
                      Text(intf.format(p.friendCount))
                    ],
                  ),
                ),
              ),
            ]
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Tetra League", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Tetra Rating"),
                          Text("Glicko"),
                          Text("RD"),
                          Text("GLIXARE"),
                          Text("S1-like TR"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Games Played"),
                          Text("Games Won"),
                          Text("Winrate"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.league.tr.isNegative ? "---" : f4.format(s.league.tr)),
                            Text(s.league.glicko!.isNegative ? "---" : f4.format(s.league.glicko)),
                            Text(s.league.rd!.isNegative ? "---" : f4.format(s.league.rd), style: TextStyle(color: s.league.rd!.isNegative ? Colors.grey : Colors.white)),
                            Text(s.league.gxe.isNegative ? "---" : f4.format(s.league.gxe)),
                            Text(s.league.s1tr.isNegative ? "---" : f4.format(s.league.s1tr)),
                            Text(s.league.standing.isNegative ? "---" : "№ "+intf.format(s.league.standing)),
                            Text(s.league.standingLocal.isNegative ? "---" : "№ "+intf.format(s.league.standingLocal)),
                           // RichText(text: s.league.standingLocal.isNegative ? TextSpan(text: "---", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(s.league.standingLocal), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (in ${s.league.})", style: TextStyle(color: Colors.grey))]))
                            Text(intf.format(s.league.gamesPlayed)),
                            Text(intf.format(s.league.gamesWon)),
                            Text(s.league.winrate.isNaN ? "---" : f4.format(s.league.winrate*100)+"%"),
                            Text(s.league.apm != null ? f2.format(s.league.apm) : "---"),
                            Text(s.league.pps != null ? f2.format(s.league.pps) : "---"),
                            Text(s.league.vs != null ? f2.format(s.league.vs) : "---"),
                            Text(""),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.app) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.vsapm) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dss) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dsp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.appdsp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.cheese) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.gbe) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.nyaapp) : "---"),
                            Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.area) : "---"),
                            Text(""),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.opener) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.plonk) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.stride) : "---"),
                            Text(s.league.playstyle != null ? f4.format(s.league.playstyle!.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
                VsGraphs(stats: [for (var s in summaries) AggregateStats.precalculated(s.league.apm??0, s.league.pps??0, s.league.vs??0, s.league.nerdStats??NerdStats(0, 0, 0), s.league.playstyle??Playstyle(0, 0, 0, 0, 0, 0, 0.0001, 0))], nicknames: nicknames)
              ],
            ),
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Quick Play", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Altitude"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("KO's"),
                          Text("Top B2B"),
                          Text("Climb Speed"),
                          Text("Peak Climb Speed"),
                          Text("Time Spend"),
                          Text("Finesse"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.altitude) : "---"),
                            Text(s.zenith != null ? "№ "+intf.format(s.zenith!.rank) : "---"),
                            Text((s.zenith != null && !s.zenith!.countryRank.isNegative) ? "№ "+intf.format(s.zenith!.countryRank) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.apm) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.pps) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.aggregateStats.vs) : "---"),
                            Text(s.zenith != null ? intf.format(s.zenith!.stats.kills) : "---"),
                            Text(s.zenith != null ? intf.format(s.zenith!.stats.topBtB) : "---"),
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.cps) : "---"),
                            Text(s.zenith != null ? f4.format(s.zenith!.stats.zenith!.peakrank) : "---"),
                            Text(s.zenith != null ? getMoreNormalTime(s.zenith!.stats.finalTime) : "---"),
                            Text(s.zenith != null ? f2.format(s.zenith!.stats.finessePercentage*100)+"%" : "---"),
                            Text(""),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.app) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.vsapm) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.dss) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.dsp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.appdsp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.cheese) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.gbe) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.nyaapp) : "---"),
                            Text(s.zenith?.aggregateStats.nerdStats != null ? f4.format(s.zenith!.aggregateStats.nerdStats.area) : "---"),
                            Text(""),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.opener) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.plonk) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.stride) : "---"),
                            Text(s.zenith?.aggregateStats.playstyle != null ? f4.format(s.zenith!.aggregateStats.playstyle.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              ],
            ),
          ),
          SizedBox(
            width: 300+300*summaries.length.toDouble(),
            child: ExpansionTile(
              title: Text("Quick Play Expert", style: _expansionTileTitleTextStyle),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(children: [
                          Text("Altitude"),
                          Text("Position"),
                          Text("Position (Country)"),
                          Text("Attack Per Minute"),
                          Text("Pieces Per Second"),
                          Text("Versus Score"),
                          Text("KO's"),
                          Text("Top B2B"),
                          Text("Climb Speed"),
                          Text("Peak Climb Speed"),
                          Text("Time Spend"),
                          Text("Finesse"),
                          Text("Nerd Stats"),
                          Text("Attack Per Piece"),
                          Text("VS / APM"),
                          Text("Downstack Per Second"),
                          Text("Downstack Per Piece"),
                          Text("APP + DSP"),
                          Text("Cheese Index"),
                          Text("Garbage Efficiency"),
                          Text("Weighted APP"),
                          Text("Area"),
                          Text("Playstyle"),
                          Text("Opener"),
                          Text("Plonk"),
                          Text("Stride"),
                          Text("Infinite Downstack"),
                        ]),
                      ),
                    ),
                    for (var s in summaries) SizedBox(
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.zenith!.altitude) : "---"),
                            Text(s.zenithEx != null ? "№ "+intf.format(s.zenithEx!.rank) : "---"),
                            Text((s.zenithEx != null && !s.zenithEx!.countryRank.isNegative) ? "№ "+intf.format(s.zenithEx!.countryRank) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.apm) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.pps) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.aggregateStats.vs) : "---"),
                            Text(s.zenithEx != null ? intf.format(s.zenithEx!.stats.kills) : "---"),
                            Text(s.zenithEx != null ? intf.format(s.zenithEx!.stats.topBtB) : "---"),
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.cps) : "---"),
                            Text(s.zenithEx != null ? f4.format(s.zenithEx!.stats.zenith!.peakrank) : "---"),
                            Text(s.zenithEx != null ? getMoreNormalTime(s.zenithEx!.stats.finalTime) : "---"),
                            Text(s.zenithEx != null ? f2.format(s.zenithEx!.stats.finessePercentage*100)+"%" : "---"),
                            Text(""),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.app) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.vsapm) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.dss) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.dsp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.appdsp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.cheese) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.gbe) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.nyaapp) : "---"),
                            Text(s.zenithEx?.aggregateStats.nerdStats != null ? f4.format(s.zenithEx!.aggregateStats.nerdStats.area) : "---"),
                            Text(""),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.opener) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.plonk) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.stride) : "---"),
                            Text(s.zenithEx?.aggregateStats.playstyle != null ? f4.format(s.zenithEx!.aggregateStats.playstyle.infds) : "---"),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          )
        ]),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCard extends StatelessWidget{
  final TetrioPlayer player;

  const HeaderCard(this.player);

  String fontStyle(int length){
    if (length < 10) return "Eurostile Round Extended";
    else if (length < 13) return "Eurostile Round";
    else return "Eurostile Round Condensed";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Card(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                if (player.bannerRevision != null) FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioBanner&user=${player.userId}&rv=${player.bannerRevision}" : "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                  height: 120.0,
                  fadeInCurve: Easing.standard, fadeInDuration: Durations.long4
                )
                else SizedBox(height: 120.0),
                Positioned(
                  top: 20.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: player.role == "banned"
                      ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: 128)
                      : player.avatarRevision != null
                        ? FadeInImage.memoryNetwork(image: kIsWeb ? "https://ts.dan63.by/oskware_bridge.php?endpoint=TetrioProfilePicture&user=${player.userId}&rv=${player.avatarRevision}" : "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                          fit: BoxFit.fitHeight, height: 128, placeholder: kTransparentImage, fadeInCurve: Easing.emphasizedDecelerate, fadeInDuration: Durations.long4)
                        : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: 128),
                  )
                ),
              ],
            ),
            RichText(
              text: TextSpan(text: player.username, style: TextStyle(
                fontFamily: fontStyle(player.username.length),
                fontSize: 28,
                shadows: textShadow
                ),
              )
            ),
          ],
        ),
      ),
    );
  }}

class AddNewColumnCard extends StatefulWidget{
  final Function addPlayer;

  const AddNewColumnCard(this.addPlayer);

  @override
  State<AddNewColumnCard> createState() => _AddNewColumnCardState();
}

class _AddNewColumnCardState extends State<AddNewColumnCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState(){
    _animController = AnimationController(
      duration: Durations.medium3,
      vsync: this,
    );
    _anim = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: _animController,
      curve: Easing.standard
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 175.0,
      child: Card(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, child) {
            return _anim.value > 0.5 ? Opacity(
              opacity: _anim.value*2-1,
              child: Container(
                transform: Matrix4.translationValues(0, 100-(_anim.value as double)*100, 0),
                child: Column(
                  children: [
                    Text("Enter username:"),
                    TextField(
                      autofocus: true,
                      onSubmitted: (value){
                        widget.addPlayer(value);
                      },
                      onTapOutside: (event) {
                        setState((){_animController.animateBack(0);});
                      },
                    )
                  ],
                ),
              ),
            ) : Center(
              child: IconButton(
                visualDensity: VisualDensity.comfortable,
                onPressed: (){setState((){_animController.forward();});},
                icon: Opacity(opacity: 1-(_anim.value as double)*2, child: Transform.translate(offset: Offset.fromDirection(pi*1.5, (_anim.value as double)*50), child: Transform.rotate(angle: (_anim.value as double)*2, child: Icon(Icons.add)))),
                constraints: BoxConstraints.expand(),
              ),
            );
          }
        )
      )
    );
  }
}

class VsGraphs extends StatelessWidget{
  final List<AggregateStats> stats;
  final List<String> nicknames;
  const VsGraphs({super.key, required this.stats, required this.nicknames});

  static const List<Color> colorsForGraphs = [
    Colors.cyanAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          children: [
            for (int i = 0; i < stats.length; i++) Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 0.0),
                  child: Container(width: 20.0, height: 10.0, decoration: BoxDecoration(color: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128), border: Border.all(color: colorsForGraphs[i%colorsForGraphs.length])),),
                ),
                Text(nicknames[i], style: TextStyle(fontFamily: "Eurostile Round Extended"))
              ],
            )
          ],
        ),
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
            child: MyRadarChart(
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
                        positionPercentageOffset: 0.05
                      );
                    case 1:
                      return RadarChartTitle(
                        text: 'PPS',
                        angle: angle,
                        positionPercentageOffset: 0.05
                      );
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
                      for (int i = 0; i < stats.length; i++) RadarDataSet(
                        fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                        borderColor: colorsForGraphs[i%colorsForGraphs.length],
                        dataEntries: [
                          RadarEntry(value: stats[i].apm * apmWeight),
                          RadarEntry(value: stats[i].pps * ppsWeight),
                          RadarEntry(value: stats[i].vs * vsWeight),
                          RadarEntry(value: stats[i].nerdStats.app * appWeight),
                          RadarEntry(value: stats[i].nerdStats.dss * dssWeight),
                          RadarEntry(value: stats[i].nerdStats.dsp * dspWeight),
                          RadarEntry(value: stats[i].nerdStats.appdsp * appdspWeight),
                          RadarEntry(value: stats[i].nerdStats.vsapm * vsapmWeight),
                          RadarEntry(value: stats[i].nerdStats.cheese * cheeseWeight),
                          RadarEntry(value: stats[i].nerdStats.gbe * gbeWeight),
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
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ),
            Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
          child: SizedBox(
            height: 310,
            width: 310,
            child: MyRadarChart(
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
                          return RadarChartTitle(text: 'Opener',angle: angle, positionPercentageOffset: 0.05);
                        case 1:
                          return RadarChartTitle(text: 'Stride', angle: angle, positionPercentageOffset: 0.05);
                        case 2:
                          return RadarChartTitle(text: 'Inf Ds', angle: angle + 180, positionPercentageOffset: 0.05);
                        case 3:
                          return RadarChartTitle(text: 'Plonk', angle: angle, positionPercentageOffset: 0.05);
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                    dataSets: [
                      for (int i = 0; i < stats.length; i++) RadarDataSet(
                        fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                        borderColor: colorsForGraphs[i%colorsForGraphs.length],
                        dataEntries: [
                          RadarEntry(value: stats[i].playstyle.opener),
                          RadarEntry(value: stats[i].playstyle.stride),
                          RadarEntry(value: stats[i].playstyle.infds),
                          RadarEntry(value: stats[i].playstyle.plonk),
                        ],
                      ),
                      RadarDataSet(
                        fillColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        dataEntries: [
                          const RadarEntry(value: 0),
                          const RadarEntry(value: 1),
                          const RadarEntry(value: 0),
                          const RadarEntry(value: 0),
                        ],
                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ),
            Padding( // sq graph
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 44),
              child: SizedBox(
                height: 310,
                width: 310,
                child: MyRadarChart(
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
                          return RadarChartTitle(text: t.graphs.attack, angle: 0, positionPercentageOffset: 0.05);
                        case 1:
                          return RadarChartTitle(text: t.graphs.speed, angle: 0, positionPercentageOffset: 0.05);
                        case 2:
                          return RadarChartTitle(text: t.graphs.defense, angle: angle + 180, positionPercentageOffset: 0.05);
                        case 3:
                          return RadarChartTitle(text: t.graphs.cheese, angle: 0, positionPercentageOffset: 0.05);
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                    dataSets: [
                      for (int i = 0; i < stats.length; i++) RadarDataSet(
                        fillColor: colorsForGraphs[i%colorsForGraphs.length].withAlpha(128),
                        borderColor: colorsForGraphs[i%colorsForGraphs.length],
                        dataEntries: [
                          RadarEntry(value: stats[i].apm / 60 * 0.4),
                          RadarEntry(value: stats[i].pps / 3.75),
                          RadarEntry(value: stats[i].nerdStats.dss * 1.15),
                          RadarEntry(value: stats[i].nerdStats.cheese / 110),
                        ],
                      ),
                      RadarDataSet(
                        fillColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        dataEntries: [
                          const RadarEntry(value: 0),
                          const RadarEntry(value: 1.2),
                          const RadarEntry(value: 0),
                          const RadarEntry(value: 0),
                        ],
                      )
                    ],
                  )
                )
              )
            )
          ],
        ),
      ],
    );
  }
}