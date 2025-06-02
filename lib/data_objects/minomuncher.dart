import 'dart:math';

import 'package:tetra_stats/gen/strings.g.dart';

class MPlacement{
  late final List<int> ppsSegments;
  late final List<int> wellColumns;
  late final ClearsChartData clearTypes;
  late final int pieces;
  late final int openerAttack;
  late final double openerFrames;
  late final int openerBlocks;
  late final int allspins;
  late final int iPieces;
  late final int tPieces;
  late final int attack;
  late final int attackSent;
  late final int cleanAttacksSent;
  late final int linesCleared;
  late final int downstackCleared;
  late final int attackWithDownstack;
  late final int cleanLinesSent;
  late final double frameDelay;
  late final double cheeseScore;
  late final int keypresses;
  late final int cheeseCleared;
  late final int attackWithCheese;
  late final int allPieces;
  late final int linesSent;
  late final double stackingTotalFrames;
  late final int stackingTotalUpdates;
  late final double downstackingTotalFrames;
  late final int downstackingTotalUpdates;

  MPlacement({
    this.ppsSegments = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,],
    this.wellColumns = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.clearTypes = const ClearsChartData("nill", 0, 0, 0, 0, 0, 0, 0, 0, 0),
    this.pieces = 0,
    this.openerAttack = 0,
    this.openerFrames = 0.0,
    this.openerBlocks = 0,
    this.allspins = 0,
    this.iPieces = 0,
    this.tPieces = 0,
    this.attack = 0,
    this.attackSent = 0,
    this.cleanAttacksSent = 0,
    this.linesCleared = 0,
    this.downstackCleared = 0,
    this.attackWithDownstack = 0,
    this.cleanLinesSent = 0,
    this.frameDelay = 0.0,
    this.cheeseScore = 0.0,
    this.keypresses = 0,
    this.cheeseCleared = 0,
    this.attackWithCheese = 0,
    this.allPieces = 0,
    this.linesSent = 0,
    this.stackingTotalFrames = 0.0,
    this.stackingTotalUpdates = 0,
    this.downstackingTotalFrames = 0.0,
    this.downstackingTotalUpdates = 0,
  });

  MPlacement operator +(MPlacement other){
    List<int> ppsSegmentsSum = [for (int i = 0; i < ppsSegments.length; i++) ppsSegments[i]+other.ppsSegments[i]];
    List<int> wellColumnsSum = [for (int i = 0; i < wellColumns.length; i++) wellColumns[i]+other.wellColumns[i]];
    return MPlacement(
      ppsSegments: ppsSegmentsSum,
      wellColumns: wellColumnsSum,
      clearTypes: clearTypes + other.clearTypes,
      pieces: pieces + other.pieces,
      openerAttack: openerAttack + other.openerAttack,
      openerFrames: openerFrames + other.openerFrames,
      openerBlocks: openerBlocks + other.openerBlocks,
      allspins: allspins + other.allspins,
      iPieces: iPieces + other.iPieces,
      tPieces: tPieces + other.tPieces,
      attack: attack + other.attack,
      attackSent: attackSent + other.attackSent,
      cleanAttacksSent: cleanAttacksSent + other.cleanAttacksSent,
      linesCleared: linesCleared + other.linesCleared,
      downstackCleared: downstackCleared + other.downstackCleared,
      attackWithDownstack: attackWithDownstack + other.attackWithDownstack,
      cleanLinesSent: cleanLinesSent + other.cleanLinesSent,
      frameDelay: frameDelay + other.frameDelay,
      cheeseScore: cheeseScore + other.cheeseScore,
      keypresses: keypresses + other.keypresses,
      cheeseCleared: cheeseCleared + other.cheeseCleared,
      attackWithCheese: attackWithCheese + other.attackWithCheese,
      allPieces: allPieces + other.allPieces,
      linesSent: linesSent + other.linesSent,
      stackingTotalFrames: stackingTotalFrames + other.stackingTotalFrames,
      stackingTotalUpdates: stackingTotalUpdates + other.stackingTotalUpdates,
      downstackingTotalFrames: downstackingTotalFrames + other.downstackingTotalFrames,
      downstackingTotalUpdates: downstackingTotalUpdates + other.downstackingTotalUpdates
    );
  }
}

