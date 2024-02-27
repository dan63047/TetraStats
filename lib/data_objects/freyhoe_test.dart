import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'tetrio_multiplayer_replay.dart';

/// That thing allows me to test my new staff i'm trying to implement
void main() async {
  // List<Tetromino> queue = List.from(tetrominoes);
  // TetrioRNG rng = TetrioRNG(0);
  // queue = rng.shuffleList(queue);
  // print(queue);
  // queue = List.from(tetrominoes);
  // queue = rng.shuffleList(queue);
  // print(queue);
  var downloadPath = await getDownloadsDirectory();
  ReplayData replay = ReplayData.fromJson(jsonDecode(File("${downloadPath!.path}/65b504a9ade6d287b8427af0").readAsStringSync()));
  List<List<Tetromino>> board = [for (var i = 0 ; i < 40; i++) [for (var i = 0 ; i < 10; i++) Tetromino.empty]];
  print(replay.rawJson);
  exit(0);
}