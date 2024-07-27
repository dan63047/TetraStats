import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
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
      appBar: AppBar(
        title: Text("${
          switch (record.gamemode){
            "40l" => t.sprint,
            "blitz" => t.blitz,
            String() => "5000000 Blast",
          }
        } ${timestamp(record.timestamp)}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SingleplayerRecord(record: record, hideTitle: true),
                  // TODO: Insert replay link here
                ] 
              )
            ],
          )
        )
      ),
    );
  }
  
}