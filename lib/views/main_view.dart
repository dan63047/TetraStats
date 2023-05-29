import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';

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
    return TetrioPlayer.fromJson(
        jsonDecode(response.body)['data']['user'],
        DateTime.fromMillisecondsSinceEpoch(
            jsonDecode(response.body)['cache']['cached_at'],
            isUtc: true));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch player');
  }
}

class _MainViewState extends State<MainView> {
  bool _searchBoolean = false;
  String _coverLink = "";
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
        flexibleSpace: Image.network(
          _coverLink,
          fit: BoxFit.cover,
        ),
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
              _coverLink =
                  "https://tetr.io/user-content/banners/${snapshot.data!.userId}.jpg?rv=${snapshot.data!.bannerRevision}";
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
  const _UserThingy({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

      return Column(
        children: [
          Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.network(
                  "https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                  fit: BoxFit.fitHeight,
                  height: 128,
                ),
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
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.hardEdge, // hard WHAT???
            children: [
              _StatCellNum(
                  playerStat: player.level,
                  playerStatLabel: "Level\n${player.xp.floor().toString()} XP"),
              _StatCellDuration(
                  playerStat: player.gameTime, playerStatLabel: "Gametime"),
              _StatCellNum(
                  playerStat: player.gamesPlayed,
                  playerStatLabel: "Games\nPlayed"),
              _StatCellNum(
                  playerStat: player.gamesWon, playerStatLabel: "Games\nWon"),
            ],
          )
        ],
      );
    });
  }
}

class _StatCellNum extends StatelessWidget {
  const _StatCellNum({
    super.key,
    required this.playerStat,
    required this.playerStatLabel,
  });

  final num playerStat;
  final String playerStatLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          playerStat.toStringAsFixed(0),
          style: const TextStyle(
            fontFamily: "Eurostile Round Extended",
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          playerStatLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Eurostile Round",
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _StatCellDuration extends StatelessWidget {
  const _StatCellDuration({
    super.key,
    required this.playerStat,
    required this.playerStatLabel,
  });

  final Duration playerStat;
  final String playerStatLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          playerStat.toString().toString().split('.').first.padLeft(8, "0"),
          style: const TextStyle(
            fontFamily: "Eurostile Round Extended",
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          playerStatLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Eurostile Round",
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
