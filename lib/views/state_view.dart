import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetra_league.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:window_manager/window_manager.dart';

final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

class StateView extends StatefulWidget {
  final TetraLeague state;
  const StateView({super.key, required this.state});

  @override
  State<StatefulWidget> createState() => StateState();
}

late String oldWindowTitle;

class StateState extends State<StateView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("State from ${timestamp(widget.state.timestamp)}");
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("State from ${timestamp(widget.state.timestamp)}"),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: TetraLeagueThingy(league: widget.state)
      )
    );
  }
}
