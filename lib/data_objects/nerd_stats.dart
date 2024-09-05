// ignore_for_file: hash_and_equals

import 'dart:math';
import 'package:vector_math/vector_math.dart';

class NerdStats {
  late double app;
  late double vsapm;
  late double dss;
  late double dsp;
  late double appdsp;
  late double cheese;
  late double gbe;
  late double nyaapp;
  late double area;

  NerdStats(double apm, double pps, double vs) {
    app = apm / (pps * 60);
    vsapm = vs / apm;
    dss = (vs / 100) - (apm / 60);
    dsp = ((vs / 100) - (apm / 60)) / pps;
    appdsp = app + dsp;
    cheese = (dsp * 150) + ((vsapm - 2) * 50) + (0.6 - app) * 125;
    gbe = app * dsp * 2;
    nyaapp = app - 5 * tan(radians((cheese / -30) + 1));
    area = apm * 1 + pps * 45 + vs * 0.444 + app * 185 + dss * 175 + dsp * 450 + gbe * 315;
  }
}
