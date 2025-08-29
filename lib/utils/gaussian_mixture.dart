import 'dart:math';

const int MAX_ITERATIONS = 200;
const double EPSILON = 1e-7;

class Gaussian {
  final double mean;
  final double variance;

  Gaussian(this.mean, this.variance);

  double pdf(double x) {
    final double sd = sqrt(variance);
    final double exponent = exp(-pow(x - mean, 2) / (2 * variance));
    return exponent / (sd * sqrt(2 * pi));
  }

  double sample(Random random) {
    // Box-Muller transform for generating normal random variables
    final double u1 = 1.0 - random.nextDouble();
    final double u2 = 1.0 - random.nextDouble();
    final double z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
    return mean + sqrt(variance) * z0;
  }
}

class GMM {
  late int nComponents;
  late List<double> weights;
  late List<double> means;
  late List<double> vars;
  late Map<String, dynamic> options;

  GMM(this.nComponents, [List<double>? weights, List<double>? means, 
      List<double>? vars, Map<String, dynamic>? options]) {
    this.weights = weights ?? List.generate(nComponents, (_) => 1.0 / nComponents);
    this.means = means ?? List.generate(nComponents, (i) => i.toDouble());
    this.vars = vars ?? List.generate(nComponents, (_) => 1.0);
    this.options = options ?? {};

    if (nComponents != this.weights.length ||
        nComponents != this.means.length ||
        nComponents != this.vars.length) {
      throw Exception('weights, means and vars must have nComponents elements.');
    }
  }

  List<Gaussian> _gaussians() {
    return List.generate(nComponents, (k) => Gaussian(means[k], vars[k]));
  }

  List<double> sample(int nSamples, [Random? random]) {
    random ??= Random();
    final samples = <double>[];
    final gaussians = _gaussians();

    for (int i = 0; i < nSamples; i++) {
      double r = random.nextDouble();
      int n = 0;
      while (r > weights[n] && n < nComponents) {
        r -= weights[n];
        n++;
      }
      samples.add(gaussians[n].sample(random));
    }
    return samples;
  }

  List<List<double>> memberships(List<double> data, [List<Gaussian>? gaussians]) {
    gaussians ??= _gaussians();
    return data.map((x) => membership(x, gaussians)).toList();
  }

  Map<String, List<double>> _membershipsHistogram(Histogram h, [List<Gaussian>? gaussians]) {
    gaussians ??= _gaussians();
    final memberships = <String, List<double>>{};
    
    for (final key in h.counts.keys) {
      final v = h.value(key);
      memberships[key] = membership(v, gaussians);
    }
    
    return memberships;
  }

  List<double> membership(double x, [List<Gaussian>? gaussians]) {
    gaussians ??= _gaussians();
    final membership = List<double>.filled(nComponents, 0.0);
    double sum = 0.0;

    for (int i = 0; i < nComponents; i++) {
      final m = gaussians[i].pdf(x);
      membership[i] = m;
      sum += m;
    }

    return membership.map((a) => a / sum).toList();
  }

  void _updateModel(List<double> data, [List<List<double>>? memberships]) {
    memberships ??= this.memberships(data);
    final n = data.length;
    final componentWeights = List<double>.filled(nComponents, 0.0);

    for (int k = 0; k < nComponents; k++) {
      componentWeights[k] = memberships.map((m) => m[k]).reduce((a, b) => a + b);
    }

    weights = componentWeights.map((w) => w / n).toList();

    for (int k = 0; k < nComponents; k++) {
      means[k] = 0.0;
      for (int i = 0; i < n; i++) {
        means[k] += memberships[i][k] * data[i];
      }
      means[k] /= componentWeights[k];
    }

    if (options.containsKey('separationPrior') && 
        options.containsKey('separationPriorRelevance')) {
      final double separationPrior = options['separationPrior'];
      final List<double> priorMeans = List.generate(nComponents, (a) => a * separationPrior);
      final priorCenter = _barycenter(priorMeans, weights);
      final center = _barycenter(means, weights);
      
      for (int k = 0; k < nComponents; k++) {
        final alpha = weights[k] / 
            (weights[k] + options['separationPriorRelevance']);
        means[k] = center + alpha * (means[k] - center) + 
            (1 - alpha) * (priorMeans[k] - priorCenter);
      }
    }

    for (int k = 0; k < nComponents; k++) {
      vars[k] = EPSILON;
      for (int i = 0; i < n; i++) {
        final diff = data[i] - means[k];
        vars[k] += memberships[i][k] * diff * diff;
      }
      vars[k] /= componentWeights[k];
      
      if (options.containsKey('variancePrior') && 
          options.containsKey('variancePriorRelevance')) {
        final alpha = weights[k] / 
            (weights[k] + options['variancePriorRelevance']);
        vars[k] = alpha * vars[k] + (1 - alpha) * options['variancePrior'];
      }
    }
  }

