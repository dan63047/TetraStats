import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

String _searchFor = "";
late Future<TetrioPlayer> me;
DB db = DB();
TetrioService teto = TetrioService();
const allowedHeightForPlayerIdInPixels = 40.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;

enum SampleItem { itemOne, itemTwo, itemThree }

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  String get title => "Tetra Stats: $_searchFor";

  @override
  State<MainView> createState() => _MainViewState();
}

Future<TetrioPlayer> fetchTetrioPlayer(String user) async {
  var url = Uri.https('ch.tetr.io', 'api/users/${user.toLowerCase()}');
  final response = await http.get(url);
  // final response = await http.get(Uri.parse('https://ch.tetr.io/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body)['success']
        ? TetrioPlayer.fromJson(
            jsonDecode(response.body)['data']['user'],
            DateTime.fromMillisecondsSinceEpoch(
                jsonDecode(response.body)['cache']['cached_at'],
                isUtc: true))
        : throw Exception("User doesn't exist");
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch player');
  }
}

class _MainViewState extends State<MainView> {
  bool _searchBoolean = false;
  @override
  void initState() {
    super.initState();
    me = fetchTetrioPlayer("dan63047");
  }

  Widget _searchTextField() {
    return TextField(
      style: const TextStyle(
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 3.0,
            color: Colors.black,
          ),
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 8.0,
            color: Colors.black,
          ),
        ],
      ),
      onSubmitted: (String value) => setState(() {
        me = fetchTetrioPlayer(value);
        _searchFor = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: !_searchBoolean
            ? Text(
                widget.title,
                style: const TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            : _searchTextField(),
        backgroundColor: Colors.black,
        actions: [
          !_searchBoolean
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      //add
                      _searchBoolean = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                  tooltip: "Search player",
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      //add
                      _searchBoolean = false;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: "Close search",
                ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemOne,
                child: Text('Compare'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemTwo,
                child: Text('States'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.itemThree,
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<TetrioPlayer>(
          future: me,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  _UserThingy(player: snapshot.data!),
                  _PlayerTabSection(context, snapshot.data!)
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${snapshot.error}',
                      style: const TextStyle(
                          fontFamily: "Eurostile Round Extended",
                          fontSize: 42)));
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              child: Text(
            'Side menu',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}

class _UserThingy extends StatelessWidget {
  final TetrioPlayer player;
  _UserThingy({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      double bannerHeight = bigScreen ? 240 : 120;
      double pfpHeight = bigScreen ? 64 : 32;
      return Column(
        children: [
          Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (player.bannerRevision != null)
                    Image.network(
                      "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                      fit: BoxFit.cover,
                      height: bannerHeight,
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        player.bannerRevision != null
                            ? bannerHeight / 1.4
                            : pfpHeight,
                        0,
                        0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                          ? Image.asset(
                              "res/avatars/tetrio_banned.png",
                              fit: BoxFit.fitHeight,
                              height: 128,
                            )
                          : Image.network(
                              "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                              fit: BoxFit.fitHeight,
                              height: 128,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "res/avatars/tetrio_anon.png",
                                fit: BoxFit.fitHeight,
                                height: 128,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(player.username,
                        style: TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            fontSize: bigScreen ? 42 : 28)),
                    Text(
                      player.userId,
                      style: const TextStyle(
                          fontFamily: "Eurostile Round Condensed",
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (player.role != "banned")
              ? Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  clipBehavior: Clip.hardEdge, // hard WHAT???
                  children: [
                    _StatCellNum(
                      playerStat: player.level,
                      playerStatLabel: "XP Level",
                      isScreenBig: bigScreen,
                      snackBar:
                          "${player.xp.floor().toString()} XP, ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} % until next level",
                    ),
                    if (player.gameTime >= Duration.zero)
                      _StatCellNum(
                        playerStat: (player.gameTime.inSeconds / 3600),
                        playerStatLabel: "Hours\nPlayed",
                        isScreenBig: bigScreen,
                        snackBar: player.gameTime.toString(),
                      ),
                    if (player.gamesPlayed >= 0)
                      _StatCellNum(
                          playerStat: player.gamesPlayed,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Online\nGames"),
                    if (player.gamesWon >= 0)
                      _StatCellNum(
                          playerStat: player.gamesWon,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Games\nWon"),
                    if (player.friendCount > 0)
                      _StatCellNum(
                          playerStat: player.friendCount,
                          isScreenBig: bigScreen,
                          playerStatLabel: "Friends"),
                  ],
                )
              : Text(
                  "BANNED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Eurostile Round Extended",
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontSize: bigScreen ? 60 : 45,
                  ),
                ),
          if (player.badstanding != null)
            player.badstanding!
                ? Text(
                    "BAD STANDING",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      fontWeight: FontWeight.w900,
                      color: Colors.red,
                      fontSize: bigScreen ? 60 : 45,
                    ),
                  )
                : const Text(
                    "Was in bad standing long time ago",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                    "${player.country?.toUpperCase()} • ${player.role.capitalize()} account ${player.registrationTime == null ? "that was from very beginning" : 'created ${player.registrationTime}'} • ${player.supporterTier == 0 ? "Not a supporter" : "Supporter tier ${player.supporterTier}"}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Eurostile Round",
                      fontSize: 16,
                    )),
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
              for (var badge in player.badges)
                IconButton(
                    onPressed: () => showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                badge.label,
                                style: const TextStyle(
                                    fontFamily: "Eurostile Round Extended"),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 25,
                                      children: [
                                        Image.asset(
                                            "res/tetrio_badges/${badge.badgeId}.png"),
                                        Text(badge.ts != null
                                            ? "Obtained ${badge.ts}"
                                            : "That badge was assigned manualy by TETR.IO admins"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                    tooltip: badge.label,
                    icon: Image.asset(
                      "res/tetrio_badges/${badge.badgeId}.png",
                      height: 64,
                      width: 64,
                    ))
            ],
          ),
        ],
      );
    });
  }
}

class _StatCellNum extends StatelessWidget {
  const _StatCellNum(
      {required this.playerStat,
      required this.playerStatLabel,
      required this.isScreenBig,
      this.snackBar,
      this.fractionDigits});

  final num playerStat;
  final String playerStatLabel;
  final bool isScreenBig;
  final String? snackBar;
  final int? fractionDigits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fractionDigits != null
              ? playerStat.toStringAsFixed(fractionDigits!)
              : playerStat.floor().toString(),
          style: TextStyle(
            fontFamily: "Eurostile Round Extended",
            fontSize: isScreenBig ? 32 : 24,
          ),
        ),
        snackBar == null
            ? Text(
                playerStatLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Eurostile Round",
                  fontSize: 16,
                ),
              )
            : TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(snackBar!)));
                },
                child: Text(
                  playerStatLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Eurostile Round",
                    fontSize: 16,
                  ),
                )),
      ],
    );
  }
}

