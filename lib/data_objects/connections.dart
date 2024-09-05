// ignore_for_file: hash_and_equals

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
