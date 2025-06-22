import 'dart:math';

// Constants
const int MAX_ITERATIONS = 200;
const double EPSILON = 1e-7;

/// Gaussian distribution helper class
class Gaussian {
  final double mean;
  final double variance;

  Gaussian(this.mean, this.variance);

  double get standardDeviation => sqrt(variance);

  /// Probability Density Function
  double pdf(double x) {
    if (variance <= 0) return 0.0;
    final double sd = standardDeviation;
    final double exponent = -pow(x - mean, 2) / (2 * variance);
    return exp(exponent) / (sd * sqrt(2 * pi));
  }

  /// Percent Point Function (Inverse CDF)
  double ppf(double p) {
    if (p <= 0 || p >= 1) throw ArgumentError('p must be in (0,1)');
    // Approximation of inverse CDF for standard normal
    final double t = sqrt(-2 * log(min(p, 1 - p)));
    final double c0 = 2.515517;
    final double c1 = 0.802853;
    final double c2 = 0.010328;
    final double d1 = 1.432788;
    final double d2 = 0.189269;
    final double d3 = 0.001308;
    final double sign = p < 0.5 ? -1.0 : 1.0;
    final double num = c0 + c1 * t + c2 * pow(t, 2);
    final double den = 1 + d1 * t + d2 * pow(t, 2) + d3 * pow(t, 3);
    final double z = sign * (t - num / den);
    return mean + z * standardDeviation;
  }
}

/// Gaussian Mixture Model
class GMM {
  int nComponents;
  List<double> weights;
  List<double> means;
  List<double> vars;
  Map<String, dynamic> options;

  GMM(
    this.nComponents, [
    List<double>? weights,
    List<double>? means,
    List<double>? vars,
    this.options = const {},
  ])  : weights = weights ?? List.filled(nComponents, 1.0 / nComponents),
        means = means ?? List.generate(nComponents, (i) => i.toDouble()),
        vars = vars ?? List.filled(nComponents, 1.0) {
    _validateDimensions();
  }

  void _validateDimensions() {
    if (nComponents != weights.length ||
        nComponents != means.length ||
        nComponents != vars.length) {
      throw ArgumentError('weights, means and vars must have nComponents elements');
    }
  }

  List<Gaussian> _gaussians() {
    return List.generate(
      nComponents,
      (k) => Gaussian(means[k], vars[k]),
    );
  }

  List<double> sample(int nSamples) {
    final gaussians = _gaussians();
    final samples = <double>[];
    final rng = Random();

    for (int i = 0; i < nSamples; i++) {
      double r = rng.nextDouble();
      int n = 0;
      while (r > weights[n] && n < nComponents - 1) {
        r -= weights[n];
        n++;
      }
      samples.add(gaussians[n].ppf(rng.nextDouble()));
    }
    return samples;
  }

  List<List<double>> memberships(List<double> data) {
    final gaussians = _gaussians();
    return data.map((x) => membership(x, gaussians)).toList();
  }

  Map<String, List<double>> _membershipsHistogram(Histogram h) {
    final gaussians = _gaussians();
    final memberships = <String, List<double>>{};
    for (final key in h.counts.keys) {
      memberships[key] = membership(h.value(key), gaussians);
    }
    return memberships;
  }

  List<double> membership(double x, [List<Gaussian>? gaussians]) {
    gaussians ??= _gaussians();
    final membership = <double>[];
    double sum = 0.0;

    for (int i = 0; i < nComponents; i++) {
      final m = weights[i] * gaussians[i].pdf(x);
      membership.add(m);
      sum += m;
    }

    if (sum == 0) return List.filled(nComponents, 1.0 / nComponents);
    return membership.map((a) => a / sum).toList();
  }

  void _updateModel(List<double> data, List<List<double>>? memberships) {
    memberships ??= this.memberships(data);
    final n = data.length;
    final componentWeights = List<double>.filled(nComponents, 0.0);

    // Update weights
    for (int k = 0; k < nComponents; k++) {
      for (int i = 0; i < n; i++) {
        componentWeights[k] += memberships[i][k];
      }
      weights[k] = componentWeights[k] / n;
    }

    // Update means
    final newMeans = List<double>.filled(nComponents, 0.0);
    for (int k = 0; k < nComponents; k++) {
      for (int i = 0; i < n; i++) {
        newMeans[k] += memberships[i][k] * data[i];
      }
      newMeans[k] /= componentWeights[k];
    }
    means = newMeans;

    // Apply separation prior
    if (options.containsKey('separationPrior') && options.containsKey('separationPriorRelevance')) {
      final separationPrior = options['separationPrior'] as double;
      final priorMeans = List.generate(nComponents, (a) => a * separationPrior);
      final priorCenter = _barycenter(priorMeans, weights);
      final center = _barycenter(means, weights);

      for (int k = 0; k < nComponents; k++) {
        final alpha = weights[k] / (weights[k] + options['separationPriorRelevance']);
        means[k] = center + alpha * (means[k] - center) + (1 - alpha) * (priorMeans[k] - priorCenter);
      }
    }

    // Update variances
    for (int k = 0; k < nComponents; k++) {
      vars[k] = EPSILON;
      for (int i = 0; i < n; i++) {
        final diff = data[i] - means[k];
        vars[k] += memberships[i][k] * diff * diff;
      }
      vars[k] /= componentWeights[k];

      // Apply variance prior
      if (options.containsKey('variancePrior') && options.containsKey('variancePriorRelevance')) {
        final alpha = weights[k] / (weights[k] + options['variancePriorRelevance']);
        vars[k] = alpha * vars[k] + (1 - alpha) * options['variancePrior'];
      }
    }
  }

