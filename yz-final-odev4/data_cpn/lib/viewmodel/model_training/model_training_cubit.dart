// model_training_cubit.dart
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'model_training_state.dart';

class ModelTrainingCubit extends Cubit<ModelTrainingState> {
  ModelTrainingCubit() : super(const ModelTrainingState());

  final Stopwatch _sw = Stopwatch();
  double? _emaSpeed; // steps/ms (EMA smoothing)

  Future<void> initAndStart(Map<String, dynamic>? extra) async {
    if (extra == null) {
      emit(state.copyWith(
        status: ModelTrainingStatus.error,
        errorMessage: 'Veri bulunamadı. Lütfen geri dönüp tekrar deneyin.',
      ));
      return;
    }

    final x = _cast2D(extra['x']);
    final y = _cast1D(extra['y']);
    final radii = _cast1D(extra['radii']);
    final fileName = extra['fileName'] as String?;

    // ✅ satır/epoch limiti (radius başına)
    final maxEpochPerRadius = (extra['maxEpochPerRadius'] as num?)?.toInt() ?? 0;

    if (x == null || y == null || radii == null) {
      emit(state.copyWith(
        status: ModelTrainingStatus.error,
        errorMessage: 'Eksik veri geldi (x/y/radii).',
      ));
      return;
    }
    if (x.isEmpty || y.isEmpty || x.length != y.length) {
      emit(state.copyWith(
        status: ModelTrainingStatus.error,
        errorMessage: 'Veri boyutları uyumsuz. (x:${x.length}, y:${y.length})',
      ));
      return;
    }
    if (radii.length < 4) {
      emit(state.copyWith(
        status: ModelTrainingStatus.error,
        errorMessage: 'En az 4 adet yarıçap değeri gerekli.',
      ));
      return;
    }

    _sw
      ..reset()
      ..start();
    _emaSpeed = null;

    emit(state.copyWith(
      status: ModelTrainingStatus.running,
      stage: TrainingStage.preparing,
      fileName: fileName,
      radii: radii,
      epochCurrent: 0,
      epochTotal: 1,
      loss: 0,
      etaText: 'Hesaplanıyor…',
      trainingTimeMs: 0,
      results: const [],
      errorMessage: null,
    ));

    await _runTraining(
      xAll: x,
      yAll: y,
      radii: radii,
      maxEpochPerRadius: maxEpochPerRadius,
    );
  }

