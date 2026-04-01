import 'package:interval_halving_method/core/models/iteration_step.dart';

abstract class OptimizationState {}

class OptimizationInitial extends OptimizationState {}

class OptimizationLoading extends OptimizationState {}

class OptimizationSuccess extends OptimizationState {
  final List<IterationStep> steps;
  final double optimalX;
  final double optimalFx;
  final int totalIterations;
  final int processTimeMs;

  OptimizationSuccess({
    required this.steps,
    required this.optimalX,
    required this.optimalFx,
    required this.totalIterations,
    required this.processTimeMs,
  });
}

class OptimizationError extends OptimizationState {
  final String message;
  OptimizationError(this.message);
}