// ignore_for_file: hash_and_equals

import 'dart:math';

class Playstyle {
  late double opener;
  late double plonk;
  late double stride;
  late double infds;

  Playstyle(double apm, double pps, double app, double vsapm, double dsp, double gbe, double srarea, double statrank) {
    double nmapm = ((apm / srarea) / ((0.069 * pow(1.0017, (pow(statrank, 5) / 4700))) + statrank / 360)) - 1;
    double nmpps = ((pps / srarea) / (0.0084264 * pow(2.14, (-2 * (statrank / 2.7 + 1.03))) - statrank / 5750 + 0.0067)) - 1;
    //double nmvs = ((vs / srarea) / (0.1333 * pow(1.0021, ((pow(statrank, 7) * (statrank / 16.5)) / 1400000)) + statrank / 133)) - 1;
    double nmapp = (app / (0.1368803292 * pow(1.0024, (pow(statrank, 5) / 2800)) + statrank / 54)) - 1;
    //double nmdss = (dss / (0.01436466667 * pow(4.1, ((statrank - 9.6) / 2.9)) + statrank / 140 + 0.01)) - 1;
    double nmdsp = (dsp / (0.02136327583 * pow(14, ((statrank - 14.75) / 3.9)) + statrank / 152 + 0.022)) - 1;
    double nmgbe = (gbe / (statrank / 350 + 0.005948424455 * pow(3.8, ((statrank - 6.1) / 4)) + 0.006)) - 1;
    double nmvsapm = (vsapm / (-pow(((statrank - 16) / 36), 2) + 2.133)) - 1;
    opener = ((nmapm + nmpps * 0.75 + nmvsapm * -10 + nmapp * 0.75 + nmdsp * -0.25) / 3.5) + 0.5;
    plonk = ((nmgbe + nmapp + nmdsp * 0.75 + nmpps * -1) / 2.73) + 0.5;
    stride = ((nmapm * -0.25 + nmpps + nmapp * -2 + nmdsp * -0.5) * 0.79) + 0.5;
    infds = ((nmdsp + nmapp * -0.75 + nmapm * 0.5 + nmvsapm * 1.5 + nmpps * 0.5) * 0.9) + 0.5;
  }
}