class MGarbage{
  late final int linesReceived;
  late final int cleanLinesRecieved;
  late final int cheeseLinesRecieved;
  late final int cheeseLinesCancelled;
  late final int cheeseLinesTanked;
  late final int cleanLinesCancelled;
  late final int cleanLinesTankedAsCheese;
  late final int cleanLinesTankedAsClean;

  MGarbage({
    this.linesReceived = 0,
    this.cleanLinesRecieved = 0,
    this.cheeseLinesRecieved = 0,
    this.cheeseLinesCancelled = 0,
    this.cheeseLinesTanked = 0,
    this.cleanLinesCancelled = 0,
    this.cleanLinesTankedAsCheese = 0,
    this.cleanLinesTankedAsClean = 0,
  });

  MGarbage operator+ (MGarbage other){
    return MGarbage(
      linesReceived: linesReceived+other.linesReceived,
      cleanLinesRecieved: cleanLinesRecieved+other.cleanLinesRecieved,
      cheeseLinesRecieved: cheeseLinesRecieved+other.cheeseLinesRecieved,
      cheeseLinesCancelled: cheeseLinesCancelled+other.cheeseLinesCancelled,
      cheeseLinesTanked: cheeseLinesTanked+other.cheeseLinesTanked,
      cleanLinesCancelled: cleanLinesCancelled+other.cleanLinesCancelled,
      cleanLinesTankedAsCheese: cleanLinesTankedAsCheese+other.cleanLinesTankedAsCheese,
      cleanLinesTankedAsClean: cleanLinesTankedAsClean+other.cleanLinesTankedAsClean
    );
  }
}

class MSurge{
  late final int chains;
  late final int btb;
  late final int garbageCleared;
  late final int linesCleared;
  late final int attack;
  late final double frames;
  late final int pieces;
  late final int fails;
  late final double framesWithSurgeGarbage;
  late final int surgeGarbageCleared;
  late final double framesWithSurgeCheese;
  late final int surgeCheeseCleared;
  late final int allspins;
  late final int btbClears;

  MSurge({
    this.chains = 0,
    this.btb = 0,
    this.garbageCleared = 0,
    this.linesCleared = 0,
    this.attack = 0,
    this.frames = 0.0,
    this.pieces = 0,
    this.fails = 0,
    this.framesWithSurgeGarbage = 0.0,
    this.surgeGarbageCleared = 0,
    this.framesWithSurgeCheese = 0.0,
    this.surgeCheeseCleared = 0,
    this.allspins = 0,
    this.btbClears = 0
  });

  MSurge operator+(MSurge other){
    return MSurge(
      chains: chains+other.chains,
      btb: btb+other.btb,
      garbageCleared: garbageCleared+other.garbageCleared,
      linesCleared: linesCleared+other.linesCleared,
      attack: attack+other.attack,
      frames: frames+other.frames,
      pieces: pieces+other.pieces,
      fails: fails+other.fails,
      framesWithSurgeGarbage: framesWithSurgeGarbage+other.framesWithSurgeGarbage,
      surgeGarbageCleared: surgeGarbageCleared+other.surgeGarbageCleared,
      framesWithSurgeCheese: framesWithSurgeCheese+other.framesWithSurgeCheese,
      surgeCheeseCleared: surgeCheeseCleared+other.surgeCheeseCleared,
      allspins: allspins+other.allspins,
      btbClears: btbClears+other.btbClears
    );
  }
}

