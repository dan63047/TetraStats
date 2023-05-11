import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tetra_stats/data_objects/tetrio.dart';

String _searchFor = "";
TetrioPlayer me = TetrioPlayer();

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Future<TetrioPlayer> fetchTetrioPlayer(String user) async {
    var url = Uri.https('ch.tetr.io', 'api/users/$user');
    final response = await http.get(url);
    // final response = await http.get(Uri.parse('https://ch.tetr.io/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TetrioPlayer.fromJson(jsonDecode(response.body));
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
                return Column(children: [
                  Text(snapshot.data!.username.toString()),
                  Text("Level ${snapshot.data!.getLevel()}"),
                  Text("Registered ${snapshot.data!.registrationTime}"),
                  Text("${snapshot.data!.tlSeason1!.rating} TR"),
                  Text(
                      "${snapshot.data!.tlSeason1!.glicko}±${snapshot.data!.tlSeason1!.rd} GLICKO"),
                  Text("${snapshot.data!.zen}")
                ]);
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
