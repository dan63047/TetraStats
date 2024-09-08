import 'package:flutter/material.dart';

const int currentSeason = 2;
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
  Stats.acceTRabs: "+eTR absolute",
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
  'z': Color(0xFF375433)
};

const Map<String, Duration> sprintAverages = {
  // based on https://discord.com/channels/673303546107658242/674421736162197515/1244287342965952562
  'x': Duration(seconds: 25, milliseconds: 144),
  'u': Duration(seconds: 36, milliseconds: 115),
  'ss': Duration(seconds: 46, milliseconds: 396),
  's+': Duration(seconds: 55, milliseconds: 056),
  's': Duration(seconds: 61, milliseconds: 892),
  's-': Duration(seconds: 68, milliseconds: 918),
  'a+': Duration(seconds: 76, milliseconds: 187),
  'a': Duration(seconds: 83, milliseconds: 529),
  'a-': Duration(seconds: 88, milliseconds: 608),
  'b+': Duration(seconds: 97, milliseconds: 626),
  'b': Duration(seconds: 104, milliseconds: 687),
  'b-': Duration(seconds: 113, milliseconds: 372),
  'c+': Duration(seconds: 123, milliseconds: 461),
  'c': Duration(seconds: 135, milliseconds: 326),
  'c-': Duration(seconds: 147, milliseconds: 056),
  'd+': Duration(seconds: 156, milliseconds: 757),
  'd': Duration(seconds: 167, milliseconds: 393),
  //'z': Duration(seconds: 66, milliseconds: 802)
};

const Map<String, int> blitzAverages = {
  'x': 600715,
  'u': 379418,
  'ss': 233740,
  's+': 158295,
  's': 125164,
  's-': 100933,
  'a+': 83593,
  'a': 68613,
  'a-': 60219,
  'b+': 51197,
  'b': 44171,
  'b-': 39045,
  'c+': 34130,
  'c': 28931,
  'c-': 25095,
  'd+': 22944,
  'd': 20728,
  //'z': 72084
};

List<DateTime> seasonStarts = [
  DateTime.utc(2020, DateTime.april, 18, 4), // Source = twitter or something
  DateTime.utc(
      2024, DateTime.august, 16, 18, 41, 10) // Source = osk status page
];

List<DateTime> seasonEnds = [
  DateTime.utc(2024, DateTime.july, 26, 15) // Source - TETR.IO discord guild
];
