// ignore_for_file: hash_and_equals

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:vector_math/vector_math.dart';

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
  "d", "d+", "c-", "c", "c+", "b-", "b", "b+", "a-", "a", "a+", "s-", "s", "s+", "ss", "u", "x"
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
// const Map<String, double> rankTargets = {
//   "x": 24503.75, // where that comes from?
//   "u": 23038,
//   "ss": 21583,
//   "s+": 20128,
//   "s": 18673,
//   "s-": 16975,
//   "a+": 15035,
//   "a": 13095,
//   "a-": 11155,
//   "b+": 9215,
//   "b": 7275,
//   "b-": 5335,
//   "c+": 3880,
//   "c": 2425,
//   "c-": 1213,
//   "d+": 606,
//   "d": 0,
// };
// DateTime seasonStart = DateTime.utc(2024, 08, 16, 18);
//DateTime seasonEnd = DateTime.utc(2024, 07, 26, 15);
enum Stats {
  tr,
  glicko,
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

const Map<String, Color> rankColors = { // thanks osk for const rankColors at https://ch.tetr.io/res/js/base.js:458
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

const Map<String, Duration> sprintAverages = { // based on https://discord.com/channels/673303546107658242/674421736162197515/1244287342965952562
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

String getStatNameByEnum(Stats stat){
  return t[stat.name];
}

Duration doubleSecondsToDuration(double value) {
  value = value * 1000000;
  return Duration(microseconds: value.floor());
}

Duration doubleMillisecondsToDuration(double value) {
  value = value * 1000;
  return Duration(microseconds: value.floor());
}

class TetrioPlayer {
  late String userId;
  late String username;
  late DateTime state;
  late String role;
  int? avatarRevision;
  int? bannerRevision;
  DateTime? registrationTime;
  List<Badge> badges = [];
  String? bio;
  String? country;
  late int friendCount;
  late int gamesPlayed;
  late int gamesWon;
  late Duration gameTime;
  late double xp;
  late int supporterTier;
  late bool verified;
  bool? badstanding;
  String? botmaster;
  Connections? connections;
  TetraLeague? tlSeason1;
  TetrioZen? zen;
  Distinguishment? distinguishment;
  DateTime? cachedUntil;

  TetrioPlayer({
    required this.userId,
    required this.username,
    required this.role,
    required this.state,
    this.avatarRevision,
    this.bannerRevision,
    this.registrationTime,
    required this.badges,
    this.bio,
    this.country,
    required this.friendCount,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.gameTime,
    required this.xp,
    required this.supporterTier,
    required this.verified,
    this.badstanding,
    this.botmaster,
    required this.connections,
    required this.tlSeason1,
    this.zen,
    this.distinguishment,
    this.cachedUntil
  });

  double get level => pow((xp / 500), 0.6) + (xp / (5000 + (max(0, xp - 4 * pow(10, 6)) / 5000))) + 1;

  TetrioPlayer.fromJson(Map<String, dynamic> json, DateTime stateTime, String id, String nick, [DateTime? cUntil]) {
    //developer.log("TetrioPlayer.fromJson $stateTime: $json", name: "data_objects/tetrio");
    userId = id;
    username = nick;
    state = stateTime;
    role = json['role'];
    registrationTime = json['ts'] != null ? DateTime.parse(json['ts']) : null;
    if (json['badges'] != null) {
      json['badges'].forEach((v) {
        badges.add(Badge.fromJson(v));
      });
    }
    xp = json['xp'] != null ? json['xp'].toDouble() : -1;
    gamesPlayed = json['gamesplayed'] ?? -1;
    gamesWon = json['gameswon'] ?? -1;
    gameTime = json['gametime'] != null && json['gametime'] != -1 ? doubleSecondsToDuration(json['gametime'].toDouble()) : const Duration(seconds: -1);
    country = json['country'];
    supporterTier = json['supporter_tier'] ?? 0;
    verified = json['verified'] ?? false;
    tlSeason1 = json['league'] != null ? TetraLeague.fromJson(json['league'], stateTime) : null;
    avatarRevision = json['avatar_revision'];
    bannerRevision = json['banner_revision'];
    bio = json['bio'];
    if (json['connections'] != null && json['connections'].isNotEmpty) connections = Connections.fromJson(json['connections']);
    distinguishment = json['distinguishment'] != null ? Distinguishment.fromJson(json['distinguishment']) : null;
    friendCount = json['friend_count'] ?? 0;
    badstanding = json['badstanding'];
    botmaster = json['botmaster'];
    cachedUntil = cUntil;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['_id'] = userId;
    // data['username'] = username;
    data['role'] = role;
    if (registrationTime != null) data['ts'] = registrationTime?.toString();
    if (badges.isNotEmpty) data['badges'] = badges.map((v) => v.toJson()).toList();
    if (xp >= 0) data['xp'] = xp;
    if (gamesPlayed >= 0) data['gamesplayed'] = gamesPlayed;
    if (gamesWon >= 0) data['gameswon'] = gamesWon;
    if (!gameTime.isNegative) data['gametime'] = gameTime.inMicroseconds / 1000000;
    if (country != null) data['country'] = country;
    if (supporterTier > 0) data['supporter_tier'] = supporterTier;
    if (verified) data['verified'] = verified;
    data['league'] = tlSeason1?.toJson();
    if (distinguishment != null) data['distinguishment'] = distinguishment?.toJson();
    if (avatarRevision != null) data['avatar_revision'] = avatarRevision;
    if (bannerRevision != null) data['banner_revision'] = bannerRevision;
    if (bio != null) data['bio'] = bio;
    if (connections != null) data['connections'] = connections!.toJson();
    if (friendCount > 0) data['friend_count'] = friendCount;
    if (badstanding != null) data['badstanding'] = badstanding;
    if (botmaster != null) data['botmaster'] = botmaster;
    //developer.log("TetrioPlayer.toJson: $data", name: "data_objects/tetrio");
    return data;
  }

  bool isSameState(covariant TetrioPlayer other) {
    if (userId != other.userId) return false;
    if (username != other.username) return false;
    if (role != other.role) return false;
    if (listEquals(badges, other.badges) == false) return false;
    //if (bio != other.bio) return false;
    if (country != other.country) return false;
    if (friendCount != other.friendCount) return false;
    if (gamesPlayed != other.gamesPlayed) return false;
    if (gamesWon != other.gamesWon) return false;
    if (gameTime != other.gameTime) return false;
    if (xp != other.xp) return false;
    if (supporterTier != other.supporterTier) return false;
    if (verified != other.verified) return false;
    if (badstanding != other.badstanding) return false;
    if (botmaster != other.botmaster) return false;
    if (connections != other.connections) return false;
    if (tlSeason1 != other.tlSeason1) return false;
    if (distinguishment != other.distinguishment) return false;
    return true;
  }

  bool checkForRetrivedHistory(covariant TetrioPlayer other) {
    return tlSeason1!.lessStrictCheck(other.tlSeason1!);
  }

  TetrioPlayerFromLeaderboard convertToPlayerFromLeaderboard() => TetrioPlayerFromLeaderboard(
    userId, username, role, xp, country, state, gamesPlayed, gamesWon,
    tlSeason1!.tr, tlSeason1!.glicko??0, tlSeason1!.rd??noTrRd, tlSeason1!.rank, tlSeason1!.bestRank, tlSeason1!.apm??0, tlSeason1!.pps??0, tlSeason1!.vs??0, tlSeason1!.decaying);

  @override
  String toString() {
    return "$username ($state)";
  }

  num? getStatByEnum(Stats stat){
    switch (stat) {
      case Stats.tr:
        return tlSeason1?.tr;
      case Stats.glicko:
        return tlSeason1?.glicko;
      case Stats.rd:
        return tlSeason1?.rd;
      case Stats.gp:
        return tlSeason1?.gamesPlayed;
      case Stats.gw:
        return tlSeason1?.gamesWon;
      case Stats.wr:
        return tlSeason1?.winrate;
      case Stats.apm:
        return tlSeason1?.apm;
      case Stats.pps:
        return tlSeason1?.pps;
      case Stats.vs:
        return tlSeason1?.vs;
      case Stats.app:
        return tlSeason1?.nerdStats?.app;
      case Stats.dss:
        return tlSeason1?.nerdStats?.dss;
      case Stats.dsp:
        return tlSeason1?.nerdStats?.dsp;
      case Stats.appdsp:
        return tlSeason1?.nerdStats?.appdsp;
      case Stats.vsapm:
        return tlSeason1?.nerdStats?.vsapm;
      case Stats.cheese:
        return tlSeason1?.nerdStats?.cheese;
      case Stats.gbe:
        return tlSeason1?.nerdStats?.gbe;
      case Stats.nyaapp:
        return tlSeason1?.nerdStats?.nyaapp;
      case Stats.area:
        return tlSeason1?.nerdStats?.area;
      case Stats.eTR:
        return tlSeason1?.estTr?.esttr;
      case Stats.acceTR:
        return tlSeason1?.esttracc;
      case Stats.acceTRabs:
        return tlSeason1?.esttracc?.abs();
      case Stats.opener:
        return tlSeason1?.playstyle?.opener;
      case Stats.plonk:
        return tlSeason1?.playstyle?.plonk;
      case Stats.infDS:
        return tlSeason1?.playstyle?.infds;
      case Stats.stride:
        return tlSeason1?.playstyle?.stride;
      case Stats.stridemMinusPlonk:
        return tlSeason1?.playstyle != null ? tlSeason1!.playstyle!.stride - tlSeason1!.playstyle!.plonk : null;
      case Stats.openerMinusInfDS:
        return tlSeason1?.playstyle != null ? tlSeason1!.playstyle!.opener - tlSeason1!.playstyle!.infds : null;
    }
  }

  @override
  int get hashCode => state.hashCode;

  @override
  bool operator ==(covariant TetrioPlayer other) => isSameState(other) && state.isAtSameMomentAs(other.state);
}

class Summaries{
  late String id;
  RecordSingle? sprint;
  RecordSingle? blitz;
  RecordSingle? zenith;
  RecordSingle? zenithEx;
  late List<Achievement> achievements;
  late TetraLeague league;
  late TetrioZen zen;

  Summaries(this.id, this.league, this.zen);

  Summaries.fromJson(Map<String, dynamic> json, String i){
    id = i;
    if (json['40l']['record'] != null) sprint = RecordSingle.fromJson(json['40l']['record'], json['40l']['rank'], json['40l']['rank_local']);
    if (json['blitz']['record'] != null) blitz = RecordSingle.fromJson(json['blitz']['record'], json['blitz']['rank'], json['40l']['rank_local']);
    if (json['zenith']['record'] != null) zenith = RecordSingle.fromJson(json['zenith']['record'], json['zenith']['rank'], json['zenith']['rank_local']);
    if (json['zenithex']['record'] != null) zenithEx = RecordSingle.fromJson(json['zenithex']['record'], json['zenithex']['rank'], json['zenithex']['rank_local']);
    achievements = [for (var achievement in json['achievements']) Achievement.fromJson(achievement)];
    league = TetraLeague.fromJson(json['league'], DateTime.now());
    zen = TetrioZen.fromJson(json['zen']);
  }
}

class Badge {
  late String badgeId;
  late String label;
  DateTime? ts;

  Badge({required this.badgeId, required this.label, this.ts});

  Badge.fromJson(Map<String, dynamic> json) {
    badgeId = json['id'];
    label = json['label'];
    ts = (json['ts'] != null && json['ts'] is String) ? DateTime.parse(json['ts']) : null; // man i love osk
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = badgeId;
    data['label'] = label;
    data['ts'] = ts?.toString();
    return data;
  }

  @override
  String toString() {
    return "Badge $label ($badgeId)";
  }

  @override
  int get hashCode => badgeId.hashCode;

  @override
  bool operator ==(covariant Badge other) => badgeId == other.badgeId;
}

class Connections {
  Discord? discord;

  Connections({this.discord});

  Connections.fromJson(Map<String, dynamic> json) {
    discord = json['discord'] != null ? Discord.fromJson(json['discord']) : null;
  }
  @override
  bool operator ==(covariant Connections other) => discord == other.discord;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (discord != null) {
      data['discord'] = discord!.toJson();
    }
    return data;
  }
}

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

class Discord {
  late String id;
  late String username;

  Discord({required this.id, required this.username});

  Discord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  @override
  bool operator ==(covariant Discord other) => id == other.id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}

class Finesse {
  late int combo;
  late int faults;
  late int perfectPieces;

  Finesse({required this.combo, required this.faults, required this.perfectPieces});

  Finesse.fromJson(Map<String, dynamic> json) {
    combo = json['combo'];
    faults = json['faults'];
    perfectPieces = json['perfectpieces'];
  }

  Finesse operator + (Finesse other){
    return Finesse(combo: max(combo, other.combo), faults: faults + other.faults, perfectPieces: perfectPieces + other.perfectPieces);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['combo'] = combo;
    data['faults'] = faults;
    data['perfectpieces'] = perfectPieces;
    return data;
  }
}

class ResultsStats {
  late int topBtB;
  late int topCombo;
  late int holds;
  late int inputs;
  late int level;
  late int piecesPlaced;
  late int lines;
  late int score;
  double? seed;
  late Duration finalTime;
  late int tSpins;
  late Clears clears;
  late int kills;
  Finesse? finesse;
  ZenithResults? zenith; 

  double get pps => piecesPlaced / (finalTime.inMicroseconds / 1000000);
  double get kpp => inputs / piecesPlaced;
  double get spp => score / piecesPlaced;
  double get kps => inputs / (finalTime.inMicroseconds / 1000000);
  double get finessePercentage => finesse != null ? finesse!.perfectPieces / piecesPlaced : 0;
  double get cps => zenith != null ? zenith!.avgrankpts / (finalTime.inMilliseconds / 1000 * 60) : 0;

  ResultsStats(
      {
      required this.topBtB,
      required this.topCombo,
      required this.holds,
      required this.inputs,
      required this.level,
      required this.piecesPlaced,
      required this.lines,
      required this.score,
      required this.seed,
      required this.finalTime,
      required this.tSpins,
      required this.clears,
      required this.finesse});

  ResultsStats.fromJson(Map<String, dynamic> json) {
    seed = json['seed']?.toDouble();
    lines = json['lines'];
    inputs = json['inputs'];
    holds = json['holds'] ?? 0;
    finalTime = doubleMillisecondsToDuration(json['finaltime'].toDouble());
    score = json['score'];
    level = json['level'];
    topCombo = json['topcombo'];
    topBtB = json['topbtb'];
    tSpins = json['tspins'];
    piecesPlaced = json['piecesplaced'];
    clears = Clears.fromJson(json['clears']);
    kills = json['kills'];
    if (json.containsKey("finesse")) finesse = Finesse.fromJson(json['finesse']);
    if (json.containsKey("zenith")) zenith = ZenithResults.fromJson(json['zenith']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seed'] = seed;
    data['lines'] = lines;
    data['inputs'] = inputs;
    data['holds'] = holds;
    data['score'] = score;
    data['level'] = level;
    data['topcombo'] = topCombo;
    data['topbtb'] = topBtB;
    data['tspins'] = tSpins;
    data['piecesplaced'] = piecesPlaced;
    data['clears'] = clears.toJson();
    if (finesse != null) data['finesse'] = finesse!.toJson();
    data['finalTime'] = finalTime;
    return data;
  }
}

class ZenithResults{
  late double altitude;
  late double rank;
  late double peakrank;
  late double avgrankpts;
  late int floor;
  late double targetingfactor;
  late double targetinggrace;
  late double totalbonus;
  late int revives;
  late int revivesTotal;
  late bool speedrun;
  late bool speedrunSeen;
  late List<Duration> splits;

  ZenithResults.fromJson(Map<String, dynamic> json){
    altitude = json['altitude'].toDouble();
    rank = json['rank'].toDouble();
    peakrank = json['peakrank'].toDouble();
    avgrankpts = json['avgrankpts'].toDouble();
    floor = json['floor'];
    targetingfactor = json['targetingfactor'].toDouble();
    targetinggrace = json['targetinggrace'].toDouble();
    totalbonus = json['totalbonus'].toDouble();
    revives = json['revives'];
    revivesTotal = json['revivesTotal'];
    speedrun = json['speedrun'];
    speedrunSeen = json['speedrun_seen'];
    splits = [];
    for (int ms in json['splits']) {
      splits.add(Duration(milliseconds: ms));
    }
  }
}

class Handling {
  late num arr;
  late num das;
  late num sdf;
  late num dcd;
  late bool cancel;
  late bool safeLock;

  Handling({required this.arr, required this.das, required this.sdf, required this.dcd, required this.cancel, required this.safeLock});

  Handling.fromJson(Map<String, dynamic> json) {
    arr = json['arr'];
    das = json['das'];
    dcd = json['dcd'];
    sdf = json['sdf'];
    safeLock = json['safelock'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['arr'] = arr.toDouble();
    data['das'] = das.toDouble();
    data['dcd'] = dcd.toDouble();
    data['sdf'] = sdf.toDouble();
    data['safelock'] = safeLock;
    data['cancel'] = cancel;
    return data;
  }
}

class NerdStats {
  final double _apm;
  final double _pps;
  final double _vs;
  late double app;
  late double vsapm;
  late double dss;
  late double dsp;
  late double appdsp;
  late double cheese;
  late double gbe;
  late double nyaapp;
  late double area;

  NerdStats(this._apm, this._pps, this._vs) {
    app = _apm / (_pps * 60);
    vsapm = _vs / _apm;
    dss = (_vs / 100) - (_apm / 60);
    dsp = ((_vs / 100) - (_apm / 60)) / _pps;
    appdsp = app + dsp;
    cheese = (dsp * 150) + ((vsapm - 2) * 50) + (0.6 - app) * 125;
    gbe = app * dsp * 2;
    nyaapp = app - 5 * tan(radians((cheese / -30) + 1));
    area = _apm * 1 + _pps * 45 + _vs * 0.444 + app * 185 + dss * 175 + dsp * 450 + gbe * 315;
  }
}

class EstTr {
  final double _apm;
  final double _pps;
  final double _vs;
  final double _app;
  final double _dss;
  final double _dsp;
  final double _gbe;
  late double esttr;
  late double srarea;
  late double statrank;
  late double estglicko;

  EstTr(this._apm, this._pps, this._vs, this._app, this._dss, this._dsp, this._gbe) {
    srarea = (_apm * 0) + (_pps * 135) + (_vs * 0) + (_app * 290) + (_dss * 0) + (_dsp * 700) + (_gbe * 0);
    statrank = 11.2 * atan((srarea - 93) / 130) + 1;
    if (statrank <= 0) statrank = 0.001;
    //estglicko = (4.0867 * srarea + 186.68);
    double ntemp = _pps*(150+(((_vs/_apm) - 1.66)*35))+_app*290+_dsp*700;
    estglicko = 0.000013*pow(ntemp, 3) - 0.0196 *pow(ntemp, 2) + (12.645*ntemp)-1005.4;
    esttr = 25000 / 
    (
      1 + pow(10, (
        (
          (
            1500-estglicko
          )*pi
        )/sqrt(
          (
            (
              3*pow(ln10, 2)
            )*pow(60, 2)
          )+(
            2500*(
              (64*pow(pi,2))+(147*pow(ln10, 2))
            )
          )
        )
      ))
    );
  }
}

class Achievement {
  late int k;
  int? o;
  late int rt;
  late int vt;
  late int min;
  late int deci;
  late String name;
  late String object;
  late String category;
  late bool hidden;
  late int art;
  late bool nolb;
  late String desc;
  late String n;
  String? sId;
  double? v;
  late int? a;
  DateTime? t;
  int? pos;
  int? total;
  int? rank;

  Achievement(
      {required this.k,
      this.o,
      required this.rt,
      required this.vt,
      required this.min,
      required this.deci,
      required this.name,
      required this.object,
      required this.category,
      required this.hidden,
      required this.art,
      required this.nolb,
      required this.desc,
      required this.n,
      this.sId,
      this.v,
      required this.a,
      this.t,
      this.pos,
      this.total,
      this.rank});

  Achievement.fromJson(Map<String, dynamic> json) {
    k = json['k'];
    o = json['o'];
    rt = json['rt'];
    vt = json['vt'];
    min = json['min'];
    deci = json['deci'];
    name = json['name'];
    object = json['object'];
    category = json['category'];
    hidden = json['hidden'];
    art = json['art'];
    nolb = json['nolb'];
    desc = json['desc'];
    n = json['n'];
    sId = json['_id'];
    v = json['v']?.toDouble();
    a = json['a'];
    t = json['t'] != null ? DateTime.parse(json['t']) : null;
    pos = json['pos'];
    total = json['total'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['k'] = k;
    data['o'] = o;
    data['rt'] = rt;
    data['vt'] = vt;
    data['min'] = min;
    data['deci'] = deci;
    data['name'] = name;
    data['object'] = object;
    data['category'] = category;
    data['hidden'] = hidden;
    data['art'] = art;
    data['nolb'] = nolb;
    data['desc'] = desc;
    data['n'] = n;
    data['_id'] = sId;
    data['v'] = v;
    data['a'] = a;
    data['t'] = t.toString();
    data['pos'] = pos;
    data['total'] = total;
    data['rank'] = rank;
    return data;
  }
}


class Playstyle {
  final double _apm;
  final double _pps;
  //final double _vs;
  final double _app;
  final double _vsapm;
  //final double _dss;
  final double _dsp;
  final double _gbe;
  final double _srarea;
  final double _statrank;
  late double opener;
  late double plonk;
  late double stride;
  late double infds;

  Playstyle(this._apm, this._pps, this._app, this._vsapm, this._dsp, this._gbe, this._srarea, this._statrank) {
    double nmapm = ((_apm / _srarea) / ((0.069 * pow(1.0017, (pow(_statrank, 5) / 4700))) + _statrank / 360)) - 1;
    double nmpps = ((_pps / _srarea) / (0.0084264 * pow(2.14, (-2 * (_statrank / 2.7 + 1.03))) - _statrank / 5750 + 0.0067)) - 1;
    //double nmvs = ((_vs / _srarea) / (0.1333 * pow(1.0021, ((pow(_statrank, 7) * (_statrank / 16.5)) / 1400000)) + _statrank / 133)) - 1;
    double nmapp = (_app / (0.1368803292 * pow(1.0024, (pow(_statrank, 5) / 2800)) + _statrank / 54)) - 1;
    //double nmdss = (_dss / (0.01436466667 * pow(4.1, ((_statrank - 9.6) / 2.9)) + _statrank / 140 + 0.01)) - 1;
    double nmdsp = (_dsp / (0.02136327583 * pow(14, ((_statrank - 14.75) / 3.9)) + _statrank / 152 + 0.022)) - 1;
    double nmgbe = (_gbe / (_statrank / 350 + 0.005948424455 * pow(3.8, ((_statrank - 6.1) / 4)) + 0.006)) - 1;
    double nmvsapm = (_vsapm / (-pow(((_statrank - 16) / 36), 2) + 2.133)) - 1;
    opener = ((nmapm + nmpps * 0.75 + nmvsapm * -10 + nmapp * 0.75 + nmdsp * -0.25) / 3.5) + 0.5;
    plonk = ((nmgbe + nmapp + nmdsp * 0.75 + nmpps * -1) / 2.73) + 0.5;
    stride = ((nmapm * -0.25 + nmpps + nmapp * -2 + nmdsp * -0.5) * 0.79) + 0.5;
    infds = ((nmdsp + nmapp * -0.75 + nmapm * 0.5 + nmvsapm * 1.5 + nmpps * 0.5) * 0.9) + 0.5;
  }
}

class TetraLeagueAlphaStream{
  late String userId;
  late List<TetraLeagueAlphaRecord> records;

  TetraLeagueAlphaStream({required this.userId, required this.records});

  TetraLeagueAlphaStream.fromJson(List<dynamic> json, String userID) {
    userId = userID;
    records = [];
    for (var value in json) {records.add(TetraLeagueAlphaRecord.fromJson(value));}
  }
}

class TetraLeagueBetaStream{
  late String id;
  List<BetaRecord> records = [];

  TetraLeagueBetaStream({required this.id, required this.records});

  TetraLeagueBetaStream.fromJson(List<dynamic> json, String userID) {
    id = userID;
    for (var entry in json) {
      records.add(BetaRecord.fromJson(entry));
    }
  }

  addFromAlphaStream(List<TetraLeagueAlphaRecord> r){
    for (var entry in r) {
      records.add(
      BetaRecord(
        id: entry.ownId,
        replayID: entry.replayId,
        ts: entry.timestamp,
        enemyID: entry.endContext[1].userId,
        enemyUsername: entry.endContext[1].username,
        gamemode: "oldleague",
        results: BetaLeagueResults(
          leaderboard: [
            BetaLeagueLeaderboardEntry(
              id: entry.endContext[0].userId,
              username: entry.endContext[0].username,
              naturalorder: entry.endContext[0].naturalOrder,
              wins: entry.endContext[0].points,
              stats: BetaLeagueStats(
                apm: entry.endContext[0].secondary,
                pps: entry.endContext[0].tertiary,
                vs: entry.endContext[0].extra,
                garbageSent: -1,
                garbageReceived: -1,
                kills: entry.endContext[0].points,
                altitude: 0.0,
                rank: -1
              )
            ),
            BetaLeagueLeaderboardEntry(
              id: entry.endContext[1].userId,
              username: entry.endContext[1].username,
              naturalorder: entry.endContext[1].naturalOrder,
              wins: entry.endContext[1].points,
              stats: BetaLeagueStats(
                apm: entry.endContext[1].secondary,
                pps: entry.endContext[1].tertiary,
                vs: entry.endContext[1].extra,
                garbageSent: -1,
                garbageReceived: -1,
                kills: entry.endContext[1].points,
                altitude: 0.0,
                rank: -1
              )
            )
          ],
          rounds: [
            for (int i=0; i<entry.endContext[0].secondaryTracking.length; i++)
            [BetaLeagueRound(
              id: entry.endContext[0].userId,
              username: entry.endContext[0].username,
              naturalorder: entry.endContext[0].naturalOrder,
              active: false,
              alive: false,
              lifetime: const Duration(milliseconds: -1),
              stats: BetaLeagueStats(
                apm: entry.endContext[0].secondaryTracking[i],
                pps: entry.endContext[0].tertiaryTracking[i],
                vs: entry.endContext[0].extraTracking[i],
                garbageSent: -1,
                garbageReceived: -1,
                kills: 0,
                altitude: 0.0,
                rank: -1
              )
            ),BetaLeagueRound(
              id: entry.endContext[1].userId,
              username: entry.endContext[1].username,
              naturalorder: entry.endContext[1].naturalOrder,
              active: false,
              alive: false,
              lifetime: const Duration(milliseconds: -1),
              stats: BetaLeagueStats(
                apm: entry.endContext[1].secondaryTracking[i],
                pps: entry.endContext[1].tertiaryTracking[i],
                vs: entry.endContext[1].extraTracking[i],
                garbageSent: -1,
                garbageReceived: -1,
                kills: 0,
                altitude: 0.0,
                rank: -1
              )
            )]
          ]
        )
      )
    );
    }
  }
}

class SingleplayerStream{
  late String userId;
  late String type;
  late List<RecordSingle> records;

  SingleplayerStream({required this.userId, required this.records, required this.type});

  SingleplayerStream.fromJson(List<dynamic> json, String userID, String tp) {
    userId = userID;
    type = tp;
    records = [];
    for (var value in json) {records.add(RecordSingle.fromJson(value, -1, -1));}
  }
}

class BetaRecord{
  late String id;
  late String replayID;
  late String gamemode;
  late DateTime ts;
  late String enemyUsername;
  late String enemyID;
  late BetaLeagueResults results;

  BetaRecord({required this.id, required this.replayID, required this.gamemode, required this.ts, required this.enemyUsername, required this.enemyID, required this.results});

  BetaRecord.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    replayID = json['replayid'];
    gamemode = json['gamemode'];
    ts = DateTime.parse(json['ts']);
    enemyUsername = json['otherusers'][0]['username'];
    enemyID = json['otherusers'][0]['id'];
    results = BetaLeagueResults.fromJson(json['results']);
  }
}

class BetaLeagueResults{
  List<BetaLeagueLeaderboardEntry> leaderboard = [];
  List<List<BetaLeagueRound>> rounds = [];

  BetaLeagueResults({required this.leaderboard, required this.rounds});

  BetaLeagueResults.fromJson(Map<String, dynamic> json){
    for (var lbEntry in json['leaderboard']) {
      leaderboard.add(BetaLeagueLeaderboardEntry.fromJson(lbEntry));
    }
    for (var roundEntry in json['rounds']){
      List<BetaLeagueRound> round = [];
      for (var r in roundEntry) {
        round.add(BetaLeagueRound.fromJson(r));
      }
      rounds.add(round);
    }
  }
}

class BetaLeagueLeaderboardEntry{
  late String id;
  late String username;
  late int naturalorder;
  late int wins;
  late BetaLeagueStats stats;

  BetaLeagueLeaderboardEntry({required this.id, required this.username, required this.naturalorder, required this.wins, required this.stats});
  
  BetaLeagueLeaderboardEntry.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    naturalorder = json['naturalorder'];
    wins = json['wins'];
    stats = BetaLeagueStats.fromJson(json['stats']);
  }
}

class BetaLeagueStats{
  late double apm;
  late double pps;
  late double vs;
  late int garbageSent;
  late int garbageReceived;
  late int kills;
  late double altitude;
  late int rank;
  int? targetingFactor;
  int? targetingRace;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;

  BetaLeagueStats({required this.apm, required this.pps, required this.vs, required this.garbageSent, required this.garbageReceived, required this.kills, required this.altitude, required this.rank}){
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  BetaLeagueStats.fromJson(Map<String, dynamic> json){
    apm = json['apm'] != null ? json['apm'].toDouble() : 0.00;
    pps = json['apm'] != null ? json['pps'].toDouble() : 0.00;
    vs = json['apm'] != null ? json['vsscore'].toDouble() : 0.00;
    garbageSent = json['garbagesent'];
    garbageReceived = json['garbagereceived'];
    kills = json['kills'];
    altitude = json['altitude'].toDouble();
    rank = json['rank'];
    targetingFactor = json['targetingfactor'];
    targetingRace = json['targetinggrace'];
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }
}

class BetaLeagueRound{
  late String id;
  late String username;
  late bool active;
  late int naturalorder;
  late bool alive;
  late Duration lifetime;
  late BetaLeagueStats stats;

  BetaLeagueRound({required this.id, required this.username, required this.active, required this.naturalorder, required this.alive, required this.lifetime, required this.stats});

  BetaLeagueRound.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    active = json['active'];
    naturalorder = json['naturalorder'];
    alive = json['alive'];
    lifetime = Duration(milliseconds: json['lifetime']);
    stats = BetaLeagueStats.fromJson(json['stats']);
  }
}

class TetraLeagueAlphaRecord{
  late String replayId;
  late String ownId;
  late DateTime timestamp;
  late bool replayAvalable;
  late List<EndContextMulti> endContext;

  TetraLeagueAlphaRecord({required this.replayId, required this.ownId, required this.timestamp, required this.endContext, required this.replayAvalable});

  TetraLeagueAlphaRecord.fromJson(Map<String, dynamic> json) {
    endContext = [EndContextMulti.fromJson(json['endcontext'][0]), EndContextMulti.fromJson(json['endcontext'][1])];
    replayId = json['replayid'];
    ownId = json['_id']??replayId;
    timestamp = DateTime.parse(json['ts']);
    replayAvalable = ownId != replayId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = ownId;
    data['endcontext'][0] = endContext[0].toJson();
    data['endcontext'][1] = endContext[1].toJson();
    data['replayid'] = replayId;
    data['ts'] = timestamp;
    return data;
  }

  @override
  bool operator ==(covariant TetraLeagueAlphaRecord other) => (ownId == other.ownId) || (replayId == other.replayId);

  @override
  String toString() {
    return "TetraLeagueAlphaRecord: ${endContext.first.userId} vs ${endContext.last.userId}";
  }
}

class EndContextMulti {
  late String userId;
  late String username;
  late int naturalOrder;
  late int inputs;
  late int piecesPlaced;
  late Handling handling;
  late int points;
  late int wins;
  late double secondary;
  late List secondaryTracking;
  late double tertiary;
  late List tertiaryTracking;
  late double extra;
  late List extraTracking;
  late bool success;
  late NerdStats nerdStats;
  late List<NerdStats> nerdStatsTracking;
  late EstTr estTr;
  late List<EstTr> estTrTracking;
  late Playstyle playstyle;
  late List<Playstyle> playstyleTracking;

  EndContextMulti(
      {required this.userId,
      required this.username,
      required this.naturalOrder,
      required this.inputs,
      required this.piecesPlaced,
      required this.handling,
      required this.points,
      required this.wins,
      required this.secondary,
      required this.secondaryTracking,
      required this.tertiary,
      required this.tertiaryTracking,
      required this.extra,
      required this.extraTracking,
      required this.success}){
        nerdStats = NerdStats(secondary, tertiary, extra);
        nerdStatsTracking = [for (int i = 0; i < secondaryTracking.length; i++) NerdStats(secondaryTracking[i], tertiaryTracking[i], extraTracking[i])];
        estTr = EstTr(secondary, tertiary, extra, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
        estTrTracking = [for (int i = 0; i < secondaryTracking.length; i++) EstTr(secondaryTracking[i], tertiaryTracking[i], extraTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].dss, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe)];
        playstyle = Playstyle(secondary, tertiary, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
        playstyleTracking = [for (int i = 0; i < secondaryTracking.length; i++) Playstyle(secondaryTracking[i], tertiaryTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].vsapm, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe, estTrTracking[i].srarea, estTrTracking[i].statrank)];
      }

  EndContextMulti.fromJson(Map<String, dynamic> json) {
    userId = json['id'] ?? json['user']['_id'];
    username = json['username'] ?? json['user']['username'];
    handling = json['handling'] != null ? Handling.fromJson(json['handling']) : Handling(arr: -1, das: -1, sdf: -1, dcd: 0, cancel: true, safeLock: true);
    success = json['success'];
    inputs = json['inputs'] ?? -1;
    piecesPlaced = json['piecesplaced'] ?? -1;
    naturalOrder = json['naturalorder'];
    wins = json['wins'];
    points = json['points']['primary'];
    secondary = json['points']['secondary'].toDouble();
    tertiary = json['points']['tertiary'].toDouble();
    secondaryTracking = json['points']['secondaryAvgTracking'] != null ? json['points']['secondaryAvgTracking'].map((e) => e.toDouble()).toList() : [];
    tertiaryTracking = json['points']['tertiaryAvgTracking'] != null ? json['points']['tertiaryAvgTracking'].map((e) => e.toDouble()).toList() : [];
    extra = json['points']['extra']['vs'].toDouble();
    extraTracking = json['points']['extraAvgTracking'] != null ? json['points']['extraAvgTracking']['aggregatestats___vsscore'].map((e) => e.toDouble()).toList() : [];
    nerdStats = NerdStats(secondary, tertiary, extra);
    nerdStatsTracking = [for (int i = 0; i < secondaryTracking.length; i++) NerdStats(secondaryTracking[i], tertiaryTracking[i], extraTracking[i])];
    estTr = EstTr(secondary, tertiary, extra, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    estTrTracking = [for (int i = 0; i < secondaryTracking.length; i++) EstTr(secondaryTracking[i], tertiaryTracking[i], extraTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].dss, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe)];
    playstyle = Playstyle(secondary, tertiary, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
    playstyleTracking = [for (int i = 0; i < secondaryTracking.length; i++) Playstyle(secondaryTracking[i], tertiaryTracking[i], nerdStatsTracking[i].app, nerdStatsTracking[i].vsapm, nerdStatsTracking[i].dsp, nerdStatsTracking[i].gbe, estTrTracking[i].srarea, estTrTracking[i].statrank)];
  }

  @override
  bool operator == (covariant EndContextMulti other){
    if (userId != other.userId) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = {'_id': userId, 'username': username};
    data['handling'] = handling.toJson();
    data['success'] = success;
    data['inputs'] = inputs;
    data['piecesplaced'] = piecesPlaced;
    data['naturalorder'] = naturalOrder;
    data['wins'] = wins;
    data['points'] = {'primary': points, 'secondary': secondary, 'tertiary':tertiary, 'extra': {'vs': extra}, 'secondaryAvgTracking': secondaryTracking, 'tertiaryAvgTracking': tertiaryTracking, 'extraAvgTracking': {'aggregatestats___vsscore': extraTracking}};
    return data;
  }
}

class TetraLeague {
  late DateTime timestamp;
  late int gamesPlayed;
  late int gamesWon;
  late String bestRank;
  late bool decaying;
  late double tr;
  late double gxe;
  late String rank;
  double? glicko;
  double? rd;
  late String percentileRank;
  late double percentile;
  late int standing;
  late int standingLocal;
  String? nextRank;
  late int nextAt;
  String? prevRank;
  late int prevAt;
  double? apm;
  double? pps;
  double? vs;
  NerdStats? nerdStats;
  EstTr? estTr;
  Playstyle? playstyle;
  List? records;

  TetraLeague(
      {required this.timestamp,
      required this.gamesPlayed,
      required this.gamesWon,
      required this.bestRank,
      required this.decaying,
      required this.tr,
      required this.gxe,
      required this.rank,
      this.glicko,
      this.rd,
      required this.percentileRank,
      required this.percentile,
      required this.standing,
      required this.standingLocal,
      this.nextRank,
      required this.nextAt,
      this.prevRank,
      required this.prevAt,
      this.apm,
      this.pps,
      this.vs,
      this.records}){
        nerdStats = (apm != null && pps != null && vs != null) ? NerdStats(apm!, pps!, vs!) : null;
        estTr = (nerdStats != null) ? EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp, nerdStats!.gbe) : null;
        playstyle =(nerdStats != null) ? Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm, nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank) : null;
      }

  double get winrate => gamesWon / gamesPlayed;

  TetraLeague.fromJson(Map<String, dynamic> json, ts) {
    timestamp = ts;
    gamesPlayed = json['gamesplayed'] ?? 0;
    gamesWon = json['gameswon'] ?? 0;
    tr = json['tr'] != null ? json['tr'].toDouble() : json['rating'] != null ? json['rating'].toDouble() : -1;
    glicko = json['glicko']?.toDouble();
    rd = json['rd'] != null ? json['rd']!.toDouble() : noTrRd;
    gxe = json['gxe'] != null ? json['gxe'].toDouble() : -1;
    rank = json['rank'] != null ? json['rank']!.toString() : 'z';
    bestRank = json['bestrank'] != null ? json['bestrank']!.toString() : 'z';
    apm = json['apm']?.toDouble();
    pps = json['pps']?.toDouble();
    vs = json['vs']?.toDouble();
    decaying = json['decaying'] ?? false;
    standing = json['standing'] ?? -1;
    percentile = json['percentile'] != null ? json['percentile'].toDouble() : rankCutoffs[rank];
    standingLocal = json['standing_local'] ?? -1;
    prevRank = json['prev_rank'];
    prevAt = json['prev_at'] ?? -1;
    nextRank = json['next_rank'];
    nextAt = json['next_at'] ?? -1;
    percentileRank = json['percentile_rank'] ?? rank;
    nerdStats = (apm != null && pps != null && vs != null) ? NerdStats(apm!, pps!, vs!) : null;
    estTr = (nerdStats != null) ? EstTr(apm!, pps!, vs!, nerdStats!.app, nerdStats!.dss, nerdStats!.dsp, nerdStats!.gbe) : null;
    playstyle = (nerdStats != null) ? Playstyle(apm!, pps!, nerdStats!.app, nerdStats!.vsapm, nerdStats!.dsp, nerdStats!.gbe, estTr!.srarea, estTr!.statrank) : null;
  }

  @override
  bool operator ==(covariant TetraLeague other) => gamesPlayed == other.gamesPlayed && rd == other.rd;

  bool lessStrictCheck (covariant TetraLeague other) => gamesPlayed == other.gamesPlayed && glicko == other.glicko;

  double? get esttracc => (estTr != null) ? estTr!.esttr - tr : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (gamesPlayed > 0) data['gamesplayed'] = gamesPlayed;
    if (gamesWon > 0) data['gameswon'] = gamesWon;
    if (tr >= 0) data['tr'] = tr;
    if (glicko != null) data['glicko'] = glicko;
    if (rd != null && rd != noTrRd) data['rd'] = rd;
    if (rank != 'z') data['rank'] = rank;
    if (bestRank != 'z') data['bestrank'] = bestRank;
    if (apm != null) data['apm'] = apm;
    if (pps != null) data['pps'] = pps;
    if (vs != null) data['vs'] = vs;
    if (decaying) data['decaying'] = decaying;
    if (standing >= 0) data['standing'] = standing;
    if (!rankCutoffs.containsValue(percentile)) data['percentile'] = percentile;
    if (standingLocal >= 0) data['standing_local'] = standingLocal;
    if (prevRank != null) data['prev_rank'] = prevRank;
    if (prevAt >= 0) data['prev_at'] = prevAt;
    if (nextRank != null) data['next_rank'] = nextRank;
    if (nextAt >= 0) data['next_at'] = nextAt;
    if (percentileRank != rank) data['percentile_rank'] = percentileRank;
    return data;
  }
}

class RecordSingle {
  late String? userId;
  late String replayId;
  late String ownId;
  late String gamemode;
  late DateTime timestamp;
  late ResultsStats stats;
  late int rank;
  late int countryRank;
  late AggregateStats aggregateStats;
  late RecordExtras extras;

