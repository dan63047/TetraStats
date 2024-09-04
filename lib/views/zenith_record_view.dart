import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/tetrio.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/widgets/text_timestamp.dart';
import 'package:tetra_stats/widgets/zenith_thingy.dart';

class ZenithRecordView extends StatelessWidget {
  final RecordSingle record;

  const ZenithRecordView({super.key, required this.record});
  
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    //bool bigScreen = MediaQuery.of(context).size.width >= 368;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("${
          switch (record.gamemode){
            "zenith" => t.quickPlay,
            "zenithex" => "${t.quickPlay} ${t.expert}",
            String() => "5000000 Blast",
          }
        } ${timestamp(record.timestamp)}"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: ZenithThingy(record: record, switchable: false),
          ),
        )
      ),
    );
  }
  
}