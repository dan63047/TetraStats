// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    setState(() {
      
    });
  }

  void addPlayer(String nickname) async {
    players.add(await teto.fetchPlayer(nickname));
    summaries.add(await teto.fetchSummaries(players.last.userId));
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
              Row(
                children: [
                  SizedBox(
                    width: 200.0, height: 175.0, child: Expanded(child: Card(child: Padding(
                    padding: const EdgeInsets.fromLTRB(80.0, 10.0, 5.0, 0),
                    child: Text("Comparison", style: TextStyle(fontSize: 20)),
                    ),
                  ))
                ),
                  for (var p in players) SizedBox(width: 350.0, child: HeaderCard(p)),
                  SizedBox(width: 350.0, child: AddNewColumnCard(addPlayer))
                ]
              ),
              Table(
                border: TableBorder(verticalInside: BorderSide(color: Colors.grey)),
                defaultColumnWidth: FixedColumnWidth(350),
                columnWidths: {
                  0: FixedColumnWidth(200.000)
                },
                children: [
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Account Created")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(timestamp(p.registrationTime!)))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("XP")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Time Played")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Online Games Played")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white))),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Online Games Won")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white))),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Followers")),
                      for (var p in players) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(p.friendCount))),
                    ]
                  ),
                ],
              ),
              SizedBox(
              width: 200+(summaries.length*350),
              child: ExpansionTile(
                title: Text("Tetra League"),
                children: [
                  Table(
                    border: TableBorder(verticalInside: BorderSide(color: Colors.grey)),
                    defaultColumnWidth: FixedColumnWidth(350),
                    columnWidths: {
                      0: FixedColumnWidth(200.000)
                    },
                    children: [
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Tetra Rating")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.tr.isNegative ? "---" : f4.format(s.league.tr))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Glicko")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.glicko!.isNegative ? "---" : f4.format(s.league.glicko))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("RD")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.rd!.isNegative ? "---" : f4.format(s.league.rd))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("GLIXARE")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.gxe.isNegative ? "---" : f4.format(s.league.gxe))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("S1-like TR")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.s1tr.isNegative ? "---" : f4.format(s.league.s1tr))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Games Played")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(s.league.gamesPlayed))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Games Won")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(intf.format(s.league.gamesWon))),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Winrate")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.winrate.isNaN ? "---" : f4.format(s.league.winrate*100)+"%")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Attack Per Minute")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.apm) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Pieces Per Second")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.pps) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Versus Score")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.apm != null ? f2.format(s.league.vs) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Nerd Stats")),
                          for (var _ in summaries) Container(),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Attack Per Piece")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.app) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("VS / APM")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.vsapm) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Downstack Per Second")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dss) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Downstack Per Piece")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.dsp) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("APP + DSP")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.appdsp) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Cheese Index")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.cheese) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Garbage Efficiency")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.gbe) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Weighted APP")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.nyaapp) : "---")),
                        ]
                      ),
                      TableRow(
                        children: [
                          Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text("Area")),
                          for (var s in summaries) Container(padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), child: Text(s.league.nerdStats != null ? f4.format(s.league.nerdStats!.area) : "---")),
                        ]
                      ),
                    ],
                  ),
                ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}


// Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Row(
//             children: [
//               SizedBox(
//                 height: 175.0,
//                 width: 300.0,
//                 child: Expanded(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(80.0, 10.0, 5.0, 0),
//                       child: Text("Comparison", style: TextStyle(fontSize: 28)),
//                     ),
//                   ),
//                 ),
//               ),
//               for (var p in players) SizedBox(
//                 width: 300.0,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     HeaderCard(p),
                    
//                   ],
//                 ),
//               ),
//               SizedBox(width: 300, child: AddNewColumnCard(addPlayer))
//             ]
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 300.0,
//                 child: Card(
//                   child: Column(children: [
//                     Text("Registration Date"),
//                     const Divider(),
//                     Text("XP"),
//                     const Divider(),
//                     Text("Time Played"),
//                     const Divider(),
//                     Text("Online Games Played"),
//                     const Divider(),
//                     Text("Online Games Won"),
//                     const Divider(),
//                     Text("Followers"),
//                   ]),
//                 ),
//               ),
//               for (var p in players) SizedBox(
//                 width: 300.0,
//                 child: Card(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(timestamp(p.registrationTime!)),
//                       const Divider(),
//                       RichText(text: p.xp.isNegative ? TextSpan(text: "hidden", style: TextStyle(fontFamily: "Eurostile Round", color: Colors.grey)) : TextSpan(text: intf.format(p.xp), style: TextStyle(fontFamily: "Eurostile Round"), children: [TextSpan(text: " (lvl ${intf.format(p.level.floor())})", style: TextStyle(color: Colors.grey))])),
//                       const Divider(),
//                       Text(p.gameTime.isNegative ? "hidden" : playtime(p.gameTime), style: TextStyle(color: p.gameTime.isNegative ? Colors.grey : Colors.white)),
//                       const Divider(),
//                       Text(p.gamesPlayed.isNegative ? "hidden" : intf.format(p.gamesPlayed), style: TextStyle(color: p.gamesPlayed.isNegative ? Colors.grey : Colors.white)),
//                       const Divider(),
//                       Text(p.gamesWon.isNegative ? "hidden" : intf.format(p.gamesWon), style: TextStyle(color: p.gamesWon.isNegative ? Colors.grey : Colors.white)),
//                       const Divider(),
//                       Text(intf.format(p.friendCount))
//                     ],
//                   ),
//                 ),
//               ),
//             ]
//           ),
//           SizedBox(
//             width: 500,
//             child: ExpansionTile(
//               title: Text("Test"),
//               children: [Text("test1"), Text("test2")],
//             ),
//           )
//         ])


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