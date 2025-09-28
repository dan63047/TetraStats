import 'dart:math';

import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/utils/gaussian_mixture.dart';

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
  late final String id;
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
    id = json.key;
    nick = json.value["username"];
    placement = MPlacement(
      ppsSegments: json.value["stats"]["placement"]["ppsSegments"].cast<int>(),
      wellColumns: json.value["stats"]["placement"]["wellColumns"].cast<int>(),
      clearTypes: ClearsChartData(nick, json.value["stats"]["placement"]["clearTypes"]["perfectClear"], json.value["stats"]["placement"]["clearTypes"]["allspin"], json.value["stats"]["placement"]["clearTypes"]["single"], json.value["stats"]["placement"]["clearTypes"]["tspinSingle"], json.value["stats"]["placement"]["clearTypes"]["double"], json.value["stats"]["placement"]["clearTypes"]["tspinDouble"], json.value["stats"]["placement"]["clearTypes"]["triple"], json.value["stats"]["placement"]["clearTypes"]["tspinTriple"], json.value["stats"]["placement"]["clearTypes"]["quad"]),
      pieces: json.value["stats"]["placement"]["pieces"],
      openerAttack: json.value["stats"]["placement"]["openerAttack"],
      openerFrames: json.value["stats"]["placement"]["openerFrames"].toDouble(),
      openerBlocks: json.value["stats"]["placement"]["openerBlocks"],
      allspins: json.value["stats"]["placement"]["allspins"],
      iPieces: json.value["stats"]["placement"]["iPieces"],
      tPieces: json.value["stats"]["placement"]["tPieces"],
      attack: json.value["stats"]["placement"]["attack"],
      attackSent: json.value["stats"]["placement"]["attacksSent"],
      cleanAttacksSent: json.value["stats"]["placement"]["cleanAttacksSent"],
      linesCleared: json.value["stats"]["placement"]["linesCleared"],
      downstackCleared: json.value["stats"]["placement"]["downstackCleared"],
      attackWithDownstack: json.value["stats"]["placement"]["attackWithDownstack"],
      cleanLinesSent: json.value["stats"]["placement"]["cleanLinesSent"],
      frameDelay: json.value["stats"]["placement"]["frameDelay"].toDouble(),
      cheeseScore: json.value["stats"]["placement"]["cheeseScore"].toDouble(),
      keypresses: json.value["stats"]["placement"]["keypresses"],
      cheeseCleared: json.value["stats"]["placement"]["cheeseCleared"],
      attackWithCheese: json.value["stats"]["placement"]["attackWithCheese"],
      allPieces: json.value["stats"]["placement"]["allPieces"],
      linesSent: json.value["stats"]["placement"]["linesSent"],
      stackingTotalFrames: json.value["stats"]["placement"]["stackSpeed"]["stacking"]["totalFrames"].toDouble(),
      stackingTotalUpdates: json.value["stats"]["placement"]["stackSpeed"]["stacking"]["totalUpdates"],
      downstackingTotalFrames: json.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalFrames"].toDouble(),
      downstackingTotalUpdates: json.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalUpdates"]
    );
    garbage = MGarbage(
      linesReceived: json.value["stats"]["garbage"]["linesReceived"],
      cleanLinesRecieved: json.value["stats"]["garbage"]["cleanLinesRecieved"],
      cheeseLinesRecieved: json.value["stats"]["garbage"]["cheeseLinesRecieved"],
      cheeseLinesCancelled: json.value["stats"]["garbage"]["cheeseLinesCancelled"],
      cheeseLinesTanked: json.value["stats"]["garbage"]["cheeseLinesTanked"],
      cleanLinesCancelled: json.value["stats"]["garbage"]["cleanLinesCancelled"],
      cleanLinesTankedAsCheese: json.value["stats"]["garbage"]["cleanLinesTankedAsCheese"],
      cleanLinesTankedAsClean: json.value["stats"]["garbage"]["cleanLinesTankedAsClean"]
    );
    surge = MSurge(
      chains: json.value["stats"]["surge"]["chains"],
      btb: json.value["stats"]["surge"]["btb"],
      garbageCleared: json.value["stats"]["surge"]["garbageCleared"],
      linesCleared: json.value["stats"]["surge"]["linesCleared"],
      attack: json.value["stats"]["surge"]["attack"],
      frames: json.value["stats"]["surge"]["frames"].toDouble(),
      pieces: json.value["stats"]["surge"]["pieces"],
      fails: json.value["stats"]["surge"]["fails"],
      framesWithSurgeGarbage: json.value["stats"]["surge"]["framesWithSurgeGarbage"].toDouble(),
      surgeGarbageCleared: json.value["stats"]["surge"]["surgeGarbageCleared"],
      framesWithSurgeCheese: json.value["stats"]["surge"]["framesWithSurgeCheese"].toDouble(),
      surgeCheeseCleared: json.value["stats"]["surge"]["surgeCheeseCleared"],
      allspins: json.value["stats"]["surge"]["allspins"],
      btbClears: json.value["stats"]["surge"]["btbClears"]
    );
    death = DeathData.fromJson(json.value["stats"]["death"], nick);
    kill = DeathData.fromJson(json.value["stats"]["kill"], nick);
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

