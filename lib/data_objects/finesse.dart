// ignore_for_file: hash_and_equals

import 'dart:math';

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
