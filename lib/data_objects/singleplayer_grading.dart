import 'dart:math';

import 'package:tetra_stats/data_objects/record_single.dart';
import 'package:tetra_stats/data_objects/tetrio_constants.dart';
import 'package:tetra_stats/utils/newton_method.dart';

final class Grade{
  String grade;
  double? score;

  Grade({required this.grade, required this.score});
}

// 40 Lines stuff
double Function(double, double) timef = (double x, double time) =>
      0.177101844685243 * pow(x, 2) +
      4.46929095717233 * x +
      (16.0499142156863 - time);
List<double?> timeToGrade(double? time) {
  if (time == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => timef(x, time),
    fPrime: (double x) => 0.3542036894 * x + 4.46929095717233,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = timef(grade!, time);
  return [grade, accuracy];
}

double Function(double, double) kppf = (double x, double kpp) =>
      0.00155540505675955 * pow(x, 2) +
      0.0879374999999998 * x +
      (2.95446323529412 - kpp);
List<double?> kppToGrade(double? kpp) {
  if (kpp == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => kppf(x, kpp),
    fPrime: (double x) => 0.003110810114 * x + 0.0879374999999998,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = kppf(grade!, kpp);
  return [grade, accuracy];
}

double Function(double, double) finessef = (double x, double finesse) =>
      0.000352810887512907 * pow(x, 2) -
      0.0420303418472654 * x +
      (1.00352612745098 - finesse);
List<double?> finesseToGrade(double? finesse) {
  if (finesse == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => finessef(x, finesse),
    fPrime: (double x) => 0.0007056217750 * x - 0.0420303418472654,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = finessef(grade!, finesse);
  return [grade, accuracy];
}

double Function(double, double) piecesf = (double x, double pieces) =>
      0.000969556243550337 * pow(x, 2) +
      0.355943756449942 * x +
      (101.171156862745 - pieces);
List<double?> piecesToGrade(double? pieces) {
  if (pieces == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => piecesf(x, pieces),
    fPrime: (double x) => 0.001939112487 * x + 0.355943756449942,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = piecesf(grade!, pieces);
  return [grade, accuracy];
}

double Function(double, double) ppsf = (double x, double pps) =>
      0.0219452399380805 * pow(x, 2) -
      0.636699496904025 * x +
      (5.54039460784314 - pps);
List<double?> ppsToGrade(double? pps) {
  if (pps == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => ppsf(x, pps),
    fPrime: (double x) => 0.04389047988 * x - 0.636699496904025,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = ppsf(grade!, pps);
  return [grade, accuracy];
}

final class SprintGrade extends Grade{
  String timeGrade;
  List<double?> timeScore;
  String kppGrade;
  List<double?> kppScore;
  String finesseGrade;
  List<double?> finesseScore;
  String piecesGrade;
  List<double?> piecesScore;
  String ppsGrade;
  List<double?> ppsScore;

  SprintGrade({required super.grade, required super.score, required this.timeGrade, required this.timeScore, required this.kppGrade, required this.kppScore, required this.finesseGrade, required this.finesseScore, required this.piecesGrade, required this.piecesScore, required this.ppsGrade, required this.ppsScore});
}

SprintGrade sprintToGrade(RecordSingle? run){
  List<double?> timeGrade = timeToGrade(run != null ? run.stats.finalTime.inMicroseconds/1000000 : null);
  List<double?> kppGrade = kppToGrade(run?.stats.kpp);
  List<double?> finesseGrade = finesseToGrade(run?.stats.finessePercentage);
  List<double?> piecesGrade = piecesToGrade(run?.stats.piecesPlaced.toDouble());
  List<double?> ppsGrade = ppsToGrade(run?.stats.pps);
  double? score = (timeGrade[0] != null && kppGrade[0] != null && finesseGrade[0] != null) ? (timeGrade[0]! * .8 + kppGrade[0]! * 2 + finesseGrade[0]!) / 3.8 : null;
  return SprintGrade(
    grade: score != null ? ranks2[max(min(score.round(), ranks2.length - 1), 0)] : "z",
    score: score,
    timeGrade: timeGrade[0] != null ? ranks2[max(min(timeGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    timeScore: timeGrade,
    kppGrade: kppGrade[0] != null ? ranks2[max(min(kppGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    kppScore: kppGrade,
    finesseGrade: finesseGrade[0] != null ? ranks2[max(min(finesseGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    finesseScore: finesseGrade,
    piecesGrade: piecesGrade[0] != null ? ranks2[max(min(piecesGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    piecesScore: piecesGrade,
    ppsGrade: ppsGrade[0] != null ? ranks2[max(min(ppsGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    ppsScore: ppsGrade,
  );
}

// Blitz stuff

double Function(double, double) scoref = (double x, double score) =>
      53.4549435864065 * pow(x, 4)
      -2628.30908730627 * pow(x, 3) +
      47536.8014041328 * pow(x, 2) - 384210.664654762 * x +
      (1261811.02559478 - score);
List<double?> scoreToGrade(double? score) {
  if (score == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => scoref(x, score),
    fPrime: (double x) => 213.819774345626 * pow(x, 3) - 7884.92726191881 * pow(x, 2) + 95073.6028082656 * x - 384210.664654762,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = ppsf(grade!, score);
  return [grade, accuracy];
}

double Function(double, double) sppf = (double x, double spp) =>
      10.9643880933953 * pow(x, 2) -
      314.658305663055 * x +
      (2510.0994877451 - spp);
List<double?> sppToGrade(double? spp) {
  if (spp == null) return [null, null];
  double? grade = NewtonMethod.solve(
    f: (double x) => sppf(x, spp),
    fPrime: (double x) => 21.92877619 * x - 314.658305663055,
    initialGuess: 2.5,
    tolerance: 1e-10,
    maxIterations: 100,
  );
  double? accuracy = ppsf(grade!, spp);
  return [grade, accuracy];
}

final class BlitzGrade extends Grade{
  String scoreGrade;
  List<double?> scoreScore;
  String sppGrade;
  List<double?> sppScore;

  BlitzGrade({required super.grade, required super.score, required this.scoreGrade, required this.scoreScore, required this.sppGrade, required this.sppScore});
}

BlitzGrade blitzToGrade(RecordSingle? run){
  List<double?> scoreGrade = scoreToGrade(run?.stats.score.toDouble());
  List<double?> sppGrade = sppToGrade(run?.stats.spp);
  double? score = (scoreGrade[0] != null && sppGrade[0] != null) ? (scoreGrade[0]! + sppGrade[0]!) / 2 : null;
  return BlitzGrade(
    grade: score != null ? ranks2[max(min(score.round(), ranks2.length - 1), 0)] : "z",
    score: score,
    scoreGrade: scoreGrade[0] != null ? ranks2[max(min(scoreGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    scoreScore: scoreGrade,
    sppGrade: sppGrade[0] != null ? ranks2[max(min(sppGrade[0]!.round(), ranks2.length - 1), 0)] : "z",
    sppScore: sppGrade,
  );
}
