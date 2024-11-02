// ignore_for_file: hash_and_equals

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

class SmallLeague{
  late double glicko;
  late double rd;
  late double tr;
  late String rank;
  late int placement;

  SmallLeague(this.glicko, this.rd, this.tr, this.rank, this.placement);

  SmallLeague.fromJson(Map<String, dynamic> json){
    glicko = json['glicko'];
    rd = json['rd'];
    tr = json['tr'];
    rank = json['rank'];
    placement = json['placement'];
  }
}

class LeagueExtras extends RecordExtras{
  late String result;
  Map<String, List<SmallLeague?>> league = {};

  LeagueExtras.fromJson(Map<String, dynamic> json){
    result = json['result'];
    for (String userID in json['league'].keys){
      league[userID] = [json['league'][userID][0] != null ? SmallLeague.fromJson(json['league'][userID][0]) : null, json['league'][userID][1] != null ? SmallLeague.fromJson(json['league'][userID][1]) : null];
    }
  }
}
