import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/beta_record.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/beta_league_entry_thingy.dart';
import 'package:tetra_stats/widgets/future_error.dart';

class TLRecords extends StatelessWidget {
  final String userID;

  /// Widget, that displays Tetra League records.
  /// Accepts list of TL records ([data]) and [userID] of player from the view
  const TLRecords(this.userID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: teto.fetchTLStream(userID),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasData){
              return Column(
                children: [
                  for (BetaRecord record in snapshot.data!.records) BetaLeagueEntryThingy(record, userID)
                ],
              );
            }
            if (snapshot.hasError){ return SizedBox(height: 500, child: Center(child: FutureError(snapshot))); }
          }
        return const Text("what?");
      },
    );
  }
}