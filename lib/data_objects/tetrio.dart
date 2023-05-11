import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<TetrioPlayer> fetchTetrioRecords(String user) async {
  var url = Uri.https('ch.tetr.io', 'api/users/$user/records');
  final response = await http.get(url);
  // final response = await http.get(Uri.parse('https://ch.tetr.io/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return TetrioPlayer.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch player');
  }
}

Duration doubleSecondsToDuration(double value) {
  value = value * 1000000;
  return Duration(microseconds: value.floor());
}

class TetrioPlayer {
  String? userId;
  String? username;
  String? role;
  int? avatarRevision;
  int? bannerRevision;
  DateTime? registrationTime;
  List<Badge>? badges;
  String? bio;
  String? country;
  int? friendCount;
  int? gamesPlayed;
  int? gamesWon;
  Duration? gameTime;
  double? xp;
  int? supporterTier;
  bool? verified;
  Connections? connections;
  TetraLeagueAlpha? tlSeason1;
  List<RecordSingle>? sprint;
  List<RecordSingle>? blitz;
  TetrioZen? zen;

  TetrioPlayer({
    this.userId,
    this.username,
    this.role,
    this.registrationTime,
    this.badges,
    this.bio,
    this.country,
    this.friendCount,
    this.gamesPlayed,
    this.gamesWon,
    this.gameTime,
    this.xp,
    this.supporterTier,
    this.verified,
    this.connections,
    this.tlSeason1,
    this.sprint,
    this.blitz,
    this.zen,
  });

  double getLevel() {
    return pow((xp! / 500), 0.6) +
        (xp! / (5000 + (max(0, xp! - 4 * pow(10, 6)) / 5000))) +
        1;
  }

  TetrioPlayer.fromJson(Map<String, dynamic> json) {
    userId = json['_id'];
    username = json['username'];
    role = json['role'];
    registrationTime = json['ts'] != null ? DateTime.parse(json['ts']) : null;
    if (json['badges'] != null) {
      badges = <Badge>[];
      json['badges'].forEach((v) {
        badges!.add(Badge.fromJson(v));
      });
    }
    xp = json['xp'].toDouble();
    gamesPlayed = json['gamesplayed'];
    gamesWon = json['gameswon'];
    gameTime = doubleSecondsToDuration(json['gametime'].toDouble());
    country = json['country'];
    supporterTier = json['supporter_tier'];
    verified = json['verified'];
    tlSeason1 = json['league'] != null
        ? TetraLeagueAlpha.fromJson(json['league'])
        : null;
    avatarRevision = json['avatar_revision'];
    bannerRevision = json['banner_revision'];
    bio = json['bio'];
    connections = json['connections'] != null
        ? Connections.fromJson(json['connections'])
        : null;
    var url = Uri.https('ch.tetr.io', 'api/users/$userId/records');
    Future response = http.get(url);
    response.then((value) {
      if (value.statusCode == 200) {
        sprint = jsonDecode(value.body)['data']['records']['40l']['record'] !=
                null
            ? [
                RecordSingle.fromJson(
                    jsonDecode(value.body)['data']['records']['40l']['record'])
              ]
            : null;
        blitz =
            jsonDecode(value.body)['data']['records']['blitz']['record'] != null
                ? [
                    RecordSingle.fromJson(jsonDecode(value.body)['data']
                        ['records']['blitz']['record'])
                  ]
                : null;
        zen = TetrioZen.fromJson(jsonDecode(value.body)['data']['zen']);
      } else {
        throw Exception('Failed to fetch player');
      }
    });
    friendCount = json['friend_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = userId;
    data['username'] = username;
    data['role'] = role;
    data['ts'] = registrationTime;
    if (badges != null) {
      data['badges'] = badges!.map((v) => v.toJson()).toList();
    }
    data['xp'] = xp;
    data['gamesplayed'] = gamesPlayed;
    data['gameswon'] = gamesWon;
    data['gametime'] = gameTime;
    data['country'] = country;
    data['supporter_tier'] = supporterTier;
    data['verified'] = verified;
    if (tlSeason1 != null) {
      data['league'] = tlSeason1!.toJson();
    }
    data['avatar_revision'] = avatarRevision;
    data['banner_revision'] = bannerRevision;
    data['bio'] = bio;
    if (connections != null) {
      data['connections'] = connections!.toJson();
    }
    data['friend_count'] = friendCount;
    return data;
  }
}

class Badge {
  String? badgeId;
  String? label;
  DateTime? ts;

  Badge({required this.badgeId, required this.label, required this.ts});

