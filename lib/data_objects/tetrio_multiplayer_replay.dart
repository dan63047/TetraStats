import 'dart:math';
import 'dart:typed_data';

import 'package:tetra_stats/data_objects/clears.dart';
import 'package:tetra_stats/data_objects/end_context_multi.dart';
import 'package:tetra_stats/data_objects/est_tr.dart';
import 'package:tetra_stats/data_objects/finesse.dart';
import 'package:tetra_stats/data_objects/nerd_stats.dart';
import 'package:tetra_stats/data_objects/playstyle.dart';

// I want to implement those fancy TWC stats
// So, i'm going to read replay for things

int biggestSpikeFromReplay(events){
  int previousIGEeventFrame = -1;
  int spikeCounter = 0;
  int biggestSpike = 0;
  for (var event in events){
    if (event["type"] == "ige" && event["data"]["data"]["type"] == "interaction"){
      if (previousIGEeventFrame.isNegative){
        spikeCounter = event['data']['data']['data']['amt'];
        biggestSpike = spikeCounter;
      }else{
        if ((event['data']['data']['frame']??event['data']['frame']) - previousIGEeventFrame < 60){
          spikeCounter = spikeCounter + event['data']['data']['data']['amt'] as int;
        }else{
          spikeCounter = event['data']['data']['data']['amt'];
        }
        biggestSpike = max(biggestSpike, spikeCounter);
      }
      previousIGEeventFrame = event['data']['data']['frame']??event['data']['frame'];
    }
  }
  return biggestSpike; 
}

class Garbage{ // charsys where???
  late int sent;
  late int recived;
  int? attack;
  late int cleared;
  int? sent_normal;
  int? maxspike;
  int? maxspike_nomult;

  Garbage({
    required this.sent,
    required this.recived,
    required this.attack,
    required this.cleared
  });

  Garbage.fromJson(Map<String, dynamic> json){
    sent = json['sent'];
    recived = json['received'];
    attack = json['attack'];
    cleared = json['cleared'];
    sent_normal = json['sent_normal'];
    maxspike = json['maxspike'];
    maxspike_nomult = json['maxspike_nomult'];
  }

  Garbage.toJson(){
    // наху надо
  }

  Garbage operator + (Garbage other){
    return Garbage(sent: sent + other.sent, recived: recived + other.recived, attack: attack??0 + (other.attack??0), cleared: cleared + other.cleared);
  }
}

class RawReplay{
  String id;
  Uint8List asBytes;
  String asString;

  RawReplay(this.id, this.asBytes, this.asString);
}

class ReplayStats{
  late int seed;
  late int linesCleared;
  late int piecesPlaced;
  late int inputs;
  late int holds;
  late int score;
  late int topCombo;
  late int topBtB;
  late int topSpike;
  late int tspins;
  late double roundLength; // in seconds
  late Clears clears;
  late Garbage garbage;
  late Finesse finesse;

  double get finessePercentage => finesse.perfectPieces / piecesPlaced;

  ReplayStats({
    required this.seed,
    required this.linesCleared,
    required this.piecesPlaced,
    required this.inputs,
    required this.holds,
    required this.score,
    required this.topCombo,
    required this.topBtB,
    required this.topSpike,
    required this.tspins,
    required this.roundLength,
    required this.clears,
    required this.garbage,
    required this.finesse,
  });

  ReplayStats.fromJson(Map<String, dynamic> json, int inputTopSpike, int framesLength){
    seed = json['seed'];
    linesCleared = json['lines'];
    piecesPlaced = json['piecesplaced'];
    inputs = json['inputs'];
    holds = json['holds'];
    score = json['score'];
    topCombo = json['topcombo'];
    topBtB = json['topbtb'];
    topSpike = inputTopSpike;
    tspins = json['tspins'];
    roundLength = framesLength / 60;
    clears = Clears.fromJson(json['clears']);
    garbage = Garbage.fromJson(json['garbage']);
    finesse = Finesse.fromJson(json['finesse']);
  }

  double get kpp => inputs / piecesPlaced;
  double get kps => inputs / roundLength;
  double get spp => score / piecesPlaced;