  Future<void> _runTraining({
    required List<List<double>> xAll,
    required List<double> yAll,
    required List<double> radii,
    required int maxEpochPerRadius,
  }) async {
    try {
      emit(state.copyWith(stage: TrainingStage.preparing));

      final split = _splitTrainTest(xAll, yAll, trainRatio: 0.7, seed: 42);
      final xTrain = split.xTrain;
      final yTrain = split.yTrain;
      final xTest = split.xTest;
      final yTest = split.yTest;

      // ✅ “satır sınırı”: radius başına işlenecek örnek sayısı
      final stepsPerRadius = (maxEpochPerRadius > 0)
          ? math.min(maxEpochPerRadius, xTrain.length)
          : xTrain.length;

      final totalSteps = (radii.length * stepsPerRadius).clamp(1, 1 << 30);
      var doneSteps = 0;

      emit(state.copyWith(
        epochTotal: totalSteps,
        epochCurrent: 0,
        etaText: 'Hesaplanıyor…',
        stage: TrainingStage.training,
      ));

      final results = <RadiusResult>[];

      for (var rIndex = 0; rIndex < radii.length; rIndex++) {
        final radius = radii[rIndex];

        final model = await _RadiusCpnModel.train(
          xTrain: xTrain,
          yTrain: yTrain,
          radius: radius,
          maxSteps: stepsPerRadius,
          onStep: (processedInThisRadius, runningMse) async {
            doneSteps = (rIndex * stepsPerRadius) + processedInThisRadius;

            final eta = _computeEtaTextMs(doneSteps, totalSteps);

            // UI’yı boğmamak için seyrek emit
            if (processedInThisRadius % 15 == 0 ||
                processedInThisRadius == stepsPerRadius) {
              emit(state.copyWith(
                epochCurrent: doneSteps,
                epochTotal: totalSteps,
                loss: runningMse,
                etaText: eta,
                currentRadius: radius,
                currentRadiusIndex: rIndex,
              ));
              await Future<void>.delayed(const Duration(milliseconds: 1));
            }
          },
        );

        emit(state.copyWith(stage: TrainingStage.validating));

        final yHatTrain = xTrain.map((row) => model.predict(row)).toList();
        final yHatTest = xTest.map((row) => model.predict(row)).toList();

        final trainMetrics = _metrics(yTrain, yHatTrain);
        final testMetrics = _metrics(yTest, yHatTest);

        results.add(
          RadiusResult(
            radius: radius,
            ruleCount: model.ruleCount,
            train: trainMetrics,
            test: testMetrics,
          ),
        );

        emit(state.copyWith(
          results: List.unmodifiable(results),
          stage: TrainingStage.training,
        ));
      }

      _sw.stop();

      emit(state.copyWith(
        status: ModelTrainingStatus.done,
        stage: TrainingStage.done,
        epochCurrent: totalSteps,
        etaText: '0 ms',
        trainingTimeMs: _sw.elapsedMilliseconds, // ✅ rapora gidecek
      ));
    } catch (e) {
      _sw.stop();
      emit(state.copyWith(
        status: ModelTrainingStatus.error,
        errorMessage: 'Eğitim hatası: $e',
      ));
    }
  }

  // ✅ ETA ms
  String _computeEtaTextMs(int done, int total) {
    if (done <= 0) return 'Hesaplanıyor…';
    if (done >= total) return '0 ms';

    final elapsedMs = _sw.elapsedMilliseconds;
    if (elapsedMs < 200) return 'Hesaplanıyor…';

    final instSpeed = done / elapsedMs; // steps/ms
    if (instSpeed <= 0) return '—';

    _emaSpeed = (_emaSpeed == null)
        ? instSpeed
        : (_emaSpeed! * 0.85 + instSpeed * 0.15);

    final remaining = (total - done).clamp(0, 1 << 30);
    final etaMs = (remaining / _emaSpeed!).ceil().clamp(0, 1 << 30);

    return '$etaMs ms';
  }

  // ---------------- Helpers ----------------

  List<List<double>>? _cast2D(dynamic v) {
    final list = v as List?;
    if (list == null) return null;
    return list
        .map((row) => (row as List).map((e) => (e as num).toDouble()).toList())
        .toList();
  }

  List<double>? _cast1D(dynamic v) {
    final list = v as List?;
    if (list == null) return null;
    return list.map((e) => (e as num).toDouble()).toList();
  }

  _Split _splitTrainTest(
      List<List<double>> x,
      List<double> y, {
        required double trainRatio,
        required int seed,
      }) {
    final n = x.length;
    final idx = List<int>.generate(n, (i) => i);
    idx.shuffle(math.Random(seed));

    final trainN = (n * trainRatio).floor().clamp(1, n - 1);

    final trainIdx = idx.take(trainN);
    final testIdx = idx.skip(trainN);

    final xTrain = <List<double>>[];
    final yTrain = <double>[];
    final xTest = <List<double>>[];
    final yTest = <double>[];

    for (final i in trainIdx) {
      xTrain.add(x[i]);
      yTrain.add(y[i]);
    }
    for (final i in testIdx) {
      xTest.add(x[i]);
      yTest.add(y[i]);
    }

    return _Split(xTrain: xTrain, yTrain: yTrain, xTest: xTest, yTest: yTest);
  }

