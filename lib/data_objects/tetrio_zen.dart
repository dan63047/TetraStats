// ignore_for_file: hash_and_equals

import 'dart:math';

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