  RecordSingle({required this.userId, required this.replayId, required this.ownId, required this.timestamp, required this.stats, required this.rank, required this.countryRank, required this.aggregateStats});

  RecordSingle.fromJson(Map<String, dynamic> json, int ran, int cran) {
    //developer.log("RecordSingle.fromJson: $json", name: "data_objects/tetrio");
    ownId = json['_id'];
    gamemode = json['gamemode'];
    stats = ResultsStats.fromJson(json['results']['stats']);
    replayId = json['replayid'];
    timestamp = DateTime.parse(json['ts']);
    if (json['user'] != null) userId = json['user']['id'];
    rank = ran;
    countryRank = cran;
    aggregateStats = AggregateStats.fromJson(json['results']['aggregatestats']);
    var ex = json['extras'] as Map<String, dynamic>;
    switch (ex.keys.firstOrNull){
      case "zenith":
        extras = ZenithExtras.fromJson(json['extras']['zenith']);
      default:
      break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = ownId;
    data['results']['stats'] = stats.toJson();
    data['ismulti'] = false;
    data['replayid'] = replayId;
    data['ts'] = timestamp;
    data['user_id'] = userId;
    return data;
  }
}

class AggregateStats{
  late double apm;
  late double pps;
  late double vs;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;

  AggregateStats(this.apm, this.pps, this.vs){
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  AggregateStats.fromJson(Map<String, dynamic> json){
    apm = json['apm'] != null ? json['apm'].toDouble() : 0.00;
    pps = json['apm'] != null ? json['pps'].toDouble() : 0.00;
    vs = json['apm'] != null ? json['vsscore'].toDouble() : 0.00;
    nerdStats = NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }
}

class RecordExtras{

}

class ZenithExtras extends RecordExtras{
  List<String> mods = [];

