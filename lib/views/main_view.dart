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
const allowedHeightForPlayerIdInPixels = 60.0;
const allowedHeightForPlayerBioInPixels = 30.0;
const givenTextHeightByScreenPercentage = 0.3;

enum SampleItem { itemOne, itemTwo, itemThree }

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
      drawer: NavDrawer(),
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Tetra Stats"),
            floating: false,
            pinned: true,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.network(
                    "https://tetr.io/user-content/avatars/6098518e3d5155e6ec429cdc.jpg?rv=1673453211638",
                    fit: BoxFit.fitHeight,
                    height: 256,
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (constraints.maxHeight *
                              givenTextHeightByScreenPercentage >
                          allowedHeightForPlayerBioInPixels)
                        const Text("dan63047",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                color: Colors.white,
                                fontSize: 42))
                      else
                        const Text("dan63047",
                            style: TextStyle(
                                fontFamily: "Eurostile Round Extended",
                                color: Colors.white,
                                fontSize: 36)),
                      if (constraints.maxHeight *
                              givenTextHeightByScreenPercentage >
                          allowedHeightForPlayerIdInPixels)
                        const Text(
                          "6098518e3d5155e6ec429cdc",
                          style: TextStyle(
                              fontFamily: "Eurostile Round Condensed",
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      if (constraints.maxHeight *
                              givenTextHeightByScreenPercentage >
                          allowedHeightForPlayerBioInPixels)
                        const Text(
                            "osk, please, if my supporter ends, let me use :petthekagari: in the chat",
                            style: TextStyle(
                              fontFamily: "Eurostile Round",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            softWrap: true),
                    ],
                  );
                })
              ],
            ),
            expandedHeight: 400,
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                tooltip: "Search player",
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: Text('Item 1'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemTwo,
                    child: Text('Item 2'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemThree,
                    child: Text('Item 3'),
                  ),
                ],
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item #$index'),
                tileColor: Colors.transparent,
                textColor: Colors.white,
              ),
              childCount: 1000,
            ),
          ),
        ],
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
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 40, 44, 41),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
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