class MinomuncherRaw {
  late final String nick;
  late final MPlacement placement;
  late final MGarbage garbage;
  late final MSurge surge;
  late final DeathData death;
  late final DeathData kill;

  MinomuncherRaw({
    String? n,
    String? i,
    MPlacement? p,
    MGarbage? g,
    MSurge? s,
    DeathData? d,
    DeathData? k
  }){
    nick = n??"Nill";
    placement = p??MPlacement();
    garbage = g??MGarbage();
    surge = s??MSurge();
    death = d??DeathData(nick, 0, 0, 0, 0, 0, 0);
    kill = k??DeathData(nick, 0, 0, 0, 0, 0, 0);
  }

  MinomuncherRaw.fromJson(MapEntry<String, dynamic> json){
    nick = json.key;
    placement = MPlacement(
      ppsSegments: json.value["placement"]["ppsSegments"].cast<int>(),
      wellColumns: json.value["placement"]["wellColumns"].cast<int>(),
      clearTypes: ClearsChartData(nick, json.value["placement"]["clearTypes"]["perfectClear"], json.value["placement"]["clearTypes"]["allspin"], json.value["placement"]["clearTypes"]["single"], json.value["placement"]["clearTypes"]["tspinSingle"], json.value["placement"]["clearTypes"]["double"], json.value["placement"]["clearTypes"]["tspinDouble"], json.value["placement"]["clearTypes"]["triple"], json.value["placement"]["clearTypes"]["tspinTriple"], json.value["placement"]["clearTypes"]["quad"]),
      pieces: json.value["placement"]["pieces"],
      openerAttack: json.value["placement"]["openerAttack"],
      openerFrames: json.value["placement"]["openerFrames"].toDouble(),
      openerBlocks: json.value["placement"]["openerBlocks"],
      allspins: json.value["placement"]["allspins"],
      iPieces: json.value["placement"]["iPieces"],
      tPieces: json.value["placement"]["tPieces"],
      attack: json.value["placement"]["attack"],
      attackSent: json.value["placement"]["attacksSent"],
      cleanAttacksSent: json.value["placement"]["cleanAttacksSent"],
      linesCleared: json.value["placement"]["linesCleared"],
      downstackCleared: json.value["placement"]["downstackCleared"],
      attackWithDownstack: json.value["placement"]["attackWithDownstack"],
      cleanLinesSent: json.value["placement"]["cleanLinesSent"],
      frameDelay: json.value["placement"]["frameDelay"].toDouble(),
      cheeseScore: json.value["placement"]["cheeseScore"],
      keypresses: json.value["placement"]["keypresses"],
      cheeseCleared: json.value["placement"]["cheeseCleared"],
      attackWithCheese: json.value["placement"]["attackWithCheese"],
      allPieces: json.value["placement"]["allPieces"],
      linesSent: json.value["placement"]["linesSent"],
      stackingTotalFrames: json.value["placement"]["stackSpeed"]["stacking"]["totalFrames"].toDouble(),
      stackingTotalUpdates: json.value["placement"]["stackSpeed"]["stacking"]["totalUpdates"],
      downstackingTotalFrames: json.value["placement"]["stackSpeed"]["downstacking"]["totalFrames"].toDouble(),
      downstackingTotalUpdates: json.value["placement"]["stackSpeed"]["downstacking"]["totalUpdates"]
    );
    garbage = MGarbage(
      linesReceived: json.value["garbage"]["linesReceived"],
      cleanLinesRecieved: json.value["garbage"]["cleanLinesRecieved"],
      cheeseLinesRecieved: json.value["garbage"]["cheeseLinesRecieved"],
      cheeseLinesCancelled: json.value["garbage"]["cheeseLinesCancelled"],
      cheeseLinesTanked: json.value["garbage"]["cheeseLinesTanked"],
      cleanLinesCancelled: json.value["garbage"]["cleanLinesCancelled"],
      cleanLinesTankedAsCheese: json.value["garbage"]["cleanLinesTankedAsCheese"],
      cleanLinesTankedAsClean: json.value["garbage"]["cleanLinesTankedAsClean"]
    );
    surge = MSurge(
      chains: json.value["surge"]["chains"],
      btb: json.value["surge"]["btb"],
      garbageCleared: json.value["surge"]["garbageCleared"],
      linesCleared: json.value["surge"]["linesCleared"],
      attack: json.value["surge"]["attack"],
      frames: json.value["surge"]["frames"].toDouble(),
      pieces: json.value["surge"]["pieces"],
      fails: json.value["surge"]["fails"],
      framesWithSurgeGarbage: json.value["surge"]["framesWithSurgeGarbage"].toDouble(),
      surgeGarbageCleared: json.value["surge"]["surgeGarbageCleared"],
      framesWithSurgeCheese: json.value["surge"]["framesWithSurgeCheese"].toDouble(),
      surgeCheeseCleared: json.value["surge"]["surgeCheeseCleared"],
      allspins: json.value["surge"]["allspins"],
      btbClears: json.value["surge"]["btbClears"]
    );
    death = DeathData.fromJson(json.value["death"], nick);
    kill = DeathData.fromJson(json.value["kill"], nick);
  }

