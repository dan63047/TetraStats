import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool? bot;
  late Connections connections;
  late TetraLeagueAlpha tlSeason1;
  List<RecordSingle?> sprint = [];
  List<RecordSingle?> blitz = [];
  TetrioZen? zen;
  Distinguishment? distinguishment;

  TetrioPlayer({
    required this.userId,
    required this.username,
    required this.role,
    required this.state,
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
    required this.connections,
    required this.tlSeason1,
    required this.sprint,
    required this.blitz,
    this.zen,
  });

  double get level =>
      pow((xp / 500), 0.6) +
      (xp / (5000 + (max(0, xp - 4 * pow(10, 6)) / 5000))) +
      1;

  TetrioPlayer.fromJson(Map<String, dynamic> json, DateTime stateTime) {
    userId = json['_id'];
    username = json['username'];
    state = stateTime;
    role = json['role'];
    registrationTime = json['ts'] != null ? DateTime.parse(json['ts']) : null;
    if (json['badges'] != null) {
      json['badges'].forEach((v) {
        badges.add(Badge.fromJson(v));
      });
    }
    xp = json['xp'].toDouble();
    gamesPlayed = json['gamesplayed'];
    gamesWon = json['gameswon'];
    gameTime = doubleSecondsToDuration(json['gametime'].toDouble());
    country = json['country'];
    supporterTier = json['supporter_tier'];
    verified = json['verified'];
    tlSeason1 = TetraLeagueAlpha.fromJson(json['league']);
    avatarRevision = json['avatar_revision'];
    bannerRevision = json['banner_revision'];
    bio = json['bio'];
    connections = Connections.fromJson(json['connections']);
    distinguishment = json['distinguishment'] != null
        ? Distinguishment.fromJson(json['distinguishment'])
        : null;
    friendCount = json['friend_count'];
  }

  Future<void> getRecords() async {
    var url = Uri.https('ch.tetr.io', 'api/users/$userId/records');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data']['records']['40l']['record'] !=
          null) {
        sprint.add(RecordSingle.fromJson(
            jsonDecode(response.body)['data']['records']['40l']['record']));
      }
      if (jsonDecode(response.body)['data']['records']['blitz']['record'] !=
          null) {
        blitz.add(RecordSingle.fromJson(
            jsonDecode(response.body)['data']['records']['blitz']['record']));
      }
      zen = TetrioZen.fromJson(jsonDecode(response.body)['data']['zen']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch player');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = userId;
    data['username'] = username;
    data['role'] = role;
    data['ts'] = registrationTime?.toString();
    data['badges'] = badges.map((v) => v.toJson()).toList();
    data['xp'] = xp;
    data['gamesplayed'] = gamesPlayed;
    data['gameswon'] = gamesWon;
    data['gametime'] = gameTime.inMicroseconds / 1000000;
    data['country'] = country;
    data['supporter_tier'] = supporterTier;
    data['verified'] = verified;
    data['league'] = tlSeason1.toJson();
    data['distinguishment'] = distinguishment?.toJson();
    data['avatar_revision'] = avatarRevision;
    data['banner_revision'] = bannerRevision;
    data['bio'] = bio;
    data['connections'] = connections.toJson();
    data['friend_count'] = friendCount;
    return data;
  }

  bool isSameState(TetrioPlayer other) {
    if (userId != other.userId) return false;
    if (username != other.username) return false;
    if (role != other.role) return false;
    if (badges != other.badges) return false;
    if (bio != other.bio) return false;
    if (country != other.country) return false;
    if (friendCount != other.friendCount) return false;
    if (gamesPlayed != other.gamesPlayed) return false;
    if (gamesWon != other.gamesWon) return false;
    if (gameTime != other.gameTime) return false;
    if (xp != other.xp) return false;
    if (supporterTier != other.supporterTier) return false;
    if (verified != other.verified) return false;
    if (badstanding != other.badstanding) return false;
    if (bot != other.bot) return false;
    if (connections != other.connections) return false;
    if (tlSeason1 != other.tlSeason1) return false;
    if (distinguishment != other.distinguishment) return false;
    return true;
  }

  @override
  String toString() {
    return "$username ($userId)";
  }

  @override
  int get hashCode => state.hashCode;

  @override
  bool operator ==(covariant TetrioPlayer other) => (userId == other.userId);
}

class Badge {
  late String badgeId;
  late String label;
  DateTime? ts;

  Badge({required this.badgeId, required this.label, this.ts});

  Badge.fromJson(Map<String, dynamic> json) {
    badgeId = json['id'];
    label = json['label'];
    ts = json['ts'] != null ? DateTime.parse(json['ts']) : null;
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
  late int singles;
  late int doubles;
  late int triples;
  late int quads;
  late int allClears;
  late int tSpinZeros;
  late int tSpinSingles;
  late int tSpinDoubles;
  late int tSpinTriples;
  late int tSpinQuads;
  late int tSpinMiniZeros;
  late int tSpinMiniSingles;
  late int tSpinMiniDoubles;

  Clears(
      {required this.singles,
      required this.doubles,
      required this.triples,
      required this.quads,
      required this.allClears,
      required this.tSpinZeros,
      required this.tSpinSingles,
      required this.tSpinDoubles,
      required this.tSpinTriples,
      required this.tSpinQuads,
      required this.tSpinMiniZeros,
      required this.tSpinMiniSingles,
      required this.tSpinMiniDoubles});

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
  late String id;
  late String username;

  Discord({required this.id, required this.username});

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
  late int combo;
  late int faults;
  late int perfectPieces;

  Finesse(
      {required this.combo, required this.faults, required this.perfectPieces});

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
    finalTime = doubleMillisecondsToDuration(json['finalTime'].toDouble());
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
  late double arr;
  late double das;
  late int sdf;
  late int dcd;
  late bool cancel;
  late bool safeLock;

  Handling(
      {required this.arr,
      required this.das,
      required this.sdf,
      required this.dcd,
      required this.cancel,
      required this.safeLock});

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
  late int gamesPlayed;
  late int gamesWon;
  late String bestRank;
  late bool decaying;
  late double rating;
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
  List? records;

  TetraLeagueAlpha(
      {required this.gamesPlayed,
      required this.gamesWon,
      required this.bestRank,
      required this.decaying,
      required this.rating,
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

  double? get app => apm! / (pps! * 60);

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
  late String userId;
  late String replayId;
  late String ownId;
  DateTime? timestamp;
  EndContextSingle? endContext;
  int? rank;

  RecordSingle(
      {required this.userId,
      required this.replayId,
      required this.ownId,
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
  late int level;
  late int score;

  TetrioZen({required this.level, required this.score});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['detail'] = detail;
    data['header'] = header;
    data['footer'] = footer;
    return data;
  }
}
