import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // debugPrint

class DeltaTableState {
  final int columnCount; // x sayısı
  final int rowCount; // sabit: 4
  final List<List<String?>> values; // tablo hücreleri (x'ler + y)
  final String? phi; // φ (string)
  final String? eta; // η (string)
  final List<String?> weights; // w1..wk (string)

  final List<double>? trainedW; // eğitim sonrası w'ler
  final double? trainedPhi; // eğitim sonrası φ
  final bool hasTrained; // en az bir eğitim yapıldı mı?
  final String? epochLimitText;

  const DeltaTableState({
    required this.columnCount,
    required this.rowCount,
    required this.values,
    required this.phi,
    required this.eta,
    required this.weights,
    this.trainedW,
    this.trainedPhi,
    this.hasTrained = false,
    this.epochLimitText,
  });

  DeltaTableState copyWith({
    int? columnCount,
    int? rowCount,
    List<List<String?>>? values,
    String? phi,
    String? eta,
    List<String?>? weights,
    List<double>? trainedW,
    double? trainedPhi,
    bool? hasTrained,
    String? epochLimitText,
  }) {
    return DeltaTableState(
      columnCount: columnCount ?? this.columnCount,
      rowCount: rowCount ?? this.rowCount,
      values: values ?? this.values,
      phi: phi ?? this.phi,
      eta: eta ?? this.eta,
      weights: weights ?? this.weights,
      trainedW: trainedW ?? this.trainedW,
      trainedPhi: trainedPhi ?? this.trainedPhi,
      hasTrained: hasTrained ?? this.hasTrained,
      epochLimitText: epochLimitText ?? this.epochLimitText,
    );
  }
}

class DeltaStepTrace {
  final int epoch;
  final int step; // 1..N
  final List<double> x; // özellikler
  final int y; // hedef (0/1 beklenir)
  final List<double> wBefore;
  final double phiBefore;
  final double z; // net = w·x + φ
  final int yhat; // sınıflama: z>=0 ? 1:0
  final int eCls; // sınıflama hatası: y - yhat
  final double eCont; // sürekli hata: y - z
  final List<double> wAfter;
  final double phiAfter;

  DeltaStepTrace({
    required this.epoch,
    required this.step,
    required this.x,
    required this.y,
    required this.wBefore,
    required this.phiBefore,
    required this.z,
    required this.yhat,
    required this.eCls,
    required this.eCont,
    required this.wAfter,
    required this.phiAfter,
  });
}

class DeltaEpochTrace {
  final int epoch;
  final int errors; // sınıflama hatası sayısı
  final double accuracy; // 0..1
  final double mse; // ort. karesel hata
  final List<DeltaStepTrace> steps;

  DeltaEpochTrace({
    required this.epoch,
    required this.errors,
    required this.accuracy,
    required this.mse,
    required this.steps,
  });
}

class DeltaTrace {
  final List<DeltaEpochTrace> epochs;
  final List<double> finalW;
  final double finalPhi;
  final int totalEpochs;
  final bool converged;

  DeltaTrace({
    required this.epochs,
    required this.finalW,
    required this.finalPhi,
    required this.totalEpochs,
    required this.converged,
  });
}

class DeltaTrainResult {
  final int epochs;
  final bool converged;
  final List<double> weights;
  final double phi;
  final double mse;
  final double accuracy;

  DeltaTrainResult({
    required this.epochs,
    required this.converged,
    required this.weights,
    required this.phi,
    required this.mse,
    required this.accuracy,
  });
}

class DeltaTableCubit extends Cubit<DeltaTableState> {
  static const int minCols = 2;
  static const int maxCols = 4;

  static const int minRows = 2;
  static const int maxRows = 12;

  static const int _kFixed = 4;

  DeltaTableCubit({int initialCount = 3})
    : assert(initialCount >= minCols && initialCount <= maxCols),
      super(_initialState(initialCount));

  static DeltaTableState _initialState(int colCount) {
    const rows = 4;
    final cols = colCount + 1; // x'ler + y
    return DeltaTableState(
      columnCount: colCount,
      rowCount: rows,
      values: List.generate(rows, (_) => List.filled(cols, null)),
      phi: null,
      eta: null,
      weights: List.filled(colCount, null),
      trainedW: null,
      trainedPhi: null,
      hasTrained: false,
      epochLimitText: null,
    );
  }

  void increase() {
    if (state.columnCount < maxCols) {
      final newCount = state.columnCount + 1;
      final cols = newCount + 1;
      emit(
        state.copyWith(
          columnCount: newCount,
          values: List.generate(state.rowCount, (_) => List.filled(cols, null)),
          weights: List.filled(newCount, null),
          phi: null,
          eta: null,
          trainedW: null,
          trainedPhi: null,
          hasTrained: false,
          epochLimitText: null,
        ),
      );
    }
  }