  ZenithExtras.fromJson(Map<String, dynamic> json){
    for (var mod in json["mods"]) {
      mods.add(mod);
    }
  }
}

class TetrioZen {
  late int level;
  late int score;

  TetrioZen({required this.level, required this.score});

  double get scoreRequirement => (10000 + 10000 * ((log(level + 1) / log(2)) - 1));

  TetrioZen.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['score'] = score;
    return data;
  }
}

class UserRecords{
  String id;
  RecordSingle? sprint;
  RecordSingle? blitz;
  TetrioZen zen;

  UserRecords(this.id, this.sprint, this.blitz, this.zen);
}

class Distinguishment {
  late String type;
  String? detail;
  String? header;
  String? footer;

  Distinguishment({required this.type, this.detail, this.header, this.footer});

  Distinguishment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    detail = json['detail'];
    header = json['header'];
    footer = json['footer'];
  }

  @override
  bool operator ==(covariant Distinguishment other) => type == other.type && detail == other.detail && header == other.header && footer == other.footer;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['detail'] = detail;
    data['header'] = header;
    data['footer'] = footer;
    return data;
  }
}

class News{
  late String id;
  late List<NewsEntry> news;

  News(this.id, this.news);

  News.fromJson(Map<String, dynamic> json, String? userID){
    id = userID != null ? "user_$userID" : json['news'].first['stream'];
    news = [for (var entry in json['news']) NewsEntry.fromJson(entry)];
  }
}

