// ignore_for_file: hash_and_equals

class Clears {
  late int singles;
  late int doubles;
  late int triples;
  late int quads;
  late int pentas;
  late int allClears;
  late int tSpinZeros;
  late int tSpinSingles;
  late int tSpinDoubles;
  late int tSpinTriples;
  late int tSpinQuads;
  late int tSpinPentas;
  late int tSpinMiniZeros;
  late int tSpinMiniSingles;
  late int tSpinMiniDoubles;
  late int tSpinMiniTriples;
  late int tSpinMiniQuads;

  Clears(
      {required this.singles,
      required this.doubles,
      required this.triples,
      required this.quads,
      required this.pentas,
      required this.allClears,
      required this.tSpinZeros,
      required this.tSpinSingles,
      required this.tSpinDoubles,
      required this.tSpinTriples,
      required this.tSpinPentas,
      required this.tSpinQuads,
      required this.tSpinMiniZeros,
      required this.tSpinMiniSingles,
      required this.tSpinMiniDoubles,
      required this.tSpinMiniTriples,
      required this.tSpinMiniQuads});

  Clears.fromJson(Map<String, dynamic> json) {
    singles = json['singles'];
    doubles = json['doubles'];
    triples = json['triples'];
    quads = json['quads'];
    pentas = json['pentas']??0;
    tSpinZeros = json['realtspins'];
    tSpinMiniZeros = json['minitspins'];
    tSpinMiniSingles = json['minitspinsingles'];
    tSpinSingles = json['tspinsingles'];
    tSpinMiniDoubles = json['minitspindoubles'];
    tSpinDoubles = json['tspindoubles'];
    tSpinMiniTriples = json['minitspintriples']??0;
    tSpinTriples = json['tspintriples'];
    tSpinMiniQuads = json['minitspinquads']??0;
    tSpinQuads = json['tspinquads'];
    tSpinPentas = json['tspinpentas']??0;
    allClears = json['allclear'];
  }

  Clears operator + (Clears other){
    return Clears(
      singles: singles + other.singles,
      doubles: doubles + other.doubles,
      triples: triples + other.triples,
      quads: quads + other.quads,
      pentas: pentas + other.pentas,
      allClears: allClears + other.allClears,
      tSpinZeros: tSpinZeros + other.tSpinZeros,
      tSpinSingles: tSpinSingles + other.tSpinSingles,
      tSpinDoubles: tSpinDoubles + other.tSpinDoubles,
      tSpinTriples: tSpinTriples + other.tSpinTriples,
      tSpinPentas: tSpinPentas + other.tSpinPentas,
      tSpinQuads: tSpinQuads + other.tSpinQuads,
      tSpinMiniZeros: tSpinMiniZeros + other.tSpinMiniZeros,
      tSpinMiniSingles: tSpinMiniSingles + other.tSpinMiniSingles,
      tSpinMiniDoubles: tSpinMiniDoubles + other.tSpinMiniDoubles,
      tSpinMiniTriples: tSpinMiniTriples + other.tSpinMiniTriples,
      tSpinMiniQuads: tSpinMiniQuads + other.tSpinMiniQuads
      );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['singles'] = singles;
    data['doubles'] = doubles;
    data['triples'] = triples;
    data['quads'] = quads;
    data['pentas'] = pentas;
    data['realtspins'] = tSpinZeros;
    data['minitspins'] = tSpinMiniZeros;
    data['minitspinsingles'] = tSpinMiniSingles;
    data['tspinsingles'] = tSpinSingles;
    data['minitspindoubles'] = tSpinMiniDoubles;
    data['tspindoubles'] = tSpinDoubles;
    data['tspintriples'] = tSpinTriples;
    data['tspinquads'] = tSpinQuads;
    data['tspinpentas'] = tSpinPentas;
    data['allclear'] = allClears;
    return data;
  }
}
