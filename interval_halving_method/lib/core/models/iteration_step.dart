class IterationStep {
  final int iteration;
  final double a;
  final double b;
  final double l;
  final double x1;
  final double xm;
  final double x2;
  final double fx1;
  final double fxm;
  final double fx2;
  final String eliminatedInterval; // Hangi aralık elendi? Örn: "[xm, b]"
  final String newInterval; // Yeni aralık nedir? Örn: "[a, xm]"

  IterationStep({
    required this.iteration,
    required this.a,
    required this.b,
    required this.l,
    required this.x1,
    required this.xm,
    required this.x2,
    required this.fx1,
    required this.fxm,
    required this.fx2,
    required this.eliminatedInterval,
    required this.newInterval,
  });
}