  void decrease() {
    if (state.columnCount > minCols) {
      final newCount = state.columnCount - 1;
      final cols = newCount + 1;
      emit(
        state.copyWith(
          columnCount: newCount,
          values: List.generate(state.rowCount, (_) => List.filled(cols, null)),
          weights: List.filled(newCount, null),
          phi: null,
          eta: null,
          trainedW: null,
          trainedPhi: null,
          hasTrained: false,
          epochLimitText: null,
        ),
      );
    }
  }

  void addRow() {
    if (state.rowCount >= maxRows) return;

    final cols = state.columnCount + 1; // x'ler + y
    final newValues = state.values.map((r) => [...r]).toList();

    // tüm kolonları null olan boş satır ekle
    newValues.add(List<String?>.filled(cols, null));

    emit(
      state.copyWith(
        rowCount: state.rowCount + 1,
        values: newValues,
      ),
    );
  }

  void removeRow() {
    if (state.rowCount <= minRows) return;

    final newValues = state.values.map((r) => [...r]).toList();
    if (newValues.isNotEmpty) {
      newValues.removeLast();
    }

    emit(
      state.copyWith(
        rowCount: state.rowCount - 1,
        values: newValues,
      ),
    );
  }

  void setCell(int row, int col, String? text) {
    final newVals = state.values.map((r) => [...r]).toList();
    newVals[row][col] = text;
    emit(state.copyWith(values: newVals));
  }

  void clearRow(int row) {
    if (row < 0 || row >= state.rowCount) return;
    final newVals = state.values.map((r) => [...r]).toList();
    for (int c = 0; c <= state.columnCount; c++) {
      newVals[row][c] = null;
    }
    emit(state.copyWith(values: newVals));
  }

  void clearAll() {
    final cols = state.columnCount + 1;
    emit(
      state.copyWith(
        values: List.generate(state.rowCount, (_) => List.filled(cols, null)),
        weights: List.filled(state.columnCount, null),
        phi: null,
        eta: null,
        trainedW: null,
        trainedPhi: null,
        hasTrained: false,
        epochLimitText: null,
      ),
    );
  }

  void setPhi(String? txt) => emit(state.copyWith(phi: txt));

  void setEta(String? txt) => emit(state.copyWith(eta: txt));

  void setEpochLimitText(String? txt) => // NEW
  emit(state.copyWith(epochLimitText: txt)); // NEW

  void setWeight(int index, String? txt) {
    if (index < 0 || index >= state.columnCount) return;
    final ws = [...state.weights];
    ws[index] = txt;
    emit(state.copyWith(weights: ws));
  }

  double _parseDouble(String? s, {double? fallback}) {
    if (s == null) return fallback ?? double.nan;
    final t = s.replaceAll(',', '.');
    return double.tryParse(t) ?? (fallback ?? double.nan);
  }

  int _parseInt01(String? s) {
    if (s == null) return 0;
    final v = int.tryParse(s.trim()) ?? 0;
    return v != 0 ? 1 : 0;
  }

  int _parseEpochLimit(String? s, {int fallback = 500}) { // NEW
    if (s == null || s.trim().isEmpty) return fallback;
    final v = int.tryParse(s.trim());
    if (v == null || v <= 0) return fallback;
    return v;
  }

