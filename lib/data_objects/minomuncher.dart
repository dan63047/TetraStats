import 'package:tetra_stats/gen/strings.g.dart';

class MinomuncherData {
  late String nick;
  late List<WellsData> wellColumns;
  late ClearsChartData clearTypes;
  late double allspinEfficiency;
  late double tEfficiency;
  late double iEfficiency;
  late double cheeseAPL;
  late double downstackAPL;
  late double upstackAPL;
  late double APL;
  late double APP;
  late double KPP;
  late double KPS;
  late double APM;
  late double PPS;
  late double midgameAPM;
  late double midgamePPS;
  late double openerAPM;
  late double openerPPS;
  late double attackCheesiness;
  late double surgeAPM;
  late double surgeAPL;
  late double surgeDS;
  late double surgePPS;
  late double surgeLength;
  late double surgeRate;
  late double? surgeSecsPerCheese;
  late double? surgeSecsPerDS;
  late double surgeAllspin;
  late double cleanLinesRecieved;
  late double cheeseLinesRecieved;
  late double cheeseLinesCancelled;
  late double cheeseLinesTanked;
  late double cleanLinesCancelled;
  late double cleanLinesTankedAsCheese;
  late double cleanLinesTankedAsClean;

  MinomuncherData.fromJson(MapEntry<String, Map<dynamic, dynamic>> entry){
    this.nick = entry.key;
    int columnsSum = entry.value["wellColumns"].reduce((a, b) => (a as int) + (b as int));
    this.wellColumns = [for (int i = 0; i <= 9; i++) WellsData(i+1, entry.value["wellColumns"][i], entry.value["wellColumns"][i]/columnsSum)];
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
	ClearsChartData(this.nick, this.perfectClear, this.allspin, this.single, this.tspinSingle, this.double, this.tspinDouble, this.triple, this.tspinTriple, this.quad);

	get total => perfectClear + allspin + single + tspinSingle + double + tspinDouble + triple + tspinTriple + quad;
  get byID => [
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
	get clearName => [
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
}

class WellsData{
	int well;
  int number;
	double value;

	WellsData(this.well, this.number, this.value);
}