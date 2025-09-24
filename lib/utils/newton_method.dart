class NewtonMethod {
  /// A math thing, that searches X based on Y of a polynomial regression
  static double? solve({
    required double Function(double) f, // polynomial regression itself
    required double Function(double) fPrime,
    required double initialGuess,
    double tolerance = 1e-10,
    int maxIterations = 100,
  }) {
    double x = initialGuess;
    int iteration = 0;

    while (iteration < maxIterations) {
      double fx = f(x);
      double fpx = fPrime(x);

      // zero division thingy
      if (fpx.abs() < tolerance) {
        print('The derivative is too small. The method may not converge.');
        return null;
      }

      double xNew = x - fx / fpx;

      // Accuracy test
      if ((xNew - x).abs() < tolerance) {
        return xNew;
      }

      x = xNew;
      iteration++;
    }

    print('The method did not converge within $maxIterations iterations.');
    return x;
  }
}