  Future<DeltaTrainResult> trainDelta({
    int maxEpochs = 500,
    double tolMse = 1e-4,
    bool debug = false,
  }) async {
    final k = state.columnCount;
    final rows = state.rowCount;
    final cols = k + 1;

    final eta = _parseDouble(state.eta, fallback: double.nan);
    var phi = _parseDouble(state.phi, fallback: double.nan);
    if (eta.isNaN) throw StateError('η (öğrenme katsayısı) boş/geçersiz.');
    if (phi.isNaN) throw StateError('φ (eşik/bias) boş/geçersiz.');

    final maxEpochsValue = _parseEpochLimit( // NEW
      state.epochLimitText,
      fallback: maxEpochs,
    );

    final w = <double>[];
    for (int j = 0; j < k; j++) {
      final v = _parseDouble(state.weights[j], fallback: double.nan);
      if (v.isNaN) throw StateError('W${j + 1} boş/geçersiz.');
      w.add(v);
    }

    final X = <List<double>>[];
    final y = <int>[];
    for (int r = 0; r < rows; r++) {
      final row = state.values[r];
      if (row.length < cols) continue;

      final feats = <double>[];
      bool ok = true;
      for (int j = 0; j < k; j++) {
        final v = _parseDouble(row[j], fallback: double.nan);
        if (v.isNaN) {
          ok = false;
          break;
        }
        feats.add(v);
      }
      if (!ok) continue;
      X.add(feats);
      y.add(_parseInt01(row[k]));
    }
    if (X.isEmpty) throw StateError('Eğitim için geçerli satır yok.');

    int epoch = 0;
    bool converged = false;
    double mse = double.infinity;
    double accuracy = 0.0;

    double net(List<double> xi) {
      double s = phi;
      for (int j = 0; j < k; j++) s += w[j] * xi[j];
      return s;
    }

    while (epoch < maxEpochsValue) {
      double se = 0.0;
      int correct = 0;

      for (int i = 0; i < X.length; i++) {
        final z = net(X[i]);
        final yhat = z >= 0 ? 1 : 0;
        final eCont = y[i] - z;

        for (int j = 0; j < k; j++) {
          w[j] += eta * eCont * X[i][j];
        }
        phi += eta * eCont;

        se += eCont * eCont;
        if (y[i] == yhat) correct++;
      }

      epoch++;
      mse = se / X.length;
      accuracy = correct / X.length;

      if (debug) {
        debugPrint(
          '[delta] epoch=$epoch  mse=${mse.toStringAsFixed(_kFixed)}  '
          'acc=${(accuracy * 100).toStringAsFixed(1)}%  '
          'w=[${w.map((v) => v.toStringAsFixed(_kFixed)).join(', ')}]  '
          'phi=${phi.toStringAsFixed(_kFixed)}',
        );
      }

      if (mse <= tolMse || accuracy == 1.0) {
        converged = true;
        break;
      }
    }

    final ws = [...state.weights];
    for (int j = 0; j < k; j++) {
      ws[j] = w[j].toStringAsFixed(_kFixed);
    }

    emit(
      state.copyWith(
        weights: ws,
        phi: phi.toStringAsFixed(_kFixed),
        trainedW: List<double>.from(w),
        trainedPhi: phi,
        hasTrained: true,
      ),
    );

    return DeltaTrainResult(
      epochs: epoch,
      converged: converged,
      weights: List<double>.from(w),
      phi: phi,
      mse: mse,
      accuracy: accuracy,
    );
  }

  Future<DeltaTrace> trainDeltaWithTrace({
    int maxEpochs = 500,
    double tolMse = 1e-4,
  }) async {
    final k = state.columnCount;
    final rows = state.rowCount;
    final cols = k + 1;

    final eta = _parseDouble(state.eta, fallback: double.nan);
    var phi = _parseDouble(state.phi, fallback: double.nan);
    if (eta.isNaN) throw StateError('η (öğrenme katsayısı) boş/geçersiz.');
    if (phi.isNaN) throw StateError('φ (eşik/bias) boş/geçersiz.');

    final w = <double>[];
    for (int j = 0; j < k; j++) {
      final v = _parseDouble(state.weights[j], fallback: double.nan);
      if (v.isNaN) throw StateError('W${j + 1} boş/geçersiz.');
      w.add(v);
    }

    final maxEpochsValue = _parseEpochLimit( // NEW
      state.epochLimitText,
      fallback: maxEpochs,
    );

    final X = <List<double>>[];
    final y = <int>[];
    for (int r = 0; r < rows; r++) {
      final row = state.values[r];
      if (row.length < cols) continue;

      final feats = <double>[];
      bool ok = true;
      for (int j = 0; j < k; j++) {
        final v = _parseDouble(row[j], fallback: double.nan);
        if (v.isNaN) {
          ok = false;
          break;
        }
        feats.add(v);
      }
      if (!ok) continue;
      X.add(feats);
      y.add(_parseInt01(row[k]));
    }
    if (X.isEmpty) throw StateError('Eğitim için geçerli satır yok.');

    final epochsTrace = <DeltaEpochTrace>[];
    int epoch = 0;
    bool converged = false;

    double net(List<double> xi) {
      double s = phi;
      for (int j = 0; j < k; j++) s += w[j] * xi[j];
      return s;
    }

    while (epoch < maxEpochsValue) {
      final steps = <DeltaStepTrace>[];
      double se = 0.0;
      int correct = 0;
      int errors = 0;

      for (int i = 0; i < X.length; i++) {
        final xi = X[i];
        final yi = y[i];

        final wBefore = List<double>.from(w);
        final phiBefore = phi;

        final z = net(xi);
        final yhat = z >= 0 ? 1 : 0;
        final eCls = yi - yhat;
        final eCont = yi - z; // delta hatası

        // update
        for (int j = 0; j < k; j++) {
          w[j] += eta * eCont * xi[j];
        }
        phi += eta * eCont;

        // metrics
        se += eCont * eCont;
        if (eCls == 0) {
          correct++;
        } else {
          errors++;
        }

        steps.add(
          DeltaStepTrace(
            epoch: epoch + 1,
            step: i + 1,
            x: List<double>.from(xi),
            y: yi,
            wBefore: wBefore,
            phiBefore: phiBefore,
            z: z,
            yhat: yhat,
            eCls: eCls,
            eCont: eCont,
            wAfter: List<double>.from(w),
            phiAfter: phi,
          ),
        );
      }

      epoch++;
      final mse = se / X.length;
      final acc = correct / X.length;

      epochsTrace.add(
        DeltaEpochTrace(
          epoch: epoch,
          errors: errors,
          accuracy: acc,
          mse: mse,
          steps: steps,
        ),
      );

      if (mse <= tolMse || acc == 1.0) {
        converged = true;
        break;
      }
    }

    final ws = [...state.weights];
    for (int j = 0; j < k; j++) {
      ws[j] = w[j].toStringAsFixed(_kFixed);
    }

    emit(
      state.copyWith(
        weights: ws,
        phi: phi.toStringAsFixed(_kFixed),
        trainedW: List<double>.from(w),
        trainedPhi: phi,
        hasTrained: true,
      ),
    );

    return DeltaTrace(
      epochs: epochsTrace,
      finalW: List<double>.from(w),
      finalPhi: phi,
      totalEpochs: epoch,
      converged: converged,
    );
  }

