import 'package:flutter/material.dart';

const int currentSeason = 2;
final DateTime sprintAndBlitzRelevance = DateTime(2024, 8, 25);
const double noTrRd = 60.9;
const double apmWeight = 1;
const double ppsWeight = 45;
const double vsWeight = 0.444;
const double appWeight = 185;
const double dssWeight = 175;
const double dspWeight = 450;
const double appdspWeight = 140;
const double vsapmWeight = 60;
const double cheeseWeight = 1.25;
const double gbeWeight = 315;

const Map<int, double> xpTableScuffed = { // level: xp required
  05000:    67009018.4885772,
  10000:   763653437.386,
  15000:  2337651144.54149,
  20000:  4572735210.50902,
  25000:  7376166347.04745,
  30000: 10693620096.2168,
  40000: 18728882739.482,
  50000: 28468683855.2853
};

const List<String> ranks = [
  "d",
  "d+",
  "c-",
  "c",
  "c+",
  "b-",
  "b",
  "b+",
  "a-",
  "a",
  "a+",
  "s-",
  "s",
  "s+",
  "ss",
  "u",
  "x",
  "x+"
];
const List<String> ranks2 = [
  "top1",
  "x+",
  "x",
  "u",
  "ss",
  "s+",
  "s",
  "s-",
  "a+",
  "a",
  "a-",
  "b+",
  "b",
  "b-",
  "c+",
  "c",
  "c-",
  "d+",
  "d"
];
const Map<String, double> rankCutoffs = {
  "x+": 0.002,
  "x": 0.01,
  "u": 0.05,
  "ss": 0.11,
  "s+": 0.17,
  "s": 0.23,
  "s-": 0.3,
  "a+": 0.38,
  "a": 0.46,
  "a-": 0.54,
  "b+": 0.62,
  "b": 0.7,
  "b-": 0.78,
  "c+": 0.84,
  "c": 0.9,
  "c-": 0.95,
  "d+": 0.975,
  "d": 1,
  "z": -1,
  "": 0.5
};
const Map<String, double> rankTargets = {
  "x+": 24000.00,
  "x": 22500.00,
  "u": 20000.00,
  "ss": 18000.00,
  "s+": 16500.00,
  "s": 15200.00,
  "s-": 13800.00,
  "a+": 12000.00,
  "a": 10500.00,
  "a-": 9000.00,
  "b+": 7400.00,
  "b": 5700.00,
  "b-": 4200.00,
  "c+": 3000.00,
  "c": 2000.00,
  "c-": 1300.00,
  "d+": 800.00,
  "d": 0.00,
};

// DateTime seasonStart = DateTime.utc(2024, 08, 16, 18);
//DateTime seasonEnd = DateTime.utc(2024, 07, 26, 15);
enum Stats {
  tr,
  glicko,
  gxe,
  s1tr,
  rd,
  gp,
  gw,
  wr,
  apm,
  pps,
  vs,
  app,
  dss,
  dsp,
  appdsp,
  vsapm,
  cheese,
  gbe,
  nyaapp,
  area,
  eTR,
  acceTR,
  acceTRabs,
  opener,
  plonk,
  infDS,
  stride,
  stridemMinusPlonk,
  openerMinusInfDS
}

const Map<Stats, String> chartsShortTitles = {
  Stats.tr: "TR",
  Stats.gxe: "Glixare",
  Stats.s1tr: "S1 TR",
  Stats.glicko: "Glicko",
  Stats.rd: "RD",
  Stats.gp: "GP",
  Stats.gw: "GW",
  Stats.wr: "WR%",
  Stats.apm: "APM",
  Stats.pps: "PPS",
  Stats.vs: "VS",
  Stats.app: "APP",
  Stats.dss: "DS/S",
  Stats.dsp: "DS/P",
  Stats.appdsp: "APP + DS/P",
  Stats.vsapm: "VS/APM",
  Stats.cheese: "Cheese",
  Stats.gbe: "GbE",
  Stats.nyaapp: "wAPP",
  Stats.area: "Area",
  Stats.eTR: "eTR",
  Stats.acceTR: "±eTR",
  Stats.acceTRabs: "±eTR absolute",
  Stats.opener: "Opener",
  Stats.plonk: "Plonk",
  Stats.infDS: "Inf. DS",
  Stats.stride: "Stride",
  Stats.stridemMinusPlonk: "Stride - Plonk",
  Stats.openerMinusInfDS: "Opener - Inf. DS"
};

const Map<String, Color> rankColors = {
  // thanks osk for const rankColors at https://ch.tetr.io/res/js/base.js:458
  'x+': Color(0xFF643C8D),
  'x': Color(0xFFFF45FF),
  'u': Color(0xFFFF3813),
  'ss': Color(0xFFDB8B1F),
  's+': Color(0xFFD8AF0E),
  's': Color(0xFFE0A71B),
  's-': Color(0xFFB2972B),
  'a+': Color(0xFF1FA834),
  'a': Color(0xFF46AD51),
  'a-': Color(0xFF3BB687),
  'b+': Color(0xFF4F99C0),
  'b': Color(0xFF4F64C9),
  'b-': Color(0xFF5650C7),
  'c+': Color(0xFF552883),
  'c': Color(0xFF733E8F),
  'c-': Color(0xFF79558C),
  'd+': Color(0xFF8E6091),
  'd': Color(0xFF907591),
  'z': Color(0xFF375433),
  'top1': Colors.yellowAccent
};

