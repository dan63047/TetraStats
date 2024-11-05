import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/cutoff_tetrio.dart';
import 'package:tetra_stats/data_objects/news.dart';
import 'package:tetra_stats/data_objects/p1nkl0bst3r.dart';
import 'package:tetra_stats/data_objects/player_leaderboard_position.dart';
import 'package:tetra_stats/data_objects/summaries.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/data_objects/tetrio_players_leaderboard.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/services/crud_exceptions.dart';
import 'package:tetra_stats/views/destination_calculator.dart';
import 'package:tetra_stats/views/destination_cutoffs.dart';
import 'package:tetra_stats/views/destination_graphs.dart';
import 'package:tetra_stats/views/destination_home.dart';
import 'package:tetra_stats/views/destination_info.dart';
import 'package:tetra_stats/views/destination_leaderboards.dart';
import 'package:tetra_stats/views/destination_saved_data.dart';
import 'package:tetra_stats/views/destination_settings.dart';
import 'package:tetra_stats/main.dart';

late Future<FetchResults> _data;
late Future<News> _newsData;
TetrioPlayersLeaderboard? _everyone;

Future<FetchResults> getData(String searchFor) async {
    TetrioPlayer player;
    try{
      if (searchFor.startsWith("ds:")){
        player = await teto.fetchPlayer(searchFor.substring(3), isItDiscordID: true); // we trying to get him with that 
      }else{
        player = await teto.fetchPlayer(searchFor); // Otherwise it's probably a user id or username
      }
      
    }on TetrioPlayerNotExist{
      return FetchResults(false, null, [], null, null, null, null, false, TetrioPlayerNotExist());
    }
    late Summaries summaries;
    late Cutoffs? cutoffs;
    late CutoffsTetrio? averages;
    try {
      List<dynamic> requests = await Future.wait([
        teto.fetchSummaries(player.userId),
        teto.fetchCutoffsBeanserver(),
        if (prefs.getBool("showAverages") == true) teto.fetchCutoffsTetrio()
      ]);

      summaries = requests[0];
      cutoffs = requests.elementAtOrNull(1);
      averages = requests.elementAtOrNull(2);
    } on Exception catch (e) {
      return FetchResults(false, null, [], null, null, null, null, false, e);
    }
    PlayerLeaderboardPosition? _meAmongEveryone;
    if (prefs.getBool("showPositions") == true){
      // Get tetra League leaderboard
      _everyone = teto.getCachedLeaderboard();
      _everyone ??= await teto.fetchTLLeaderboard();
      if (_everyone!.leaderboard.isNotEmpty){
        _meAmongEveryone = await compute(_everyone!.getLeaderboardPosition, {player.userId: summaries.league});
        if (_meAmongEveryone != null) teto.cacheLeaderboardPositions(player.userId, _meAmongEveryone); 
      }
    }
    List<TetraLeague> states = await teto.getStates(player.userId, season: currentSeason);

    bool isTracking = await teto.isPlayerTracking(player.userId);
    if (isTracking){ // if tracked - save data to local DB
      await teto.storeState(summaries.league);
    }

    return FetchResults(true, player, states, summaries, cutoffs, averages, _meAmongEveryone, isTracking, null);
  }

class MainView extends StatefulWidget {
  final String? player;
  /// The very first view, that user see when he launch this programm.
  /// By default it loads my or defined in preferences user stats, but
  /// if [player] username or id provided, it loads his stats. Also it hides menu drawer and three dots menu.
  const MainView({super.key, this.player});

  @override
  State<MainView> createState() => _MainState();
}

enum Cards {overview, tetraLeague, quickPlay, sprint, blitz}
enum CardMod {info, records, ex, exRecords}
Map<Cards, String> cardsTitles = {
  Cards.overview: "Overview",
  Cards.tetraLeague: t.tetraLeague,
  Cards.quickPlay: t.quickPlay,
  //Cards.quickPlayExpert: "${t.quickPlay} ${t.expert}",
  Cards.sprint: t.sprint,
  Cards.blitz: t.blitz,
  //Cards.other: t.other
};

late ScrollController controller;

