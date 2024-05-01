import 'dart:math';
// I reimplemented kenany/glicko2-lite in dart lol
// Don't look here lol

List<double> scale(double rating, double rd, double options) {
  double mu = (rating - options) / 173.7178;
  double phi = rd / 173.7178;
  return [ mu, phi ];
}

double g(phi) {
  return 1 / sqrt(1 + 3 * pow(phi, 2) / pow(pi, 2));
}

double e(double mu, double muj, double phij) {
  return 1 / (1 + exp(-g(phij) * (mu - muj)));
}

List<Map<String, double>> scaleOpponents(double mu, List<List<double>> opponents, double rating) {
  return opponents.map((opp) {
    var scaled = scale(opp[0], opp[1], rating);
    return {
      "muj": scaled[0],
      "phij": scaled[1],
      "gphij": g(scaled[1]),
      "emmp": e(mu, scaled[0], scaled[1]),
      "score": opp[2]
    };
  }).toList();
}

double updateRating(List<Map<String, double>> opponents) {
  double value = pow(opponents.first["gphij"]!, 2) * opponents.first["emmp"]! * (1 - opponents.first["emmp"]!);
  opponents.skip(1).forEach((element) {
    value += pow(element["gphij"]!, 2) * element["emmp"]! * (1 - element["emmp"]!);
  });
  return 1 / value;
}

double computeDelta(v, List<Map<String, double>> opponents) {
  double value = opponents.first["gphij"]! * (opponents.first["score"]! - opponents.first["emmp"]!);
  opponents.skip(1).forEach((element) {
    value += opponents.first["gphij"]! * (opponents.first["score"]! - opponents.first["emmp"]!);
  });
  return v * value;
}

Function volF(double phi, double v, double delta, double a, double tau) {
  num phi2 = pow(phi, 2);
  num d2 = pow(delta, 2);

  return (x) {
    double ex = exp(x);
    double a2 = phi2 + v + ex;
    double p2 = (x - a) / pow(tau, 2);
    double p1 = (ex * (d2 - phi2 - v - ex)) / (2 * pow(a2, 2));
    return p1 - p2;
  };
}

double computeVolatility(double sigma, double phi, double v, double delta, double options) {
  // 5.1
  double a = log(pow(sigma, 2));
  Function f = volF(phi, v, delta, a, options);

  // 5.2
  double b;
  if (pow(delta, 2) > pow(phi, 2) + v) {
    b = log(pow(delta, 2) - pow(phi, 2) - v);
  }
  else {
    double k = 1;
    while (f(a - k * options) < 0) {
      k++;
    }
    b = a - k * options;
  }

  // 5.3
  double fa = f(a);
  double fb = f(b);

  // 5.4
  while ((b - a).abs() > 0.000001) {
    double c = a + (a - b) * fa / (fb - fa);
    double fc = f(c);

    if (fc * fb <= 0) {
      a = b;
      fa = fb;
    }
    else {
      fa /= 2;
    }

    b = c;
    fb = fc;
  }

  // 5.5
  return exp(a / 2);
}

double phiStar(sigmap, phi) {
  return sqrt(pow(sigmap, 2) + pow(phi, 2));
}

Map<String, double> newRating(phis, mu, v, opponents) {
  double phip = 1 / sqrt(1 / pow(phis, 2) + 1 / v);
  double value = opponents.first["gphij"]! * (opponents.first["score"]! - opponents.first["emmp"]!);
  opponents.skip(1).forEach((element) {
    value += element["gphij"]! * (element["score"]! - element["emmp"]!);
  });
  double mup = mu + pow(phip, 2) * value;
  return { "mu": mup, "phi": phip };
}

List<double> unscale(mup, phip, options) {
  double rating = 173.7178 * mup + options["rating"];
  double rd = 173.7178 * phip;
  return [ rating, rd ];
}

List<double> rate(double rating, double rd, double sigma, List<List<double>> opponents, Map<String, double> options) {
  Map<String, double> opts = { "rating": options["rating"]??1500, "tau": options["tau"]??0.5 };

  // Step 2
  List<double> scaled = scale(rating, rd, opts["rating"]!);
  List<Map<String, double>> scaledOpponents = scaleOpponents(scaled[0], opponents, opts["rating"]!);

  // Step 3
  double v = updateRating(scaledOpponents);

  // Step 4
  double delta = computeDelta(v, scaledOpponents);

  // Step 5
  double sigmap = computeVolatility(sigma, scaled[1], v, delta, opts["tau"]!);

  // Step 6
  double phis = phiStar(sigmap, scaled[1]);

  // Step 7
  Map<String, double> updated = newRating(phis, scaled[0], v, scaledOpponents);

  return unscale(updated['mu'], updated['phi'], opts)..add(sigmap);
}