import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tetra_stats/data_objects/tetrio.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Future<TetrioPlayer> fetchTetrioPlayer() async {
    final response = await http.get(Uri.parse('https://ch.tetr.io/api/users/dan63047'));

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
    me = fetchTetrioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tetra Stats"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          FutureBuilder<TetrioPlayer>(
            future: me,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: [
                      Text(snapshot.data!.username.toString()),
                      Text("Level ${snapshot.data!.getLevel()}"),
                      Text("Registered ${snapshot.data!.registrationTime}"),
                      Text("${snapshot.data!.tlSeason1!.rating} TR"),
                      Text("${snapshot.data!.tlSeason1!.glicko}±${snapshot.data!.tlSeason1!.rd} GLICKO"),
                      TextButton(onPressed: (){print("killed");}, child: const Text("kill")),
                    ]
                );
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