  ReplayStats.createEmpty(){
    seed = -1;
    linesCleared = 0;
    piecesPlaced = 0;
    inputs = 0;
    holds = 0;
    score = 0;
    topCombo = 0;
    topBtB = 0;
    topSpike = 0;
    tspins = 0;
    roundLength = 0.0;
    clears = Clears(singles: 0, doubles: 0, triples: 0, quads: 0, pentas: 0, allClears: 0, tSpinZeros: 0, tSpinSingles: 0, tSpinDoubles: 0, tSpinTriples: 0, tSpinPentas: 0, tSpinQuads: 0, tSpinMiniZeros: 0, tSpinMiniSingles: 0, tSpinMiniDoubles: 0, tSpinMiniTriples: 0, tSpinMiniQuads: 0);
    garbage = Garbage(sent: 0, recived: 0, attack: 0, cleared: 0);
    finesse = Finesse(combo: 0, faults: 0, perfectPieces: 0);
  }

  ReplayStats operator + (ReplayStats other){
    return ReplayStats(seed: -1,
    linesCleared: linesCleared + other.linesCleared,
    piecesPlaced: piecesPlaced + other.piecesPlaced,
    inputs: inputs + other.inputs,
    holds: holds + other.holds,
    score: score + other.score,
    topCombo: max(topCombo, other.topCombo),
    topBtB: max(topBtB, other.topBtB),
    topSpike: max(topSpike, other.topSpike),
    tspins: tspins + other.tspins,
    roundLength: roundLength + other.roundLength,
    clears: clears + other.clears,
    garbage: garbage + other.garbage,
    finesse: finesse + other.finesse
    );
  }
}

class AggregateStats{
  double apm;
  double pps;
  double vs;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;
  double spp;
  double kpp;
  double kps;

  AggregateStats(this.apm, this.pps, this.vs, this.spp, this.kpp, this.kps){
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }
}

class ReplayData{
  late String id;
  late Map<dynamic, dynamic> rawJson;
  late List<EndContextMulti> endcontext;
  late List<AggregateStats> timeWeightedStats;
  late List<List<ReplayStats>> stats;
  late List<ReplayStats> totalStats;
  late List<List<String>> roundWinners;
  late List<int> roundLengths; // in frames
  late int totalLength; // in frames

  ReplayData({
    required this.id,
    required this.endcontext,
    required this.stats,
    required this.totalStats,
    required this.roundWinners,
    required this.roundLengths,
    required this.totalLength
  }){
    rawJson = {};
  }