  MinomuncherData get data => MinomuncherData.fromRaw(this);

  MinomuncherRaw operator+(MinomuncherRaw other){
    return MinomuncherRaw(
      n: nick,
      p: placement+other.placement,
      g: garbage+other.garbage,
      s: surge+other.surge,
      d: death+other.death,
      k: kill+other.kill
    );
  }
}

double sigmoid(double v){
    double top = 1/(1+exp(-10 * (v-0.3))) - 1/(1+exp(3));
    double bottom = 1/(1+exp(-7)) - 1/(1+exp(3));
    return top/bottom;
}

double getVariance(List<double> arr, double mean) {
    return arr.reduce((pre, cur) {
      pre = pre + pow((cur - mean), 2);
      return pre;
    })/arr.length;
  }

/// Part of gaussian-mixture thing
/// dude i don't want to reimplement entire js library for that
List<double> means(List<double> data){
  List<double> me = [];
  int n = data.length;
  Random rand = Random();
  const int nComponents = 3;
  // Find the first seed at random
  me.add(data[(rand.nextDouble() * (n - 1)).round()]);
  var distances = [];

  // Chose all other seeds
  for (var m = 1; m < nComponents; m++) {
    // Compute the distance from each datapoint
    double dsum = 0;
    for (var i = 0; i < n; i++) {
      var meansDistances = me.map((x) { return (x - data[i]) * (x - data[i]); });
      var d = meansDistances.reduce((a, b) { return min(a, b); });
      try{
        distances[i] = d;
      }on RangeError{
        distances.add(d);
      }
      dsum += d;
    }

    // Chose the next seed at random with probabilities d / dsum
    var r = rand.nextDouble();
    var c;
    for (var j = 0; j < n; j++) {
      double p = dsum > 0 ? (distances[j] / dsum) : 0;
      if (p > r || j == (n - 1)) {
        c = data[j];
        break;
      } else {
        r -= p;
      }
    }

    me.add(c);
  }

  me.sort((a, b) { return (a - b).round(); });
  return me;
}