  void _updateModelHistogram(Histogram h, [Map<String, List<double>>? memberships]) {
    memberships ??= _membershipsHistogram(h);
    final keys = h.counts.keys.toList();
    final n = h.total;
    final componentWeights = List<double>.filled(nComponents, 0.0);

    // Update weights
    for (int k = 0; k < nComponents; k++) {
      for (final key in keys) {
        componentWeights[k] += memberships[key]![k] * h.counts[key]!;
      }
      weights[k] = componentWeights[k] / n;
    }

    // Update means
    final newMeans = List<double>.filled(nComponents, 0.0);
    for (int k = 0; k < nComponents; k++) {
      for (final key in keys) {
        final value = h.value(key);
        newMeans[k] += memberships[key]![k] * value * h.counts[key]!;
      }
      newMeans[k] /= componentWeights[k];
    }
    means = newMeans;

    // Apply separation prior
    if (options.containsKey('separationPrior') && options.containsKey('separationPriorRelevance')) {
      final separationPrior = options['separationPrior'] as double;
      final priorMeans = List.generate(nComponents, (a) => a * separationPrior);
      final priorCenter = _barycenter(priorMeans, weights);
      final center = _barycenter(means, weights);

      for (int k = 0; k < nComponents; k++) {
        final alpha = weights[k] / (weights[k] + options['separationPriorRelevance']);
        means[k] = center + alpha * (means[k] - center) + (1 - alpha) * (priorMeans[k] - priorCenter);
      }
    }

    // Update variances
    for (int k = 0; k < nComponents; k++) {
      vars[k] = EPSILON;
      for (final key in keys) {
        final value = h.value(key);
        final diff = value - means[k];
        vars[k] += memberships[key]![k] * diff * diff * h.counts[key]!;
      }
      vars[k] /= componentWeights[k];

      // Apply variance prior
      if (options.containsKey('variancePrior') && options.containsKey('variancePriorRelevance')) {
        final alpha = weights[k] / (weights[k] + options['variancePriorRelevance']);
        vars[k] = alpha * vars[k] + (1 - alpha) * options['variancePrior'];
      }
    }
  }

  double logLikelihood(dynamic data) {
    if (data is List<double>) return _logLikelihood(data);
    if (data is Histogram) return _logLikelihoodHistogram(data);
    throw ArgumentError('Data must be List<double> or Histogram');
  }

