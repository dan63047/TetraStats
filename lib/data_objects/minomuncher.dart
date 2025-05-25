import 'package:tetra_stats/gen/strings.g.dart';

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
  late final List<num> ppsSegments;
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

  MinomuncherData.fromJson(MapEntry<String, Map<dynamic, dynamic>> entry){
    this.nick = entry.key;
    this.wellColumns = [for (int i = 0; i <= 9; i++) WellsData(i+1, entry.value["wellColumns"][i])];
    this.clearTypes = ClearsChartData(nick, entry.value["clearTypes"]["perfectClear"], entry.value["clearTypes"]["allspin"], entry.value["clearTypes"]["single"], entry.value["clearTypes"]["tspinSingle"], entry.value["clearTypes"]["double"], entry.value["clearTypes"]["tspinDouble"], entry.value["clearTypes"]["triple"], entry.value["clearTypes"]["tspinTriple"], entry.value["clearTypes"]["quad"]);
    this.allspinEfficiency = entry.value["allspinEfficiency"];
    this.tEfficiency = entry.value["tEfficiency"];
    this.iEfficiency = entry.value["iEfficiency"];
    this.cheeseAPL = entry.value["cheeseAPL"];
    this.downstackAPL = entry.value["downstackAPL"];
    this.upstackAPL = entry.value["upstackAPL"];
    this.APL = entry.value["APL"];
    this.APP = entry.value["APP"];
    this.KPP = entry.value["KPP"];
    this.KPS = entry.value["KPS"];
    this.APM = entry.value["APM"];
    this.PPS = entry.value["PPS"];
    this.ppsSegments = entry.value["ppsSegments"];
    this.BurstPPS = entry.value["BurstPPS"];
    this.PlonkPPS = entry.value["PlonkPPS"];
    this.PPSCoeff = entry.value["PPSCoeff"];
    this.midgameAPM = entry.value["midgameAPM"];
    this.midgamePPS = entry.value["midgamePPS"];
    this.openerAPM = entry.value["openerAPM"];
    this.openerPPS = entry.value["openerPPS"];
    this.attackCheesiness = entry.value["attackCheesiness"];
    this.surgeAPM = entry.value["surgeAPM"];
    this.surgeAPL = entry.value["surgeAPL"];
    this.surgeDS = entry.value["surgeDS"].toDouble();
    this.surgePPS = entry.value["surgePPS"];
    this.surgeLength = entry.value["surgeLength"];
    this.surgeRate = entry.value["surgeRate"];
    this.surgeSecsPerCheese = entry.value["surgeSecsPerCheese"];
    this.surgeSecsPerDS = entry.value["surgeSecsPerDS"];
    this.surgeAllspin = entry.value["surgeAllspin"]?.toDouble();
    this.cleanLinesRecieved = entry.value["cleanLinesRecieved"]?.toDouble();
    this.cheeseLinesRecieved = entry.value["cheeseLinesRecieved"]?.toDouble();
    this.cheeseLinesCancelled = entry.value["cheeseLinesCancelled"]?.toDouble();
    this.cheeseLinesTanked = entry.value["cheeseLinesTanked"]?.toDouble();
    this.cleanLinesCancelled = entry.value["cleanLinesCancelled"]?.toDouble();
    this.cleanLinesTankedAsCheese = entry.value["cleanLinesTankedAsCheese"]?.toDouble();
    this.cleanLinesTankedAsClean = entry.value["cleanLinesTankedAsClean"]?.toDouble();
    this.deathStats = DeathData.fromJson(entry.value["deathStats"], nick);
    this.killStats = DeathData.fromJson(entry.value["killStats"], nick);
    this.upstackPPS = entry.value["PPS"];
    this.downstackPPS = entry.value["PPS"];
    this.downstackingRatio = entry.value["PPS"];
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
    single,
    tspinSingle,
    double,
    tspinDouble,
    triple,
    tspinTriple,
    quad,
  ];
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
		t.stats.lineClears.single,
		"${t.stats.tSpin} ${t.stats.lineClears.single}",
		t.stats.lineClears.double,
		"${t.stats.tSpin} ${t.stats.lineClears.double}",
		t.stats.lineClears.triple,
		"${t.stats.tSpin} ${t.stats.lineClears.triple}",
		t.stats.lineClears.quad,
		//"${t.stats.tSpin} ${t.stats.lineClears.quad}"
	];

class WellsData{
	final int well;
	final double value;

	const WellsData(this.well, this.value);
}