import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:intl/intl.dart';
import 'package:tetra_stats/views/main_view.dart' show textShadow;
import 'dart:developer' as developer;
import 'package:tetra_stats/widgets/stat_sell_num.dart';

const Map<int, double> xpTableScuffed = { // level: xp required
  05000:    67009018.4885772,
  10000:   763653437.386,
  15000:  2337651144.54149,
  20000:  4572735210.50902,
  25000:  7376166347.04745,
  30000: 10693620096.2168,
  40000: 18728882739.482,
  50000: 28468683855.2853
};

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

class UserThingy extends StatelessWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final Function setState;
  
  const UserThingy({super.key, required this.player, required this.showStateTimestamp, required this.setState});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      double bannerHeight = bigScreen ? 240 : 120;
      double pfpHeight = 128;
      int xpTableID = 0;

      while (player.xp > xpTableScuffed.values.toList()[xpTableID]) {
        xpTableID++;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              if (player.bannerRevision != null)
                Image.network("https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                  fit: BoxFit.cover,
                  height: bannerHeight,
                  errorBuilder: (context, error, stackTrace) {
                    developer.log("Error with building banner image", name: "main_view", error: error, stackTrace: stackTrace);
                      return Container();
                    },
                  ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, player.bannerRevision != null ? bannerHeight / 1.4 : 0, 8, bigScreen ? 16 : 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Wrap(
                          direction: bigScreen ? Axis.horizontal : Axis.vertical,
                          alignment: WrapAlignment.spaceBetween,
                          spacing: bigScreen ? 25 : 0,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Wrap(
                              direction: bigScreen ? Axis.horizontal : Axis.vertical,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: bigScreen ? 20 : 0,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: player.role == "banned"
                                        ? Image.asset("res/avatars/tetrio_banned.png", fit: BoxFit.fitHeight, height: pfpHeight,)
                                        : player.avatarRevision != null
                                          ? Image.network("https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                                              fit: BoxFit.fitHeight, height: 128, errorBuilder: (context, error, stackTrace) {
                                                developer.log("Error with building profile picture", name: "main_view", error: error, stackTrace: stackTrace);
                                                  return Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight);
                                                })
                                          : Image.asset("res/avatars/tetrio_anon.png", fit: BoxFit.fitHeight, height: pfpHeight),
                                      ),
                                    if (player.verified)
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(pfpHeight - 22, pfpHeight - 32, 0, 0),
                                        child: const Icon(Icons.verified),
                                      )
                                  ],
                                ),
                                Column(
                                children: [
                                  Text(player.username,
                                  style: TextStyle(
                                    fontFamily: "Eurostile Round Extended",
                                    fontSize: bigScreen ? 42 : 28,
                                    shadows: textShadow,
                                    )),
                                  TextButton(
                                    child: Text(player.userId, style: const TextStyle(fontFamily: "Eurostile Round Condensed", fontSize: 14)),
                                    onPressed: () {
                                      copyToClipboard(player.userId);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copiedToClipboard)));
                                    }),
                                ],
                                ),   
                              ],
                            ),
                            showStateTimestamp
                            ? Text(t.fetchDate(date: dateFormat.format(player.state)))
                            : Wrap(direction: Axis.horizontal, alignment: WrapAlignment.center, spacing: 25, crossAxisAlignment: WrapCrossAlignment.start, children: [
                                FutureBuilder(
                                    future: teto.isPlayerTracking(player.userId),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                        case ConnectionState.done:
                                          if (snapshot.data != null && snapshot.data!) {
                                            return Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.person_remove,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: Offset(0.0, 0.0),
                                                        blurRadius: 3.0,
                                                        color: Colors.black,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(0.0, 0.0),
                                                        blurRadius: 8.0,
                                                        color: Colors.black,
                                                      ),
                                                    ],),
                                                  onPressed: () {
                                                    teto.deletePlayerToTrack(player.userId).then((value) => setState());
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.stoppedBeingTracked)));
                                                  },
                                                ),
                                                Text(t.stopTracking, textAlign: TextAlign.center)
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.person_add,
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: Offset(0.0, 0.0),
                                                        blurRadius: 3.0,
                                                        color: Colors.black,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(0.0, 0.0),
                                                        blurRadius: 8.0,
                                                        color: Colors.black,
                                                      ),
                                                    ],),
                                                  onPressed: () {
                                                    teto.addPlayerToTrack(player).then((value) => setState());
                                                    teto.storeState(player);
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.becameTracked)));
                                                  },
                                                ),
                                                Text(t.track, textAlign: TextAlign.center)
                                              ],
                                            );
                                          }
                                      }
                                    }),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.balance,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                          ),
                                          Shadow(
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 8.0,
                                            color: Colors.black,
                                          ),
                                        ],),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CompareView(greenSide: [player, null, player.tlSeason1], redSide: const [null, null, null], greenMode: Mode.player, redMode: Mode.player),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(t.compare, textAlign: TextAlign.center)
                                  ],
                                )
                              ])
                          ]),
                      ],
                    ),
                  ],
                ),
              ), 
            ],
          ),
          if (!["banned", "p1nkl0bst3r"].contains(player.role))
            Wrap(
              // mainAxisSize: MainAxisSize.min,
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 25,
              crossAxisAlignment: WrapCrossAlignment.start,
              clipBehavior: Clip.hardEdge, // hard WHAT???
              children: [
                StatCellNum(
                  playerStat: player.level,
                  playerStatLabel: t.statCellNum.xpLevel,
                  isScreenBig: bigScreen,
                  alertWidgets: [
                    Text(
                      "${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 2).format(player.xp)} XP",
                      style: const TextStyle(fontFamily: "Eurostile Round", fontWeight: FontWeight.bold)
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: SfLinearGauge(
                        minimum: 0,
                        maximum: 1,
                        interval: 1, 
                        ranges: [
                          LinearGaugeRange(startValue: 0, endValue: player.level - player.level.floor(), color: Colors.cyanAccent),
                          LinearGaugeRange(startValue: 0, endValue: (player.xp / xpTableScuffed.values.toList()[xpTableID]), color: Colors.redAccent, position: LinearElementPosition.cross)
                          ],
                        // markerPointers: [LinearShapePointer(value: player.level - player.level.floor(), position: LinearElementPosition.inside, shapeType: LinearShapePointerType.triangle, color: Colors.white, height: 20)],
                        showTicks: true,
                        showLabels: false
                        ),
                    ),
                    Text("${t.statCellNum.xpProgress}: ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} %"),
                    Text("${t.statCellNum.xpFrom0ToLevel(n: xpTableScuffed.keys.toList()[xpTableID])}: ${((player.xp / xpTableScuffed.values.toList()[xpTableID]) * 100).toStringAsFixed(2)} % (${NumberFormat.decimalPatternDigits(locale: LocaleSettings.currentLocale.languageCode, decimalDigits: 0).format(xpTableScuffed.values.toList()[xpTableID] - player.xp)} ${t.statCellNum.xpLeft})")],
                  okText: t.popupActions.ok,
                  higherIsBetter: true,
                ),
                if (player.gameTime >= Duration.zero)
                  StatCellNum(
                    playerStat: player.gameTime.inHours,
                    playerStatLabel: t.statCellNum.hoursPlayed,
                    isScreenBig: bigScreen,
                    alertTitle: t.exactGametime,
                    alertWidgets: [Text(player.gameTime.toString(), style: const TextStyle(fontFamily: "Eurostile Round Extended"),)],
                    higherIsBetter: true,),
                if (player.gamesPlayed >= 0) 
                  StatCellNum(
                    playerStat: player.gamesPlayed,
                    isScreenBig: bigScreen,
                    playerStatLabel: t.statCellNum.onlineGames,
                    higherIsBetter: true,),
                if (player.gamesWon >= 0) 
                  StatCellNum(
                    playerStat: player.gamesWon,
                    isScreenBig: bigScreen,
                    playerStatLabel: t.statCellNum.gamesWon,
                    higherIsBetter: true,),
                if (player.friendCount > 0) 
                  StatCellNum(
                    playerStat: player.friendCount,
                    isScreenBig: bigScreen,
                    playerStatLabel: t.statCellNum.friends,
                    higherIsBetter: true,),
                ],
              ),
            if (player.role == "banned") Text(
                t.bigRedBanned,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Eurostile Round Extended",
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  fontSize: bigScreen ? 60 : 45,
                ),
              ),
            if (player.role == "p1nkl0bst3r") Text(
              t.p1nkl0bst3rAlert,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Eurostile Round",
                fontSize: 16,
              )
            ),
        if (player.badstanding != null && player.badstanding!)
          Text(
            t.bigRedBadStanding,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Eurostile Round Extended",
              fontWeight: FontWeight.w900,
              color: Colors.red,
              fontSize: bigScreen ? 60 : 45,
            ),
          ),
        if (player.role != "p1nkl0bst3r") Padding(
          padding: EdgeInsets.only(top: bigScreen ? 8 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                    "${player.country != null ? "${t.countries[player.country]} • " : ""}${t.playerRole[player.role]}${t.playerRoleAccount}${player.registrationTime == null ? t.wasFromBeginning : '${t.created} ${dateFormat.format(player.registrationTime!)}'}${player.botmaster != null ? " ${t.botCreatedBy} ${player.botmaster}" : ""} • ${player.supporterTier == 0 ? t.notSupporter : t.supporter(tier: player.supporterTier)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Eurostile Round",
                      fontSize: 16,
                    )),
              )
            ],
          ),
        ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 25,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.hardEdge,
            children: [
              for (var badge in player.badges)
                IconButton(
                    onPressed: () => showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                badge.label,
                                style: const TextStyle(fontFamily: "Eurostile Round Extended"),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 25,
                                      children: [
                                        Image.asset("res/tetrio_badges/${badge.badgeId}.png"),
                                        Text(badge.ts != null
                                            ? t.obtainDate(date: dateFormat.format(badge.ts!))
                                            : t.assignedManualy),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(t.popupActions.ok),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                    tooltip: badge.label,
                    icon: Image.asset(
                      "res/tetrio_badges/${badge.badgeId}.png",
                      height: 32,
                      width: 32,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log("Error with building $badge", name: "main_view", error: error, stackTrace: stackTrace);
                        return Image.network(
                          "https://tetr.io/res/badges/${badge.badgeId}.png",
                          height: 32,
                          width: 32,
                          errorBuilder:(context, error, stackTrace) {
                            return Image.asset("res/icons/kagari.png", height: 32, width: 32);
                          }
                        ); 
                      },
                    ))
            ],
          ),
        ],
      );
    });
  }
}