  /// Eğitim sonrası mevcut w ve φ ile test yapar.
  ///
  /// [table] verilmezse, default olarak `state.values` üzerinde test yapar.
  /// Her satır: [x1, x2, ..., x_k, y] formatında olmalı.
  Future<DeltaTestResult> testDeltaOnTable({List<List<String?>>? table}) async {
    final k = state.columnCount;
    final cols = k + 1;
    final data = table ?? state.values;

    // 1) w ve φ'yi state'ten oku (eğitimden sonra doldurulmuş olmalı)
    final phiStr = state.phi;
    if (phiStr == null) {
      throw StateError(
        'Test için φ değeri bulunamadı. Önce eğitim yapmalısın.',
      );
    }
    final phi = _parseDouble(phiStr, fallback: double.nan);
    if (phi.isNaN) {
      throw StateError(
        'φ değeri geçersiz. Lütfen eğitim parametrelerini kontrol et.',
      );
    }

    final w = <double>[];
    for (int j = 0; j < k; j++) {
      final txt = state.weights[j];
      final v = _parseDouble(txt, fallback: double.nan);
      if (v.isNaN) {
        throw StateError(
          'Test için W${j + 1} değeri geçersiz. Önce eğitim yap.',
        );
      }
      w.add(v);
    }

    // 2) Satırlardan X ve y'yi çek, net ve ŷ hesapla
    final samples = <DeltaTestSampleResult>[];
    int total = 0;
    int correct = 0;

    for (final row in data) {
      if (row.length < cols) continue;

      final feats = <double>[];
      bool ok = true;
      for (int j = 0; j < k; j++) {
        final v = _parseDouble(row[j], fallback: double.nan);
        if (v.isNaN) {
          ok = false;
          break;
        }
        feats.add(v);
      }
      if (!ok) continue;

      final t = _parseInt01(row[k]); // gerçek y

      double z = phi;
      for (int j = 0; j < k; j++) {
        z += w[j] * feats[j];
      }
      final yhat = z >= 0 ? 1 : 0;

      final sample = DeltaTestSampleResult(
        x: feats,
        target: t,
        netInput: z,
        prediction: yhat,
      );
      samples.add(sample);

      total++;
      if (sample.isCorrect) correct++;
    }

    if (total == 0) {
      throw StateError('Test için geçerli satır yok.');
    }

    final acc = correct / total;

    return DeltaTestResult(
      samples: samples,
      usedWeights: List<double>.from(w),
      usedPhi: phi,
      total: total,
      correct: correct,
      incorrect: total - correct,
      accuracy: acc,
    );
  }
}

String subscript(int n) {
  const subs = {
    '0': '₀',
    '1': '₁',
    '2': '₂',
    '3': '₃',
    '4': '₄',
    '5': '₅',
    '6': '₆',
    '7': '₇',
    '8': '₈',
    '9': '₉',
    '-': '₋',
  };
  return n.toString().split('').map((c) => subs[c] ?? c).join();
}

class DeltaTestSampleResult {
  final List<double> x; // özellikler
  final int target; // gerçek y (0/1)
  final double netInput; // z = w·x + φ
  final int prediction; // ŷ = 1[z>=0]
  bool get isCorrect => target == prediction;

  DeltaTestSampleResult({
    required this.x,
    required this.target,
    required this.netInput,
    required this.prediction,
  });
}

class DeltaTestResult {
  final List<DeltaTestSampleResult> samples;
  final List<double> usedWeights;
  final double usedPhi;
  final int total;
  final int correct;
  final int incorrect;
  final double accuracy; // 0..1

  const DeltaTestResult({
    required this.samples,
    required this.usedWeights,
    required this.usedPhi,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.accuracy,
  });
}
