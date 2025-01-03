// ignore_for_file: hash_and_equals

import 'dart:math';

class EstTr {
  late double esttr;
  late double srarea;
  late double statrank;
  late double estglicko;

  EstTr(double apm, double pps, double vs, double app, double dss, double dsp, double gbe) {
    srarea = (apm * 0) + (pps * 135) + (vs * 0) + (app * 290) + (dss * 0) + (dsp * 700) + (gbe * 0);
    statrank = 11.2 * atan((srarea - 93) / 130) + 1;
    if (statrank <= 0) statrank = 0.001;
    //estglicko = (4.0867 * srarea + 186.68);
    double ntemp = pps*(150+(((vs/apm) - 1.66)*35))+app*290+dsp*700;
    estglicko = 0.000013*pow(ntemp, 3) - 0.0196 *pow(ntemp, 2) + (12.645*ntemp)-1005.4;
    esttr = 25000 / 
    (
      1 + pow(10, (
        (
          (
            1500-estglicko
          )*pi
        )/sqrt(
          (
            (
              3*pow(ln10, 2)
            )*pow(60, 2)
          )+(
            2500*(
              (64*pow(pi,2))+(147*pow(ln10, 2))
            )
          )
        )
      ))
    );
  }
}
