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
    recived = json['recived'];
    attack = json['attack'];
    cleared = json['cleared'];
  }

  Garbage.toJson(){
    // наху надо
  }
}

class ReplayStats{
  late int seed;
  late int linesCleared;
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

  ReplayStats({
    required this.seed,
    required this.linesCleared,
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

}

class ReplayData{
  late String id;
  late List<EndContextMulti> endcontext;
  late List<List<ReplayStats>> stats;
  late List<int> roundLengths; // in frames

  ReplayData({
    required this.id,
    required this.endcontext,
    required this.stats,
    required this.roundLengths
  });

  ReplayData.fromJson(Map<String, dynamic> json){
    // завтра разберусь,
    // пока что знаю, что тут будет for loop, который чекает replay["data"]
  }
}