class MinomuncherData {
  late final String id; 
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
    this.id = entry.key;
    this.nick = entry.value["username"];
    this.wellColumns = [for (int i = 0; i <= 9; i++) WellsData(i+1, entry.value["stats"]["placement"]["wellColumns"][i].toDouble())];
    this.clearTypes = ClearsChartData(nick, entry.value["stats"]["placement"]["clearTypes"]["perfectClear"], entry.value["stats"]["placement"]["clearTypes"]["allspin"], entry.value["stats"]["placement"]["clearTypes"]["single"], entry.value["stats"]["placement"]["clearTypes"]["tspinSingle"], entry.value["stats"]["placement"]["clearTypes"]["double"], entry.value["stats"]["placement"]["clearTypes"]["tspinDouble"], entry.value["stats"]["placement"]["clearTypes"]["triple"], entry.value["stats"]["placement"]["clearTypes"]["tspinTriple"], entry.value["stats"]["placement"]["clearTypes"]["quad"]);
    this.allspinEfficiency = entry.value["stats"]["placement"]["allspins"]/entry.value["stats"]["placement"]["allPieces"];
    this.tEfficiency = (clearTypes.tspinSingle+clearTypes.tspinDouble+clearTypes.tspinTriple)/entry.value["stats"]["placement"]["tPieces"];
    this.iEfficiency = clearTypes.quad/entry.value["stats"]["placement"]["iPieces"];
    this.cheeseAPL = entry.value["stats"]["placement"]["attackWithCheese"]/entry.value["stats"]["placement"]["cheeseCleared"];
    this.downstackAPL = entry.value["stats"]["placement"]["attackWithDownstack"]/entry.value["stats"]["placement"]["downstackCleared"];
    this.upstackAPL = (entry.value["stats"]["placement"]["attack"]-entry.value["stats"]["placement"]["attackWithDownstack"])/(entry.value["stats"]["placement"]["linesCleared"]-entry.value["stats"]["placement"]["downstackCleared"]);
    this.APL = entry.value["stats"]["placement"]["attack"]/entry.value["stats"]["placement"]["linesCleared"];
    this.APP = entry.value["stats"]["placement"]["attack"]/entry.value["stats"]["placement"]["pieces"];
    this.KPP = entry.value["stats"]["placement"]["keypresses"]/entry.value["stats"]["placement"]["pieces"];
    this.KPS = entry.value["stats"]["placement"]["keypresses"]/secs;
    this.APM = entry.value["stats"]["placement"]["attack"]/mins;
    this.PPS = entry.value["stats"]["placement"]["pieces"]/secs;
    this.ppsSegments = entry.value["stats"]["placement"]["ppsSegments"].cast<double>();
    final gmm = GMM(3, null, null, null, {'initialize': true});
    gmm.optimize(ppsSegments.where((e) => e != 9.9).toList());
    List<double> me = gmm.means;
    this.BurstPPS = me.reduce(max); //entry.value["BurstPPS"];
    this.PlonkPPS = me.reduce(min); // entry.value["PlonkPPS"];
    this.PPSCoeff = getVariance(entry.value["stats"]["placement"]["ppsSegments"], PPS);
    this.midgameAPM = (entry.value["stats"]["placement"]["attack"] - entry.value["stats"]["placement"]["openerAttack"]) / (mins - attackMins);
    this.midgamePPS = (entry.value["stats"]["placement"]["pieces"] - entry.value["stats"]["placement"]["openerBlocks"]) / (secs - attackSecs);
    this.openerAPM = entry.value["stats"]["placement"]["openerAttack"]/attackMins;
    this.openerPPS = entry.value["stats"]["placement"]["openerBlocks"]/attackSecs;
    this.attackCheesiness = sigmoid(entry.value["stats"]["placement"]["cheeseScore"] / entry.value["stats"]["placement"]["linesSent"]);
    this.surgeAPM = entry.value["stats"]["surge"]["attack"] / surgeMins;
    this.surgeAPL = entry.value["stats"]["surge"]["attack"] / entry.value["stats"]["surge"]["linesCleared"];
    this.surgeDS = entry.value["stats"]["surge"]["garbageCleared"] / entry.value["stats"]["surge"]["chains"];
    this.surgePPS = entry.value["stats"]["surge"]["pieces"] / surgeSecs;
    this.surgeLength = entry.value["stats"]["surge"]["btb"] / entry.value["stats"]["surge"]["chains"];
    this.surgeRate = entry.value["stats"]["surge"]["chains"] / (entry.value["stats"]["surge"]["chains"] + entry.value["stats"]["surge"]["fails"]);
    this.surgeSecsPerCheese = entry.value["stats"]["surge"]["framesWithSurgeCheese"] / 60 / entry.value["stats"]["surge"]["surgeCheeseCleared"];
    this.surgeSecsPerDS = entry.value["stats"]["surge"]["framesWithSurgeGarbage"] / 60 / entry.value["stats"]["surge"]["surgeGarbageCleared"];
    this.surgeAllspin = entry.value["stats"]["surge"]["allspins"] / entry.value["stats"]["surge"]["btbClears"];
    this.cleanLinesRecieved = entry.value["stats"]["garbage"]["cleanLinesRecieved"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cheeseLinesRecieved = entry.value["stats"]["garbage"]["cheeseLinesRecieved"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cheeseLinesCancelled = entry.value["stats"]["garbage"]["cheeseLinesCancelled"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cheeseLinesTanked = entry.value["stats"]["garbage"]["cheeseLinesTanked"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cleanLinesCancelled = entry.value["stats"]["garbage"]["cleanLinesCancelled"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cleanLinesTankedAsCheese = entry.value["stats"]["garbage"]["cleanLinesTankedAsCheese"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.cleanLinesTankedAsClean = entry.value["stats"]["garbage"]["cleanLinesTankedAsClean"]/entry.value["stats"]["garbage"]["linesReceived"];
    this.deathStats = DeathData.fromJson(entry.value["stats"]["death"], nick);
    this.killStats = DeathData.fromJson(entry.value["stats"]["kill"], nick);
    this.upstackPPS = entry.value["stats"]["placement"]["stackSpeed"]["stacking"]["totalUpdates"]/(entry.value["stats"]["placement"]["stackSpeed"]["stacking"]["totalFrames"]/60);
    this.downstackPPS = entry.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalUpdates"]/(entry.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalFrames"]/60);
    this.downstackingRatio = entry.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalFrames"]/(entry.value["stats"]["placement"]["stackSpeed"]["stacking"]["totalFrames"]+entry.value["stats"]["placement"]["stackSpeed"]["downstacking"]["totalFrames"]);
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
      final gmm = GMM(3, null, null, null, {'initialize': true});
      gmm.optimize(huhPPSSegments.where((e) => e != 9.9).toList());
      List<double> me = gmm.means;
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
		t.stats.allSpins,
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