  ReplayData.fromJson(Map<String, dynamic> json){
    rawJson = json;
    id = json['_id'];
    endcontext = [EndContextMulti.fromJson(json['endcontext'][0]), EndContextMulti.fromJson(json['endcontext'][1])];
    roundLengths = [];
    totalLength = 0;
    stats = [];
    roundWinners = [];
    int roundID = 0;
    List<double> apmMultipliedByWeights = [0, 0];
    List<double> ppsMultipliedByWeights = [0, 0];
    List<double> vsMultipliedByWeights = [0, 0];
    List<double> sppMultipliedByWeights = [0, 0];
    List<double> kppMultipliedByWeights = [0, 0];
    List<double> kpsMultipliedByWeights = [0, 0];
    totalStats = [ReplayStats.createEmpty(), ReplayStats.createEmpty()];
    for(var round in json['data']) {
      int firstInEndContext = round['replays'][0]["events"].last['data']['export']['options']['username'].startsWith(endcontext[0].username) ? 0 : 1;
      int secondInEndContext = round['replays'][1]["events"].last['data']['export']['options']['username'].startsWith(endcontext[1].username) ? 1 : 0;
      int roundLength = max(round['replays'][0]['frames'], round['replays'][1]['frames']);
      roundLengths.add(roundLength);
      totalLength = totalLength + max(round['replays'][0]['frames'], round['replays'][1]['frames']);
      apmMultipliedByWeights[0] += endcontext[0].secondaryTracking[roundID]*roundLength;
      apmMultipliedByWeights[1] += endcontext[1].secondaryTracking[roundID]*roundLength;
      ppsMultipliedByWeights[0] += endcontext[0].tertiaryTracking[roundID]*roundLength;
      ppsMultipliedByWeights[1] += endcontext[1].tertiaryTracking[roundID]*roundLength;
      vsMultipliedByWeights[0] += endcontext[0].extraTracking[roundID]*roundLength;
      vsMultipliedByWeights[1] += endcontext[1].extraTracking[roundID]*roundLength;
      int winner = round['board'].indexWhere((element) => element['success'] == true);
      roundWinners.add([round['board'][winner]['id']??round['board'][winner]['user']['_id'], round['board'][winner]['username']??round['board'][winner]['user']['username']]);
      ReplayStats playerOne = ReplayStats.fromJson(round['replays'][firstInEndContext]['events'].last['data']['export']['stats'], biggestSpikeFromReplay(round['replays'][secondInEndContext]['events']), round['replays'][firstInEndContext]['frames']); // (events contain recived attacks)
      ReplayStats playerTwo = ReplayStats.fromJson(round['replays'][secondInEndContext]['events'].last['data']['export']['stats'], biggestSpikeFromReplay(round['replays'][firstInEndContext]['events']), round['replays'][secondInEndContext]['frames']);
      sppMultipliedByWeights[0] += playerOne.spp*roundLength;
      sppMultipliedByWeights[1] += playerTwo.spp*roundLength;
      kppMultipliedByWeights[0] += playerOne.kpp*roundLength;
      kppMultipliedByWeights[1] += playerTwo.kpp*roundLength;
     kpsMultipliedByWeights[0] += playerOne.kps*roundLength;
     kpsMultipliedByWeights[1] += playerTwo.kps*roundLength;
      stats.add([playerOne, playerTwo]);
      totalStats[0] = totalStats[0] + playerOne;
      totalStats[1] = totalStats[1] + playerTwo;
      roundID ++;
    }
    timeWeightedStats = [
      AggregateStats(apmMultipliedByWeights[0]/totalLength, ppsMultipliedByWeights[0]/totalLength, vsMultipliedByWeights[0]/totalLength, sppMultipliedByWeights[0]/totalLength, kppMultipliedByWeights[0]/totalLength, kpsMultipliedByWeights[0]/totalLength),
      AggregateStats(apmMultipliedByWeights[1]/totalLength, ppsMultipliedByWeights[1]/totalLength, vsMultipliedByWeights[1]/totalLength, sppMultipliedByWeights[1]/totalLength, kppMultipliedByWeights[1]/totalLength, kpsMultipliedByWeights[1]/totalLength)
    ];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['endcontext'] = [endcontext[0].toJson(), endcontext[1].toJson()];
    data['data'] = [];
    for(var round in rawJson['data']) {
      List<dynamic> eventsPlayerOne = round['replays'][0]['events'];
      List<dynamic> eventsPlayerTwo = round['replays'][1]['events'];
      eventsPlayerOne.removeWhere((v) => (v['type'] == 'ige' && v['data']['data']['type'] != 'interaction') || (v['type'] != 'end' && v['type'] != 'ige'));
      eventsPlayerTwo.removeWhere((v) => (v['type'] == 'ige' && v['data']['data']['type'] != 'interaction') || (v['type'] != 'end' && v['type'] != 'ige'));
      data['data'].add({'board': round['board'], 'replays': [
        {'frames': round['replays'][0]['frames'], 'events': eventsPlayerOne},
        {'frames': round['replays'][1]['frames'], 'events': eventsPlayerTwo}
      ]});
    }
    return data;
  }
}

// can't belive i have to implement that difficult shit

// List<Event> readEventList(Map<dynamic, dynamic> json){
//   List<Event> events = [];
//   int id = 0;
//   for (var event in json['data'][0]['replays'][0]['events']){
//     int frame = event["frame"];
//     EventType type = EventType.values.byName(event['type']);
//     switch (type) {
//       case EventType.start:
//         events.add(Event(id, frame, type));
//         break;
//       case EventType.full:
//         events.add(EventFull(id, frame, type, DataFull.fromJson(event["data"])));
//         break;
//       case EventType.targets:
//         events.add(EventTargets(id, frame, type, Targets.fromJson(event["data"])));
//         break;
//       case EventType.keydown:
//         events.add(EventKeyPress(id, frame, type, 
//           Keypress(
//             KeyType.values.byName(event['data']['key']),
//             event['data']['subframe'],
//             false)
//         ));
//         break;
//       case EventType.keyup:
//         events.add(EventKeyPress(id, frame, type,
//         Keypress(
//           KeyType.values.byName(event['data']['key']),
//           event['data']['subframe'],
//           true)
//         ));
//         break;
//       case EventType.end:
//         events.add(EventEnd(id, frame, type, EndData(event['data']['reason'], DataFull.fromJson(event['data']['export']))));
//         break;
//       case EventType.ige:
//         events.add(EventIGE(id, frame, type, IGE(
//             event['data']['id'],
//             event['data']['frame'],
//             event['data']['type'],
//             event['data']['data']
//           ))
//         );
//         break;
//       case EventType.exit:
//         events.add(Event(id, frame, type));
//         break;
//     }
//     id++;
//   }
//   return events;
// }

