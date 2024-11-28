import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/views/destination_home.dart';
import 'package:tetra_stats/widgets/singleplayer_record.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';

class SingleplayerRecordView extends StatelessWidget {
  final RecordSingle record;

  const SingleplayerRecordView({super.key, required this.record});
  
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    //bool bigScreen = MediaQuery.of(context).size.width >= 368;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: t.goBackButton,
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 768
              ),
              child: switch (record.gamemode){
                "zenith" => ZenithCard(record, false),
                "zenithex" => ZenithCard(record, false),
                _ => SingleplayerRecord(record: record, hideTitle: true)
              },
            ),
          )
        )
      ),
    );
  }
  
}