class NewsEntry {
  //late String id; do i need it?
  late String type;
  late Map<String, dynamic> data;
  late DateTime timestamp;

  NewsEntry({required this.type, required this.data, required this.timestamp});

  NewsEntry.fromJson(Map<String, dynamic> json){
    //id = json["_id"];
    type = json["type"];
    data = json["data"];
    timestamp = DateTime.parse(json['ts']);
  }
}

class PlayerLeaderboardPosition{
  late LeaderboardPosition? apm;
  late LeaderboardPosition? pps;
  late LeaderboardPosition? vs;
  late LeaderboardPosition? gamesPlayed;
  late LeaderboardPosition? gamesWon;
  late LeaderboardPosition? winrate;
  late LeaderboardPosition? app;
  late LeaderboardPosition? vsapm;
  late LeaderboardPosition? dss;
  late LeaderboardPosition? dsp;
  late LeaderboardPosition? appdsp;
  late LeaderboardPosition? cheese;
  late LeaderboardPosition? gbe;
  late LeaderboardPosition? nyaapp;
  late LeaderboardPosition? area;
  late LeaderboardPosition? estTr;
  late LeaderboardPosition? accOfEst;

  PlayerLeaderboardPosition({
    required this.apm,
    required this.pps,
    required this.vs,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.winrate,
    required this.app,
    required this.vsapm,
    required this.dss,
    required this.dsp,
    required this.appdsp,
    required this.cheese,
    required this.gbe,
    required this.nyaapp,
    required this.area,
    required this.estTr,
    required this.accOfEst
  });
  