  void _updateModelHistogram(Histogram h, [Map<String, List<double>>? memberships]) {
    memberships ??= _membershipsHistogram(h);
    final keys = h.counts.keys.toList();
    final componentWeights = List<double>.filled(nComponents, 0.0);

    for (int k = 0; k < nComponents; k++) {
      componentWeights[k] = keys
          .map((key) => memberships![key]![k] * h.counts[key]!)
          .reduce((a, b) => a + b);
    }

    weights = componentWeights.map((w) => w / h.total).toList();

    for (int k = 0; k < nComponents; k++) {
      means[k] = 0.0;
      for (final key in keys) {
        final v = h.value(key);
        means[k] += memberships[key]![k] * v * h.counts[key]!;
      }
      means[k] /= componentWeights[k];
    }

    if (options.containsKey('separationPrior') && 
        options.containsKey('separationPriorRelevance')) {
      final double separationPrior = options['separationPrior'];
      final List<double> priorMeans = List.generate(nComponents, (a) => a * separationPrior);
      final priorCenter = _barycenter(priorMeans, weights);
      final center = _barycenter(means, weights);
      
      for (int k = 0; k < nComponents; k++) {
        final alpha = weights[k] / 
            (weights[k] + options['separationPriorRelevance']);
        means[k] = center + alpha * (means[k] - center) + 
            (1 - alpha) * (priorMeans[k] - priorCenter);
      }
    }

    for (int k = 0; k < nComponents; k++) {
      vars[k] = EPSILON;
      for (final key in keys) {
        final v = h.value(key);
        final diff = v - means[k];
        vars[k] += memberships[key]![k] * diff * diff * h.counts[key]!;
      }
      vars[k] /= componentWeights[k];
      
      if (options.containsKey('variancePrior') && 
          options.containsKey('variancePriorRelevance')) {
        final alpha = weights[k] / 
            (weights[k] + options['variancePriorRelevance']);
        vars[k] = alpha * vars[k] + (1 - alpha) * options['variancePrior'];
      }
    }
  }

  double logLikelihood(dynamic data) {
    if (data is List<double>) return _logLikelihood(data);
    if (data is Histogram) return _logLikelihoodHistogram(data);
    throw Exception('Data must be an Array or a Histogram.');
  }

