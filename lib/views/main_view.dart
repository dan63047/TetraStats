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
  var url = Uri.https('ch.tetr.io', 'api/users/$user');
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
      decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      style: const TextStyle(
        color: Colors.white,
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
      backgroundColor: Colors.black,
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
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}',
                  style: const TextStyle(
                      fontFamily: "Eurostile Round Extended",
                      color: Colors.white,
                      fontSize: 42));
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
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
                      height: 240,
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0, player.bannerRevision != null ? 170 : 64, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.network(
                        "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                        fit: BoxFit.fitHeight,
                        height: 128,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.network(
                          "https://tetr.io/res/avatar.png",
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
                        style: const TextStyle(
                            fontFamily: "Eurostile Round Extended",
                            color: Colors.white,
                            fontSize: 42)),
                    Text(
                      player.userId,
                      style: const TextStyle(
                          fontFamily: "Eurostile Round Condensed",
                          color: Colors.white,
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
                      playerStatLabel: "Level",
                      snackBar:
                          "${player.xp.floor().toString()} XP, ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} % until next level",
                    ),
                    if (player.gameTime >= Duration.zero)
                      _StatCellNum(
                        playerStat: (player.gameTime.inSeconds / 3600),
                        playerStatLabel: "Hours\nPlayed",
                        snackBar: player.gameTime.toString(),
                      ),
                    if (player.gamesPlayed >= 0)
                      _StatCellNum(
                          playerStat: player.gamesPlayed,
                          playerStatLabel: "Games\nPlayed"),
                    if (player.gamesWon >= 0)
                      _StatCellNum(
                          playerStat: player.gamesWon,
                          playerStatLabel: "Games\nWon"),
                    if (player.friendCount > 0)
                      _StatCellNum(
                          playerStat: player.friendCount,
                          playerStatLabel: "Friends"),
                  ],
                )
              : Text(
                  "BANNED",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Eurostile Round Extended",
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontSize: 60,
                  ),
                ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.hardEdge,
            children: [
              Text(
                  "${player.role.capitalize()} account ${player.registrationTime == null ? "that was from very beginning" : 'created ${player.registrationTime}'}",
                  style: const TextStyle(
                    fontFamily: "Eurostile Round",
                    color: Colors.white,
                    fontSize: 16,
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
      {super.key,
      required this.playerStat,
      required this.playerStatLabel,
      this.snackBar});

  final num playerStat;
  final String playerStatLabel;
  final String? snackBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          playerStat.floor().toString(),
          style: const TextStyle(
            fontFamily: "Eurostile Round Extended",
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        snackBar == null
            ? Text(
                playerStatLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Eurostile Round",
                  color: Colors.white,
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
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
      ],
    );
  }
}
