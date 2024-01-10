import 'dart:io';
import 'dart:math';
import 'tetrio.dart';

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
        if (event['data']['data']['frame'] - previousIGEeventFrame < 60){
          spikeCounter = spikeCounter + event['data']['data']['data']['amt'] as int;
        }else{
          spikeCounter = event['data']['data']['data']['amt'];
        }
        biggestSpike = max(biggestSpike, spikeCounter);
      }
      previousIGEeventFrame = event['data']['data']['frame'];
    }
  }
  return biggestSpike; 
}

class Garbage{ // charsys where???
  late int sent;
  late int recived;
  late int attack;
  late int cleared;

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
  }

  Garbage.toJson(){
    // наху надо
  }

  Garbage operator + (Garbage other){
    return Garbage(sent: sent + other.sent, recived: recived + other.recived, attack: attack + other.attack, cleared: cleared + other.cleared);
  }
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
    clears = Clears(singles: 0, doubles: 0, triples: 0, quads: 0, pentas: 0, allClears: 0, tSpinZeros: 0, tSpinSingles: 0, tSpinDoubles: 0, tSpinTriples: 0, tSpinPentas: 0, tSpinQuads: 0, tSpinMiniZeros: 0, tSpinMiniSingles: 0, tSpinMiniDoubles: 0);
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

class ReplayData{
  late String id;
  late Map<dynamic, dynamic> rawJson;
  late List<EndContextMulti> endcontext;
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
    totalStats = [ReplayStats.createEmpty(), ReplayStats.createEmpty()];
    for(var round in json['data']) {
      int firstInEndContext = round['replays'][0]["events"].last['data']['export']['options']['gameid'].startsWith(endcontext[0].userId) ? 0 : 1;
      int secondInEndContext = round['replays'][1]["events"].last['data']['export']['options']['gameid'].startsWith(endcontext[1].userId) ? 1 : 0;
      roundLengths.add(max(round['replays'][0]['frames'], round['replays'][1]['frames']));
      totalLength = totalLength + max(round['replays'][0]['frames'], round['replays'][1]['frames']);
      int winner = round['board'].indexWhere((element) => element['success'] == true);
      roundWinners.add([round['board'][winner]['id'], round['board'][winner]['username']]);
      ReplayStats playerOne = ReplayStats.fromJson(round['replays'][firstInEndContext]['events'].last['data']['export']['stats'], biggestSpikeFromReplay(round['replays'][secondInEndContext]['events']), round['replays'][firstInEndContext]['frames']); // (events contain recived attacks)
      ReplayStats playerTwo = ReplayStats.fromJson(round['replays'][secondInEndContext]['events'].last['data']['export']['stats'], biggestSpikeFromReplay(round['replays'][firstInEndContext]['events']), round['replays'][secondInEndContext]['frames']);
      stats.add([playerOne, playerTwo]);
      totalStats[0] = totalStats[0] + playerOne;
      totalStats[1] = totalStats[1] + playerTwo;
    }
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