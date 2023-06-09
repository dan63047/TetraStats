import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/tl_thingy.dart';
import 'package:tetra_stats/widgets/user_thingy.dart';

final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();

class StateView extends StatefulWidget {
  final TetrioPlayer state;
  const StateView({Key? key, required this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StateState();
}

class StateState extends State<StateView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  void _justUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(t.stateViewTitle(nickname: widget.state.username.toUpperCase(), date: dateFormat.format(widget.state.state))),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [SliverToBoxAdapter(child: UserThingy(player: widget.state, showStateTimestamp: true, setState: _justUpdate))];
                },
                body: TLThingy(tl: widget.state.tlSeason1, userID: widget.state.userId))));
  }
}