  PlayerLeaderboardPosition.fromSearchResults(List<LeaderboardPosition?> results){
    apm = results[0];
    pps = results[1];
    vs = results[2];
    gamesPlayed = results[3];
    gamesWon = results[4];
    winrate = results[5];
    app = results[6];
    vsapm = results[7];
    dss = results[8];
    dsp = results[9];
    appdsp = results[10];
    cheese = results[11];
    gbe = results[12];
    nyaapp = results[13];
    area = results[14];
    estTr = results[15];
    accOfEst = results[16];
  }
}

class LeaderboardPosition{
  int position;
  double percentage;

  LeaderboardPosition(this.position, this.percentage);
}

class TetrioPlayersLeaderboard {
  late String type;
  late DateTime timestamp;
  late List<TetrioPlayerFromLeaderboard> leaderboard;

  TetrioPlayersLeaderboard(this.type, this.leaderboard);

  @override
  String toString(){
    return "$type leaderboard: ${leaderboard.length} players";
  }

  List<TetrioPlayerFromLeaderboard> getStatRanking(List<TetrioPlayerFromLeaderboard> leaderboard, Stats stat, {bool reversed = false, String country = ""}){
    List<TetrioPlayerFromLeaderboard> lb = List.from(leaderboard);
    if (country.isNotEmpty){
      lb.removeWhere((element) => element.country != country);
    }
    lb.sort(((a, b) {
      if (a.getStatByEnum(stat).isNaN) return 1;
      if (b.getStatByEnum(stat).isNaN) return -1;
      if (a.getStatByEnum(stat) > b.getStatByEnum(stat)){
        return reversed ? 1 : -1;
      }else if (a.getStatByEnum(stat) == b.getStatByEnum(stat)){
        return 0;
      }else{
        return reversed ? -1 : 1;
      }
    }));
    return lb;
  }

