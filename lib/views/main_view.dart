import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
TetrioPlayersLeaderboard? _everyone;
late RangeValues currentRangeValues;
int destination = 0;

// TODO: Redesign some widgets, so they could look nice on mobile view
// - stats below TL progress bar & similar parts in other widgets
// - APP and VS/APM gadget
// - different design for radar graphs
// - i should put tooltips everywhere
Future<FetchResults> getData(String searchFor, {bool withHistory = false}) async {
    TetrioPlayer player;
    try{
      if (searchFor.startsWith("ds:")){
        player = await teto.fetchPlayer(searchFor.substring(3), isItDiscordID: true); // we trying to get him with that 
      }else{
        player = await teto.fetchPlayer(searchFor); // Otherwise it's probably a user id or username
      }
      
    }on TetrioPlayerNotExist{
      return FetchResults(false, null, [], null, null, null, null, null, false, TetrioPlayerNotExist());
    }
    late Summaries summaries;
    late News? news;
    late Cutoffs? cutoffs;
    late CutoffsTetrio? averages;
    try {
      List<dynamic> requests = await Future.wait([
        teto.fetchSummaries(player.userId),
        teto.fetchNews(player.userId),
        teto.fetchCutoffsBeanserver(),
        if (prefs.getBool("showAverages") ?? true) teto.fetchCutoffsTetrio()
      ]);

      summaries = requests[0];
      news = requests[1];
      cutoffs = requests.elementAtOrNull(2);
      averages = requests.elementAtOrNull(3);

    if(withHistory) await teto.fetchAndsaveTLHistory(player.userId, 1); // Retrieve if needed
    } on Exception catch (e) {
      return FetchResults(false, null, [], null, null, null, null, null, false, e);
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

    return FetchResults(true, player, states.reversed.toList(), summaries, news, cutoffs, averages, _meAmongEveryone, isTracking, null);
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
  Cards.overview: t.homeNavigation.overview,
  Cards.tetraLeague: t.gamemodes["league"]!,
  Cards.quickPlay: t.gamemodes["zenith"]!,
  //Cards.quickPlayExpert: "${t.quickPlay} ${t.expert}",
  Cards.sprint: t.gamemodes["zenith"]!,
  Cards.blitz: t.gamemodes["zenithex"]!,
  //Cards.other: t.other
};

late ScrollController controller;

class _MainState extends State<MainView> with TickerProviderStateMixin {
  String _searchFor = "6098518e3d5155e6ec429cdc";
  final TextEditingController _searchController = TextEditingController();
  Timer _backgroundUpdate = Timer(const Duration(days: 365), (){});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    teto.open();
    controller = ScrollController();
    changePlayer(prefs.getString('playerID')??_searchFor);

    if (prefs.getBool("updateInBG") == true) {
      _backgroundUpdate = Timer(Duration(minutes: 5), () {
        changePlayer(_searchFor);
      });
    }

    super.initState();
  }

  void changePlayer(String player) {
    setState(() {
      currentRangeValues = const RangeValues(0, 1);
      _searchFor = player;
      _data = getData(_searchFor);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _searchController.dispose();
    _backgroundUpdate.cancel();
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

   NavigationDestination getMobileDestinationButton(IconData icon, String title){
    return NavigationDestination(
      icon: Tooltip(
        message: title,
        child: Icon(icon)
      ),
      selectedIcon: Icon(icon),
      label: title,
    );
  }

  Widget pickers(int destination){
    return switch (destination) {
      0 => Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<CardMod>(
              showSelectedIcon: false,
              selected: <CardMod>{cardMod},
              segments: modeButtons[rightCard]!,
              onSelectionChanged: (p0) {
                setState(() {
                  cardMod = p0.first;
                });
              },
            ),
          ),
          SegmentedButton<Cards>(
          showSelectedIcon: false,
          segments: <ButtonSegment<Cards>>[
            ButtonSegment<Cards>(
                value: Cards.overview,
                tooltip: t.homeNavigation.overview,
                icon: Icon(Icons.calendar_view_day)),
            ButtonSegment<Cards>(
                value: Cards.tetraLeague,
                tooltip: t.gamemodes["league"],
                icon: SvgPicture.asset("res/icons/league.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
            ButtonSegment<Cards>(
                value: Cards.quickPlay,
                tooltip: t.gamemodes["zenith"],
                icon: SvgPicture.asset("res/icons/qp.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
            ButtonSegment<Cards>(
                value: Cards.sprint,
                tooltip: t.gamemodes["40l"],
                icon: SvgPicture.asset("res/icons/40l.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
            ButtonSegment<Cards>(
                value: Cards.blitz,
                tooltip: t.gamemodes["blitz"],
                icon: SvgPicture.asset("res/icons/blitz.svg", height: 16, colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.modulate))),
          ],
          selected: <Cards>{rightCard},
          onSelectionChanged: (Set<Cards> newSelection) {
            setState(() {
              cardMod = CardMod.info;
              rightCard = newSelection.first;
            });})
        ],
      ),
      1 => SegmentedButton<Graph>(
        showSelectedIcon: false,
        segments: <ButtonSegment<Graph>>[
          ButtonSegment<Graph>(
            value: Graph.history,
            label: Text(t.graphsNavigation.history)),
          ButtonSegment<Graph>(
            value: Graph.leagueState,
            label: Text(t.graphsNavigation.league)),
          ButtonSegment<Graph>(
            value: Graph.leagueCutoffs,
            label: Text(t.graphsNavigation.cutoffs),
          ),
        ],
        selected: <Graph>{graph},
        onSelectionChanged: (Set<Graph> newSelection) {
          setState(() {
            graph = newSelection.first;
            switch (newSelection.first){
              case Graph.leagueCutoffs:
              case Graph.history:
                Ychart = Stats.tr;
              case Graph.leagueState:
                Ychart = Stats.apm;
            }
          });}),
      4 => SegmentedButton<CalcCards>(
          showSelectedIcon: false,
          segments: <ButtonSegment<CalcCards>>[
            ButtonSegment<CalcCards>(
                value: CalcCards.calc,
                label: Text(t.calcNavigation.stats),
                ),
            ButtonSegment<CalcCards>(
                value: CalcCards.damage,
                label: Text(t.calcNavigation.damage),
                ),
          ],
          selected: <CalcCards>{calcCard},
          onSelectionChanged: (Set<CalcCards> newSelection) {
            setState(() {
              calcCard = newSelection.first;
            });}),
      _ => Container()
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        bool screenIsBig = constraints.maxWidth > 768.00;
        return Scaffold(
        key: _scaffoldKey,
        drawer: SearchDrawer(changePlayer: changePlayer, controller: _searchController),
        endDrawer: DestinationsDrawer(changeDestination: (value) {setState(() {destination = value;});}),
        bottomNavigationBar: screenIsBig ? null : BottomAppBar(
          shape: const AutomaticNotchedShape(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))), RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)))),
          notchMargin: 2.0,
          height: 88,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.primary),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: t.navMenuTooltip,
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
                Expanded(
                  child: pickers(destination),
                ),
                SizedBox(
                  width: 40.0,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: screenIsBig ? null : FloatingActionButtonLocation.endDocked,
        floatingActionButton: screenIsBig ? null : FloatingActionButton(
          elevation: 0,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
            _searchController.clear();
          },
          child: const Icon(Icons.search),
        ),
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (screenIsBig) TweenAnimationBuilder(
                child: NavigationRail(
                  leading: FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                      _searchController.clear();
                    },
                    child: const Icon(Icons.search),
                  ),
                  trailing: IconButton(
                    tooltip: t.refresh,
                    onPressed: () {
                      changePlayer(_searchFor);
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  destinations: [
                    getDestinationButton(Icons.home, t.destinations.home),
                    getDestinationButton(Icons.data_thresholding_outlined, t.destinations.graphs),
                    getDestinationButton(Icons.leaderboard, t.destinations.leaderboards),
                    getDestinationButton(Icons.compress, t.destinations.cutoffs),
                    getDestinationButton(Icons.calculate, t.destinations.calc),
                    getDestinationButton(Icons.info_outline, t.destinations.info),
                    getDestinationButton(Icons.storage, t.destinations.data),
                    getDestinationButton(Icons.settings, t.destinations.settings),
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
                  0 => DestinationHome(searchFor: _searchFor, constraints: constraints, dataFuture: _data, noSidebar: !screenIsBig),
                  1 => DestinationGraphs(searchFor: _searchFor, constraints: constraints, noSidebar: !screenIsBig),
                  2 => DestinationLeaderboards(constraints: constraints, noSidebar: !screenIsBig),
                  3 => DestinationCutoffs(constraints: constraints),
                  4 => DestinationCalculator(constraints: constraints),
                  5 => DestinationInfo(constraints: constraints),
                  6 => DestinationSavedData(constraints: constraints),
                  7 => DestinationSettings(constraints: constraints),
                  _ => Text("Unknown destination $destination")
                },
              )
            ]
          ),
        ));
      }
    );
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
      child: SafeArea(
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
                        hintText: t.searchHint,
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
                        autoFocus: true,
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
                        child: Text(t.trackedPlayers, style: Theme.of(context).textTheme.headlineLarge),
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
        ),
      )
    );
  }
}