  static Metrics _metrics(List<double> y, List<double> yHat) {
    double mae = 0;
    double mse = 0;

    final n = y.length;
    for (var i = 0; i < n; i++) {
      final e = y[i] - yHat[i];
      mae += e.abs();
      mse += e * e;
    }
    mae /= n;
    mse /= n;

    final rmse = math.sqrt(mse);

    final meanY = y.reduce((a, b) => a + b) / n;
    double sst = 0;
    double sse = 0;
    for (var i = 0; i < n; i++) {
      final dy = y[i] - meanY;
      sst += dy * dy;

      final e = y[i] - yHat[i];
      sse += e * e;
    }

    final r2 = (sst == 0) ? 0.0 : (1 - (sse / sst));
    return Metrics(mae: mae, mse: mse, rmse: rmse, r2: r2);
  }
}

// ---------------- Model ----------------

typedef _StepCallback = Future<void> Function(int processed, double runningMse);

class _RadiusCpnModel {
  _RadiusCpnModel._(this._clusters);

  final List<_Cluster> _clusters;

  int get ruleCount => _clusters.length;

  double predict(List<double> x) {
    if (_clusters.isEmpty) return 0.0;

    var best = _clusters.first;
    var bestD = _dist(best.center, x);

    for (var i = 1; i < _clusters.length; i++) {
      final d = _dist(_clusters[i].center, x);
      if (d < bestD) {
        bestD = d;
        best = _clusters[i];
      }
    }
    return best.meanY;
  }

  static Future<_RadiusCpnModel> train({
    required List<List<double>> xTrain,
    required List<double> yTrain,
    required double radius,
    required int maxSteps,
    required _StepCallback onStep,
  }) async {
    final clusters = <_Cluster>[];
    double runningMse = 0;
    int processed = 0;

    final limit = math.min(maxSteps, xTrain.length);

    for (var i = 0; i < limit; i++) {
      final x = xTrain[i];
      final y = yTrain[i];

      if (clusters.isEmpty) {
        clusters.add(_Cluster.fromFirst(x, y));
      } else {
        var bestIndex = 0;
        var bestD = _dist(clusters[0].center, x);

        for (var c = 1; c < clusters.length; c++) {
          final d = _dist(clusters[c].center, x);
          if (d < bestD) {
            bestD = d;
            bestIndex = c;
          }
        }

        if (bestD > radius) {
          clusters.add(_Cluster.fromFirst(x, y));
        } else {
          clusters[bestIndex].update(x, y);
        }
      }

      final yHat = _predictFromClusters(clusters, x);
      final e = y - yHat;
      runningMse = ((runningMse * processed) + (e * e)) / (processed + 1);

      processed++;
      await onStep(processed, runningMse);
    }

    return _RadiusCpnModel._(clusters);
  }

  static double _predictFromClusters(List<_Cluster> clusters, List<double> x) {
    var best = clusters.first;
    var bestD = _dist(best.center, x);
    for (var i = 1; i < clusters.length; i++) {
      final d = _dist(clusters[i].center, x);
      if (d < bestD) {
        bestD = d;
        best = clusters[i];
      }
    }
    return best.meanY;
  }

  static double _dist(List<double> a, List<double> b) {
    final dx = a[0] - b[0];
    final dy = a[1] - b[1];
    return math.sqrt(dx * dx + dy * dy);
  }
}

class _Cluster {
  _Cluster({
    required this.center,
    required this.sumY,
    required this.count,
  });

  final List<double> center;
  double sumY;
  int count;

  double get meanY => sumY / count;

  factory _Cluster.fromFirst(List<double> x, double y) {
    return _Cluster(center: [x[0], x[1]], sumY: y, count: 1);
  }

  void update(List<double> x, double y) {
    count += 1;
    center[0] = center[0] + (x[0] - center[0]) / count;
    center[1] = center[1] + (x[1] - center[1]) / count;
    sumY += y;
  }
}

class _Split {
  _Split({
    required this.xTrain,
    required this.yTrain,
    required this.xTest,
    required this.yTest,
  });

  final List<List<double>> xTrain;
  final List<double> yTrain;
  final List<List<double>> xTest;
  final List<double> yTest;
}
