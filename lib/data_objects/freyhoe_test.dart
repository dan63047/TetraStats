import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'tetrio_multiplayer_replay.dart';

// That thing allows me to test my new staff i'm trying to implement
void main() async {
  // List<Tetromino> queue = List.from(tetrominoes);
  // TetrioRNG rng = TetrioRNG(0);
  // queue = rng.shuffleList(queue);
  // print(queue);
  // queue = List.from(tetrominoes);
  // queue = rng.shuffleList(queue);
  // print(queue);

  //var downloadPath = await getDownloadsDirectory();
  var replayJson = jsonDecode(File("/home/dan63047/Документы/replays/6550eecf2ffc5604e6224fc5.ttrm").readAsStringSync());
  ReplayData replay = ReplayData.fromJson(replayJson);
  //List<List<Tetromino>> board = [for (var i = 0 ; i < 40; i++) [for (var i = 0 ; i < 10; i++) Tetromino.empty]];
  List<Event> events = readEventList(replay.rawJson);
  //events.retainWhere((element) => element.runtimeType == EventIGE && (element as EventIGE).data.data['type'] == "interaction_confirm");
  print(events);
 exit(0);
}