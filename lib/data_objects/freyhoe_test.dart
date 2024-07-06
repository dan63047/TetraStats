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

  @override
  String toString(){
    return "das: ${das}f; arr: ${arr}f";
  }

  int movementKeyPressed(bool left, bool right, double subframe){
      if (left) {
        activeLeft = left;
        direction = -1;
      }
      if (right) {
        activeRight = right;
        direction = 1;
      }
      dasLeft = das - (1 - subframe);
      return direction;
    }

    void movementKeyReleased(bool left, bool right, double subframe){
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

  int processMovenent(double delta){
    if (!activeLeft && !activeRight) return 0;
    if (dasLeft > 0.0) {
        dasLeft -= delta;
        if (dasLeft < 0.0) {
            arrLeft += dasLeft;
            dasLeft = 0.0;
            return direction;
        }else{
            return 0;
        }
    }else{
        arrLeft -= delta;
        if (arr == 0.0) return direction*10;
        if (arrLeft < 0.0) {
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

  bool wasATSpin(Tetromino type, Coords coords, int rot){
    if (!(positionIsValid(type, Coords(coords.x+1, coords.y), rot) ||
			    positionIsValid(type, Coords(coords.x-1, coords.y), rot) ||
			    positionIsValid(type, Coords(coords.x, coords.y+1), rot) ||
			    positionIsValid(type, Coords(coords.x, coords.y-1), rot))
      ){
      return true;
    }
    return false;
  }

  void writeToBoard(Tetromino type, Coords coords, int rot) {
    if (!positionIsValid(type, coords, rot)) throw Exception("Attempted to write $type to $coords in $rot rot");
    List<Coords> shape = shapes[type.index][rot];
    for (Coords mino in shape){
      var finalCoords = coords+mino;
      board[finalCoords.y][finalCoords.x] = type;
    }
  }

  void writeGarbage(GarbageData data, [int? amt]){
    List<List<Tetromino>> garbage = [for (int i = 0; i < (amt??data.amt!); i++) [for (int k = 0; k < width; k++) k == data.column! ? Tetromino.empty : Tetromino.garbage]];
    board.insertAll(0, garbage);
    board.removeRange(height-garbage.length, height);
  }

  List<int> clearFullLines(){
    int linesCleared = 0;
    int garbageLines = 0;
    int difficultLineClear = 0;
    for (int i = 0; i < board.length; i++){
      if (board[i-linesCleared].every((element) => element != Tetromino.empty)){
        if (board[i-linesCleared].any((element) => element == Tetromino.garbage)) garbageLines++;
        board.removeAt(i-linesCleared);
        List<Tetromino> emptyRow = [for (int t = 0; t < width; t++) Tetromino.empty];
        board.add(emptyRow);
        linesCleared += 1;
      }
    }
    if (linesCleared >= 4) difficultLineClear = 1;
    return [linesCleared, garbageLines, difficultLineClear];
  }
}

class IncomingGarbage{
  int? frameOfThreat; // will enter board after this frame, null if unconfirmed
  GarbageData data;

  IncomingGarbage(this.data);

  @override
  String toString(){
    return "f$frameOfThreat: col${data.column} amt${data.amt}";
  }

  void confirm(int confirmationFrame, int garbageSpeed){
    frameOfThreat = confirmationFrame+garbageSpeed;
  }
}

class LineClearResult{
  int linesCleared;
  Tetromino piece;
  bool spin;
  int garbageCleared;
  int column;
  int attackProduced;

  LineClearResult(this.linesCleared, this.piece, this.spin, this.garbageCleared, this.column, this.attackProduced);
}

class Stats{
  int combo = -1;
  int btb = -1;
  int attackRecived = 0;
  int attackTanked = 0;

  LineClearResult processLineClear(List<int> clearFullLinesResult, Tetromino current, Coords pos, bool spinWasLastMove, bool tspin){
    if (clearFullLinesResult[0] > 0) combo++;
    else combo = -1;
    if (clearFullLinesResult[2] > 0) btb++;
    else btb = -1;
    int attack = 0;
    switch (clearFullLinesResult[0]){
      case 0:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin']!;
        }
      break;
      case 1:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin single']!;
        }else{
          attack = garbage['single']!;
        }
      break;
      case 2:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin double']!;
        }else{
          attack = garbage['double']!;
        }
      break;
      case 3:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin triple']!;
        }else{
          attack = garbage['triple']!;
        }
      break;
      case 4:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin quad']!;
        }else{
          attack = garbage['quad']!;
        }
      break;
      case 5:
        if (spinWasLastMove && tspin) {
          attack = garbage['t-spin penta']!;
        }else{
          attack = garbage['penta']!;
        }
      break;
      case _:
      developer.log("${clearFullLinesResult[0]} lines cleared");
      break;
    }
    return LineClearResult(clearFullLinesResult[0], Tetromino.empty, false, clearFullLinesResult[1], 0, attack);
  }
}