  double _logLikelihood(List<double> data) {
    double l = 0.0;
    final gaussians = _gaussians();
    
    for (final x in data) {
      double p = 0.0;
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * gaussians[k].pdf(x);
      }
      if (p == 0) return double.negativeInfinity;
      l += log(p);
    }
    return l;
  }

  double _logLikelihoodHistogram(Histogram h) {
    double l = 0.0;
    final gaussians = _gaussians();
    final keys = h.counts.keys.toList();
    
    for (final key in keys) {
      double p = 0.0;
      final v = h.value(key);
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * gaussians[k].pdf(v);
      }
      if (p == 0) return double.negativeInfinity;
      l += log(p) * h.counts[key]!;
    }
    return l;
  }

  double _logLikelihoodMemberships(List<List<double>> memberships) {
    double l = 0.0;
    for (final m in memberships) {
      double p = 0.0;
      for (int k = 0; k < nComponents; k++) {
        p += weights[k] * m[k];
      }
      if (p == 0) return double.negativeInfinity;
      l += log(p);
    }
    return l;
  }

  int optimize(dynamic data, [int? maxIterations, double? logLikelihoodTol]) {
    if (data is List<double>) return _optimize(data, maxIterations, logLikelihoodTol);
    if (data is Histogram) return _optimizeHistogram(data, maxIterations, logLikelihoodTol);
    throw Exception('Data must be an Array or a Histogram.');
  }

  int _optimize(List<double> data, [int? maxIterations, double? logLikelihoodTol]) {
    maxIterations ??= MAX_ITERATIONS;
    logLikelihoodTol ??= EPSILON;
    
    if (options['initialize'] == true) _initialize(data);
    
    double logLikelihood = double.negativeInfinity;
    double logLikelihoodDiff = double.infinity;
    List<List<double>>? memberships;
    
    for (int i = 0; i < maxIterations && logLikelihoodDiff > logLikelihoodTol; i++) {
      _updateModel(data, memberships);
      memberships = this.memberships(data);
      final temp = _logLikelihoodMemberships(memberships);
      logLikelihoodDiff = (logLikelihood - temp).abs();
      logLikelihood = temp;
    }
    
    return maxIterations;
  }

  int _optimizeHistogram(Histogram h, [int? maxIterations, double? logLikelihoodTol]) {
    maxIterations ??= MAX_ITERATIONS;
    logLikelihoodTol ??= EPSILON;
    
    if (options['initialize'] == true) _initializeHistogram(h);
    
    double logLikelihood = double.negativeInfinity;
    double logLikelihoodDiff = double.infinity;
    
    for (int i = 0; i < maxIterations && logLikelihoodDiff > logLikelihoodTol; i++) {
      _updateModelHistogram(h);
      final temp = _logLikelihoodHistogram(h);
      logLikelihoodDiff = (logLikelihood - temp).abs();
      logLikelihood = temp;
    }
    
    return maxIterations;
  }

  List<double> _initialize(List<double> data) {
    final n = data.length;
    if (n < nComponents) {
      throw Exception('Data must have more points than components');
    }
    
    final means = <double>[];
    final random = Random();
    means.add(data[random.nextInt(n)]);
    
    for (int m = 1; m < nComponents; m++) {
      final distances = List<double>.filled(n, 0.0);
      double dsum = 0.0;
      
      for (int i = 0; i < n; i++) {
        double minDist = double.infinity;
        for (final mean in means) {
          final d = pow(data[i] - mean, 2).toDouble();
          if (d < minDist) minDist = d;
        }
        distances[i] = minDist;
        dsum += minDist;
      }
      
      double r = random.nextDouble() * dsum;
      double cumsum = 0.0;
      for (int i = 0; i < n; i++) {
        cumsum += distances[i];
        if (cumsum >= r) {
          means.add(data[i]);
          break;
        }
      }
    }
    
    means.sort();
    this.means = means;
    return means;
  }

  List<double> _initializeHistogram(Histogram h) {
    if (h.total < nComponents) {
      throw Exception('Data must have more points than components');
    }
    
    final means = <double>[];
    final random = Random();
    final keys = h.counts.keys.toList();
    
    double r = random.nextDouble() * h.total;
    double cumsum = 0.0;
    for (final key in keys) {
      cumsum += h.counts[key]!;
      if (cumsum >= r) {
        means.add(h.value(key));
        break;
      }
    }
    
    for (int m = 1; m < nComponents; m++) {
      final distances = <double>[];
      double dsum = 0.0;
      
      for (final key in keys) {
        double minDist = double.infinity;
        for (final mean in means) {
          final d = pow(h.value(key) - mean, 2).toDouble();
          if (d < minDist) minDist = d;
        }
        final distance = minDist * h.counts[key]!;
        distances.add(distance);
        dsum += distance;
      }
      
      r = random.nextDouble() * dsum;
      cumsum = 0.0;
      for (int i = 0; i < keys.length; i++) {
        cumsum += distances[i];
        if (cumsum >= r) {
          means.add(h.value(keys[i]));
          break;
        }
      }
    }
    
    means.sort();
    this.means = means;
    return means;
  }

  static double _barycenter(List<double> array, List<double> weights) {
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
      'vars': vars
    };
  }

  static GMM fromModel(Map<String, dynamic> model, [Map<String, dynamic>? options]) {
    return GMM(
      model['nComponents'],
      List<double>.from(model['weights']),
      List<double>.from(model['means']),
      List<double>.from(model['vars']),
      options
    );
  }
}

class Histogram {
  Map<String, List<double>>? bins;
  Map<String, int> counts;
  int total;

  Histogram({Map<String, List<double>>? bins, Map<String, int>? counts})
      : bins = bins,
        counts = counts ?? {},
        total = _total(counts ?? {});

  static int _total(Map<String, int> counts) {
    return counts.values.fold(0, (a, b) => a + b);
  }

  static String _classify(double x, Map<String, List<double>>? bins) {
    if (bins == null) return x.round().toString();
    
    for (final key in bins.keys) {
      final bounds = bins[key]!;
      if (bounds[0] <= x && x < bounds[1]) return key;
    }
    
    return '';
  }

  void add(double x) {
    final c = _classify(x, bins);
    if (c.isNotEmpty) {
      counts.update(c, (value) => value + 1, ifAbsent: () => 1);
      total++;
    }
  }

  List<double> flatten() {
    final result = <double>[];
    for (final key in counts.keys) {
      final value = this.value(key);
      for (int i = 0; i < counts[key]!; i++) {
        result.add(value);
      }
    }
    return result;
  }

  static Histogram fromData(List<double> data, [Map<String, List<double>>? bins]) {
    final histogram = Histogram(bins: bins);
    for (final x in data) {
      histogram.add(x);
    }
    return histogram;
  }

  double value(String key) {
    if (bins != null) {
      if (bins!.containsKey(key)) return (bins![key]![0] + bins![key]![1]) / 2;
      throw Exception('No bin for this key.');
    }
    return double.parse(key);
  }
}