class _MainState extends State<MainView> with TickerProviderStateMixin {
  int destination = 0;
  String _searchFor = "6098518e3d5155e6ec429cdc";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    teto.open();
    controller = ScrollController();
    changePlayer(_searchFor);
    super.initState();
  }

  void changePlayer(String player) {
    setState(() {
      _searchFor = player;
      _data = getData(_searchFor);
      _newsData = teto.fetchNews(_searchFor);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  NavigationRailDestination getDestinationButton(IconData icon, String title){
    return NavigationRailDestination(
      icon: Tooltip(
        message: title,
        child: Icon(icon)
      ),
      selectedIcon: Icon(icon),
      label: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SearchDrawer(changePlayer: changePlayer, controller: _searchController),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              child: NavigationRail(
                leading: FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(Icons.search),
                    ),
                trailing: IconButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                destinations: [
                  getDestinationButton(Icons.home, "Home"),
                  getDestinationButton(Icons.data_thresholding_outlined, "Graphs"),
                  getDestinationButton(Icons.leaderboard, "Leaderboards"),
                  getDestinationButton(Icons.compress, "Cutoffs"),
                  getDestinationButton(Icons.calculate, "Calc"),
                  getDestinationButton(Icons.info_outline, "Information"),
                  getDestinationButton(Icons.storage, "Saved Data"),
                  getDestinationButton(Icons.settings, "Settings"),
                ],
                selectedIndex: destination,
                onDestinationSelected: (value) {
                  setState(() {
                    destination = value;
                  });
                },
                ),
                duration: Durations.long4,
                tween: Tween<double>(begin: 0, end: 1),
                curve: Easing.standard,
                builder: (context, value, child) {
                  return Container(
                    transform: Matrix4.translationValues(-80+value*80, 0, 0),
                    child: Opacity(opacity: value, child: child),
                  );
                },
            ),
            Expanded(
              child: switch (destination){
                0 => DestinationHome(searchFor: _searchFor, constraints: constraints, dataFuture: _data, newsFuture: _newsData),
                1 => DestinationGraphs(searchFor: _searchFor, constraints: constraints),
                2 => DestinationLeaderboards(constraints: constraints),
                3 => DestinationCutoffs(constraints: constraints),
                4 => DestinationCalculator(constraints: constraints),
                5 => DestinationInfo(constraints: constraints),
                6 => DestinationSavedData(constraints: constraints),
                7 => DestinationSettings(constraints: constraints),
                _ => Text("Unknown destination $destination")
              },
            )
          ]);
        },
      ));
  }
}

class SearchDrawer extends StatefulWidget{
  final Function changePlayer;
  final TextEditingController controller;
  const SearchDrawer({super.key, required this.changePlayer, required this.controller});

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer>  {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: teto.allPlayers,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
            case ConnectionState.active:
            final allPlayers = (snapshot.data != null)
                ? snapshot.data as Map<String, String>
                : <String, String>{};
            allPlayers.remove(prefs.getString("playerID") ?? "6098518e3d5155e6ec429cdc"); // player from the home button will be delisted
            List<String> keys = allPlayers.keys.toList();
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool value){
                return [
                  SliverToBoxAdapter(
                    child: SearchBar(
                      controller: widget.controller,
                      hintText: "Enter the username",
                      hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
                      trailing: [
                        IconButton(onPressed: (){setState(() {
                          widget.changePlayer(widget.controller.value.text);
                          Navigator.of(context).pop();
                        });}, icon: const Icon(Icons.search))
                      ],
                      onSubmitted: (value) {
                        setState(() {
                          widget.changePlayer(value);
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text(prefs.getString("player") ?? "dan63"),
                    onTap: () {
                      widget.changePlayer(prefs.getString("playerID") ?? "6098518e3d5155e6ec429cdc");
                      Navigator.of(context).pop();
                    },
                  ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("Tracked Players", style: Theme.of(context).textTheme.headlineLarge),
                    ),
                  )
                ];
              },
              body: ListView.builder( // Builds list of tracked players.
              itemCount: allPlayers.length,
              itemBuilder: (context, index) {
                var i = allPlayers.length-1-index; // Last players in this map are most recent ones, they are gonna be shown at the top.
                return ListTile(
                  title: Text(allPlayers[keys[i]]??keys[i]), // Takes last known username from list of states
                  trailing: IconButton(onPressed: (){
                    teto.deletePlayerToTrack(keys[i]);
                  }, icon: Icon(Icons.delete, color: Colors.grey)),
                  onTap: () {
                    widget.changePlayer(keys[i]); // changes to chosen player
                    Navigator.of(context).pop(); // and closes itself.
                  },
                );
              })
            );
          }
        }
      )
    );
  }
}

// class EstTrThingy extends StatelessWidget{
//   final EstTr estTr;

//   const EstTrThingy({super.key, required this.estTr});
  
//   @override
//   Widget build(BuildContext context) {
//     return const Card(
//       //child: ,
//     );
//   }
// }