Widget _PlayerTabSection(BuildContext context, TetrioPlayer player) {
  bool bigScreen = MediaQuery.of(context).size.width > 768;
  return DefaultTabController(
    length: 4,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: TabBar(tabs: [
            Tab(text: "Tetra League"),
            Tab(text: "40 Lines"),
            Tab(text: "Blitz"),
            Tab(text: "Other"),
          ]),
        ),
        Container(
          //Add this to give height
          height: MediaQuery.of(context).size.height,
          child: TabBarView(children: [
            Container(
              child: Column(
                children: (player.tlSeason1.gamesPlayed > 0)
                    ? [
                        Text("Tetra League",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                        if (player.tlSeason1.gamesPlayed >= 10)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "res/tetrio_tl_alpha_ranks/${player.tlSeason1.rank}.png",
                                height: bigScreen ? 128 : 64,
                              ),
                              Column(children: [
                                Text(
                                    "${player.tlSeason1.rating.toStringAsFixed(2)} TR",
                                    style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28)),
                                Text(
                                  "Top ${(player.tlSeason1.percentile * 100).toStringAsFixed(2)}% • Top Rank: ${player.tlSeason1.bestRank.toUpperCase()} • Glicko: ${player.tlSeason1.glicko?.toStringAsFixed(2)}±${player.tlSeason1.rd?.toStringAsFixed(2)}${player.tlSeason1.decaying ? ' • Decaying' : ''}",
                                  textAlign: TextAlign.center,
                                ),
                              ])
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                      "${10 - player.tlSeason1.gamesPlayed} games until being ranked",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontFamily: "Eurostile Round Extended",
                                        fontSize: bigScreen ? 42 : 28,
                                        overflow: TextOverflow.visible,
                                      )),
                                  //Text("Top ${(player.tlSeason1.percentile * 100).toStringAsFixed(2)}% • Glicko: ${player.tlSeason1.glicko?.toStringAsFixed(2)}±${player.tlSeason1.rd?.toStringAsFixed(2)}${player.tlSeason1.decaying ? ' • Decaying' : ''}")
                                ],
                              )
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 48),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            spacing: 25,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              if (player.tlSeason1.apm != null)
                                _StatCellNum(
                                    playerStat: player.tlSeason1.apm!,
                                    isScreenBig: bigScreen,
                                    fractionDigits: 2,
                                    playerStatLabel: "Attack\nPer Minute"),
                              if (player.tlSeason1.pps != null)
                                _StatCellNum(
                                    playerStat: player.tlSeason1.pps!,
                                    isScreenBig: bigScreen,
                                    fractionDigits: 2,
                                    playerStatLabel: "Pieces\nPer Second"),
                              if (player.tlSeason1.apm != null)
                                _StatCellNum(
                                    playerStat: player.tlSeason1.vs!,
                                    isScreenBig: bigScreen,
                                    fractionDigits: 2,
                                    playerStatLabel: "Versus\nScore"),
                              if (player.tlSeason1.standing > 0)
                                _StatCellNum(
                                    playerStat: player.tlSeason1.standing,
                                    isScreenBig: bigScreen,
                                    playerStatLabel: "Leaderboard\nplacement"),
                              if (player.tlSeason1.standingLocal > 0)
                                _StatCellNum(
                                    playerStat: player.tlSeason1.standingLocal,
                                    isScreenBig: bigScreen,
                                    playerStatLabel: "Country LB\nplacement"),
                              _StatCellNum(
                                  playerStat: player.tlSeason1.gamesPlayed,
                                  isScreenBig: bigScreen,
                                  playerStatLabel: "Games\nplayed"),
                              _StatCellNum(
                                  playerStat: player.tlSeason1.gamesWon,
                                  isScreenBig: bigScreen,
                                  playerStatLabel: "Games\nwon"),
                              _StatCellNum(
                                  playerStat: player.tlSeason1.winrate * 100,
                                  isScreenBig: bigScreen,
                                  fractionDigits: 2,
                                  playerStatLabel: "Winrate\nprecentage"),
                            ],
                          ),
                        ),
                        if (player.tlSeason1.apm != null &&
                            player.tlSeason1.pps != null &&
                            player.tlSeason1.apm != null)
                          Column(
                            children: [
                              Text("Nerd Stats",
                                  style: TextStyle(
                                      fontFamily: "Eurostile Round Extended",
                                      fontSize: bigScreen ? 42 : 28)),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 48),
                                child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    spacing: 25,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      _StatCellNum(
                                          playerStat: player.tlSeason1.app!,
                                          isScreenBig: bigScreen,
                                          fractionDigits: 3,
                                          playerStatLabel: "Attack\nPer Piece"),
                                      _StatCellNum(
                                          playerStat: player.tlSeason1.vsapm!,
                                          isScreenBig: bigScreen,
                                          fractionDigits: 3,
                                          playerStatLabel: "VS/APM"),
                                      _StatCellNum(
                                          playerStat: player.tlSeason1.dss!,
                                          isScreenBig: bigScreen,
                                          fractionDigits: 3,
                                          playerStatLabel:
                                              "Downstack\nPer Second"),
                                      _StatCellNum(
                                          playerStat: player.tlSeason1.dsp!,
                                          isScreenBig: bigScreen,
                                          fractionDigits: 3,
                                          playerStatLabel:
                                              "Downstack\nPer Piece"),
                                    ]),
                              )
                            ],
                          )
                      ]
                    : [
                        Text("That user never played Tetra League",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                fontSize: bigScreen ? 42 : 28)),
                      ],
              ),
            ),
            Container(
              child: Text("40 Lines",
                  style: TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      fontSize: bigScreen ? 42 : 28)),
            ),
            Container(
              child: Text("Blitz",
                  style: TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      fontSize: bigScreen ? 42 : 28)),
            ),
            Container(
              child: Text("Other info",
                  style: TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      fontSize: bigScreen ? 42 : 28)),
            ),
          ]),
        ),
      ],
    ),
  );
}