class MinomuncherData {
  late final String nick;
  late final List<WellsData> wellColumns;
  late final ClearsChartData clearTypes;
  late final double allspinEfficiency;
  late final double tEfficiency;
  late final double iEfficiency;
  late final double cheeseAPL;
  late final double downstackAPL;
  late final double upstackAPL;
  late final double APL;
  late final double APP;
  late final double KPP;
  late final double KPS;
  late final double APM;
  late final double PPS;
  late final List<double> ppsSegments;
  late final double BurstPPS;
  late final double PlonkPPS;
  late final double PPSCoeff;
  late final double midgameAPM;
  late final double midgamePPS;
  late final double openerAPM;
  late final double openerPPS;
  late final double attackCheesiness;
  late final double surgeAPM;
  late final double surgeAPL;
  late final double surgeDS;
  late final double surgePPS;
  late final double surgeLength;
  late final double surgeRate;
  late final double? surgeSecsPerCheese;
  late final double? surgeSecsPerDS;
  late final double surgeAllspin;
  late final double cleanLinesRecieved;
  late final double cheeseLinesRecieved;
  late final double cheeseLinesCancelled;
  late final double cheeseLinesTanked;
  late final double cleanLinesCancelled;
  late final double cleanLinesTankedAsCheese;
  late final double cleanLinesTankedAsClean;
  late final DeathData deathStats;
  late final DeathData killStats;
  late final double upstackPPS;
  late final double downstackPPS;
  late final double downstackingRatio;