class Simulation{

}

// That thing allows me to test my new staff i'm trying to implement
void main() async {
  var replayJson = jsonDecode(File("/home/dan63047/Документы/replays/6550eecf2ffc5604e6224fc5.ttrm").readAsStringSync());
  // frame 994: garbage lost
  // frame 1550: T-spin failed
  ReplayData replay = ReplayData.fromJson(replayJson);
  TetrioRNG rng = TetrioRNG(replay.stats[0][0].seed);
  List<Tetromino> queue = rng.shuffleList(tetrominoes.toList());
  List<Event> events = readEventList(replay.rawJson);
  DataFullOptions? settings;
  HandlingHandler? handling;
  Map<KeyType, EventKeyPress> activeKeypresses = {};
  int currentFrame = 0;
  double subframesWent = 0;
  events.removeAt(0); // get rig of Event.start
  Event nextEvent = events.removeAt(0);
  Stats stats = Stats();
  Board board = Board(10, 20, 20);
  KicksetBase kickset = SRSPlus();
  List<IncomingGarbage> garbageQueue = [];
  Tetromino? hold;
  int rot = 0;
  bool spinWasLastMove = false;
  Coords coords = Coords(3, 21);
  double lockDelay = 30; // frames
  int lockResets = 15;
  bool floored = false;
  double gravityBucket = 1.0;

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
    lockResets = 15;
    lockDelay = 30;
    floored = false;
    gravityBucket = 1.0;
    return queue.removeAt(0);
  }

  bool handleRotation(int r){
    if (r == 0) return true;
    int futureRotation = (rot + r) % 4;
    List<Coords> tests = (current == Tetromino.I ? kickset.kickTableI : kickset.kickTable)[rot][r == -1 ? 0 : r];
    for (Coords test in tests){
      if (board.positionIsValid(current, coords+test, futureRotation)){
        coords += test;
        rot = futureRotation;
        return true;
      }
    }
    return false;
  }

  void handleHardDrop(){
    board.writeToBoard(current, coords, rot);
    bool tspin = board.wasATSpin(current, coords, rot);
    LineClearResult lineClear = stats.processLineClear(board.clearFullLines(), current, coords, spinWasLastMove, tspin);
    print("${lineClear.linesCleared} lines, ${lineClear.garbageCleared} garbage");
    if (garbageQueue.isNotEmpty) {
      if (lineClear.linesCleared > 0){
        int garbageToDelete = lineClear.attackProduced;
        for (IncomingGarbage garbage in garbageQueue){
          if (garbage.data.amt! >= garbageToDelete) {
            garbageToDelete -= garbage.data.amt!;
            lineClear.attackProduced = garbageToDelete;
            garbage.data.amt = 0;
          }else{
            garbage.data.amt = garbage.data.amt! - garbageToDelete;
            lineClear.attackProduced = 0;
            break;
          }
        }
      }else{
        int needToTake = settings!.garbageCap!;
        for (IncomingGarbage garbage in garbageQueue){
          if ((garbage.frameOfThreat??99999999) > currentFrame) break;
          if (garbage.data.amt! > needToTake) {
            board.writeGarbage(garbage.data, needToTake);
            garbage.data.amt = garbage.data.amt! - needToTake;
            break;
          } else {
            board.writeGarbage(garbage.data);
            needToTake -= garbage.data.amt!;
            garbage.data.amt = 0;
          }                  
        }
      }
      garbageQueue.removeWhere((element) => element.data.amt == 0);
    }
    current = getNewOne();
    coords = Coords(3, 21) + spawnPositionFixes[current.index];
  }

  void handleGravity(double frames){
    if (frames == 0) return;
    gravityBucket += settings != null ? (handling!.sdfActive ? max(settings.g! * settings.handling!.sdf, 0.05 * settings.handling!.sdf)  : settings.g!) * frames : 0;
    int gravityImpact = 0;
    if (gravityBucket >= 1.0){
      gravityImpact = gravityBucket.truncate();
      gravityBucket -= gravityBucket.truncate();
    }
    while (gravityImpact > 0){
      if (board.positionIsValid(current, Coords(coords.x, coords.y-1), rot)) {coords.y -= 1; floored = false;}
      else floored = true;
      gravityImpact--;
    }
    if (floored) lockDelay -= frames;
    if (lockDelay <= 0 && floored){
      handleHardDrop();
    }
  }

  void handleMovement(double frames){
    if (frames == 0 || handling == null) return;
    int movement = handling.processMovenent(frames);
    while (movement.abs() > 0){
      if (board.positionIsValid(current, Coords(movement.isNegative ? coords.x-1 : coords.x+1, coords.y), rot)) movement.isNegative ? coords.x-- : coords.x++;
      movement.isNegative ? movement++ : movement--;
    }   
  }

  coords += spawnPositionFixes[current.index];
  for (currentFrame; currentFrame <= replay.roundLengths[0]; currentFrame++){
    handleMovement(1-subframesWent);
    handleGravity(1-subframesWent);
    subframesWent = 0;
    
    if (settings?.handling?.sdf == 41) coords.y = sonicDrop();
    print("$currentFrame: $current at $coords\n$board");
    //print(stats.combo);
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
          lockDelay = settings.locktime!.toDouble();
          lockResets = settings.lockresets!;
          break;
        case EventType.keydown:
          nextEvent as EventKeyPress;
          double subframesDiff = nextEvent.data.subframe - subframesWent;
          subframesWent += subframesDiff;
          handleMovement(subframesDiff);
          handleGravity(subframesDiff);
          //activeKeypresses[nextEvent.data.key] = nextEvent;
          switch (nextEvent.data.key){
            case KeyType.rotateCCW:
              handleRotation(-1);
              break;
            case KeyType.rotateCW:
              handleRotation(1);
              break;
            case KeyType.rotate180:
              handleRotation(2);
              break;
            case KeyType.moveLeft:
            case KeyType.moveRight:
              int pontencialMovement = handling!.movementKeyPressed(nextEvent.data.key == KeyType.moveLeft, nextEvent.data.key == KeyType.moveRight, nextEvent.data.subframe);
              if (board.positionIsValid(current, Coords(coords.x+pontencialMovement, coords.y), rot)) coords.x += pontencialMovement;
              break;
            case KeyType.softDrop:
              handling!.sdfActive = true;
              break;
            case KeyType.hardDrop:
              coords.y = sonicDrop();
              handleHardDrop();
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
                rot = 0;
                lockResets = 15;
                lockDelay = 30;
                gravityBucket = 1.0;
                floored = false;
                coords = Coords(3, 21) + spawnPositionFixes[current.index];
                break;
              }
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
          if (nextEvent.data.key == KeyType.rotateCW && nextEvent.data.key == KeyType.rotateCW && nextEvent.data.key == KeyType.rotateCW){
            spinWasLastMove = true;
          }else{
            spinWasLastMove = false;
          }
          break;
        case EventType.keyup:
          nextEvent as EventKeyPress;
          double subframesDiff = nextEvent.data.subframe - subframesWent;
          subframesWent += subframesDiff;
          handleMovement(subframesDiff);
          handleGravity(subframesDiff);
          switch (nextEvent.data.key){
            case KeyType.moveLeft:
            case KeyType.moveRight:
              handling!.movementKeyReleased(nextEvent.data.key == KeyType.moveLeft, nextEvent.data.key == KeyType.moveRight, nextEvent.data.subframe);
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
        case EventType.ige:
          nextEvent as EventIGE;
          switch (nextEvent.data.data.type){
            case "interaction":
            garbageQueue.add(IncomingGarbage((nextEvent.data.data as IGEdataInteraction).data));
            case "interaction_confirm":
            GarbageData data = (nextEvent.data.data as IGEdataInteraction).data;
            if(data.type != "targeted") garbageQueue.firstWhere((element) => element.data.iid == data.iid).confirm(currentFrame, settings!.garbageSpeed!);
            case "allow_targeting":
            case "target":
            default:
            developer.log("Unknown IGE type: ${nextEvent.data.type}", level: 900);
            break;
          }
          // garbage speed counts from interaction comfirm
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