const List<Color> achievementColors = [
  Colors.grey,
  Color(0xFFB38070), // bronze
  Color(0xFF7E9EA7), // silver
  Color(0xFFE2A042), // gold
  Color(0xFF70D0A3), // platinum
  Color(0xFFD590FF), // diamond
  Colors.white,
];

const Map<String, Duration> sprintAverages = {
  // based on https://discord.com/channels/673303546107658242/674421736162197515/1277367281264889908
  'x+': Duration(seconds: 18, milliseconds: 867),
  'x': Duration(seconds: 23, milliseconds: 277),
  'u': Duration(seconds: 28, milliseconds: 853),
  'ss': Duration(seconds: 35, milliseconds: 173),
  's+': Duration(seconds: 39, milliseconds: 028),
  's': Duration(seconds: 45, milliseconds: 807),
  's-': Duration(seconds: 48, milliseconds: 840),
  'a+': Duration(seconds: 54, milliseconds: 975),
  'a': Duration(seconds: 60, milliseconds: 287),
  'a-': Duration(seconds: 64, milliseconds: 019),
  'b+': Duration(seconds: 76, milliseconds: 531),
  'b': Duration(seconds: 77, milliseconds: 635),
  'b-': Duration(seconds: 92, milliseconds: 279),
  'c+': Duration(seconds: 97, milliseconds: 911),
  'c': Duration(seconds: 104, milliseconds: 700),
  'c-': Duration(seconds: 115, milliseconds: 173),
  'd+': Duration(seconds: 131, milliseconds: 486),
  'd': Duration(seconds: 158, milliseconds: 397),
};

const Map<String, int> blitzAverages = {
  'x+': 879378,
  'x': 677479,
  'u': 485962,
  'ss': 369043,
  's+': 279242,
  's': 245619,
  's-': 199368,
  'a+': 162035,
  'a': 130949,
  'a-': 111505,
  'b+': 97251,
  'b': 83580,
  'b-': 70511,
  'c+': 56747,
  'c': 43002,
  'c-': 38925,
  'd+': 30483,
  'd': 22513,
};

List<DateTime> seasonStarts = [
  DateTime.utc(2020, DateTime.april, 18, 4), // Source = twitter or something
  DateTime.utc(2024, DateTime.august, 16, 18, 41, 10) // Source = osk status page
];

List<DateTime> seasonEnds = [
  DateTime.utc(2024, DateTime.july, 26, 15) // Source - TETR.IO discord guild
];

/// Stolen directly from TETR.IO, redone for the sake of me

const List<String> clearNames = ["Zero", "Single", "Double", "Triple", "Quad", "Penta", "Hexa", "Hepta", "Octa", "Ennea", "Deca", "Hendeca", "Dodeca", "Triadeca", "Tessaradeca", "Pentedeca", "Hexadeca", "Heptadeca", "Octadeca", "Enneadeca", "Eicosa", "Kagaris"];

enum Lineclears{
  ZERO,
  SINGLE,
  DOUBLE,
  TRIPLE,
  QUAD,
  PENTA,
  TSPIN_MINI,
  TSPIN,
  TSPIN_MINI_SINGLE,
  TSPIN_SINGLE,
  TSPIN_MINI_DOUBLE,
  TSPIN_DOUBLE,
  TSPIN_MINI_TRIPLE,
  TSPIN_TRIPLE,
  TSPIN_MINI_QUAD,
  TSPIN_QUAD,
  TSPIN_PENTA,
}

enum ComboTables{
  none,
  classic,
  modern,
  multiplier
}

Map<ComboTables, String> comboTablesNames = {
  ComboTables.none: "None",
  ComboTables.classic: "Classic",
  ComboTables.modern: "Modern",
  ComboTables.multiplier: "Multiplier"
};

const int BACKTOBACK_BONUS = 1;
const double BACKTOBACK_BONUS_LOG = .8;
const int COMBO_MINIFIER = 1;
const double COMBO_MINIFIER_LOG = 1.25;
const double COMBO_BONUS = .25;
// const int ALL_CLEAR = 10; lol

const Map<Lineclears, int> garbage = {
  Lineclears.SINGLE: 0,
  Lineclears.DOUBLE: 1,
  Lineclears.TRIPLE: 2,
  Lineclears.QUAD: 4,
  Lineclears.PENTA: 5,
  Lineclears.TSPIN_MINI: 0,
  Lineclears.TSPIN: 0,
  Lineclears.TSPIN_MINI_SINGLE: 0,
  Lineclears.TSPIN_SINGLE: 2,
  Lineclears.TSPIN_MINI_DOUBLE: 1,
  Lineclears.TSPIN_DOUBLE: 4,
  Lineclears.TSPIN_MINI_TRIPLE: 2,
  Lineclears.TSPIN_TRIPLE: 6,
  Lineclears.TSPIN_MINI_QUAD: 4,
  Lineclears.TSPIN_QUAD: 10,
  Lineclears.TSPIN_PENTA: 12
};

const Map<ComboTables, List<int>> combotable = {
    ComboTables.none: [0],
    ComboTables.classic: [0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5],
    ComboTables.modern: [0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4]
};