  MinomuncherData.fromJson(MapEntry<String, dynamic> entry){
    double secs = entry.value["placement"]["frameDelay"] / 60;
    double mins = secs / 60;
    double attackSecs = entry.value["placement"]["openerFrames"] / 60;
    double attackMins = attackSecs / 60;
    double surgeSecs = entry.value["surge"]["frames"] / 60;
    double surgeMins = surgeSecs / 60;
    this.nick = entry.key;
    this.wellColumns = [for (int i = 0; i <= 9; i++) WellsData(i+1, entry.value["placement"]["wellColumns"][i].toDouble())];
    this.clearTypes = ClearsChartData(nick, entry.value["placement"]["clearTypes"]["perfectClear"], entry.value["placement"]["clearTypes"]["allspin"], entry.value["placement"]["clearTypes"]["single"], entry.value["placement"]["clearTypes"]["tspinSingle"], entry.value["placement"]["clearTypes"]["double"], entry.value["placement"]["clearTypes"]["tspinDouble"], entry.value["placement"]["clearTypes"]["triple"], entry.value["placement"]["clearTypes"]["tspinTriple"], entry.value["placement"]["clearTypes"]["quad"]);
    this.allspinEfficiency = entry.value["placement"]["allspins"]/entry.value["placement"]["allPieces"];
    this.tEfficiency = (clearTypes.tspinSingle+clearTypes.tspinDouble+clearTypes.tspinTriple)/entry.value["placement"]["tPieces"];
    this.iEfficiency = clearTypes.quad/entry.value["placement"]["iPieces"];
    this.cheeseAPL = entry.value["placement"]["attackWithCheese"]/entry.value["placement"]["cheeseCleared"];
    this.downstackAPL = entry.value["placement"]["attackWithDownstack"]/entry.value["placement"]["downstackCleared"];
    this.upstackAPL = (entry.value["placement"]["attack"]-entry.value["placement"]["attackWithDownstack"])/(entry.value["placement"]["linesCleared"]-entry.value["placement"]["downstackCleared"]);
    this.APL = entry.value["placement"]["attack"]/entry.value["placement"]["linesCleared"];
    this.APP = entry.value["placement"]["attack"]/entry.value["placement"]["pieces"];
    this.KPP = entry.value["placement"]["keypresses"]/entry.value["placement"]["pieces"];
    this.KPS = entry.value["placement"]["keypresses"]/secs;
    this.APM = entry.value["placement"]["attack"]/mins;
    this.PPS = entry.value["placement"]["pieces"]/secs;
    this.ppsSegments = entry.value["placement"]["ppsSegments"].cast<double>();
    List<double> me = means(ppsSegments);
    this.BurstPPS = me.reduce(max); //entry.value["BurstPPS"];
    this.PlonkPPS = me.reduce(min); // entry.value["PlonkPPS"];
    this.PPSCoeff = getVariance(entry.value["placement"]["ppsSegments"], PPS);
    this.midgameAPM = (entry.value["placement"]["attack"] - entry.value["placement"]["openerAttack"]) / (mins - attackMins);
    this.midgamePPS = (entry.value["placement"]["pieces"] - entry.value["placement"]["openerBlocks"]) / (secs - attackSecs);
    this.openerAPM = entry.value["placement"]["openerAttack"]/attackMins;
    this.openerPPS = entry.value["placement"]["openerBlocks"]/attackSecs;
    this.attackCheesiness = sigmoid(entry.value["placement"]["cheeseScore"] / entry.value["placement"]["linesSent"]);
    this.surgeAPM = entry.value["surge"]["attack"] / surgeMins;
    this.surgeAPL = entry.value["surge"]["attack"] / entry.value["surge"]["linesCleared"];
    this.surgeDS = entry.value["surge"]["garbageCleared"] / entry.value["surge"]["chains"];
    this.surgePPS = entry.value["surge"]["pieces"] / surgeSecs;
    this.surgeLength = entry.value["surge"]["btb"] / entry.value["surge"]["chains"];
    this.surgeRate = entry.value["surge"]["chains"] / (entry.value["surge"]["chains"] + entry.value["surge"]["fails"]);
    this.surgeSecsPerCheese = entry.value["surge"]["framesWithSurgeCheese"] / 60 / entry.value["surge"]["surgeCheeseCleared"];
    this.surgeSecsPerDS = entry.value["surge"]["framesWithSurgeGarbage"] / 60 / entry.value["surge"]["surgeGarbageCleared"];
    this.surgeAllspin = entry.value["surge"]["allspins"] / entry.value["surge"]["btbClears"];
    this.cleanLinesRecieved = entry.value["garbage"]["cleanLinesRecieved"]/entry.value["garbage"]["linesReceived"];
    this.cheeseLinesRecieved = entry.value["garbage"]["cheeseLinesRecieved"]/entry.value["garbage"]["linesReceived"];
    this.cheeseLinesCancelled = entry.value["garbage"]["cheeseLinesCancelled"]/entry.value["garbage"]["linesReceived"];
    this.cheeseLinesTanked = entry.value["garbage"]["cheeseLinesTanked"]/entry.value["garbage"]["linesReceived"];
    this.cleanLinesCancelled = entry.value["garbage"]["cleanLinesCancelled"]/entry.value["garbage"]["linesReceived"];
    this.cleanLinesTankedAsCheese = entry.value["garbage"]["cleanLinesTankedAsCheese"]/entry.value["garbage"]["linesReceived"];
    this.cleanLinesTankedAsClean = entry.value["garbage"]["cleanLinesTankedAsClean"]/entry.value["garbage"]["linesReceived"];
    this.deathStats = DeathData.fromJson(entry.value["death"], nick);
    this.killStats = DeathData.fromJson(entry.value["kill"], nick);
    this.upstackPPS = entry.value["placement"]["stackSpeed"]["stacking"]["totalUpdates"]/(entry.value["placement"]["stackSpeed"]["stacking"]["totalFrames"]/60);
    this.downstackPPS = entry.value["placement"]["stackSpeed"]["downstacking"]["totalUpdates"]/(entry.value["placement"]["stackSpeed"]["downstacking"]["totalFrames"]/60);
    this.downstackingRatio = entry.value["placement"]["stackSpeed"]["downstacking"]["totalFrames"]/(entry.value["placement"]["stackSpeed"]["stacking"]["totalFrames"]+entry.value["placement"]["stackSpeed"]["downstacking"]["totalFrames"]);
    }

