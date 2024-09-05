// ignore_for_file: hash_and_equals

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:tetra_stats/data_objects/badge.dart';
import 'package:tetra_stats/data_objects/connections.dart';
import 'package:tetra_stats/data_objects/distinguishment.dart';
import 'package:tetra_stats/data_objects/tetrio_zen.dart';

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
    registrationTime = json['ts'] != null ? DateTime.parse(json['ts']) : DateTime.fromMillisecondsSinceEpoch(int.parse(id.substring(0, 8), radix: 16) * 1000);
    if (json['badges'] != null) {
      json['badges'].forEach((v) {
        badges.add(Badge.fromJson(v));
      });
    }
    xp = json['xp'] != null ? json['xp'].toDouble() : -1;
    gamesPlayed = json['gamesplayed'] ?? -1;
    gamesWon = json['gameswon'] ?? -1;
    gameTime = json['gametime'] != null && json['gametime'] != -1 ? Duration(microseconds: (json['gametime'].toDouble() * 1000000).floor()) : const Duration(seconds: -1);
    country = json['country'];
    supporterTier = json['supporter_tier'] ?? 0;
    verified = json['verified'] ?? false;
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
    if (distinguishment != other.distinguishment) return false;
    return true;
  }

  @override
  String toString() {
    return "$username ($state)";
  }

  @override
  int get hashCode => state.hashCode;

  @override
  bool operator ==(covariant TetrioPlayer other) => isSameState(other) && state.isAtSameMomentAs(other.state);
}