  List<dynamic> getAverageOfRank(String rank){ // i tried to refactor it and that's was terrible
    if (rank.isNotEmpty && !rankCutoffs.keys.contains(rank)) throw Exception("Invalid rank");
    List<TetrioPlayerFromLeaderboard> filtredLeaderboard = List.from(leaderboard); 
    if (rank.isNotEmpty) {
      filtredLeaderboard.removeWhere((element) => element.rank != rank);
    }
    if (filtredLeaderboard.isNotEmpty){
      double avgAPM = 0,
        avgPPS = 0,
        avgVS = 0,
        avgTR = 0,
        avgGlicko = 0,
        avgRD = 0,
        avgAPP = 0,
        avgVSAPM = 0,
        avgDSS = 0,
        avgDSP = 0,
        avgAPPDSP = 0,
        avgCheese = 0,
        avgGBE = 0,
        avgNyaAPP = 0,
        avgArea = 0,
        avgEstTR = 0,
        avgEstAcc = 0,
        avgOpener = 0,
        avgPlonk = 0,
        avgStride = 0,
        avgInfDS = 0,
        lowestTR = 25000,
        lowestGlicko = double.infinity,
        lowestRD = double.infinity,
        lowestWinrate = double.infinity,
        lowestAPM = double.infinity,
        lowestPPS = double.infinity,
        lowestVS = double.infinity,
        lowestAPP = double.infinity,
        lowestVSAPM = double.infinity,
        lowestDSS = double.infinity,
        lowestDSP = double.infinity,
        lowestAPPDSP = double.infinity,
        lowestCheese = double.infinity,
        lowestGBE = double.infinity,
        lowestNyaAPP = double.infinity,
        lowestArea = double.infinity,
        lowestEstTR = double.infinity,
        lowestEstAcc = double.infinity,
        lowestOpener = double.infinity,
        lowestPlonk = double.infinity,
        lowestStride = double.infinity,
        lowestInfDS = double.infinity,
        highestTR = double.negativeInfinity,
        highestGlicko = double.negativeInfinity,
        highestRD = double.negativeInfinity,
        highestWinrate = double.negativeInfinity,
        highestAPM = double.negativeInfinity,
        highestPPS = double.negativeInfinity,
        highestVS = double.negativeInfinity,
        highestAPP = double.negativeInfinity,
        highestVSAPM = double.negativeInfinity,
        highestDSS = double.negativeInfinity,
        highestDSP = double.negativeInfinity,
        highestAPPDSP = double.negativeInfinity,
        highestCheese = double.negativeInfinity,
        highestGBE = double.negativeInfinity,
        highestNyaAPP = double.negativeInfinity,
        highestArea = double.negativeInfinity,
        highestEstTR = double.negativeInfinity,
        highestEstAcc = double.negativeInfinity,
        highestOpener = double.negativeInfinity,
        highestPlonk = double.negativeInfinity,
        highestStride = double.negativeInfinity,
        highestInfDS = double.negativeInfinity;
      int avgGamesPlayed = 0,
        avgGamesWon = 0,
        totalGamesPlayed = 0,
        totalGamesWon = 0,
        lowestGamesPlayed = pow(2, 53) as int,
        lowestGamesWon = pow(2, 53) as int,
        highestGamesPlayed = 0,
        highestGamesWon = 0;
      String lowestTRid = "", lowestTRnick = "",
        lowestGlickoID = "", lowestGlickoNick = "",
        lowestRdID = "", lowestRdNick = "",
        lowestGamesPlayedID = "", lowestGamesPlayedNick = "",
        lowestGamesWonID = "", lowestGamesWonNick = "",
        lowestWinrateID = "", lowestWinrateNick = "",
        lowestAPMid = "", lowestAPMnick = "",
        lowestPPSid = "", lowestPPSnick = "",
        lowestVSid = "", lowestVSnick = "",
        lowestAPPid = "", lowestAPPnick = "",
        lowestVSAPMid = "", lowestVSAPMnick = "",
        lowestDSSid = "", lowestDSSnick = "",
        lowestDSPid = "", lowestDSPnick = "",
        lowestAPPDSPid = "", lowestAPPDSPnick = "",
        lowestCheeseID = "", lowestCheeseNick = "",
        lowestGBEid = "", lowestGBEnick = "",
        lowestNyaAPPid = "", lowestNyaAPPnick = "",
        lowestAreaID = "", lowestAreaNick = "",
        lowestEstTRid = "", lowestEstTRnick = "",
        lowestEstAccID = "", lowestEstAccNick = "",
        lowestOpenerID = "", lowestOpenerNick = "",
        lowestPlonkID = "", lowestPlonkNick = "",
        lowestStrideID = "", lowestStrideNick = "",
        lowestInfDSid = "", lowestInfDSnick = "",
        highestTRid = "", highestTRnick = "",
        highestGlickoID = "", highestGlickoNick = "",
        highestRdID = "", highestRdNick = "",
        highestGamesPlayedID = "", highestGamesPlayedNick = "",
        highestGamesWonID = "", highestGamesWonNick = "",
        highestWinrateID = "", highestWinrateNick = "",
        highestAPMid = "", highestAPMnick = "",
        highestPPSid = "", highestPPSnick = "",
        highestVSid = "", highestVSnick = "",
        highestAPPid = "", highestAPPnick = "",
        highestVSAPMid = "", highestVSAPMnick = "",
        highestDSSid = "", highestDSSnick = "",
        highestDSPid = "", highestDSPnick = "",
        highestAPPDSPid = "", highestAPPDSPnick = "",
        highestCheeseID = "", highestCheeseNick = "",
        highestGBEid = "", highestGBEnick = "",
        highestNyaAPPid = "", highestNyaAPPnick = "",
        highestAreaID = "", highestAreaNick = "",
        highestEstTRid = "", highestEstTRnick = "",
        highestEstAccID = "", highestEstAccNick = "",
        highestOpenerID = "", highestOpenerNick = "",
        highestPlonkID = "", highestPlonkNick = "",
        highestStrideID = "", highestStrideNick = "",
        highestInfDSid = "", highestInfDSnick = "";
      for (var entry in filtredLeaderboard){
        avgAPM += entry.apm;
        avgPPS += entry.pps;
        avgVS += entry.vs;
        avgTR += entry.tr;
        if (entry.glicko != null) avgGlicko += entry.glicko!;
        if (entry.rd != null) avgRD += entry.rd!;
        avgAPP += entry.nerdStats.app;
        avgVSAPM += entry.nerdStats.vsapm;
        avgDSS += entry.nerdStats.dss;
        avgDSP += entry.nerdStats.dsp;
        avgAPPDSP += entry.nerdStats.appdsp;
        avgCheese += entry.nerdStats.cheese;
        avgGBE += entry.nerdStats.gbe;
        avgNyaAPP += entry.nerdStats.nyaapp;
        avgArea += entry.nerdStats.area;
        avgEstTR += entry.estTr.esttr;
        avgEstAcc += entry.esttracc;
        avgOpener += entry.playstyle.opener;
        avgPlonk += entry.playstyle.plonk;
        avgStride += entry.playstyle.stride;
        avgInfDS += entry.playstyle.infds;
        totalGamesPlayed += entry.gamesPlayed;
        totalGamesWon += entry.gamesWon;
        if (entry.tr < lowestTR){
          lowestTR = entry.tr;
          lowestTRid = entry.userId;
          lowestTRnick = entry.username;
        }
        if (entry.glicko != null && entry.glicko! < lowestGlicko){
          lowestGlicko = entry.glicko!;
          lowestGlickoID = entry.userId;
          lowestGlickoNick = entry.username;
        }
        if (entry.rd != null && entry.rd! < lowestRD){
          lowestRD = entry.rd!;
          lowestRdID = entry.userId;
          lowestRdNick = entry.username;
        }
        if (entry.gamesPlayed < lowestGamesPlayed){
          lowestGamesPlayed = entry.gamesPlayed;
          lowestGamesPlayedID = entry.userId;
          lowestGamesPlayedNick = entry.username;
        }
        if (entry.gamesWon < lowestGamesWon){
          lowestGamesWon = entry.gamesWon;
          lowestGamesWonID = entry.userId;
          lowestGamesWonNick = entry.username;
        }
        if (entry.winrate < lowestWinrate){
          lowestWinrate = entry.winrate;
          lowestWinrateID = entry.userId;
          lowestWinrateNick = entry.username;
        }
        if (entry.apm < lowestAPM){
          lowestAPM = entry.apm;
          lowestAPMid = entry.userId;
          lowestAPMnick = entry.username;
        }
        if (entry.pps < lowestPPS){
          lowestPPS = entry.pps;
          lowestPPSid = entry.userId;
          lowestPPSnick = entry.username;
        }
        if (entry.vs < lowestVS){
          lowestVS = entry.vs;
          lowestVSid = entry.userId;
          lowestVSnick = entry.username;
        }
        if (entry.nerdStats.app < lowestAPP){
          lowestAPP = entry.nerdStats.app;
          lowestAPPid = entry.userId;
          lowestAPPnick = entry.username;
        }
        if (entry.nerdStats.vsapm < lowestVSAPM){
          lowestVSAPM = entry.nerdStats.vsapm;
          lowestVSAPMid = entry.userId;
          lowestVSAPMnick = entry.username;
        }
        if (entry.nerdStats.dss < lowestDSS){
          lowestDSS = entry.nerdStats.dss;
          lowestDSSid = entry.userId;
          lowestDSSnick = entry.username;
        }
        if (entry.nerdStats.dsp < lowestDSP){
          lowestDSP = entry.nerdStats.dsp;
          lowestDSPid = entry.userId;
          lowestDSPnick = entry.username;
        }
        if (entry.nerdStats.appdsp < lowestAPPDSP){
          lowestAPPDSP = entry.nerdStats.appdsp;
          lowestAPPDSPid = entry.userId;
          lowestAPPDSPnick = entry.username;
        }
        if (entry.nerdStats.cheese < lowestCheese){
          lowestCheese = entry.nerdStats.cheese;
          lowestCheeseID = entry.userId;
          lowestCheeseNick = entry.username;
        }
        if (entry.nerdStats.gbe < lowestGBE){
          lowestGBE = entry.nerdStats.gbe;
          lowestGBEid = entry.userId;
          lowestGBEnick = entry.username;
        }
        if (entry.nerdStats.nyaapp < lowestNyaAPP){
          lowestNyaAPP = entry.nerdStats.nyaapp;
          lowestNyaAPPid = entry.userId;
          lowestNyaAPPnick = entry.username;
        }
        if (entry.nerdStats.area < lowestArea){
          lowestArea = entry.nerdStats.area;
          lowestAreaID = entry.userId;
          lowestAreaNick = entry.username;
        }
        if (entry.estTr.esttr < lowestEstTR){
          lowestEstTR = entry.estTr.esttr;
          lowestEstTRid = entry.userId;
          lowestEstTRnick = entry.username;
        }
        if (entry.esttracc < lowestEstAcc){
          lowestEstAcc = entry.esttracc;
          lowestEstAccID = entry.userId;
          lowestEstAccNick = entry.username;
        }
        if (entry.playstyle.opener < lowestOpener){
          lowestOpener = entry.playstyle.opener;
          lowestOpenerID = entry.userId;
          lowestOpenerNick = entry.username;
        }
        if (entry.playstyle.plonk < lowestPlonk){
          lowestPlonk = entry.playstyle.plonk;
          lowestPlonkID = entry.userId;
          lowestPlonkNick = entry.username;
        }
        if (entry.playstyle.stride < lowestStride){
          lowestStride = entry.playstyle.stride;
          lowestStrideID = entry.userId;
          lowestStrideNick = entry.username;
        }
        if (entry.playstyle.infds < lowestInfDS){
          lowestInfDS = entry.playstyle.infds;
          lowestInfDSid = entry.userId;
          lowestInfDSnick = entry.username;
        }
        if (entry.tr > highestTR){
          highestTR = entry.tr;
          highestTRid = entry.userId;
          highestTRnick = entry.username;
        }
        if (entry.glicko != null && entry.glicko! > highestGlicko){
          highestGlicko = entry.glicko!;
          highestGlickoID = entry.userId;
          highestGlickoNick = entry.username;
        }
        if (entry.rd != null && entry.rd! > highestRD){
          highestRD = entry.rd!;
          highestRdID = entry.userId;
          highestRdNick = entry.username;
        }
        if (entry.gamesPlayed > highestGamesPlayed){
          highestGamesPlayed = entry.gamesPlayed;
          highestGamesPlayedID = entry.userId;
          highestGamesPlayedNick = entry.username;
        }
        if (entry.gamesWon > highestGamesWon){
          highestGamesWon = entry.gamesWon;
          highestGamesWonID = entry.userId;
          highestGamesWonNick = entry.username;
        }
        if (entry.winrate > highestWinrate){
          highestWinrate = entry.winrate;
          highestWinrateID = entry.userId;
          highestWinrateNick = entry.username;
        }
        if (entry.apm > highestAPM){
          highestAPM = entry.apm;
          highestAPMid = entry.userId;
          highestAPMnick = entry.username;
        }
        if (entry.pps > highestPPS){
          highestPPS = entry.pps;
          highestPPSid = entry.userId;
          highestPPSnick = entry.username;
        }
        if (entry.vs > highestVS){
          highestVS = entry.vs;
          highestVSid = entry.userId;
          highestVSnick = entry.username;
        }
        if (entry.nerdStats.app > highestAPP){
          highestAPP = entry.nerdStats.app;
          highestAPPid = entry.userId;
          highestAPPnick = entry.username;
        }
        if (entry.nerdStats.vsapm > highestVSAPM){
          highestVSAPM = entry.nerdStats.vsapm;
          highestVSAPMid = entry.userId;
          highestVSAPMnick = entry.username;
        }
        if (entry.nerdStats.dss > highestDSS){
          highestDSS = entry.nerdStats.dss;
          highestDSSid = entry.userId;
          highestDSSnick = entry.username;
        }
        if (entry.nerdStats.dsp > highestDSP){
          highestDSP = entry.nerdStats.dsp;
          highestDSPid = entry.userId;
          highestDSPnick = entry.username;
        }
        if (entry.nerdStats.appdsp > highestAPPDSP){
          highestAPPDSP = entry.nerdStats.appdsp;
          highestAPPDSPid = entry.userId;
          highestAPPDSPnick = entry.username;
        }
        if (entry.nerdStats.cheese > highestCheese){
          highestCheese = entry.nerdStats.cheese;
          highestCheeseID = entry.userId;
          highestCheeseNick = entry.username;
        }
        if (entry.nerdStats.gbe > highestGBE){
          highestGBE = entry.nerdStats.gbe;
          highestGBEid = entry.userId;
          highestGBEnick = entry.username;
        }
        if (entry.nerdStats.nyaapp > highestNyaAPP){
          highestNyaAPP = entry.nerdStats.nyaapp;
          highestNyaAPPid = entry.userId;
          highestNyaAPPnick = entry.username;
        }
        if (entry.nerdStats.area > highestArea){
          highestArea = entry.nerdStats.area;
          highestAreaID = entry.userId;
          highestAreaNick = entry.username;
        }
        if (entry.estTr.esttr > highestEstTR){
          highestEstTR = entry.estTr.esttr;
          highestEstTRid = entry.userId;
          highestEstTRnick = entry.username;
        }
        if (entry.esttracc > highestEstAcc){
          highestEstAcc = entry.esttracc;
          highestEstAccID = entry.userId;
          highestEstAccNick = entry.username;
        }
        if (entry.playstyle.opener > highestOpener){
          highestOpener = entry.playstyle.opener;
          highestOpenerID = entry.userId;
          highestOpenerNick = entry.username;
        }
        if (entry.playstyle.plonk > highestPlonk){
          highestPlonk = entry.playstyle.plonk;
          highestPlonkID = entry.userId;
          highestPlonkNick = entry.username;
        }
        if (entry.playstyle.stride > highestStride){
          highestStride = entry.playstyle.stride;
          highestStrideID = entry.userId;
          highestStrideNick = entry.username;
        }
        if (entry.playstyle.infds > highestInfDS){
          highestInfDS = entry.playstyle.infds;
          highestInfDSid = entry.userId;
          highestInfDSnick = entry.username;
        }
      }
      avgAPM /= filtredLeaderboard.length;
      avgPPS /= filtredLeaderboard.length;
      avgVS /= filtredLeaderboard.length;
      avgTR /= filtredLeaderboard.length;
      avgGlicko /= filtredLeaderboard.length;
      avgRD /= filtredLeaderboard.length;
      avgAPP /= filtredLeaderboard.length;
      avgVSAPM /= filtredLeaderboard.length;
      avgDSS /= filtredLeaderboard.length;
      avgDSP /= filtredLeaderboard.length;
      avgAPPDSP /= leaderboard.length;
      avgCheese /= filtredLeaderboard.length;
      avgGBE /= filtredLeaderboard.length;
      avgNyaAPP /= filtredLeaderboard.length;
      avgArea /= filtredLeaderboard.length;
      avgEstTR /= filtredLeaderboard.length;
      avgEstAcc /= filtredLeaderboard.length;
      avgOpener /= filtredLeaderboard.length;
      avgPlonk /= filtredLeaderboard.length;
      avgStride /= filtredLeaderboard.length;
      avgInfDS /= filtredLeaderboard.length;
      avgGamesPlayed = (totalGamesPlayed / filtredLeaderboard.length).floor();
      avgGamesWon = (totalGamesWon / filtredLeaderboard.length).floor();
      return [TetraLeague(timestamp: DateTime.now(), apm: avgAPM, pps: avgPPS, vs: avgVS, glicko: avgGlicko, rd: avgRD, gamesPlayed: avgGamesPlayed, gamesWon: avgGamesWon, bestRank: rank, gxe: -1, decaying: false, tr: avgTR, rank: rank == "" ? "z" : rank, percentileRank: rank, percentile: rankCutoffs[rank]!, standing: -1, standingLocal: -1, nextAt: -1, prevAt: -1),
      {
        "everyone": rank == "",
        "totalGamesPlayed": totalGamesPlayed,
        "totalGamesWon": totalGamesWon,
        "players": filtredLeaderboard.length,
        "lowestTR": lowestTR,
        "lowestTRid": lowestTRid,
        "lowestTRnick": lowestTRnick,
        "lowestGlicko": lowestGlicko,
        "lowestGlickoID": lowestGlickoID,
        "lowestGlickoNick": lowestGlickoNick,
        "lowestRD": lowestRD,
        "lowestRdID": lowestRdID,
        "lowestRdNick": lowestRdNick,
        "lowestGamesPlayed": lowestGamesPlayed,
        "lowestGamesPlayedID": lowestGamesPlayedID,
        "lowestGamesPlayedNick": lowestGamesPlayedNick,
        "lowestGamesWon": lowestGamesWon,
        "lowestGamesWonID": lowestGamesWonID,
        "lowestGamesWonNick": lowestGamesWonNick,
        "lowestWinrate": lowestWinrate,
        "lowestWinrateID": lowestWinrateID,
        "lowestWinrateNick": lowestWinrateNick,
        "lowestAPM": lowestAPM,
        "lowestAPMid": lowestAPMid,
        "lowestAPMnick": lowestAPMnick,
        "lowestPPS": lowestPPS,
        "lowestPPSid": lowestPPSid,
        "lowestPPSnick": lowestPPSnick,
        "lowestVS": lowestVS,
        "lowestVSid": lowestVSid,
        "lowestVSnick": lowestVSnick,
        "lowestAPP": lowestAPP,
        "lowestAPPid": lowestAPPid,
        "lowestAPPnick": lowestAPPnick,
        "lowestVSAPM": lowestVSAPM,
        "lowestVSAPMid": lowestVSAPMid,
        "lowestVSAPMnick": lowestVSAPMnick,
        "lowestDSS": lowestDSS,
        "lowestDSSid": lowestDSSid,
        "lowestDSSnick": lowestDSSnick,
        "lowestDSP": lowestDSP,
        "lowestDSPid": lowestDSPid,
        "lowestDSPnick": lowestDSPnick,
        "lowestAPPDSP": lowestAPPDSP,
        "lowestAPPDSPid": lowestAPPDSPid,
        "lowestAPPDSPnick": lowestAPPDSPnick,
        "lowestCheese": lowestCheese,
        "lowestCheeseID": lowestCheeseID,
        "lowestCheeseNick": lowestCheeseNick,
        "lowestGBE": lowestGBE,
        "lowestGBEid": lowestGBEid,
        "lowestGBEnick": lowestGBEnick,
        "lowestNyaAPP": lowestNyaAPP,
        "lowestNyaAPPid": lowestNyaAPPid,
        "lowestNyaAPPnick": lowestNyaAPPnick,
        "lowestArea": lowestArea,
        "lowestAreaID": lowestAreaID,
        "lowestAreaNick": lowestAreaNick,
        "lowestEstTR": lowestEstTR,
        "lowestEstTRid": lowestEstTRid,
        "lowestEstTRnick": lowestEstTRnick,
        "lowestEstAcc": lowestEstAcc,
        "lowestEstAccID": lowestEstAccID,
        "lowestEstAccNick": lowestEstAccNick,
        "lowestOpener": lowestOpener,
        "lowestOpenerID": lowestOpenerID,
        "lowestOpenerNick": lowestOpenerNick,
        "lowestPlonk": lowestPlonk,
        "lowestPlonkID": lowestPlonkID,
        "lowestPlonkNick": lowestPlonkNick,
        "lowestStride": lowestStride,
        "lowestStrideID": lowestStrideID,
        "lowestStrideNick": lowestStrideNick,
        "lowestInfDS": lowestInfDS,
        "lowestInfDSid": lowestInfDSid,
        "lowestInfDSnick": lowestInfDSnick,
        "highestTR": highestTR,
        "highestTRid": highestTRid,
        "highestTRnick": highestTRnick,
        "highestGlicko": highestGlicko,
        "highestGlickoID": highestGlickoID,
        "highestGlickoNick": highestGlickoNick,
        "highestRD": highestRD,
        "highestRdID": highestRdID,
        "highestRdNick": highestRdNick,
        "highestGamesPlayed": highestGamesPlayed,
        "highestGamesPlayedID": highestGamesPlayedID,
        "highestGamesPlayedNick": highestGamesPlayedNick,
        "highestGamesWon": highestGamesWon,
        "highestGamesWonID": highestGamesWonID,
        "highestGamesWonNick": highestGamesWonNick,
        "highestWinrate": highestWinrate,
        "highestWinrateID": highestWinrateID,
        "highestWinrateNick": highestWinrateNick,
        "highestAPM": highestAPM,
        "highestAPMid": highestAPMid,
        "highestAPMnick": highestAPMnick,
        "highestPPS": highestPPS,
        "highestPPSid": highestPPSid,
        "highestPPSnick": highestPPSnick,
        "highestVS": highestVS,
        "highestVSid": highestVSid,
        "highestVSnick": highestVSnick,
        "highestAPP": highestAPP,
        "highestAPPid": highestAPPid,
        "highestAPPnick": highestAPPnick,
        "highestVSAPM": highestVSAPM,
        "highestVSAPMid": highestVSAPMid,
        "highestVSAPMnick": highestVSAPMnick,
        "highestDSS": highestDSS,
        "highestDSSid": highestDSSid,
        "highestDSSnick": highestDSSnick,
        "highestDSP": highestDSP,
        "highestDSPid": highestDSPid,
        "highestDSPnick": highestDSPnick,
        "highestAPPDSP": highestAPPDSP,
        "highestAPPDSPid": highestAPPDSPid,
        "highestAPPDSPnick": highestAPPDSPnick,
        "highestCheese": highestCheese,
        "highestCheeseID": highestCheeseID,
        "highestCheeseNick": highestCheeseNick,
        "highestGBE": highestGBE,
        "highestGBEid": highestGBEid,
        "highestGBEnick": highestGBEnick,
        "highestNyaAPP": highestNyaAPP,
        "highestNyaAPPid": highestNyaAPPid,
        "highestNyaAPPnick": highestNyaAPPnick,
        "highestArea": highestArea,
        "highestAreaID": highestAreaID,
        "highestAreaNick": highestAreaNick,
        "highestEstTR": highestEstTR,
        "highestEstTRid": highestEstTRid,
        "highestEstTRnick": highestEstTRnick,
        "highestEstAcc": highestEstAcc,
        "highestEstAccID": highestEstAccID,
        "highestEstAccNick": highestEstAccNick,
        "highestOpener": highestOpener,
        "highestOpenerID": highestOpenerID,
        "highestOpenerNick": highestOpenerNick,
        "highestPlonk": highestPlonk,
        "highestPlonkID": highestPlonkID,
        "highestPlonkNick": highestPlonkNick,
        "highestStride": highestStride,
        "highestStrideID": highestStrideID,
        "highestStrideNick": highestStrideNick,
        "highestInfDS": highestInfDS,
        "highestInfDSid": highestInfDSid,
        "highestInfDSnick": highestInfDSnick,
        "avgAPP": avgAPP,
        "avgVSAPM": avgVSAPM,
        "avgDSS": avgDSS,
        "avgDSP": avgDSP,
        "avgAPPDSP": avgAPPDSP,
        "avgCheese": avgCheese,
        "avgGBE": avgGBE,
        "avgNyaAPP": avgNyaAPP,
        "avgArea": avgArea,
        "avgEstTR": avgEstTR,
        "avgEstAcc": avgEstAcc,
        "avgOpener": avgOpener,
        "avgPlonk": avgPlonk,
        "avgStride": avgStride,
        "avgInfDS": avgInfDS,
        "toEnterTR": rank.toLowerCase() != "z" ? leaderboard[(leaderboard.length * rankCutoffs[rank]!).floor()].tr : lowestTR,
        "toEnterGlicko": rank.toLowerCase() != "z" ? leaderboard[(leaderboard.length * rankCutoffs[rank]!).floor()].glicko : 0,
        "entries": filtredLeaderboard
      }];
    }else{
      return [TetraLeague(timestamp: DateTime.now(), apm: 0, pps: 0, vs: 0, glicko: 0, rd: noTrRd, gamesPlayed: 0, gamesWon: 0, bestRank: rank, decaying: false, tr: 0, rank: rank, percentileRank: rank, gxe: -1, percentile: rankCutoffs[rank]!, standing: -1, standingLocal: -1, nextAt: -1, prevAt: -1),
      {"players": filtredLeaderboard.length, "lowestTR": 0, "toEnterTR": 0, "toEnterGlicko": 0}];
    }
  }