    MinomuncherData.fromRaw(MinomuncherRaw raw){
      this.nick = raw.nick;
      double secs = raw.placement.frameDelay / 60;
      double mins = secs / 60;
      double attackSecs = raw.placement.openerFrames / 60;
      double attackMins = attackSecs / 60;
      double surgeSecs = raw.surge.frames / 60;
      double surgeMins = surgeSecs / 60;
      int wellSum = raw.placement.wellColumns.reduce((a, b) => a + b);
      this.wellColumns = [for (int i = 0; i <= 9; i++) WellsData(i+1, raw.placement.wellColumns[i]/wellSum)];
      this.clearTypes = raw.placement.clearTypes;
      this.allspinEfficiency = raw.placement.allspins/raw.placement.allPieces;
      this.tEfficiency = (clearTypes.tspinSingle+clearTypes.tspinDouble+clearTypes.tspinTriple)/raw.placement.tPieces;
      this.iEfficiency = clearTypes.quad/raw.placement.iPieces;
      this.cheeseAPL = raw.placement.attackWithCheese/raw.placement.cheeseCleared;
      this.downstackAPL = raw.placement.attackWithDownstack/raw.placement.downstackCleared;
      this.upstackAPL = (raw.placement.attack-raw.placement.attackWithDownstack)/(raw.placement.linesCleared-raw.placement.downstackCleared);
      this.APL = raw.placement.attack/raw.placement.linesCleared;
      this.APP = raw.placement.attack/raw.placement.pieces;
      this.KPP = raw.placement.keypresses/raw.placement.pieces;
      this.KPS = raw.placement.keypresses/secs;
      this.APM = raw.placement.attack/mins;
      this.PPS = raw.placement.pieces/secs;
      int ppsSegmentSum = raw.placement.ppsSegments.reduce((accumulator, currentValue) => accumulator + currentValue);
      this.ppsSegments = raw.placement.ppsSegments.map<double>((x) => x / ppsSegmentSum).toList();
      List<double> huhPPSSegments = [];
      for (int i = 0; i < raw.placement.ppsSegments.length; i++) {
        double PPS = i / 10;
        for (int j = 0; j < raw.placement.ppsSegments[i]; j++)  huhPPSSegments.add(PPS);
      }
      List<double> me = means(huhPPSSegments);
      this.BurstPPS = me.reduce(max);
      this.PlonkPPS = me.reduce(min);
      this.PPSCoeff = getVariance(huhPPSSegments, PPS);
      this.midgameAPM = (raw.placement.attack - raw.placement.openerAttack) / (mins - attackMins);
      this.midgamePPS = (raw.placement.pieces - raw.placement.openerBlocks) / (secs - attackSecs);
      this.openerAPM = raw.placement.openerAttack/attackMins;
      this.openerPPS = raw.placement.openerBlocks/attackSecs;
      this.attackCheesiness = sigmoid(raw.placement.cheeseScore / raw.placement.linesSent);
      this.surgeAPM = raw.surge.attack / surgeMins;
      this.surgeAPL = raw.surge.attack / raw.surge.linesCleared;
      this.surgeDS = raw.surge.garbageCleared / raw.surge.chains;
      this.surgePPS = raw.surge.pieces / surgeSecs;
      this.surgeLength = raw.surge.btb / raw.surge.chains;
      this.surgeRate = raw.surge.chains / (raw.surge.chains + raw.surge.fails);
      this.surgeSecsPerCheese = raw.surge.framesWithSurgeCheese / 60 / raw.surge.surgeCheeseCleared;
      this.surgeSecsPerDS = raw.surge.framesWithSurgeGarbage / 60 / raw.surge.surgeGarbageCleared;
      this.surgeAllspin = raw.surge.allspins / raw.surge.btbClears;
      this.cleanLinesRecieved = raw.garbage.cleanLinesRecieved / raw.garbage.linesReceived;
      this.cheeseLinesRecieved = raw.garbage.cheeseLinesRecieved / raw.garbage.linesReceived;
      this.cheeseLinesCancelled = raw.garbage.cheeseLinesCancelled / raw.garbage.linesReceived;
      this.cheeseLinesTanked = raw.garbage.cheeseLinesTanked / raw.garbage.linesReceived;
      this.cleanLinesCancelled = raw.garbage.cleanLinesCancelled / raw.garbage.linesReceived;
      this.cleanLinesTankedAsCheese = raw.garbage.cleanLinesTankedAsCheese / raw.garbage.linesReceived;
      this.cleanLinesTankedAsClean = raw.garbage.cleanLinesTankedAsClean / raw.garbage.linesReceived;
      this.deathStats = raw.death;
      this.killStats = raw.kill;
      this.upstackPPS = raw.placement.stackingTotalUpdates / (raw.placement.stackingTotalFrames / 60);
      this.downstackPPS = raw.placement.downstackingTotalUpdates / (raw.placement.downstackingTotalFrames / 60);
      this.downstackingRatio = raw.placement.downstackingTotalFrames / (raw.placement.downstackingTotalFrames + raw.placement.stackingTotalFrames);
    }
}

