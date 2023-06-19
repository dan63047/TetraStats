import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/views/compare_view.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:tetra_stats/widgets/stat_sell_num.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

final DateFormat dateFormat = DateFormat.yMMMd().add_Hms();

class UserThingy extends StatelessWidget {
  final TetrioPlayer player;
  final bool showStateTimestamp;
  final Function setState;
  const UserThingy({Key? key, required this.player, required this.showStateTimestamp, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        return const Placeholder(
                          color: Colors.black,
                        );
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard!")));
                      }),
                ],
              )),
              showStateTimestamp
                  ? Text("Fetched ${dateFormat.format(player.state)}")
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
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Removed from tracking list!")));
                                        },
                                      ),
                                      const Text("Stop tracking")
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
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to tracking list!")));
                                        },
                                      ),
                                      const Text("Track")
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
                                  builder: (context) => CompareView(greenSide: player, redSide: null),
                                ),
                              );
                            },
                          ),
                          const Text("Compare")
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
                      playerStatLabel: "XP Level",
                      isScreenBig: bigScreen,
                      snackBar: "${player.xp.floor().toString()} XP, ${((player.level - player.level.floor()) * 100).toStringAsFixed(2)} % until next level",
                    ),
                    if (player.gameTime >= Duration.zero)
                      StatCellNum(
                          playerStat: player.gameTime.inHours, playerStatLabel: "Hours\nPlayed", isScreenBig: bigScreen, snackBar: player.gameTime.toString()),
                    if (player.gamesPlayed >= 0) StatCellNum(playerStat: player.gamesPlayed, isScreenBig: bigScreen, playerStatLabel: "Online\nGames"),
                    if (player.gamesWon >= 0) StatCellNum(playerStat: player.gamesWon, isScreenBig: bigScreen, playerStatLabel: "Games\nWon"),
                    if (player.friendCount > 0) StatCellNum(playerStat: player.friendCount, isScreenBig: bigScreen, playerStatLabel: "Friends"),
                  ],
                )
              : Text(
                  "BANNED",
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
              "BAD STANDING",
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
                    "${player.country != null ? "${player.country?.toUpperCase()} • " : ""}${player.role.capitalize()} account ${player.registrationTime == null ? "that was from very beginning" : 'created ${dateFormat.format(player.registrationTime!)}'}${player.botmaster != null ? " by ${player.botmaster}" : ""} • ${player.supporterTier == 0 ? "Not a supporter" : "Supporter tier ${player.supporterTier}"}",
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
                                            ? "Obtained ${dateFormat.format(badge.ts!)}"
                                            : "That badge was assigned manualy by TETR.IO admins"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
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