  PlayerLeaderboardPosition? getLeaderboardPosition(TetrioPlayer user) {
    if (user.tlSeason1?.gamesPlayed == 0) return null;
    bool fakePositions = false;
    late List<TetrioPlayerFromLeaderboard> copyOfLeaderboard;
    if (leaderboard.indexWhere((element) => element.userId == user.userId) == -1){
      fakePositions =true;
      copyOfLeaderboard = List.of(leaderboard);
      copyOfLeaderboard.add(user.convertToPlayerFromLeaderboard());
    } 
    List<Stats> stats = [Stats.apm, Stats.pps, Stats.vs, Stats.gp, Stats.gw, Stats.wr,
    Stats.app, Stats.vsapm, Stats.dss, Stats.dsp, Stats.appdsp, Stats.cheese, Stats.gbe, Stats.nyaapp, Stats.area, Stats.eTR, Stats.acceTR];
    List<LeaderboardPosition?> results = [];
    for (Stats stat in stats) {
      List<TetrioPlayerFromLeaderboard> sortedLeaderboard = getStatRanking(fakePositions ? copyOfLeaderboard : leaderboard, stat, reversed: stat == Stats.cheese ? true : false);
      int position = sortedLeaderboard.indexWhere((element) => element.userId == user.userId) + 1;
      if (position == 0) {
        results.add(null);
      } else {
        results.add(LeaderboardPosition(fakePositions ? 1001 : position, position / sortedLeaderboard.length));
      }
    }
    return PlayerLeaderboardPosition.fromSearchResults(results);
  }

