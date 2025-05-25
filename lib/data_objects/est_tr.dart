// ignore_for_file: hash_and_equals

import 'dart:math';

class EstTr {
  late double esttr;
  late double srarea;
  late double statrank;
  late double estglicko;

  EstTr(double apm, double pps, double vs, int wincount, double rd, double app, double dss, double dsp, double gbe) {
    srarea = (apm * 0) + (pps * 135) + (vs * 0) + (app * 290) + (dss * 0) + (dsp * 700) + (gbe * 0);
    statrank = 11.2 * atan((srarea - 93) / 130) + 1;
    if (statrank <= 0) statrank = 0.001;
    //estglicko = (4.0867 * srarea + 186.68);
    double ntemp = pps*(150+(((vs/apm) - 1.66)*35))+app*290+dsp*700;
    estglicko = 0.000013*pow(ntemp, 3) - 0.0196 *pow(ntemp, 2) + (12.645*ntemp)-1005.4;

    // osk's stuff
    final F = min(1, 0.5 + 0.5 * (wincount / 18)); // Falloff   - pulls the graph down
    final D = 1 + (60 - rd) / 1500;                     // Deviation - 1+\frac{60-D}{1500}
    const B = 1.56;
    const C = 0.86;
    const v = 0.87646605;
    const w = 0.25;  // Constants for the two curves
    esttr = (22000 / pow((1 + pow(e, (-D * B * ((estglicko - 1500) / 500)))), (1/(v*F)))) + (3000 / pow((1 + pow(e, (-D * C * ((estglicko - 2000) / 500)))), (1/(w*pow(F, 2)))));
    // esttr = 25000 / 
    // (
    //   1 + pow(10, (
    //     (
    //       (
    //         1500-estglicko
    //       )*pi
    //     )/sqrt(
    //       (
    //         (
    //           3*pow(ln10, 2)
    //         )*pow(60, 2)
    //       )+(
    //         2500*(
    //           (64*pow(pi,2))+(147*pow(ln10, 2))
    //         )
    //       )
    //     )
    //   ))
    // );
  }
}
