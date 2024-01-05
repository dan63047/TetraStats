import 'dart:io';
import 'dart:math';
import 'tetrio.dart';

// I want to implement those fancy TWC stats
// So, i'm going to read replay for things

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
  late int tspins;
  late Clears clears;
  late Garbage garbage;
  late Finesse finesse;
  late int kills;

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
    required this.tspins,
    required this.clears,
    required this.garbage,
    required this.finesse,
    required this.kills,
  });

  ReplayStats.fromJson(Map<String, dynamic> json){
    seed = json['seed'];
    linesCleared = json['lines'];
    piecesPlaced = json['piecesplaced'];
    inputs = json['inputs'];
    holds = json['holds'];
    score = json['score'];
    topCombo = json['topcombo'];
    topBtB = json['topbtb'];
    tspins = json['tspins'];
    clears = Clears.fromJson(json['clears']);
    garbage = Garbage.fromJson(json['garbage']);
    finesse = Finesse.fromJson(json['finesse']);
    kills = json['kills'];
  }

  ReplayStats.createEmpty(){
    seed = -1;
    linesCleared = 0;
    piecesPlaced = 0;
    inputs = 0;
    holds = 0;
    score = 0;
    topCombo = 0;
    topBtB = 0;
    tspins = 0;
    clears = Clears(singles: 0, doubles: 0, triples: 0, quads: 0, pentas: 0, allClears: 0, tSpinZeros: 0, tSpinSingles: 0, tSpinDoubles: 0, tSpinTriples: 0, tSpinPentas: 0, tSpinQuads: 0, tSpinMiniZeros: 0, tSpinMiniSingles: 0, tSpinMiniDoubles: 0);
    garbage = Garbage(sent: 0, recived: 0, attack: 0, cleared: 0);
    finesse = Finesse(combo: 0, faults: 0, perfectPieces: 0);
    kills = 0;
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
    tspins: tspins + other.tspins,
    clears: clears + other.clears,
    garbage: garbage + other.garbage,
    finesse: finesse + other.finesse,
    kills: kills + other.kills);
  }
}

class ReplayData{
  late String id;
  late Map<dynamic, dynamic> rawJson;
  late List<EndContextMulti> endcontext;
  late List<List<ReplayStats>> stats;
  late List<ReplayStats> totalStats;
  late List<int> roundLengths; // in frames
  late int totalLength; // in frames

  ReplayData({
    required this.id,
    required this.endcontext,
    required this.stats,
    required this.totalStats,
    required this.roundLengths,
    required this.totalLength
  }){
    rawJson = {};
  }

  ReplayData.fromJson(Map<String, dynamic> json){
    rawJson = json;
    id = json["_id"];
    endcontext = [EndContextMulti.fromJson(json["endcontext"][0]), EndContextMulti.fromJson(json["endcontext"][1])];
    roundLengths = [];
    totalLength = 0;
    stats = [];
    totalStats = [ReplayStats.createEmpty(), ReplayStats.createEmpty()];

    for(var round in json['data']) {
      roundLengths.add(max(round['replays'][0]['frames'], round['replays'][1]['frames']));
      totalLength = totalLength + max(round['replays'][0]['frames'], round['replays'][1]['frames']);
      ReplayStats playerOne = ReplayStats.fromJson(round['replays'][0]['events'].last['data']['export']['stats']);
      ReplayStats playerTwo = ReplayStats.fromJson(round['replays'][1]['events'].last['data']['export']['stats']);
      stats.add([playerOne, playerTwo]);
      totalStats[0] = totalStats[0] + playerOne;
      totalStats[1] = totalStats[1] + playerTwo;
      // print(round['replays'][0]['events'].last['data']['export']['stats']);
      // for (var event in round['replays'][0]['events']){
      //   if (event["type"] == "ige" && event["data"]["data"]["type"] == "interaction_confirm"){
      //     print(event['data']["data"]["data"]); // lol
      //   }
      // } 
    }
    // Сами по себе эти ивенты ничего не дают,
    // Хотя можно попробовать вычислить biggest spike
  }
}