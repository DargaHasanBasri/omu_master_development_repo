import 'dart:math' as Math;

enum ActivationType { linear, sigmoid, tanh }

double activate(double x, ActivationType t) {
  switch (t) {
    case ActivationType.linear:
      return x;

    case ActivationType.sigmoid:
      if (x >= 0) {
        final z = MathHelpers.exp(-x);
        return 1.0 / (1.0 + z);
      } else {
        final z = MathHelpers.exp(x);
        return z / (1.0 + z);
      }

    case ActivationType.tanh:
      return MathHelpers.tanh(x);
  }
}

double dActivateFromA(double a, ActivationType t) {
  switch (t) {
    case ActivationType.linear:
      return 1.0;
    case ActivationType.sigmoid:
      return a * (1.0 - a);
    case ActivationType.tanh:
      return 1.0 - a * a;
  }
}

abstract final class MathHelpers {
  static double exp(double x) => Math.exp(x);

  static double tanh(double x) {
    if (x > 20) return 1.0;
    if (x < -20) return -1.0;

    final e2x = exp(2 * x);
    return (e2x - 1) / (e2x + 1);
  }
}