// enum EventType
// {
// 	start,
// 	end,
// 	full,
// 	keydown,
// 	keyup,
// 	targets,
// 	ige,
// 	exit
// }

// enum KeyType
// {
// 	moveLeft,
// 	moveRight,
// 	softDrop,
// 	rotateCCW,
// 	rotateCW,
// 	rotate180,
// 	hardDrop,
// 	hold,
// 	chat,
// 	exit,
// 	retry
// }

// class Event{
//   int id;
//   int frame;
//   EventType type;
//   //dynamic data;

//   Event(this.id, this.frame, this.type);

//   @override
//   String toString(){
//     return "E#$id f#$frame: $type";
//   }
// }

// class Keypress{
//   KeyType key;
//   late double subframe;
//   bool released;

//   Keypress(this.key, num sframe, this.released){
//     subframe = sframe.toDouble();
//   }
// }

// class EventKeyPress extends Event{
//   Keypress data;

//   EventKeyPress(super.id, super.frame, super.type, this.data);
// }

// class Targets{
//   String? id;
// 	int? frame;
// 	String? type;
// 	List<dynamic>? data;

//   Targets(this.id, this.frame, this.type, this.data);

//   Targets.fromJson(Map<String, dynamic> json){
//     id = json["id"];
//     frame = json["frame"];
//     type = json["type"];
//     data = json["data"];
//   }
// }

// class EventTargets extends Event{
//   Targets data;

//   EventTargets(super.id, super.frame, super.type, this.data);
// }

// class IGEdata{
//   late String type;
//   late String? gameid;
//   late int? frame;

//   IGEdata.fromJson(Map<String, dynamic> d){
//     type = d['type'];
//     gameid = d['gameid'];
//     frame = d['frame'];
//   }
// }

// enum GarbageStatus
// {
// 	sleeping,
// 	caution,
// 	spawn,
// 	danger
// }

// class GarbageData{
//   int? id;
// 	int? iid;
// 	int? ackiid;
// 	String? username;
// 	late String type;
// 	bool? active;
// 	GarbageStatus? status;
// 	int? delay;
// 	bool? queued;
// 	int? amt;
// 	int? x;
// 	int? y;
// 	int? size;
// 	int? column;
// 	int? cid;
// 	bool? firstcycle;
// 	int? gid;
//   bool? value;

//   GarbageData.fromJson(Map<String, dynamic> data){
//     id = data['id'];
//     iid = data['iid'];
//     ackiid = data['ackiid'];
//     username = data['username'];
//     type = data['type'];
//     active = data['active'];
//     status = data['status'] != null ? GarbageStatus.values[data['status']] : null;
//     delay = data['delay'];
//     queued = data['queued'];
//     amt = data['amt'];
//     x = data['x'];
//     y = data['y'];
//     size = data['size'];
//     column = data['column'];
//     cid = data['cid'];
//     firstcycle = data['firstcycle'];
//     gid = data['gid'];
//     value = data['value'];
//   }
// }

// class IGEdataTarget extends IGEdata{
// 	late List<dynamic> targets;
	
// 	GarbageData? data;
// 	//compatibility for v15 targets event
// 	String? sender_id;

//   IGEdataTarget.fromJson(Map<String, dynamic> d) : super.fromJson(d){
//     targets = d['targets'];
//     data = d['data'] != null ? GarbageData.fromJson(d['data']) : null;
//   }
// }

// class IGEdataAllowTargeting extends IGEdata{
//   late bool value;

