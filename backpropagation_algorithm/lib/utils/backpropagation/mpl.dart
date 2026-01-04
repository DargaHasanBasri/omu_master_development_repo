import 'dart:math' as Math;
import 'package:backpropagation_algorithm/utils/backpropagation/activation.dart';

final class TrainingHistory {
  const TrainingHistory({
    required this.trainLoss,
    required this.testLoss,
    required this.trainPred,
    required this.testPred,
    required this.trainTrue,
    required this.testTrue,
    required this.metricsTrain,
    required this.metricsTest,
  });

  final List<double> trainLoss;
  final List<double> testLoss;

  final List<double> trainPred;
  final List<double> testPred;
  final List<double> trainTrue;
  final List<double> testTrue;

  final Map<String, double> metricsTrain;
  final Map<String, double> metricsTest;
}

final class MlpConfig {
  const MlpConfig({
    required this.inputSize,
    required this.hiddenLayers, // [] => tek katman (input->output)
    this.outputSize = 1,
    required this.activation,
    required this.learningRate,
    required this.epochs,
    this.batchSize = 1,
    this.seed = 42,
  });

  final int inputSize;
  final List<int> hiddenLayers;
  final int outputSize;
  final ActivationType activation;
  final double learningRate;
  final int epochs;
  final int batchSize;
  final int seed;

  List<int> get layerSizes => <int>[inputSize, ...hiddenLayers, outputSize];
}

/// Basit MLP (tam bağlantılı), tek çıktı regresyon
final class Mlp {
  Mlp(this.config) : _rng = Math.Random(config.seed) {
    _initParams();
  }

  final MlpConfig config;
  final Math.Random _rng;

  // W[l] : out x in
  late final List<List<List<double>>> W;
  late final List<List<double>> b;

  void _initParams() {
    final sizes = config.layerSizes;
    final L = sizes.length - 1;

    W = List.generate(L, (_) => <List<double>>[]);
    b = List.generate(L, (_) => <double>[]);

    for (int l = 0; l < L; l++) {
      final inSize = sizes[l];
      final outSize = sizes[l + 1];

      // Xavier init (sigmoid/tanh için iyi)
      final limit = Math.sqrt(6.0 / (inSize + outSize));
      W[l] = List.generate(
        outSize,
            (_) => List.generate(inSize, (_) => (_rng.nextDouble() * 2 - 1) * limit),
      );
      b[l] = List.filled(outSize, 0.0);
    }
  }

  double predictOne(List<double> x) {
    var a = x;
    for (int l = 0; l < W.length; l++) {
      final z = _affine(W[l], b[l], a); // out
      a = z.map((v) => activate(v, config.activation)).toList();
    }
    return a.first;
  }

  List<double> predictAll(List<List<double>> X) => X.map(predictOne).toList();

  /// Senkron eğitim (eski halin aynısı) - UI'ı kilitleyebilir
  TrainingHistory fit({
    required List<List<double>> trainX,
    required List<double> trainY,
    required List<List<double>> testX,
    required List<double> testY,
    void Function(int epoch, double trainMse, double testMse)? onEpoch,
  }) {
    final n = trainY.length;
    final bs = config.batchSize.clamp(1, n);

    final trainLossHist = <double>[];
    final testLossHist = <double>[];

    final idx = List<int>.generate(n, (i) => i);

    for (int epoch = 1; epoch <= config.epochs; epoch++) {
      idx.shuffle(_rng);

      for (int start = 0; start < n; start += bs) {
        final end = (start + bs).clamp(0, n);
        final batchIdx = idx.sublist(start, end);

        final gradW = W
            .map((wl) => List.generate(
          wl.length,
              (j) => List.filled(wl[j].length, 0.0),
        ))
            .toList();
        final gradB = b.map((bl) => List.filled(bl.length, 0.0)).toList();

        for (final i in batchIdx) {
          _backpropOne(
            x: trainX[i],
            y: trainY[i],
            gradW: gradW,
            gradB: gradB,
          );
        }

        final scale = 1.0 / batchIdx.length;
        _applyGradients(gradW, gradB, scale: scale);
      }

      final trainMse = _mse(predictAll(trainX), trainY);
      final testMse = _mse(predictAll(testX), testY);

      trainLossHist.add(trainMse);
      testLossHist.add(testMse);

      onEpoch?.call(epoch, trainMse, testMse);
    }

    final trainPred = predictAll(trainX);
    final testPred = predictAll(testX);

    return TrainingHistory(
      trainLoss: trainLossHist,
      testLoss: testLossHist,
      trainPred: trainPred,
      testPred: testPred,
      trainTrue: List<double>.from(trainY),
      testTrue: List<double>.from(testY),
      metricsTrain: _metrics(trainPred, trainY),
      metricsTest: _metrics(testPred, testY),
    );
  }

