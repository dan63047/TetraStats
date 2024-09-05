// ignore_for_file: hash_and_equals

import 'package:tetra_stats/data_objects/beta_league_leaderboard_entry.dart';
import 'package:tetra_stats/data_objects/beta_league_results.dart';
import 'package:tetra_stats/data_objects/beta_league_round.dart';
import 'package:tetra_stats/data_objects/beta_league_stats.dart';
import 'package:tetra_stats/data_objects/beta_record.dart';
import 'package:tetra_stats/data_objects/tetra_league_alpha_record.dart';

class TetraLeagueBetaStream{
  late String id;
  List<BetaRecord> records = [];

  TetraLeagueBetaStream({required this.id, required this.records});

  TetraLeagueBetaStream.fromJson(List<dynamic> json, String userID) {
    id = userID;
    for (var entry in json) {
      records.add(BetaRecord.fromJson(entry));
    }
  }

  addFromAlphaStream(List<TetraLeagueAlphaRecord> r){
    for (var entry in r) {
      records.add(
      BetaRecord(
        id: entry.ownId,
        replayID: entry.replayId,
        ts: entry.timestamp,
        enemyID: entry.endContext[1].userId,
        enemyUsername: entry.endContext[1].username,
        gamemode: "oldleague",
        results: BetaLeagueResults(
          leaderboard: [
            BetaLeagueLeaderboardEntry(
              id: entry.endContext[0].userId,
              username: entry.endContext[0].username,
              naturalorder: entry.endContext[0].naturalOrder,
              wins: entry.endContext[0].points,
              stats: BetaLeagueStats(
                apm: entry.endContext[0].secondary,
                pps: entry.endContext[0].tertiary,
                vs: entry.endContext[0].extra,
                garbageSent: -1,
                garbageReceived: -1,
                kills: entry.endContext[0].points,
                altitude: 0.0,
                rank: -1
              )
            ),
            BetaLeagueLeaderboardEntry(
              id: entry.endContext[1].userId,
              username: entry.endContext[1].username,
              naturalorder: entry.endContext[1].naturalOrder,
              wins: entry.endContext[1].points,
              stats: BetaLeagueStats(
                apm: entry.endContext[1].secondary,
                pps: entry.endContext[1].tertiary,
                vs: entry.endContext[1].extra,
                garbageSent: -1,
                garbageReceived: -1,
                kills: entry.endContext[1].points,
                altitude: 0.0,
                rank: -1
              )
            )
          ],
          rounds: [
            for (int i=0; i<entry.endContext[0].secondaryTracking.length; i++)
            [BetaLeagueRound(
              id: entry.endContext[0].userId,
              username: entry.endContext[0].username,
              naturalorder: entry.endContext[0].naturalOrder,
              active: false,
              alive: false,
              lifetime: const Duration(milliseconds: -1),
              stats: BetaLeagueStats(
                apm: entry.endContext[0].secondaryTracking[i],
                pps: entry.endContext[0].tertiaryTracking[i],
                vs: entry.endContext[0].extraTracking[i],
                garbageSent: -1,
                garbageReceived: -1,
                kills: 0,
                altitude: 0.0,
                rank: -1
              )
            ),BetaLeagueRound(
              id: entry.endContext[1].userId,
              username: entry.endContext[1].username,
              naturalorder: entry.endContext[1].naturalOrder,
              active: false,
              alive: false,
              lifetime: const Duration(milliseconds: -1),
              stats: BetaLeagueStats(
                apm: entry.endContext[1].secondaryTracking[i],
                pps: entry.endContext[1].tertiaryTracking[i],
                vs: entry.endContext[1].extraTracking[i],
                garbageSent: -1,
                garbageReceived: -1,
                kills: 0,
                altitude: 0.0,
                rank: -1
              )
            )]
          ]
        )
      )
    );
    }
  }
}