//   IGEdataAllowTargeting.fromJson(Map<String, dynamic> d) : super.fromJson(d){
//     value = d['value'];
//     frame = d['frame'];
//   }
// }

// class IGEdataInteraction extends IGEdata{
//   late GarbageData data;
//   String? sender;
//   String? senderID;
//   int? sentFrame;
//   bool confirm = false;
  

//   IGEdataInteraction.fromJson(Map<String, dynamic> d) : super.fromJson(d){
//     //data = Targeted(d['data']['targeted'], d['data']['value']);
//     data = GarbageData.fromJson(d['data']);
//     sender = d['sender'];
//     senderID = d['sender_id'];
//     confirm = type == "interaction_confirm";
//   }
// }

// class IGE{
//   int id;
//   int frame;
//   String type;
//   late IGEdata data;

//   IGE(this.id, this.frame, this.type, Map<String, dynamic> d){
//     data = switch (d["type"] as String) {
//       "interaction" => IGEdataInteraction.fromJson(d),
//       "interaction_confirm" => IGEdataInteraction.fromJson(d),
//       "target" => IGEdataTarget.fromJson(d),
//       "allow_targeting" => IGEdataAllowTargeting.fromJson(d),
//       _ => IGEdata.fromJson(d),
//     };
//   }
// }

// class EventIGE extends Event{
//   IGE data;

//   EventIGE(super.id, super.frame, super.type, this.data);
// }

// class EndData {
//   String reason;
//   DataFull export;

//   EndData(this.reason, this.export);
// }

// class EventEnd extends Event{
//   EndData data;

//   EventEnd(super.id, super.frame, super.type, this.data);
// }

// class Hold
// {
// 	String? piece;
// 	bool locked;

//   Hold(this.piece, this.locked);
// }

// class DataFullOptions{
//   int? version;
//   bool? seedRandom;
//   int? seed;
//   double? g;
//   int? stock;
//   int? gMargin;
//   double? gIncrease;
//   double? garbageMultiplier;
//   int? garbageMargin;
//   double? garbageIncrease;
//   int? garbageCap;
//   double? garbageCapIncrease;
//   int? garbageCapMax;
//   int? garbageHoleSize;
//   String? garbageBlocking; // TODO: enum
//   bool? hasGarbage;
//   int? locktime;
//   int? garbageSpeed;
//   int? forfeitTime;
//   int? are;
//   int? areLineclear;
//   bool? infiniteMovement;
//   int? lockresets;
//   bool? allow180;
//   bool? btbChaining;
//   bool? allclears;
//   bool? clutch;
//   bool? noLockout;
//   String? passthrough;
//   int? boardwidth;
//   int? boardheight;
//   Handling? handling;
//   int? boardbuffer;

//   DataFullOptions.fromJson(Map<String, dynamic> json){
//     version = json["version"];
//     seedRandom = json["seed_random"];
//     seed = json["seed"];
//     g = json["g"];
//     stock = json["stock"];
//     gMargin = json["gmargin"];
//     gIncrease = json["gincrease"];
//     garbageMultiplier = json["garbagemultiplier"].toDouble();
//     garbageCap = json["garbagecap"];
//     garbageCapIncrease = json["garbagecapincrease"].toDouble();
//     garbageCapMax = json["garbagecapmax"];
//     garbageHoleSize = json["garbageholesize"];
//     garbageBlocking = json["garbageblocking"];
//     hasGarbage = json["hasgarbage"];
//     locktime = json["locktime"];
//     garbageSpeed = json["garbagespeed"];
//     forfeitTime = json["forfeit_time"];
//     are = json["are"];
//     areLineclear = json["lineclear_are"];
//     infiniteMovement = json["infinitemovement"];
//     lockresets = json["lockresets"];
//     allow180 = json["allow180"];
//     btbChaining = json["b2bchaining"];
//     allclears = json["allclears"];
//     clutch = json["clutch"];
//     noLockout = json["nolockout"];
//     passthrough = json["passthrough"];
//     boardwidth = json["boardwidth"];
//     boardheight = json["boardheight"];
//     handling = Handling.fromJson(json["handling"]);
//     boardbuffer = json["boardbuffer"];
//   }
// }