  double _logLikelihood(List<double> data) {
    final gaussians = _gaussians();
    double logLikelihood = 0.0;

    for (final x in data) {
      double p = 0.0;
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * gaussians[k].pdf(x);
      }
      if (p <= 0) return double.negativeInfinity;
      logLikelihood += log(p);
    }
    return logLikelihood;
  }

  double _logLikelihoodHistogram(Histogram h) {
    final gaussians = _gaussians();
    double logLikelihood = 0.0;
    final keys = h.counts.keys;

    for (final key in keys) {
      final value = h.value(key);
      final count = h.counts[key]!;
      double p = 0.0;
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * gaussians[k].pdf(value);
      }
      if (p <= 0) return double.negativeInfinity;
      logLikelihood += log(p) * count;
    }
    return logLikelihood;
  }

  int optimize(dynamic data, [int? maxIterations, double? logLikelihoodTol]) {
    if (data is List<double>) return _optimize(data, maxIterations, logLikelihoodTol);
    if (data is Histogram) return _optimizeHistogram(data, maxIterations, logLikelihoodTol);
    throw ArgumentError('Data must be List<double> or Histogram');
  }

  int _optimize(List<double> data, [int? maxIterations, double? logLikelihoodTol]) {
    maxIterations ??= MAX_ITERATIONS;
    logLikelihoodTol ??= EPSILON;

    if (options['initialize'] == true) _initialize(data);

    double logLikelihood = double.negativeInfinity;
    List<List<double>>? currentMemberships;
    int iteration = 0;

    for (; iteration < maxIterations; iteration++) {
      _updateModel(data, currentMemberships);
      currentMemberships = memberships(data);

      final newLogLikelihood = _logLikelihoodMemberships(currentMemberships);
      if ((newLogLikelihood - logLikelihood).abs() < logLikelihoodTol) break;
      logLikelihood = newLogLikelihood;
    }
    return iteration;
  }

  int _optimizeHistogram(Histogram h, [int? maxIterations, double? logLikelihoodTol]) {
    maxIterations ??= MAX_ITERATIONS;
    logLikelihoodTol ??= EPSILON;

    if (options['initialize'] == true) _initializeHistogram(h);

    double logLikelihood = double.negativeInfinity;
    int iteration = 0;

    for (; iteration < maxIterations; iteration++) {
      _updateModelHistogram(h);
      final newLogLikelihood = _logLikelihoodHistogram(h);
      if ((newLogLikelihood - logLikelihood).abs() < logLikelihoodTol) break;
      logLikelihood = newLogLikelihood;
    }
    return iteration;
  }

  double _logLikelihoodMemberships(List<List<double>> memberships) {
    double logLikelihood = 0.0;
    for (final membership in memberships) {
      double p = 0.0;
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * membership[k];
      }
      if (p <= 0) return double.negativeInfinity;
      logLikelihood += log(p);
    }
    return logLikelihood;
  }

  void _initialize(List<double> data) {
    if (data.length < nComponents) {
      throw StateError('Data must have more points than components');
    }

    final rng = Random();
    final means = <double>[];

    // First seed
    means.add(data[rng.nextInt(data.length)]);

    // Subsequent seeds
    for (int m = 1; m < nComponents; m++) {
      final distances = <double>[];
      double dsum = 0.0;

      for (final x in data) {
        double minDist = double.infinity;
        for (final mean in means) {
          final double dist = pow(x - mean, 2).toDouble();
          if (dist < minDist) minDist = dist;
        }
        distances.add(minDist);
        dsum += minDist;
      }

      double r = rng.nextDouble();
      double cumulative = 0.0;
      for (int i = 0; i < data.length; i++) {
        cumulative += distances[i] / dsum;
        if (cumulative >= r || i == data.length - 1) {
          means.add(data[i]);
          break;
        }
      }
    }

    means.sort();
    this.means = means;
  }

  void _initializeHistogram(Histogram h) {
    if (h.total < nComponents) {
      throw StateError('Data must have more points than components');
    }

    final rng = Random();
    final means = <double>[];
    final keys = h.counts.keys.toList();

    // First seed
    double r = rng.nextDouble() * h.total;
    double cumulative = 0.0;
    for (final key in keys) {
      cumulative += h.counts[key]!;
      if (cumulative >= r) {
        means.add(h.value(key));
        break;
      }
    }

    // Subsequent seeds
    for (int m = 1; m < nComponents; m++) {
      final distances = <double>[];
      double dsum = 0.0;

      for (final key in keys) {
        final value = h.value(key);
        double minDist = double.infinity;
        for (final mean in means) {
          final double dist = pow(value - mean, 2).toDouble();
          if (dist < minDist) minDist = dist;
        }
        distances.add(minDist * h.counts[key]!);
        dsum += minDist * h.counts[key]!;
      }

      r = rng.nextDouble();
      cumulative = 0.0;
      for (int i = 0; i < keys.length; i++) {
        cumulative += distances[i] / dsum;
        if (cumulative >= r || i == keys.length - 1) {
          means.add(h.value(keys[i]));
          break;
        }
      }
    }

    means.sort();
    this.means = means;
  }

  double _barycenter(List<double> array, List<double> weights) {
    double total = 0.0;
    double barycenter = 0.0;
    for (int i = 0; i < array.length; i++) {
      total += weights[i];
      barycenter += array[i] * weights[i];
    }
    return barycenter / total;
  }

  Map<String, dynamic> model() {
    return {
      'nComponents': nComponents,
      'weights': weights,
      'means': means,
      'vars': vars,
    };
  }

  static GMM fromModel(Map<String, dynamic> model, [Map<String, dynamic> options = const {}]) {
    return GMM(
      model['nComponents'],
      List<double>.from(model['weights']),
      List<double>.from(model['means']),
      List<double>.from(model['vars']),
      options,
    );
  }
}

/// Histogram data container
class Histogram {
  Map<String, List<double>>? bins;
  Map<String, int> counts;
  int total = 0;

  Histogram({this.bins, Map<String, int>? counts})
      : counts = counts ?? {} {
    total = this.counts.values.fold(0, (sum, count) => sum + count);
  }

  static Histogram fromData(List<double> data, [Map<String, List<double>>? bins]) {
    final hist = Histogram(bins: bins);
    for (final x in data) {
      hist.add(x);
    }
    return hist;
  }

  String _classify(double x) {
    if (bins == null) return x.round().toString();

    for (final entry in bins!.entries) {
      final bounds = entry.value;
      if (bounds[0] <= x && x < bounds[1]) return entry.key;
    }
    return 'unclassified';
  }

  void add(double x) {
    final key = _classify(x);
    counts[key] = (counts[key] ?? 0) + 1;
    total++;
  }

  List<double> flatten() {
    final flat = <double>[];
    counts.forEach((key, count) {
      final value = this.value(key);
      flat.addAll(List.filled(count, value));
    });
    return flat;
  }

  double value(String key) {
    if (bins != null) {
      if (bins!.containsKey(key)) {
        return (bins![key]![0] + bins![key]![1]) / 2;
      }
      throw ArgumentError('Invalid bin key');
    }
    return double.parse(key);
  }
}