class DestinationsDrawer extends StatefulWidget{
  final Function changeDestination;

  const DestinationsDrawer({super.key, required this.changeDestination});

  @override
  State<StatefulWidget> createState() => _DestinationsDrawerState();
  
}

class _DestinationsDrawerState extends State<DestinationsDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool value){
          return [
            SliverToBoxAdapter(
              child: DrawerHeader(
                child: Text(t.navMenu, style: const TextStyle(color: Colors.white, fontSize: 25),
          )))
          ];
        },
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text(t.destinations.home),
              onTap: (){
                widget.changeDestination(0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.data_thresholding_outlined),
              title: Text(t.destinations.graphs),
              onTap: (){
                widget.changeDestination(1);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text(t.destinations.leaderboards),
              onTap: (){
                widget.changeDestination(2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.compress),
              title: Text(t.destinations.cutoffs),
              onTap: (){
                widget.changeDestination(3);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text(t.destinations.calc),
              onTap: (){
                widget.changeDestination(4);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(t.destinations.info),
              onTap: (){
                widget.changeDestination(5);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text(t.destinations.data),
              onTap: (){
                widget.changeDestination(6);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(t.destinations.settings),
              onTap: (){
                widget.changeDestination(7);
                Navigator.of(context).pop();
              },
            ),
          ],
        )
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