// class DataFullStats
// 	{
// 		int? seed;
// 		int? lines;
// 		int? levelLines;
// 		int? levelLinesNeeded;
// 		int? inputs;
// 		int? holds;
// 		int? score;
// 		int? zenLevel;
// 		int? zenProgress;
// 		int? level;
// 		int? combo;
// 		int? currentComboPower;
// 		int? topCombo;
// 		int? btb;
// 		int? topbtb;
// 		int? tspins;
// 		int? piecesPlaced;
//     Clears? clears;
//     Garbage? garbage;
// 		int? kills;
//     Finesse? finesse;

//     DataFullStats.fromJson(Map<String, dynamic> json){
//       seed = json["seed"];
//       lines = json["lines"];
//       levelLines = json["level_lines"];
//       levelLinesNeeded = json["level_lines_needed"];
//       inputs = json["inputs"];
//       holds = json["holds"];
//       score = json["score"];
//       zenLevel = json["zenlevel"];
//       zenProgress = json["zenprogress"];
//       level = json["level"];
//       combo = json["combo"];
//       currentComboPower = json["currentcombopower"];
//       topCombo = json["topcombo"];
//       btb = json["btb"];
//       topbtb = json["topbtb"];
//       tspins = json["tspins"];
//       piecesPlaced = json["piecesplaced"];
//       clears = Clears.fromJson(json["clears"]);
//       garbage = Garbage.fromJson(json["garbage"]);
//       kills = json["kills"];
//       finesse = Finesse.fromJson(json["finesse"]);
//     }
// 	}

// class DataFullGame
// 	{
// 		List<dynamic>? board;
// 		List<dynamic>? bag;
// 		double? g;
// 		bool? playing;
// 		Hold? hold;
// 		String? piece;
// 		Handling? handling;

//     DataFullGame.fromJson(Map<String, dynamic> json){
//       board = json["board"];
//       bag = json["bag"];
//       hold = Hold(json["hold"]["piece"], json["hold"]["locked"]);
//       g = json["g"];
//       handling = Handling.fromJson(json["handling"]);
//     }
// 	}

// class DataFull{
//   bool? successful;
//   String? gameOverReason;
//   int? fire;
//   DataFullOptions? options;
//   DataFullStats? stats;
//   DataFullGame? game;

//   DataFull.fromJson(Map<String, dynamic> json){
//     successful = json["successful"];
//     gameOverReason = json["gameoverreason"];
//     fire = json["fire"];
//     options = DataFullOptions.fromJson(json["options"]);
//     stats = DataFullStats.fromJson(json["stats"]);
//     game = DataFullGame.fromJson(json["game"]);
//   }
// }

// class EventFull extends Event{
//   DataFull data;

//   EventFull(super.id, super.frame, super.type, this.data);
// }

// class TetrioRNG{
//   late double _t;

//   TetrioRNG(int seed){
//     _t = seed % 2147483647;
// 		if (_t <= 0) _t += 2147483646;
//   }

//   int next(){
//     _t = 16807 * _t % 2147483647;
// 		return _t.toInt();
//   }

//   double nextFloat(){
// 		return (next() - 1) / 2147483646;
// 	}

//   List<Tetromino> shuffleList(List<Tetromino> array){
// 		int length = array.length;
// 		if (length == 0) return [];

// 		for (; --length > 0;){
// 			int swapIndex = ((nextFloat()) * (length + 1)).toInt();
//       Tetromino tmp = array[length];
// 			array[length] = array[swapIndex];
//       array[swapIndex] = tmp;
// 		}
//     return array;
// 	}
// }

// enum Tetromino{
//   Z,
//   L,
//   O,
//   S,
//   I,
//   J,
//   T,
//   garbage,
//   empty
// }

// class Coords{
//   int x;
//   int y;

//   Coords(this.x, this.y);

//   @override
//   String toString() {
//     return "($x; $y)";
//   }

//   Coords operator+(Coords other){
//     return Coords(x+other.x, y+other.y);
//   }

//   Coords operator-(Coords other){
//     return Coords(x-other.x, y-other.y);
//   }
// }