  /// ✅ Async eğitim: UI donmasın diye yield veriyor
  /// - evalEvery: loss/metric hesaplamayı kaç epoch'ta bir yapayım? (örn 10)
  /// - yieldEveryBatches: kaç batch'te bir event loop'a dönsün? (örn 20)
  Future<TrainingHistory> fitAsync({
    required List<List<double>> trainX,
    required List<double> trainY,
    required List<List<double>> testX,
    required List<double> testY,
    void Function(int epoch, double trainMse, double testMse)? onEpoch,
    int evalEvery = 1,
    int yieldEveryBatches = 20,
  }) async {
    final n = trainY.length;
    final bs = config.batchSize.clamp(1, n);

    final trainLossHist = <double>[];
    final testLossHist = <double>[];

    final idx = List<int>.generate(n, (i) => i);

    evalEvery = evalEvery.clamp(1, config.epochs);
    yieldEveryBatches = yieldEveryBatches.clamp(1, 1000000);

    for (int epoch = 1; epoch <= config.epochs; epoch++) {
      idx.shuffle(_rng);

      int batchNo = 0;
      for (int start = 0; start < n; start += bs) {
        final end = (start + bs).clamp(0, n);
        final batchIdx = idx.sublist(start, end);

        final gradW = W
            .map((wl) => List.generate(
          wl.length,
              (j) => List.filled(wl[j].length, 0.0),
        ))
            .toList();
        final gradB = b.map((bl) => List.filled(bl.length, 0.0)).toList();

        for (final i in batchIdx) {
          _backpropOne(
            x: trainX[i],
            y: trainY[i],
            gradW: gradW,
            gradB: gradB,
          );
        }

        final scale = 1.0 / batchIdx.length;
        _applyGradients(gradW, gradB, scale: scale);

        batchNo++;
        if (batchNo % yieldEveryBatches == 0) {
          await Future<void>.delayed(Duration.zero); // ✅ UI'ya nefes
        }
      }

      final shouldEval =
          (epoch == 1) || (epoch % evalEvery == 0) || (epoch == config.epochs);

      if (shouldEval) {
        final trainMse = _mse(predictAll(trainX), trainY);
        final testMse = _mse(predictAll(testX), testY);

        trainLossHist.add(trainMse);
        testLossHist.add(testMse);

        onEpoch?.call(epoch, trainMse, testMse);

        // ✅ emit sonrası frame çizilebilsin
        await Future<void>.delayed(Duration.zero);
      } else {
        // yine de epoch arası UI'a şans ver
        await Future<void>.delayed(Duration.zero);
      }
    }

    final trainPred = predictAll(trainX);
    final testPred = predictAll(testX);

    return TrainingHistory(
      trainLoss: trainLossHist,
      testLoss: testLossHist,
      trainPred: trainPred,
      testPred: testPred,
      trainTrue: List<double>.from(trainY),
      testTrue: List<double>.from(testY),
      metricsTrain: _metrics(trainPred, trainY),
      metricsTest: _metrics(testPred, testY),
    );
  }

  void _backpropOne({
    required List<double> x,
    required double y,
    required List<List<List<double>>> gradW,
    required List<List<double>> gradB,
  }) {
    final activations = <List<double>>[x]; // a0
    var a = x;

    for (int l = 0; l < W.length; l++) {
      final z = _affine(W[l], b[l], a);
      a = z.map((v) => activate(v, config.activation)).toList();
      activations.add(a);
    }

    final pred = activations.last.first;
    final dL_da = pred - y;

    var delta = List<double>.filled(activations.last.length, 0.0);
    for (int j = 0; j < delta.length; j++) {
      final aL = activations.last[j];
      delta[j] = dL_da * dActivateFromA(aL, config.activation);
    }

    for (int l = W.length - 1; l >= 0; l--) {
      final aPrev = activations[l];
      final w = W[l];

      for (int j = 0; j < w.length; j++) {
        gradB[l][j] += delta[j];
        for (int k = 0; k < w[j].length; k++) {
          gradW[l][j][k] += delta[j] * aPrev[k];
        }
      }

      if (l == 0) break;

      final deltaPrev = List<double>.filled(aPrev.length, 0.0);
      for (int k = 0; k < aPrev.length; k++) {
        double s = 0.0;
        for (int j = 0; j < w.length; j++) {
          s += w[j][k] * delta[j];
        }
        deltaPrev[k] = s * dActivateFromA(activations[l][k], config.activation);
      }
      delta = deltaPrev;
    }
  }

  void _applyGradients(
      List<List<List<double>>> gradW,
      List<List<double>> gradB, {
        required double scale,
      }) {
    final lr = config.learningRate;
    for (int l = 0; l < W.length; l++) {
      for (int j = 0; j < W[l].length; j++) {
        b[l][j] -= lr * gradB[l][j] * scale;
        for (int k = 0; k < W[l][j].length; k++) {
          W[l][j][k] -= lr * gradW[l][j][k] * scale;
        }
      }
    }
  }

  static List<double> _affine(
      List<List<double>> w,
      List<double> b,
      List<double> a,
      ) {
    final out = List<double>.filled(b.length, 0.0);
    for (int j = 0; j < b.length; j++) {
      double s = b[j];
      for (int k = 0; k < a.length; k++) {
        s += w[j][k] * a[k];
      }
      out[j] = s;
    }
    return out;
  }

  static double _mse(List<double> pred, List<double> y) {
    double s = 0.0;
    for (int i = 0; i < y.length; i++) {
      final e = pred[i] - y[i];
      s += e * e;
    }
    return s / y.length;
  }

  static Map<String, double> _metrics(List<double> pred, List<double> y) {
    final mse = _mse(pred, y);
    final rmse = Math.sqrt(mse);

    double mae = 0.0;
    for (int i = 0; i < y.length; i++) {
      mae += (pred[i] - y[i]).abs();
    }
    mae /= y.length;

    final meanY = y.reduce((a, b) => a + b) / y.length;
    double ssTot = 0.0;
    double ssRes = 0.0;
    for (int i = 0; i < y.length; i++) {
      ssTot += (y[i] - meanY) * (y[i] - meanY);
      ssRes += (y[i] - pred[i]) * (y[i] - pred[i]);
    }
    final r2 = ssTot == 0 ? 0.0 : (1.0 - ssRes / ssTot);

    return {
      'MSE': mse,
      'RMSE': rmse,
      'MAE': mae,
      'R2': r2,
    };
  }
}
