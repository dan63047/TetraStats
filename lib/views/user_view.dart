import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/views/destination_home.dart';
import 'package:tetra_stats/views/main_view_tiles.dart';

final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

class UserView extends StatefulWidget {
  final String searchFor;
  const UserView({super.key, required this.searchFor});

  @override
  State<StatefulWidget> createState() => UserState();
}

late String oldWindowTitle;

class UserState extends State<UserView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      // windowManager.getTitle().then((value) => oldWindowTitle = value);
      // windowManager.setTitle("State from ${timestamp(widget.state.timestamp)}");
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final t = Translations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Fuck go back',
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) { 
            return Row(
              children: [
                Card(
                  child: Column(
                    children: [
                      Text("Pornograph", style: TextStyle(),)
                    ]
                  ),
                ),
                DestinationHome(searchFor: widget.searchFor, dataFuture: getData(widget.searchFor), newsFuture: teto.fetchNews(widget.searchFor), constraints: constraints),
              ],
            );
          }
        )
      )
    );
  }
}