// List<Tetromino> tetrominoes = [Tetromino.Z, Tetromino.L, Tetromino.O, Tetromino.S, Tetromino.I, Tetromino.J, Tetromino.T];
// List<List<List<Coords>>> shapes = [
//   [ // Z
//     [Coords(0, 2), Coords(1, 2), Coords(1, 1), Coords(2, 1)],
//     [Coords(2, 2), Coords(2, 1), Coords(1, 1), Coords(1, 0)],
//     [Coords(2, 0), Coords(1, 0), Coords(1, 1), Coords(0, 1)],
//     [Coords(0, 0), Coords(0, 1), Coords(1, 1), Coords(1, 2)]
//   ],
//   [ // L
//     [Coords(2, 2), Coords(2, 1), Coords(1, 1), Coords(0, 1)],
//     [Coords(2, 0), Coords(1, 0), Coords(1, 1), Coords(1, 2)],
//     [Coords(0, 0), Coords(0, 1), Coords(1, 1), Coords(2, 1)],
//     [Coords(0, 2), Coords(1, 2), Coords(1, 1), Coords(1, 0)]
//   ],
//   [ // O
//     [Coords(0, 0), Coords(1, 0), Coords(0, 1), Coords(1, 1)],
//     [Coords(0, 0), Coords(1, 0), Coords(0, 1), Coords(1, 1)],
//     [Coords(0, 0), Coords(1, 0), Coords(0, 1), Coords(1, 1)],
//     [Coords(0, 0), Coords(1, 0), Coords(0, 1), Coords(1, 1)]
//   ],
//   [ // S
//     [Coords(2, 2), Coords(1, 2), Coords(1, 1), Coords(0, 1)],
//     [Coords(2, 0), Coords(2, 1), Coords(1, 1), Coords(1, 2)],
//     [Coords(0, 0), Coords(1, 0), Coords(1, 1), Coords(2, 1)],
//     [Coords(0, 2), Coords(0, 1), Coords(1, 1), Coords(1, 0)]
//   ],
//   [ // I
//     [Coords(0, 2), Coords(1, 2), Coords(2, 2), Coords(3, 2)],
// 		[Coords(2, 3), Coords(2, 2), Coords(2, 1), Coords(2, 0)],
// 		[Coords(3, 1), Coords(2, 1), Coords(1, 1), Coords(0, 1)],
// 		[Coords(1, 0), Coords(1, 1), Coords(1, 2), Coords(1, 3)]
//   ],
//   [ // J
//     [Coords(0, 2), Coords(0, 1), Coords(1, 1), Coords(2, 1)],
//     [Coords(2, 2), Coords(1, 2), Coords(1, 1), Coords(1, 0)],
//     [Coords(2, 0), Coords(2, 1), Coords(1, 1), Coords(0, 1)],
//     [Coords(0, 0), Coords(1, 0), Coords(1, 1), Coords(1, 2)]
//   ],
//   [ // T
//     [Coords(1, 2), Coords(0, 1), Coords(1, 1), Coords(2, 1)],
//     [Coords(2, 1), Coords(1, 2), Coords(1, 1), Coords(1, 0)],
//     [Coords(1, 0), Coords(2, 1), Coords(1, 1), Coords(0, 1)],
//     [Coords(0, 1), Coords(1, 0), Coords(1, 1), Coords(1, 2)]
//   ]
// ];
// List<Coords> spawnPositionFixes = [Coords(0, 0), Coords(0, 0), Coords(1, 1), Coords(0, 0), Coords(0, -1), Coords(0, 0), Coords(0, 0)];

// const Map<String, int> garbage = {
//   "single": 0,
//   "double": 1,
//   "triple": 2,
//   "quad": 4,
//   "penta": 5,
//   "t-spin": 0,
//   "t-spin single": 2,
//   "t-spin double": 4,
//   "t-spin triple": 6,
//   "t-spin quad": 10,
//   "t-spin penta": 12,
//   "t-spin mini": 0,
//   "t-spin mini single": 0,
//   "t-spin mini double": 1,
//   "allclear": 10
// };
// int btbBonus = 1;
// double btbLog = 0.8;
// double comboBonus = 0.25;
// int comboMinifier = 1;
// double comboMinifierLog = 1.25;
// List<int> comboTable = [0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5];

// class KicksetBase {
// 	List<Coords>? additionalOffsets;
// 	late List<Coords> additionalOffsetEmpty;
// 	List<int>? spawnRotation;
// 	late List<List<List<Coords>>> kickTable; //kickTable[initRot][rotDirection-1][kick]
// 	late List<List<List<Coords>>> kickTableI;
// }

