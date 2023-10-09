import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/services/tetrio_crud.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/tl_match_view.dart';
import 'package:window_manager/window_manager.dart';

final TetrioService teto = TetrioService();
final NumberFormat f2 = NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2);
late String oldWindowTitle;

class MatchesView extends StatefulWidget {
  final String userID;
  final String username;
  const MatchesView({Key? key, required this.userID, required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MatchesState();
}

class MatchesState extends State<MatchesView> {

  @override
  void initState() {
    if (!Platform.isAndroid && !Platform.isIOS){
      windowManager.getTitle().then((value) => oldWindowTitle = value);
      windowManager.setTitle("Tetra Stats: ${t.matchesViewTitle(nickname: widget.username)}");
    }
    super.initState();
  }

  @override
  void dispose(){
    if (!Platform.isAndroid && !Platform.isIOS) windowManager.setTitle(oldWindowTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    bool bigScreen = MediaQuery.of(context).size.width > 768;
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return Scaffold(
        appBar: AppBar(
          title: Text(t.matchesViewTitle(nickname: widget.username)),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: FutureBuilder(
              future: teto.getTLMatchesbyPlayerID(widget.userID),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  case ConnectionState.done:
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: (snapshot.data!.isNotEmpty)
                          ? [for (var value in snapshot.data!) ListTile(
                            leading: Text("${value.endContext.firstWhere((element) => element.userId == widget.userID).points} : ${value.endContext.firstWhere((element) => element.userId != widget.userID).points}",
                            style: bigScreen ? const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28) :
                            const TextStyle(fontSize: 28)),
                            title: Text("vs. ${value.endContext.firstWhere((element) => element.userId != widget.userID).username}"),
                            subtitle: Text(dateFormat.format(value.timestamp)),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  DateTime nn = value.timestamp;
                                  teto.deleteTLMatch(value.ownId).then((value) => setState(() {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.matchRemoved(date: dateFormat.format(nn)))));
                                      }));
                                },
                              ),
                            onTap: (){Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TlMatchResultView(record: value, initPlayerId: widget.userID),
                                  ),
                                );},
                          )]
                          : [Center(child: Text(t.noRecords, style: const TextStyle(fontFamily: "Eurostile Round Extended", fontSize: 28)))],
                    );
                }
              }
        )
      )
    );
  }
}
