class TetrioPlayer{
  final String userId;
  final String username;
  final String role;
  final DateTime registrationTime;
  final List badges;
  final String bio;
  final String country;
  final int friendCount;
  final int gamesPlayed;
  final int gamesWon;
  final double gameTime;
  final double xp;
  final int supporterTier;
  final bool verified;
  final List<String> connection;
  final TetraLeagueAlpha tlSeason1;
  final List<TetrioSprint> sprint;
  final List<TetrioBlitz> blitz;
  final TetrioZen zen;

  const TetrioPlayer({
    required this.userId,
    required this.username,
    required this.role,
    required this.registrationTime,
    required this.badges,
    required this.bio,
    required this.country,
    required this.friendCount,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.gameTime,
    required this.xp,
    required this.supporterTier,
    required this.verified,
    required this.connection,
    required this.tlSeason1,
    required this.sprint,
    required this.blitz,
    required this.zen,
  });
}

class EndContextClears{
  final int singles;
  final int doubles;
  final int triples;
  final int quads;
  final int allClears;
  final int tSpinZeros;
  final int tSpinSingles;
  final int tSpinDoubles;
  final int tSpinTriples;
  final int tSpinQuads;
  final int tSpinMiniZeros;
  final int tSpinMiniSingles;
  final int tSpinMiniDoubles;

  const EndContextClears({
    required this.singles,
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
    required this.tSpinMiniDoubles
});
}

class EndContextFinesse{
  final int combo;
  final int faults;
  final int perfectPieces;

  const EndContextFinesse({
    required this.combo,
    required this.faults,
    required this.perfectPieces
});
}

class ReplayEndContextSingle{
  final String gameType;
  final int topBtB;
  final int topCombo;
  final int holds;
  final int inputs;
  final int level;
  final int piecesPlaced;
  final int lines;
  final int score;
  final int seed;
  final double finalTime;
  final int tSpins;
  final EndContextClears clears;
  final EndContextFinesse finesse;

  const ReplayEndContextSingle({
    required this.gameType,
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
    required this.finesse
});
}

class TetraLeagueAlpha{
  final String userId;
  final int gamesPlayed;
  final int gamesWon;
  final String bestRank;
  final bool decaying;
  final double rating;
  final String rank;
  final double gliko;
  final double rd;
  final String percentileRank;
  final String percentile;
  final int standing;
  final int standingLocal;
  final String nextRank;
  final int nextAt;
  final String prevRank;
  final int prevAt;
  final double apm;
  final double pps;
  final double vs;
  final List records;

  const TetraLeagueAlpha({
    required this.userId,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.bestRank,
    required this.decaying,
    required this.rating,
    required this.rank,
    required this.gliko,
    required this.rd,
    required this.percentileRank,
    required this.percentile,
    required this.standing,
    required this.standingLocal,
    required this.nextRank,
    required this.nextAt,
    required this.prevRank,
    required this.prevAt,
    required this.apm,
    required this.pps,
    required this.vs,
    required this.records
});
}

class TetrioSprint{
  final String userId;
  final String replayId;
  final String ownId;
  final DateTime timestamp;
  final ReplayEndContextSingle endContext;
  final int rank;

  const TetrioSprint({
    required this.userId,
    required this.replayId,
    required this.ownId,
    required this.timestamp,
    required this.endContext,
    required this.rank
});
}

class TetrioBlitz{
  final String userId;
  final String replayId;
  final String ownId;
  final DateTime timestamp;
  final ReplayEndContextSingle endContext;
  final int rank;

  const TetrioBlitz({
    required this.userId,
    required this.replayId,
    required this.ownId,
    required this.timestamp,
    required this.endContext,
    required this.rank
  });
}

class TetrioZen{
  final String userId;
  final int level;
  final int score;

  const TetrioZen({
    required this.userId,
    required this.level,
    required this.score
});
}