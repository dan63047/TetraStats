import 'dart:math';

import 'package:tetra_stats/data_objects/singleplayer_grading.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/utils/numers_formats.dart';
import 'package:tetra_stats/utils/relative_timestamps.dart';



int main() {
  //testing times
  // List<double> sprintTimes = [
  //   for (double i = 12.000; i < 180.000; i += 1.000) i
  // ];
  // for (int i = 0; i < sprintTimes.length; i++) {
  //   List<double?> solution = timeToGrade(sprintTimes[i]);
  //   if (solution[0] != null) {
  //     print('${get40lTime((sprintTimes[i]*1000000).floor())}: ${solution[0] != null ? ranks2[max(min(solution[0]!.round(), ranks2.length - 1), 0)] : "z"} ${solution}');
  //   } else {
  //     print('Решение не найдено');
  //   }
  // }
  // testing blitz
  List<double> blitzScores = [
    for (double i = 2000000; i > -1; i -= 1000) i
  ];
  for (int i = 0; i < blitzScores.length; i++) {
    List<double?> solution = scoreToGrade(blitzScores[i]);
    if (solution[0] != null) {
      print('${intf.format(blitzScores[i])}: ${solution[0] != null ? ranks2[max(min(solution[0]!.round(), ranks2.length - 1), 0)] : "z"} ${solution}');
    } else {
      print('Решение не найдено');
    }
  }
  return 0;
}