class ClearsChartData {
	final String nick;
	final int perfectClear;
	final int allspin;
	final int single;
	final int tspinSingle;
	final int double;
	final int tspinDouble;
	final int triple;
	final int tspinTriple;
	final int quad;
	const ClearsChartData(this.nick, this.perfectClear, this.allspin, this.single, this.tspinSingle, this.double, this.tspinDouble, this.triple, this.tspinTriple, this.quad);

	int get total => perfectClear + allspin + single + tspinSingle + double + tspinDouble + triple + tspinTriple + quad;
  List<int> get byID => [
    perfectClear,
    allspin,
    tspinTriple,
    tspinDouble,
    tspinSingle,
    quad,
    triple,
    double,
    single
  ];

  ClearsChartData operator+(ClearsChartData other){
    return ClearsChartData(nick, perfectClear+other.perfectClear, allspin+other.allspin, single+other.single, tspinSingle+other.tspinSingle, double+other.double, tspinDouble+other.tspinDouble, triple+other.triple, tspinTriple+other.tspinTriple, quad+other.quad);
  }
}

class DeathData{
  late final String nick;
  late final int surgeConflict;
  late final int surgeSpike;
  late final int cheeseSpike;
  late final int spike;
  late final int cheesePressure;
  late final int pressure;
  DeathData(this.nick, this.surgeConflict, this.surgeSpike, this.cheeseSpike, this.spike, this.cheesePressure, this.pressure);

  DeathData.fromJson(Map<String, dynamic> json, String nickname){
    this.nick = nickname;
    this.surgeConflict = json["Surge Conflict"];
    this.surgeSpike = json["Surge Spike"];
    this.cheeseSpike = json["Cheese Spike"];
    this.spike = json["Spike"];
    this.cheesePressure = json["Cheese Pressure"];
    this.pressure = json["Pressure"];
  }

  List<int> get values => [
    this.surgeConflict,
    this.surgeSpike,
    this.cheeseSpike,
    this.spike,
    this.cheesePressure,
    this.pressure
  ];

  DeathData operator+(DeathData other){
    return DeathData(nick, surgeConflict+other.surgeConflict, surgeSpike+other.surgeSpike, cheeseSpike+other.cheeseSpike, spike+other.spike, cheesePressure+other.cheesePressure, pressure+other.pressure);
  }
}

List<String> get killsLabels => [
  "Surge Conflict",
  "Surge Spike",
  "Cheese Spike",
  "Spike",
  "Cheese Pressure",
  "Pressure"
];

List<String> get graphClearName => [
		t.stats.pcs,
		"All Spins",
    "${t.stats.tSpin} ${t.stats.lineClears.triple}",
    "${t.stats.tSpin} ${t.stats.lineClears.double}",
    "${t.stats.tSpin} ${t.stats.lineClears.single}",
    t.stats.lineClears.quad,
    t.stats.lineClears.triple,
		t.stats.lineClears.double,
		t.stats.lineClears.single,
	];

class WellsData{
	final int well;
	final double value;

	const WellsData(this.well, this.value);
}