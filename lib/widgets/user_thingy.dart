import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:tetra_stats/widgets/stat_sell_num.dart';

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

class UserThingy extends StatelessWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final Function setState;
  const UserThingy({Key? key, required this.player, required this.showStateTimestamp, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd(LocaleSettings.currentLocale.languageCode).add_Hms();
    return LayoutBuilder(builder: (context, constraints) {
      bool bigScreen = constraints.maxWidth > 768;
      double bannerHeight = bigScreen ? 240 : 120;
      double pfpHeight = 128;

      return Column(
        children: [
          Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (player.bannerRevision != null)
                    Image.network(
                      "https://tetr.io/user-content/banners/${player.userId}.jpg?rv=${player.bannerRevision}",
                      fit: BoxFit.cover,
                      height: bannerHeight,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log("Error with building banner image", name: "main_view", error: error, stackTrace: stackTrace);
                        return Container();
                      },
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, player.bannerRevision != null ? bannerHeight / 1.4 : pfpHeight, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: player.role == "banned"
                          ? Image.asset(
                              "res/avatars/tetrio_banned.png",
                              fit: BoxFit.fitHeight,
                              height: pfpHeight,
                            )
                          : player.avatarRevision != null
                              ? Image.network("https://tetr.io/user-content/avatars/${player.userId}.jpg?rv=${player.avatarRevision}",
                                  fit: BoxFit.fitHeight, height: 128, errorBuilder: (context, error, stackTrace) {
                                  developer.log("Error with building profile picture", name: "main_view", error: error, stackTrace: stackTrace);
                                  return Image.asset(
                                    "res/avatars/tetrio_anon.png",
                                    fit: BoxFit.fitHeight,
                                    height: pfpHeight,
                                  );
                                })
                              : Image.asset(
                                  "res/avatars/tetrio_anon.png",
                                  fit: BoxFit.fitHeight,
                                  height: pfpHeight,
                                ),
                    ),
                  ),
                  if (player.verified)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          pfpHeight - 22,
                          bigScreen //                                                                                          verified icon top padding:
                              ? (player.bannerRevision != null ? bannerHeight + pfpHeight - 96 : pfpHeight + pfpHeight - 32) // for big screen
                              : (player.bannerRevision != null ? bannerHeight + pfpHeight - 58 : pfpHeight + pfpHeight - 32), // for small screen
                          0,
                          0),
                      child: const Icon(Icons.verified),
                    )
                ],
              ),
              Flexible(
                  child: Column(
                children: [
                  Text(player.username, style: TextStyle(fontFamily: "Eurostile Round Extended", fontSize: bigScreen ? 42 : 28)),
                  TextButton(
                      child: Text(player.userId, style: const TextStyle(fontFamily: "Eurostile Round Condensed", fontSize: 14)),
                      onPressed: () {
                        copyToClipboard(player.userId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copiedToClipboard)));
                      }),
                ],
              )),
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
                                        icon: const Icon(Icons.person_remove),
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
                                        icon: const Icon(Icons.person_add),
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
                            icon: const Icon(Icons.balance),
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
                    ]),
            ],
          ),
          (player.role != "banned")
              ? Wrap(
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
                      alertWidgets: [Text("${NumberFormat.decimalPatternDigits(decimalDigits: 2).format(player.xp)} XP", style: const TextStyle(fontFamily: "Eurostile Round Extended"),), Text("Progress to next level: ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} %"), Text("Progress from 0 XP to level 5000: ${((player.xp / 67009017.7589378) * 100).toStringAsFixed(2)} %")],
                      higherIsBetter: true,
                    ),
                    if (player.gameTime >= Duration.zero)
                      StatCellNum(
                        playerStat: player.gameTime.inHours,
                        playerStatLabel: t.statCellNum.hoursPlayed,
                        isScreenBig: bigScreen,
                        alertWidgets: [Text("${t.exactGametime}: ${player.gameTime.toString()}")],
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
                )
              : Text(
                  t.bigRedBanned,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Eurostile Round Extended",
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                    fontSize: bigScreen ? 60 : 45,
                  ),
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
          Row(
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
                      height: 64,
                      width: 64,
                      errorBuilder: (context, error, stackTrace) {
                        developer.log("Error with building $badge", name: "main_view", error: error, stackTrace: stackTrace);
                        return Image.asset("res/icons/kagari.png", height: 64, width: 64);
                      },
                    ))
            ],
          ),
        ],
      );
    });
  }
}
