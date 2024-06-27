import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi';
import 'dart:math';
import 'package:logging/logging.dart' as logging;
import 'package:vector_math/vector_math_64.dart';
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

  void movementKeyPressed(bool left, bool right, double subframe){
      if (left) {
        activeLeft = left;
        direction = -1;
      }
      if (right) {
        activeRight = right;
        direction = 1;
      }
      dasLeft = das - (1 - subframe);
    }

    int movementKeyReleased(bool left, bool right, double subframe){
      int lastFrameMovement = processMovenent(subframe);
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
      return lastFrameMovement;
    }

  int processMovenent(double delta){
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

class Board{
  int width;
  int height;
  int bufferHeight;
  late List<List<Tetromino>> board;
  late int totalHeight;

  Board(this.width, this.height, this.bufferHeight){
    totalHeight = height+bufferHeight;
    board = [for (var i = 0 ; i < totalHeight; i++) [for (var i = 0 ; i < width; i++) Tetromino.empty]];
  }

  @override
  String toString() {
    String result = "";
    for (var row in board.reversed){
      for (var cell in row) result += cell.name[0];
      result += "\n";
    }
    return result;
  }

  bool isOccupied(Coords coords)
	{
		if (coords.x < 0 || coords.x >= width ||
		    coords.y < 0 || coords.y >= totalHeight ||
		    board[coords.y][coords.x] != Tetromino.empty) return true;
		return false;
	}

  bool positionIsValid(Tetromino type, Coords coords, int r){
    List<Coords> shape = shapes[type.index][r];
    for (Coords mino in shape){
      if (isOccupied(coords+mino)) return false;
    }
    return true;
  }

  void writeToBoard(Tetromino type, Coords coords, int rot) {
    if (!positionIsValid(type, coords, rot)) throw Exception("Attempted to write $type to $coords in $rot rot");
    List<Coords> shape = shapes[type.index][rot];
    for (Coords mino in shape){
      var finalCoords = coords+mino;
      board[finalCoords.y][finalCoords.x] = type;
    }
  }
}

class Simulation{

}

// That thing allows me to test my new staff i'm trying to implement
void main() async {
  var replayJson = jsonDecode(File("/home/dan63047/Документы/replays/6550eecf2ffc5604e6224fc5.ttrm").readAsStringSync());
  ReplayData replay = ReplayData.fromJson(replayJson);
  TetrioRNG rng = TetrioRNG(replay.stats[0][0].seed);
  List<Tetromino> queue = rng.shuffleList(tetrominoes.toList());
  List<Event> events = readEventList(replay.rawJson);
  DataFullOptions? settings;
  HandlingHandler? handling;
  Map<KeyType, EventKeyPress> activeKeypresses = {};
  int currentFrame = 0;
  events.removeAt(0); // get rig of Event.start
  Event nextEvent = events.removeAt(0);
  Board board = Board(10, 20, 20); 
  Tetromino? hold;
  int rot = 0;
  Coords coords = Coords(4, 21);
  double gravityBucket = 0.00000000000000;

  developer.log("Seed is ${replay.stats[0][0].seed}, first bag is $queue");
  Tetromino current = queue.removeAt(0);
  //developer.log("Second bag is ${rng.shuffleList(tetrominoes)}");

  int sonicDrop(){
    int height = coords.y;
    while (board.positionIsValid(current, Coords(coords.x, height), rot)){
      height -= 1;
    }
    height += 1;
    return height;
  }

  Tetromino getNewOne(){
    
    if (queue.length <= 1) {
      List<Tetromino> nextPieces = rng.shuffleList(tetrominoes.toList());
      queue.addAll(nextPieces);
    }
    //developer.log("Next queue is $queue");
    rot = 0;
    return queue.removeAt(0);
  }

  coords += spawnPositionFixes[current.index];
  for (currentFrame; currentFrame <= replay.roundLengths[0]; currentFrame++){
    gravityBucket += settings != null ? (handling!.sdfActive ? settings.g! * settings.handling!.sdf : settings.g!) : 0;

    int movement = handling != null ? handling.processMovenent(1.0) : 0;
    if (board.positionIsValid(current, Coords(coords.x+movement, coords.y), rot)) coords.x += movement;

    int gravityImpact = 0;
    if (gravityBucket >= 1.0){
      gravityImpact = gravityBucket.truncate();
      gravityBucket -= gravityBucket.truncate();
    }
    if (board.positionIsValid(current, Coords(coords.x, coords.y-gravityImpact), rot)) coords.y -= gravityImpact;
    print("$currentFrame: $current at $coords\n$board");

    if (currentFrame == nextEvent.frame){
      while (currentFrame == nextEvent.frame){
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
              handling!.movementKeyPressed(true, false, nextEvent.data.subframe);
              break;
            case KeyType.moveRight:
              handling!.movementKeyPressed(false, true, nextEvent.data.subframe);
              break;
            case KeyType.softDrop:
              handling!.sdfActive = true;
              break;
            case KeyType.hardDrop:
              coords.y = sonicDrop();
              board.writeToBoard(current, coords, rot);
              current = getNewOne();
              coords = Coords(4, 21) + spawnPositionFixes[current.index];
              //handling!.movementKeyReleased(true, true);
            case KeyType.hold:
              switch (hold){
                case null:
                hold = current;
                current = getNewOne();
                break;
                case _:
                Tetromino temp;
                temp = hold;
                hold = current;
                current = temp;
                break;
              }
              coords = Coords(4, 21) + spawnPositionFixes[current.index];
              break;
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
              int pontencialMovement = handling!.movementKeyReleased(true, false, nextEvent.data.subframe);
              if (board.positionIsValid(current, Coords(coords.x+pontencialMovement, coords.y), rot)) coords.x += pontencialMovement;
              break;
            case KeyType.moveRight:
              int pontencialMovement = handling!.movementKeyReleased(false, true, nextEvent.data.subframe);
              if (board.positionIsValid(current, Coords(coords.x+pontencialMovement, coords.y), rot)) coords.x += pontencialMovement;
              break;
            case KeyType.softDrop:
               handling?.sdfActive = false;
               break;
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
        case EventType.end:
          currentFrame = replay.roundLengths[0]+1;
          break;
        default:
          developer.log("Event wasn't processed: ${nextEvent}", level: 900);
      } 
        try{
          nextEvent = events.removeAt(0);
        }
        catch (e){
          developer.log(e.toString());
        }
      }
      //developer.log("Next is: $nextEvent");
    }
  }
 exit(0);
}