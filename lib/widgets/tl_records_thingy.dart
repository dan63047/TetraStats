import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetra_stats/data_objects/beta_record.dart';
import 'package:tetra_stats/main.dart';
import 'package:tetra_stats/widgets/beta_league_entry_thingy.dart';
import 'package:tetra_stats/widgets/future_error.dart';

class TLRecords extends StatefulWidget {
  final String userID;

  /// Widget, that displays Tetra League records.
  /// Accepts list of TL records ([data]) and [userID] of player from the view
  const TLRecords(this.userID);

  @override
  State<TLRecords> createState() => _TLRecordsState();
}

class _TLRecordsState extends State<TLRecords> {
  List<BetaRecord> records = [];
  bool isFetchingRecords = false;
  bool reachedEndOfRecords = false;
  final StreamController<List<dynamic>> _recordsStreamController = StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get recordsStream => _recordsStreamController.stream;
  String? recordsPrisecter;
  late final ScrollController _scrollController;

  @override
  void initState(){
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          _fetchRecord(widget.userID);
        }
      });
    });
    _fetchRecord(widget.userID);
    super.initState();
  }

  Future<void> _fetchRecord(String userID) async {
  if (isFetchingRecords || reachedEndOfRecords) {
    // Avoid fetching new data while already fetching
    return;
  }
  try {
    isFetchingRecords = true;

    final items = (await teto.fetchTLStream(userID, prisecter: recordsPrisecter)).records;

    if (items.isEmpty) reachedEndOfRecords = true;
    records.addAll(items);
    if (items.isNotEmpty){
      _recordsStreamController.add(records);
      recordsPrisecter = records.last.prisecter.toString();
    } else{
      _recordsStreamController.add([]);
    }
  } catch (e) {
    _recordsStreamController.addError(e);
  } finally {
    // Set to false when data fetching is complete
    isFetchingRecords = false;
  }
}

  Future<void> resetRecords(String userID) async {
    records.clear();
    recordsPrisecter = null;
    reachedEndOfRecords = false;
    _fetchRecord(userID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recordsStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData){
              return SizedBox(
                height: MediaQuery.of(context).size.height - 130,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: records.length,
                  prototypeItem: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ListTile(
                      leading: Text("0"),
                      title: Text("ehhh...", style: TextStyle(fontSize: 22)),
                      trailing: SizedBox(height: 36, width: 1),
                      subtitle: const Text("eh\n...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return BetaLeagueEntryThingy(records[index], widget.userID, MediaQuery.of(context).size.width >= 768.0);
                  }
                ),
              );
            }
            if (snapshot.hasError){ return SizedBox(height: 500, child: Center(child: FutureError(snapshot))); }
            return const Center(child: Text("whar?"));
          }
      },
    );
  }
}