  Badge.fromJson(Map<String, dynamic> json) {
    badgeId = json['id'];
    label = json['label'];
    ts = json['ts'] != null ? DateTime.parse(json['ts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = badgeId;
    data['label'] = label;
    data['ts'] = ts;
    return data;
  }
}

class Connections {
  Discord? discord;

  Connections({this.discord});

  Connections.fromJson(Map<String, dynamic> json) {
    discord =
        json['discord'] != null ? Discord.fromJson(json['discord']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (discord != null) {
      data['discord'] = discord!.toJson();
    }
    return data;
  }
}

class Clears {
  int? singles;
  int? doubles;
  int? triples;
  int? quads;
  int? allClears;
  int? tSpinZeros;
  int? tSpinSingles;
  int? tSpinDoubles;
  int? tSpinTriples;
  int? tSpinQuads;
  int? tSpinMiniZeros;
  int? tSpinMiniSingles;
  int? tSpinMiniDoubles;

  Clears(
      {this.singles,
      this.doubles,
      this.triples,
      this.quads,
      this.allClears,
      this.tSpinZeros,
      this.tSpinSingles,
      this.tSpinDoubles,
      this.tSpinTriples,
      this.tSpinQuads,
      this.tSpinMiniZeros,
      this.tSpinMiniSingles,
      this.tSpinMiniDoubles});

  Clears.fromJson(Map<String, dynamic> json) {
    singles = json['singles'];
    doubles = json['doubles'];
    triples = json['triples'];
    quads = json['quads'];
    tSpinZeros = json['realtspins'];
    tSpinMiniZeros = json['minitspins'];
    tSpinMiniSingles = json['minitspinsingles'];
    tSpinSingles = json['tspinsingles'];
    tSpinMiniDoubles = json['minitspindoubles'];
    tSpinDoubles = json['tspindoubles'];
    tSpinTriples = json['tspintriples'];
    tSpinQuads = json['tspinquads'];
    allClears = json['allclear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['singles'] = singles;
    data['doubles'] = doubles;
    data['triples'] = triples;
    data['quads'] = quads;
    data['realtspins'] = tSpinZeros;
    data['minitspins'] = tSpinMiniZeros;
    data['minitspinsingles'] = tSpinMiniSingles;
    data['tspinsingles'] = tSpinSingles;
    data['minitspindoubles'] = tSpinMiniDoubles;
    data['tspindoubles'] = tSpinDoubles;
    data['tspintriples'] = tSpinTriples;
    data['tspinquads'] = tSpinQuads;
    data['allclear'] = allClears;
    return data;
  }
}

class Discord {
  String? id;
  String? username;

  Discord({this.id, this.username});

  Discord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}

class Finesse {
  int? combo;
  int? faults;
  int? perfectPieces;

  Finesse({this.combo, this.faults, this.perfectPieces});

  Finesse.fromJson(Map<String, dynamic> json) {
    combo = json['combo'];
    faults = json['faults'];
    perfectPieces = json['perfectpieces'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['combo'] = combo;
    data['faults'] = faults;
    data['perfectpieces'] = perfectPieces;
    return data;
  }
}

class EndContextSingle {
  String? gameType;
  int? topBtB;
  int? topCombo;
  int? holds;
  int? inputs;
  int? level;
  int? piecesPlaced;
  int? lines;
  int? score;
  int? seed;
  Duration? finalTime;
  int? tSpins;
  Clears? clears;
  Finesse? finesse;

  EndContextSingle(
      {this.gameType,
      this.topBtB,
      this.topCombo,
      this.holds,
      this.inputs,
      this.level,
      this.piecesPlaced,
      this.lines,
      this.score,
      this.seed,
      this.finalTime,
      this.tSpins,
      this.clears,
      this.finesse});

  EndContextSingle.fromJson(Map<String, dynamic> json) {
    seed = json['seed'];
    lines = json['lines'];
    inputs = json['inputs'];
    holds = json['holds'];
    finalTime = doubleSecondsToDuration(json['finalTime'].toDouble());
    score = json['score'];
    level = json['level'];
    topCombo = json['topcombo'];
    topBtB = json['topbtb'];
    tSpins = json['tspins'];
    piecesPlaced = json['piecesplaced'];
    clears = json['clears'] != null ? Clears.fromJson(json['clears']) : null;
    finesse =
        json['finesse'] != null ? Finesse.fromJson(json['finesse']) : null;
    gameType = json['gametype'];
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
    if (clears != null) {
      data['clears'] = clears!.toJson();
    }
    if (finesse != null) {
      data['finesse'] = finesse!.toJson();
    }
    data['finalTime'] = finalTime;
    data['gametype'] = gameType;
    return data;
  }
}

class Handling {
  double? arr;
  double? das;
  int? sdf;
  int? dcd;
  bool? cancel;
  bool? safeLock;

  Handling(
      {this.arr, this.das, this.sdf, this.dcd, this.cancel, this.safeLock});

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
    data['arr'] = arr;
    data['das'] = das;
    data['dcd'] = dcd;
    data['sdf'] = sdf;
    data['safelock'] = safeLock;
    data['cancel'] = cancel;
    return data;
  }
}

class EndContextMulti {
  String? userId;
  int? naturalOrder;
  int? inputs;
  int? piecesPlaced;
  Handling? handling;
  int? points;
  int? wins;
  double? secondary;
  List<double>? secondaryTracking;
  double? tertiary;
  List<double>? tertiaryTracking;
  double? extra;
  List<double>? extraTracking;
  bool? success;

  EndContextMulti(
      {this.userId,
      this.naturalOrder,
      this.inputs,
      this.piecesPlaced,
      this.handling,
      this.points,
      this.wins,
      this.secondary,
      this.secondaryTracking,
      this.tertiary,
      this.tertiaryTracking,
      this.extra,
      this.extraTracking,
      this.success});

  EndContextMulti.fromJson(Map<String, dynamic> json) {
    userId = json['user']['_id'];
    handling =
        json['handling'] != null ? Handling.fromJson(json['handling']) : null;
    success = json['success'];
    inputs = json['inputs'];
    piecesPlaced = json['piecesplaced'];
    naturalOrder = json['naturalorder'];
    wins = json['wins'];
    points = json['points']['primary'];
    secondary = json['points']['secondary'];
    tertiary = json['points']['tertiary'];
    secondaryTracking = json['points']['secondaryAvgTracking'].cast<double>();
    tertiaryTracking = json['points']['tertiaryAvgTracking'].cast<double>();
    extra = json['points']['extra']['vs'];
    extraTracking = json['points']['extraAvgTracking']
            ['aggregatestats___vsscore']
        .cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = userId;
    if (handling != null) {
      data['handling'] = handling!.toJson();
    }
    data['success'] = success;
    data['inputs'] = inputs;
    data['piecesplaced'] = piecesPlaced;
    data['naturalorder'] = naturalOrder;
    data['wins'] = wins;
    data['points']['primary'] = points;
    data['points']['secondary'] = secondary;
    data['points']['tertiary'] = tertiary;
    data['points']['extra']['vs'] = extra;
    data['points']['extraAvgTracking']['aggregatestats___vsscore'] =
        extraTracking;
    return data;
  }
}

class TetraLeagueAlpha {
  String? userId;
  int? gamesPlayed;
  int? gamesWon;
  String? bestRank;
  bool? decaying;
  double? rating;
  String? rank;
  double? glicko;
  double? rd;
  String? percentileRank;
  double? percentile;
  int? standing;
  int? standingLocal;
  String? nextRank;
  int? nextAt;
  String? prevRank;
  int? prevAt;
  double? apm;
  double? pps;
  double? vs;
  List? records;

  TetraLeagueAlpha(
      {this.userId,
      this.gamesPlayed,
      this.gamesWon,
      this.bestRank,
      this.decaying,
      this.rating,
      this.rank,
      this.glicko,
      this.rd,
      this.percentileRank,
      this.percentile,
      this.standing,
      this.standingLocal,
      this.nextRank,
      this.nextAt,
      this.prevRank,
      this.prevAt,
      this.apm,
      this.pps,
      this.vs,
      this.records});

  TetraLeagueAlpha.fromJson(Map<String, dynamic> json) {
    gamesPlayed = json['gamesplayed'];
    gamesWon = json['gameswon'];
    rating = json['rating'].toDouble();
    glicko = json['glicko']?.toDouble();
    rd = json['rd']?.toDouble();
    rank = json['rank'];
    bestRank = json['bestrank'];
    apm = json['apm']?.toDouble();
    pps = json['pps']?.toDouble();
    vs = json['vs']?.toDouble();
    decaying = json['decaying'];
    standing = json['standing'];
    percentile = json['percentile'].toDouble();
    standingLocal = json['standing_local'];
    prevRank = json['prev_rank'];
    prevAt = json['prev_at'];
    nextRank = json['next_rank'];
    nextAt = json['next_at'];
    percentileRank = json['percentile_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gamesplayed'] = gamesPlayed;
    data['gameswon'] = gamesWon;
    data['rating'] = rating;
    data['glicko'] = glicko;
    data['rd'] = rd;
    data['rank'] = rank;
    data['bestrank'] = bestRank;
    data['apm'] = apm;
    data['pps'] = pps;
    data['vs'] = vs;
    data['decaying'] = decaying;
    data['standing'] = standing;
    data['percentile'] = percentile;
    data['standing_local'] = standingLocal;
    data['prev_rank'] = prevRank;
    data['prev_at'] = prevAt;
    data['next_rank'] = nextRank;
    data['next_at'] = nextAt;
    data['percentile_rank'] = percentileRank;
    return data;
  }
}

class RecordSingle {
  String? userId;
  String? replayId;
  String? ownId;
  DateTime? timestamp;
  EndContextSingle? endContext;
  int? rank;

  RecordSingle(
      {this.userId,
      this.replayId,
      this.ownId,
      this.timestamp,
      this.endContext,
      this.rank});

  RecordSingle.fromJson(Map<String, dynamic> json) {
    ownId = json['_id'];
    endContext = json['endcontext'] != null
        ? EndContextSingle.fromJson(json['endcontext'])
        : null;
    replayId = json['replayid'];
    timestamp = DateTime.parse(json['ts']);
    userId = json['user']['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = ownId;
    if (endContext != null) {
      data['endcontext'] = endContext!.toJson();
    }
    data['ismulti'] = false;
    data['replayid'] = replayId;
    data['ts'] = timestamp;
    data['user_id'] = userId;
    return data;
  }
}

class TetrioZen {
  String? userId;
  int? level;
  int? score;

  TetrioZen({this.userId, this.level, this.score});

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
