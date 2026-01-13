// model_training_state.dart
part of 'model_training_cubit.dart';

enum ModelTrainingStatus { initial, running, done, error }
enum TrainingStage { preparing, training, validating, done }

@immutable
class ModelTrainingState {
  const ModelTrainingState({
    this.status = ModelTrainingStatus.initial,
    this.stage = TrainingStage.preparing,
    this.epochCurrent = 0,
    this.epochTotal = 1,
    this.loss = 0,
    this.etaText = '—',
    this.trainingTimeMs = 0, // ✅ eklendi
    this.currentRadius,
    this.currentRadiusIndex = 0,
    this.radii = const [],
    this.results = const [],
    this.fileName,
    this.errorMessage,
  });

  final ModelTrainingStatus status;
  final TrainingStage stage;

  final int epochCurrent;
  final int epochTotal;
  final double loss;

  final String etaText; // ✅ ms cinsinden yazdıracağız
  final int trainingTimeMs; // ✅ eklendi

  final double? currentRadius;
  final int currentRadiusIndex;

  final List<double> radii;
  final List<RadiusResult> results;

  final String? fileName;
  final String? errorMessage;

  bool get isRunning => status == ModelTrainingStatus.running;
  bool get isDone => status == ModelTrainingStatus.done;

  double get progress {
    if (epochTotal <= 0) return 0;
    return (epochCurrent / epochTotal).clamp(0.0, 1.0);
  }

  ModelTrainingState copyWith({
    ModelTrainingStatus? status,
    TrainingStage? stage,
    int? epochCurrent,
    int? epochTotal,
    double? loss,
    String? etaText,
    int? trainingTimeMs, // ✅ eklendi
    double? currentRadius,
    int? currentRadiusIndex,
    List<double>? radii,
    List<RadiusResult>? results,
    String? fileName,
    String? errorMessage,
  }) {
    return ModelTrainingState(
      status: status ?? this.status,
      stage: stage ?? this.stage,
      epochCurrent: epochCurrent ?? this.epochCurrent,
      epochTotal: epochTotal ?? this.epochTotal,
      loss: loss ?? this.loss,
      etaText: etaText ?? this.etaText,
      trainingTimeMs: trainingTimeMs ?? this.trainingTimeMs, // ✅ eklendi
      currentRadius: currentRadius ?? this.currentRadius,
      currentRadiusIndex: currentRadiusIndex ?? this.currentRadiusIndex,
      radii: radii ?? this.radii,
      results: results ?? this.results,
      fileName: fileName ?? this.fileName,
      errorMessage: errorMessage,
    );
  }
}

@immutable
class RadiusResult {
  const RadiusResult({
    required this.radius,
    required this.ruleCount,
    required this.train,
    required this.test,
  });

  final double radius;
  final int ruleCount;
  final Metrics train;
  final Metrics test;
}

@immutable
class Metrics {
  const Metrics({
    required this.mae,
    required this.mse,
    required this.rmse,
    required this.r2,
  });

  final double mae;
  final double mse;
  final double rmse;
  final double r2;
}
