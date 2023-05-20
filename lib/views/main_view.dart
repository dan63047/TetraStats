import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/services/sqlite_db_controller.dart';

String _searchFor = "";
late TetrioPlayer me;
DB db = DB();
TetrioService teto = TetrioService();

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Future<TetrioPlayer> fetchTetrioPlayer(String user) async {
    var url = Uri.https('ch.tetr.io', 'api/users/$user');
    db.open();
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

  late Future<TetrioPlayer> me;

  @override
  void initState() {
    super.initState();
    me = fetchTetrioPlayer("blaarg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tetra Stats"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: TextField(
            onChanged: (String value) {
              _searchFor = value;
            },
            onSubmitted: (String value) {
              setState(() {
                me = fetchTetrioPlayer(value);
              });
            },
            maxLength: 25,
          )),
          TextButton(
              child: const Text("Search"),
              onPressed: () {
                setState(() {
                  me = fetchTetrioPlayer(_searchFor);
                });
              }),
          FutureBuilder<TetrioPlayer>(
            future: me,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                snapshot.data!.getRecords();
                teto.storeState(snapshot.data!, db);
                return Flexible(
                    child: Column(children: [
                  Text(snapshot.data!.username.toString()),
                  Text(snapshot.data!.userId.toString()),
                  Text(snapshot.data!.role.toString()),
                  Text(
                      "Level ${snapshot.data!.level.toStringAsFixed(2)} (${snapshot.data!.xp} XP)"),
                  Text("Registered ${snapshot.data!.registrationTime}"),
                  Text("Bio: ${snapshot.data!.bio}", softWrap: true),
                  Text("Country: ${snapshot.data!.country}"),
                  Text("${snapshot.data!.friendCount} friends"),
                  Text(
                      "Won/PLayed: ${snapshot.data!.gamesWon}/${snapshot.data!.gamesPlayed}"),
                  Text("Gametime: ${snapshot.data!.gameTime}"),
                  Text("Supporter tier ${snapshot.data!.supporterTier}"),
                  const Text("\nTetra League", softWrap: true),
                  Text(
                      "${snapshot.data!.tlSeason1.rating.toStringAsFixed(2)} TR"),
                  Text(
                      "${snapshot.data!.tlSeason1.glicko?.toStringAsFixed(2)}±${snapshot.data!.tlSeason1.rd?.toStringAsFixed(2)} GLICKO"),
                  Text(
                      "Rank: ${snapshot.data!.tlSeason1.rank.toUpperCase()} (top ${(snapshot.data!.tlSeason1.percentile * 100).toStringAsFixed(2)}%)"),
                  Text(
                      "Won/Games: ${snapshot.data!.tlSeason1.gamesPlayed}/${snapshot.data!.tlSeason1.gamesWon}"),
                  Text(
                      "№${snapshot.data!.tlSeason1.standing} (№${snapshot.data!.tlSeason1.standingLocal} in country)"),
                  Text(
                      "${snapshot.data!.tlSeason1.apm} APM, ${snapshot.data!.tlSeason1.pps} PPS, ${snapshot.data!.tlSeason1.vs} VS, ${snapshot.data!.tlSeason1.app?.toStringAsFixed(3)} APP"),
                  const Text("\n40 Lines", softWrap: true),
                  Text(snapshot.data!.sprint.isNotEmpty
                      ? snapshot.data!.sprint[0].toString()
                      : "No record"),
                ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