  Map<String, List<dynamic>> get averages => {
    'x+': getAverageOfRank("x+"),
    'x': getAverageOfRank("x"),
    'u': getAverageOfRank("u"),
    'ss': getAverageOfRank("ss"),
    's+': getAverageOfRank("s+"),
    's': getAverageOfRank("s"),
    's-': getAverageOfRank("s-"),
    'a+': getAverageOfRank("a+"),
    'a': getAverageOfRank("a"),
    'a-': getAverageOfRank("a-"),
    'b+': getAverageOfRank("b+"),
    'b': getAverageOfRank("b"),
    'b-': getAverageOfRank("b-"),
    'c+': getAverageOfRank("c+"),
    'c': getAverageOfRank("c"),
    'c-': getAverageOfRank("c-"),
    'd+': getAverageOfRank("d+"),
    'd': getAverageOfRank("d"),
    'z': getAverageOfRank("z")
    };

  Map<String, double> get cutoffs => {
    'x': getAverageOfRank("x")[1]["toEnterTR"],
    'u': getAverageOfRank("u")[1]["toEnterTR"],
    'ss': getAverageOfRank("ss")[1]["toEnterTR"],
    's+': getAverageOfRank("s+")[1]["toEnterTR"],
    's': getAverageOfRank("s")[1]["toEnterTR"],
    's-': getAverageOfRank("s-")[1]["toEnterTR"],
    'a+': getAverageOfRank("a+")[1]["toEnterTR"],
    'a': getAverageOfRank("a")[1]["toEnterTR"],
    'a-': getAverageOfRank("a-")[1]["toEnterTR"],
    'b+': getAverageOfRank("b+")[1]["toEnterTR"],
    'b': getAverageOfRank("b")[1]["toEnterTR"],
    'b-': getAverageOfRank("b-")[1]["toEnterTR"],
    'c+': getAverageOfRank("c+")[1]["toEnterTR"],
    'c': getAverageOfRank("c")[1]["toEnterTR"],
    'c-': getAverageOfRank("c-")[1]["toEnterTR"],
    'd+': getAverageOfRank("d+")[1]["toEnterTR"],
    'd': getAverageOfRank("d")[1]["toEnterTR"]
    };

  Map<String, double> get cutoffsGlicko => {
    'x': getAverageOfRank("x")[1]["toEnterGlicko"],
    'u': getAverageOfRank("u")[1]["toEnterGlicko"],
    'ss': getAverageOfRank("ss")[1]["toEnterGlicko"],
    's+': getAverageOfRank("s+")[1]["toEnterGlicko"],
    's': getAverageOfRank("s")[1]["toEnterGlicko"],
    's-': getAverageOfRank("s-")[1]["toEnterGlicko"],
    'a+': getAverageOfRank("a+")[1]["toEnterGlicko"],
    'a': getAverageOfRank("a")[1]["toEnterGlicko"],
    'a-': getAverageOfRank("a-")[1]["toEnterGlicko"],
    'b+': getAverageOfRank("b+")[1]["toEnterGlicko"],
    'b': getAverageOfRank("b")[1]["toEnterGlicko"],
    'b-': getAverageOfRank("b-")[1]["toEnterGlicko"],
    'c+': getAverageOfRank("c+")[1]["toEnterGlicko"],
    'c': getAverageOfRank("c")[1]["toEnterGlicko"],
    'c-': getAverageOfRank("c-")[1]["toEnterGlicko"],
    'd+': getAverageOfRank("d+")[1]["toEnterGlicko"],
    'd': getAverageOfRank("d")[1]["toEnterGlicko"]
    };

  TetrioPlayersLeaderboard.fromJson(List<dynamic> json, String t, DateTime ts) {
    type = t;
    timestamp = ts;
    leaderboard = [];
    for (Map<String, dynamic> entry in json) {
      leaderboard.add(TetrioPlayerFromLeaderboard.fromJson(entry, ts));
    }
  }

  addPlayers(List<TetrioPlayerFromLeaderboard> list){
    leaderboard.addAll(list);
  }
}

class TetrioPlayerFromLeaderboard {
  late String userId;
  late String username;
  late String role;
  late double xp;
  String? country;
  late DateTime timestamp;
  late int gamesPlayed;
  late int gamesWon;
  late double tr;
  late double? glicko;
  late double? rd;
  late String rank;
  late String? bestRank;
  late double apm;
  late double pps;
  late double vs;
  late bool decaying;
  late NerdStats nerdStats;
  late EstTr estTr;
  late Playstyle playstyle;

  TetrioPlayerFromLeaderboard(
    this.userId,
    this.username,
    this.role,
    this.xp,
    this.country,
    this.timestamp,
    this.gamesPlayed,
    this.gamesWon,
    this.tr,
    this.glicko,
    this.rd,
    this.rank,
    this.bestRank,
    this.apm,
    this.pps,
    this.vs,
    this.decaying){
      nerdStats =  NerdStats(apm, pps, vs);
      estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
      playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
    }

  double get winrate => gamesWon / gamesPlayed;
  double get esttracc => estTr.esttr - tr;

  TetrioPlayerFromLeaderboard.fromJson(Map<String, dynamic> json, DateTime ts) {
    userId = json['_id'];
    username = json['username'];
    role = json['role'];
    xp = json['xp'].toDouble();
    country = json['country'];
    timestamp = ts;
    gamesPlayed = json['league']['gamesplayed'] as int;
    gamesWon = json['league']['gameswon'] as int;
    tr = json['league']['tr'] != null ? json['league']['tr'].toDouble() : 0;
    glicko = json['league']['glicko']?.toDouble();
    rd = json['league']['rd']?.toDouble();
    rank = json['league']['rank'];
    bestRank = json['league']['bestrank'];
    apm = json['league']['apm'] != null ? json['league']['apm'].toDouble() : 0.00;
    pps = json['league']['pps'] != null ? json['league']['pps'].toDouble() : 0.00;
    vs = json['league']['vs'] != null ? json['league']['vs'].toDouble(): 0.00;
    decaying = json['league']['decaying'];
    nerdStats =  NerdStats(apm, pps, vs);
    estTr = EstTr(apm, pps, vs, nerdStats.app, nerdStats.dss, nerdStats.dsp, nerdStats.gbe);
    playstyle = Playstyle(apm, pps, nerdStats.app, nerdStats.vsapm, nerdStats.dsp, nerdStats.gbe, estTr.srarea, estTr.statrank);
  }

  num getStatByEnum(Stats stat){
    switch (stat) {
      case Stats.tr:
        return tr;
      case Stats.glicko:
        return glicko??-1;
      case Stats.rd:
        return rd??-1;
      case Stats.gp:
        return gamesPlayed;
      case Stats.gw:
        return gamesWon;
      case Stats.wr:
        return winrate*100;
      case Stats.apm:
        return apm;
      case Stats.pps:
        return pps;
      case Stats.vs:
        return vs;
      case Stats.app:
        return nerdStats.app;
      case Stats.dss:
        return nerdStats.dss;
      case Stats.dsp:
        return nerdStats.dsp;
      case Stats.appdsp:
        return nerdStats.appdsp;
      case Stats.vsapm:
        return nerdStats.vsapm;
      case Stats.cheese:
        return nerdStats.cheese;
      case Stats.gbe:
        return nerdStats.gbe;
      case Stats.nyaapp:
        return nerdStats.nyaapp;
      case Stats.area:
        return nerdStats.area;
      case Stats.eTR:
        return estTr.esttr;
      case Stats.acceTR:
        return esttracc;
      case Stats.acceTRabs:
        return esttracc.abs();
      case Stats.opener:
        return playstyle.opener;
      case Stats.plonk:
        return playstyle.plonk;
      case Stats.infDS:
        return playstyle.infds;
      case Stats.stride:
        return playstyle.stride;
      case Stats.stridemMinusPlonk:
        return playstyle.stride - playstyle.plonk;
      case Stats.openerMinusInfDS:
        return playstyle.opener - playstyle.infds;
    }
  }
}
