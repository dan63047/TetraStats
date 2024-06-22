import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi';
import 'dart:math';
import 'package:logging/logging.dart' as logging;
import 'dart:io';
import 'tetrio_multiplayer_replay.dart';

class HandlingHandler{
  double das;
  double arr;
  late double dasLeft; // frames
  late double arrLeft; // frames
  bool sdfActive = false;
  bool activeLeft = false;
  bool activeRight = false;
  int direction = 0; // -1 - left, 1 - right, 0 - none

  HandlingHandler(this.das, this.arr){
    dasLeft = das;
    arrLeft = arr;
  }

  void movement_key_pressed(bool left, bool right){
      if (left) {
        activeLeft = left;
        direction = -1;
      }
      if (right) {
        activeRight = right;
        direction = 1;
      }
      dasLeft = das;
    }

    void movement_key_released(bool left, bool right){
      if (left) {
        activeLeft = !left;
      }
      if (right) {
        activeRight = !right;
      }
      if (activeLeft) {
        direction = -1;
      }
      if (activeRight) {
        direction = 1;
      }
      if (activeLeft && activeRight){
        arrLeft = arr;
        dasLeft = das;
        direction = 0;
      }
    }

  int process_movenent(double delta){
    if (!activeLeft && !activeRight) return 0;
    if (dasLeft > 0.0) {
        dasLeft -= delta;
        if (dasLeft <= 0.0) {
            arrLeft += dasLeft;
            dasLeft = 0.0;
            return direction;
        }else{
            return 0;
        }
    }else{
        arrLeft -= delta;
        if (arrLeft <= 0.0) {
            arrLeft += arr;
            return direction;
        }else {
            return 0;
        }
    }
  }
}

// That thing allows me to test my new staff i'm trying to implement
void main() async {
  var replayJson = jsonDecode(File("/home/dan63047/Документы/replays/6550eecf2ffc5604e6224fc5.ttrm").readAsStringSync());
  ReplayData replay = ReplayData.fromJson(replayJson);
  List<Tetromino> queue = List.from(tetrominoes);
  TetrioRNG rng = TetrioRNG(replay.stats[0][0].seed);
  List<Tetromino> bag = rng.shuffleList(tetrominoes);
  List<Event> events = readEventList(replay.rawJson);
  DataFullOptions? settings;
  HandlingHandler? handling;
  Map<KeyType, EventKeyPress> activeKeypresses = {};
  int currentFrame = 0;
  events.removeAt(0); // get rig of Event.start
  Event nextEvent = events.removeAt(0);
  List<List<Tetromino>> board = [for (var i = 0 ; i < 40; i++) [for (var i = 0 ; i < 10; i++) Tetromino.empty]];
  Tetromino current = bag.removeAt(0);
  Tetromino? hold;
  int rot = 0;
  int x = 4;
  int y = 21;
  double gravityBucket = 0.00000000000000;

  x += spawnPositionFixes[current.index].x.toInt();
  y += spawnPositionFixes[current.index].y.toInt();
  for (currentFrame; currentFrame <= replay.roundLengths[0]; currentFrame++){
    gravityBucket += settings != null ? settings.g! : 0;
    if (gravityBucket >= 1.0){
      y -= gravityBucket.truncate();
      gravityBucket -= gravityBucket.truncate();
    }
    x += handling != null ? handling.process_movenent(1.0) : 0;
    print("$currentFrame: $x $y");
    if (currentFrame == nextEvent.frame){
      print("Processing $nextEvent");
      switch (nextEvent.type){
      case EventType.start:
        developer.log("go");
        break;
      case EventType.full:
        settings = (nextEvent as EventFull).data.options;
        handling = HandlingHandler(settings!.handling!.das.toDouble(), settings.handling!.arr.toDouble());
        break;
      case EventType.keydown:
        nextEvent as EventKeyPress;
        activeKeypresses[nextEvent.data.key] = nextEvent;
        switch (nextEvent.data.key){
          case KeyType.rotateCCW:
            rot = (rot-1)%4;
            break;
          case KeyType.rotateCW:
            rot = (rot+1)%4;
            break;
          case KeyType.rotate180:
            rot = (rot+2)%4;
            break;
          case KeyType.moveLeft:
            handling!.movement_key_pressed(true, false);
          case KeyType.moveRight:
            handling!.movement_key_pressed(false, true);
          case KeyType.softDrop:
            // TODO: Handle this case.
          case KeyType.hardDrop:
            // TODO: Handle this case.
          case KeyType.hold:
            // TODO: Handle this case.
          case KeyType.chat:
            // TODO: Handle this case.
          case KeyType.exit:
            // TODO: Handle this case.
          case KeyType.retry:
            // TODO: Handle this case.
          default:
            developer.log(nextEvent.data.key.name);
        }
        break;
      case EventType.keyup:
        nextEvent as EventKeyPress;
        switch (nextEvent.data.key){
          case KeyType.moveLeft:
            handling!.movement_key_released(true, false);
          case KeyType.moveRight:
            handling!.movement_key_released(false, true);
          case KeyType.softDrop:
            // TODO: Handle this case.
          case KeyType.rotateCCW:
            // TODO: Handle this case.
          case KeyType.rotateCW:
            // TODO: Handle this case.
          case KeyType.rotate180:
            // TODO: Handle this case.
          case KeyType.hardDrop:
            // TODO: Handle this case.
          case KeyType.hold:
            // TODO: Handle this case.
          case KeyType.chat:
            // TODO: Handle this case.
          case KeyType.exit:
            // TODO: Handle this case.
          case KeyType.retry:
            // TODO: Handle this case.
        }
        activeKeypresses.remove(nextEvent.data.key);
        break;
      default:
        developer.log("Event wasn't processed: ${nextEvent}", level: 900);
    }
      nextEvent = events.removeAt(0);
      developer.log("Next is: $nextEvent");
    }
  }
 exit(0);
}