// class SRSPlus extends KicksetBase{
//   SRSPlus(){
//     kickTable = [
//       [
//         [Coords( 0, 0), Coords( 1, 0), Coords( 1, 1), Coords( 0,-2), Coords( 1,-2)], // 0 -> 270
//         [Coords( 0, 0), Coords(-1, 0), Coords(-1, 1), Coords( 0,-2), Coords(-1,-2)], // 0 -> 90
//         [Coords( 0, 0), Coords( 0, 1), Coords( 1, 1), Coords(-1, 1), Coords( 1, 0), Coords(-1, 0)], // 0 -> 180
//       ],
//       [
//         [Coords( 0, 0), Coords( 1, 0), Coords( 1,-1), Coords( 0, 2), Coords( 1, 2)], // 90 -> 0
//         [Coords( 0, 0), Coords( 1, 0), Coords( 1,-1), Coords( 0, 2), Coords( 1, 2)], // 90 -> 180
//         [Coords( 0, 0), Coords( 1, 0), Coords( 1, 2), Coords( 1, 1), Coords( 0, 2), Coords( 0, 1)], // 90 -> 270
//       ],
//       [
//         [Coords( 0, 0), Coords(-1, 0), Coords(-1, 1), Coords( 0,-2), Coords(-1,-2)], // 180 -> 90
//         [Coords( 0, 0), Coords( 1, 0), Coords( 1, 1), Coords( 0,-2), Coords( 1,-2)], // 180 -> 270
//         [Coords( 0, 0), Coords( 0,-1), Coords(-1,-1), Coords( 1,-1), Coords(-1, 0), Coords( 1, 0)], // 180 -> 0
//       ], 
//       [ 
//         [Coords( 0, 0), Coords(-1, 0), Coords(-1,-1), Coords( 0, 2), Coords(-1, 2)], // 270 -> 180
//         [Coords( 0, 0), Coords(-1, 0), Coords(-1,-1), Coords( 0, 2), Coords(-1, 2)], // 270 -> 0
//         [Coords( 0, 0), Coords(-1, 0), Coords(-1, 2), Coords(-1, 1), Coords( 0, 2), Coords( 0, 1)], // 270 -> 90
//       ] 
//     ];
//     kickTableI = [
//       [
//         [Coords( 0, 0), Coords(-1, 0), Coords( 2, 0), Coords( 2,-1), Coords(-1, 2)], // 0 -> 270
//         [Coords( 0, 0), Coords( 1, 0), Coords( 2, 0), Coords(-1,-1), Coords( 1, 2)], // 0 -> 90
//         [Coords( 0, 0), Coords( 0, 1)], // 0 -> 180
//       ],
//       [
//         [Coords( 0, 0), Coords(-1, 0), Coords( 2, 0), Coords(-1,-2), Coords( 2,-1)], // 90 -> 0
//         [Coords( 0, 0), Coords(-1, 0), Coords( 2, 0), Coords(-1, 2), Coords( 2, 1)], // 90 -> 180
//         [Coords( 0, 0), Coords( 1, 0)], // 90 -> 270
//       ],
//       [
//         [Coords( 0, 0), Coords(-2, 0), Coords( 1, 0), Coords(-2, 1), Coords( 1,-2)], // 180 -> 90
//         [Coords( 0, 0), Coords(-2, 0), Coords(-1, 0), Coords( 2, 1), Coords(-1,-2)], // 180 -> 270
//         [Coords( 0, 0), Coords( 0,-1)], // 180 -> 0
//       ], 
//       [
//         [Coords( 0, 0), Coords( 1, 0), Coords(-2, 0), Coords( 1, 2), Coords(-2,-1)], // 270 -> 180
//         [Coords( 0, 0), Coords( 1, 0), Coords(-2, 0), Coords( 1,-2), Coords(-2, 1)], // 270 -> 0
//         [Coords( 0, 0), Coords(-1, 0)], // 270 -> 90
//       ] 
//     ];
//     additionalOffsetEmpty = [Coords( 0, 0),Coords( 0, 0),Coords( 0, 0),Coords( 0, 0)];
//   }
// }
