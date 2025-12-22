import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class DataSetTableState {
  final int inputCount; // Girdi özellik sayısı (x1..x_k)
  final int rowCount; // Satır sayısı (örnek sayısı) – şu an sabit 4
  final List<List<String?>>
  samples; // Eğitim verisi: her satır [x1, x2, ..., x_k, y] şeklinde
  final String?
  biasText; // Bias katsayısı (w₀) için textfield değeri (bias sabiti = 1)
  final String? learningRateText; // Öğrenme katsayısı η için textfield değeri
  final List<String?>
  weightTexts; // Ağırlıklar w₁..w_k için textfield değerleri
  final List<double>? trainedWeights; // eğitim sonrası w1..wk
  final double? trainedBiasWeight; // eğitim sonrası w0
  final bool hasTrained; // en az bir eğitim yapıldı mı?
  final String? epochLimitText;

  const DataSetTableState({
    required this.inputCount,
    required this.rowCount,
    required this.samples,
    required this.biasText,
    required this.learningRateText,
    required this.weightTexts,
    this.trainedWeights,
    this.trainedBiasWeight,
    this.hasTrained = false,
    this.epochLimitText,
  });

  DataSetTableState copyWith({
    int? inputCount,
    int? rowCount,
    List<List<String?>>? samples,
    String? biasText,
    String? learningRateText,
    List<String?>? weightTexts,
    List<double>? trainedWeights,
    double? trainedBiasWeight,
    bool? hasTrained,
    String? epochLimitText,
  }) {
    return DataSetTableState(
      inputCount: inputCount ?? this.inputCount,
      rowCount: rowCount ?? this.rowCount,
      samples: samples ?? this.samples,
      biasText: biasText ?? this.biasText,
      learningRateText: learningRateText ?? this.learningRateText,
      weightTexts: weightTexts ?? this.weightTexts,
      trainedWeights: trainedWeights ?? this.trainedWeights,
      trainedBiasWeight: trainedBiasWeight ?? this.trainedBiasWeight,
      hasTrained: hasTrained ?? this.hasTrained,
      epochLimitText: epochLimitText ?? this.epochLimitText,
    );
  }
}

class DataSetTableCubit extends Cubit<DataSetTableState> {
  static const int minInputs = 2;
  static const int maxInputs = 4;

  static const int minRows = 2;
  static const int maxRows = 12;

  DataSetTableCubit({int initialInputCount = 3})
    : assert(initialInputCount >= minInputs && initialInputCount <= maxInputs),
      super(_initialState(initialInputCount));

  // -------------------- INIT --------------------
  static DataSetTableState _initialState(int inputCount) {
    const rows = 4;
    final cols = inputCount + 1; // x'ler + y
    return DataSetTableState(
      inputCount: inputCount,
      rowCount: rows,
      samples: List.generate(rows, (_) => List.filled(cols, null)),
      biasText: null,
      learningRateText: null,
      weightTexts: List.filled(inputCount, null),
      trainedWeights: null,
      trainedBiasWeight: null,
      hasTrained: false,
      epochLimitText: null,
    );
  }

  // -------------------- INPUT COUNT OPS --------------------
  void increaseInputs() {
    if (state.inputCount < maxInputs) {
      final newCount = state.inputCount + 1;
      final cols = newCount + 1;
      emit(
        state.copyWith(
          inputCount: newCount,
          samples: List.generate(
            state.rowCount,
            (_) => List.filled(cols, null),
          ),
          weightTexts: List.filled(newCount, null),
          biasText: null,
          learningRateText: null,
        ),
      );
      clearAll();
    }
  }

  void decreaseInputs() {
    if (state.inputCount > minInputs) {
      final newCount = state.inputCount - 1;
      final cols = newCount + 1;
      emit(
        state.copyWith(
          inputCount: newCount,
          samples: List.generate(
            state.rowCount,
            (_) => List.filled(cols, null),
          ),
          weightTexts: List.filled(newCount, null),
          biasText: null,
          learningRateText: null,
        ),
      );
      clearAll();
    }
  }

  void addRow() {
    if (state.rowCount >= maxRows) return;

    final cols = state.inputCount + 1; // x'ler + y
    final newSamples = state.samples.map((r) => [...r]).toList();

    // tüm kolonları null olan boş satır ekle
    newSamples.add(List<String?>.filled(cols, null));

    emit(
      state.copyWith(
        rowCount: state.rowCount + 1,
        samples: newSamples,
      ),
    );
  }

  /// Tablodan en alttaki satırı siler.
  void removeRow() {
    if (state.rowCount <= minRows) return;

    final newSamples = state.samples.map((r) => [...r]).toList();
    if (newSamples.isNotEmpty) {
      newSamples.removeLast();
    }

    emit(
      state.copyWith(
        rowCount: state.rowCount - 1,
        samples: newSamples,
      ),
    );
  }

  // -------------------- TABLE OPS --------------------
  /// Hücre yaz (col: 0..inputCount-1 => x, inputCount => y)
  void setCell(int row, int col, String? text) {
    final newSamples = state.samples.map((r) => [...r]).toList();
    newSamples[row][col] = text;
    emit(state.copyWith(samples: newSamples));
  }

  void clearRow(int row) {
    if (row < 0 || row >= state.rowCount) return;
    final newSamples = state.samples.map((r) => [...r]).toList();
    for (int c = 0; c <= state.inputCount; c++) {
      newSamples[row][c] = null;
    }
    emit(state.copyWith(samples: newSamples));
  }

  void clearAll() {
    final cols = state.inputCount + 1;
    emit(
      state.copyWith(
        samples: List.generate(state.rowCount, (_) => List.filled(cols, null)),
        weightTexts: List.filled(state.inputCount, null),
        biasText: null,
        learningRateText: null,
        trainedWeights: null,
        trainedBiasWeight: null,
        hasTrained: false,
        epochLimitText: null,
      ),
    );
  }

  // -------------------- PARAM SET --------------------
  /// Bias katsayısı (w₀) için textfield setter
  void setBiasText(String? txt) => emit(state.copyWith(biasText: txt));

  /// Öğrenme katsayısı η için textfield setter
  void setLearningRateText(String? txt) =>
      emit(state.copyWith(learningRateText: txt));

  /// w_j için textfield setter
  void setWeightText(int index, String? txt) {
    if (index < 0 || index >= state.inputCount) return;
    final ws = [...state.weightTexts];
    ws[index] = txt;
    emit(state.copyWith(weightTexts: ws));
  }

  /// Epoch sınırı için textfield setter
  void setEpochLimitText(String? txt) =>
      emit(state.copyWith(epochLimitText: txt));

  // -------------------- HELPERS --------------------
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

  int _parseEpochLimit(String? s, {int fallback = 500}) {
    if (s == null || s.trim().isEmpty) return fallback;
    final v = int.tryParse(s.trim());
    if (v == null || v <= 0) return fallback;
    return v;
  }

  /// W1, W2, W3, η ve w₀ değerlerini default olarak ayarlar:
  /// W1 = 0.2, W2 = -0.5, W3 = -0.1, η = 0.2, w₀ = 0.5
  void applyDefaultParams() {
    const defaultInputCount = 3;

    // inputCount'i 3'e çekiyoruz (3 özellik: x1,x2,x3)
    final rows = state.rowCount;
    final cols = defaultInputCount + 1; // 3 x + y

    // Eski veriyi mümkün olduğunca koruyarak kolonları genişlet
    final newSamples = List<List<String?>>.generate(rows, (r) {
      final old = r < state.samples.length
          ? state.samples[r]
          : const <String?>[];
      final list = List<String?>.filled(cols, null);
      for (int c = 0; c < old.length && c < cols; c++) {
        list[c] = old[c];
      }
      return list;
    });

    // İlk 3 ağırlık için text değerleri
    final weightTexts = <String?>['0.2', '-0.5', '-0.1'];

    emit(
      state.copyWith(
        inputCount: defaultInputCount,
        samples: newSamples,
        weightTexts: weightTexts,
        learningRateText: '0.2',
        biasText: '0.5',
        trainedWeights: null,
        trainedBiasWeight: null,
        hasTrained: false,
      ),
    );
  }

  /// Eğitim verisini default olarak ayarlar:
  /// x1: 0,0,1,1
  /// x2: 0,1,0,1
  /// x3: 1,0,1,1
  /// y : 1,1,1,0
  void applyDefaultDataset() {
    const defaultInputCount = 3;
    const rows = 4;
    const cols = defaultInputCount + 1; // 3 x + y

    final samples = <List<String?>>[
      ['0', '0', '1', '1'], // x1=0, x2=0, x3=1, y=1
      ['0', '1', '1', '1'], // x1=0, x2=1, x3=1, y=1
      ['1', '0', '1', '1'], // x1=1, x2=0, x3=1, y=1
      ['1', '1', '1', '0'], // x1=1, x2=1, x3=1, y=0
    ];

    emit(
      state.copyWith(
        inputCount: defaultInputCount,
        rowCount: rows,
        samples: samples,
        // eğitim verisini kurarken eğitim sonucunu resetlemek mantıklı
        trainedWeights: null,
        trainedBiasWeight: null,
        hasTrained: false,
      ),
    );
  }

  // -------------------- PERCEPTRON TRAIN + DEBUG --------------------
  /// Bias sabiti = 1’dir; [biasWeight] (w₀) bu sabitin katsayısıdır.
  ///
  /// net = w·x + biasWeight * 1
  /// ŷ = 1[net >= 0]
  ///
  /// Güncelleme:
  ///   w_j <- w_j + η * e * x_j
  ///   biasWeight <- biasWeight + η * e
  ///
  /// Eğitim sonunda: w'ler `state.weightTexts` içine,
  /// bias katsayısı da `state.biasText` içine yazılır.
  ///
  /// [debug]: true ise her örnek için debugPrint log yazar.
  /// [onEpoch]: (epoch, w, biasWeight, errors) callback’i; UI’da izlemek için.
  Future<PerceptronTrainResult> trainPerceptron({
    int maxEpochs = 500,
    bool debug = false,
    void Function(
      int epoch,
      List<double> weights,
      double biasWeight,
      int errors,
    )?
    onEpoch,
  }) async {
    final k = state.inputCount; // özellik sayısı
    final rows = state.rowCount;
    final cols = k + 1; // x'ler + y

    final learningRate = _parseDouble(
      state.learningRateText,
      fallback: double.nan,
    );
    var biasWeight = _parseDouble(state.biasText, fallback: double.nan);
    if (learningRate.isNaN) {
      throw StateError('η (öğrenme katsayısı) boş/geçersiz.');
    }
    if (biasWeight.isNaN) {
      throw StateError('Bias katsayısı (w₀) boş/geçersiz.');
    }

    // başlangıç ağırlıkları w₁..w_k
    final weights = <double>[];
    for (int j = 0; j < k; j++) {
      final v = _parseDouble(state.weightTexts[j], fallback: double.nan);
      if (v.isNaN) {
        throw StateError('W${j + 1} boş/geçersiz.');
      }
      weights.add(v);
    }

    // eğitim verisi
    final X = <List<double>>[];
    final y = <int>[];
    for (int r = 0; r < rows; r++) {
      final row = state.samples[r];
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

      final yy = _parseInt01(row[k]);
      X.add(feats);
      y.add(yy);
    }
    if (X.isEmpty) {
      throw StateError('Eğitim için geçerli satır yok.');
    }

    int epoch = 0;
    bool converged = false;

    double net(List<double> xi) {
      double s = biasWeight; // bias sabiti 1 olduğundan: w·x + w₀*1
      for (int j = 0; j < k; j++) {
        s += weights[j] * xi[j];
      }
      return s;
    }

    int predict(List<double> xi) => net(xi) >= 0 ? 1 : 0;

    final maxEpochsValue = _parseEpochLimit(
      state.epochLimitText,
      fallback: maxEpochs,
    );

    while (epoch < maxEpochsValue) {
      int errors = 0;

      for (int i = 0; i < X.length; i++) {
        final xi = X[i];
        final yi = y[i];

        final yhat = predict(xi);
        final e = yi - yhat; // -1,0,+1

        if (e != 0) {
          for (int j = 0; j < k; j++) {
            weights[j] += learningRate * e * xi[j];
          }
          biasWeight += learningRate * e;
          errors++;
        }

        if (debug) {
          final s = net(xi);
          debugPrint(
            '[ep=${epoch + 1} step=${i + 1}] '
            'net=${s.toStringAsFixed(6)}  y=$yi  y^=$yhat  e=$e  '
            'w=[${weights.map((v) => v.toStringAsFixed(6)).join(', ')}]  '
            'bias=${biasWeight.toStringAsFixed(6)}',
          );
        }
      }

      epoch++;
      onEpoch?.call(epoch, List<double>.from(weights), biasWeight, errors);

      if (errors == 0) {
        converged = true;
        break;
      }
    }

    // son değerleri "eğitim sonucu" olarak state'e yaz
    emit(
      state.copyWith(
        trainedWeights: List<double>.from(weights),
        trainedBiasWeight: biasWeight,
        hasTrained: true,
      ),
    );

    return PerceptronTrainResult(
      epochs: epoch,
      converged: converged,
      weights: List<double>.from(weights),
      biasWeight: biasWeight,
    );
  }

  // İZLİ EĞİTİM:
  /// net = w·x + biasWeight * 1, eşik 0
  /// ŷ = 1[net >= 0]
  /// w <- w + η*e*x ;  biasWeight <- biasWeight + η*e
  Future<PerceptronTrace> trainPerceptronWithTrace({
    int maxEpochs = 500,
  }) async {
    final k = state.inputCount;
    final rows = state.rowCount;
    final cols = k + 1;

    final learningRate = _parseDouble(
      state.learningRateText,
      fallback: double.nan,
    );
    var biasWeight = _parseDouble(state.biasText, fallback: double.nan);
    if (learningRate.isNaN) {
      throw StateError('η (öğrenme katsayısı) boş/geçersiz.');
    }
    if (biasWeight.isNaN) {
      throw StateError('Bias katsayısı (w₀) boş/geçersiz.');
    }

    // başlangıç w
    final weights = <double>[];
    for (int j = 0; j < k; j++) {
      final v = _parseDouble(state.weightTexts[j], fallback: double.nan);
      if (v.isNaN) {
        throw StateError('W${j + 1} boş/geçersiz.');
      }
      weights.add(v);
    }

    // veri
    final X = <List<double>>[];
    final y = <int>[];
    for (int r = 0; r < rows; r++) {
      final row = state.samples[r];
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
    if (X.isEmpty) {
      throw StateError('Eğitim için geçerli satır yok.');
    }

    final epochTraces = <EpochTrace>[];
    int epoch = 0;
    bool converged = false;

    double net(List<double> xi) {
      double s = biasWeight;
      for (int j = 0; j < k; j++) {
        s += weights[j] * xi[j];
      }
      return s;
    }

    final maxEpochsValue = _parseEpochLimit(
      state.epochLimitText,
      fallback: maxEpochs,
    );

    while (epoch < maxEpochsValue) {
      final steps = <StepTrace>[];
      int errors = 0;
      int correct = 0;

      for (int i = 0; i < X.length; i++) {
        final xi = X[i];
        final yi = y[i];

        final wBefore = List<double>.from(weights);
        final biasBefore = biasWeight;

        final netInput = net(xi);
        final yhat = (netInput >= 0) ? 1 : 0;
        final e = yi - yhat;

        if (e != 0) {
          for (int j = 0; j < k; j++) {
            weights[j] += learningRate * e * xi[j];
          }
          biasWeight += learningRate * e;
          errors++;
        } else {
          correct++;
        }

        steps.add(
          StepTrace(
            epoch: epoch + 1,
            step: i + 1,
            x: List<double>.from(xi),
            y: yi,
            weightsBefore: wBefore,
            biasBefore: biasBefore,
            netInput: netInput,
            yhat: yhat,
            error: e,
            weightsAfter: List<double>.from(weights),
            biasAfter: biasWeight,
          ),
        );
      }

      epoch++;
      final acc = X.isEmpty ? 0.0 : correct / X.length;
      epochTraces.add(
        EpochTrace(epoch: epoch, errors: errors, accuracy: acc, steps: steps),
      );

      if (errors == 0) {
        converged = true;
        break;
      }
    }

    emit(
      state.copyWith(
        trainedWeights: List<double>.from(weights),
        trainedBiasWeight: biasWeight,
        hasTrained: true,
      ),
    );

    return PerceptronTrace(
      epochs: epochTraces,
      finalWeights: List<double>.from(weights),
      finalBiasWeight: biasWeight,
      totalEpochs: epoch,
      converged: converged,
    );
  }

  /// -------------------- TEST (EĞİTİM SONUCU İLE) --------------------
  ///
  /// Bu fonksiyon ağırlıkları ARTIK GÜNCELLEMEZ.
  /// Sadece:
  ///   - state.trainedWeights & state.trainedBiasWeight varsa onları kullanır,
  ///   - yoksa text alanlarındaki w₁..w_k ve w₀ değerlerini kullanmayı dener,
  ///   - mevcut tablo (samples) üstünde net, ŷ, doğruluk hesaplar.
  ///
  Future<PerceptronTestResult> testPerceptron() async {
    final k = state.inputCount;
    final rows = state.rowCount;
    final cols = k + 1; // x'ler + y

    // 1) Kullanılacak ağırlıkları seç (önce eğitim sonucu, yoksa textfield)
    List<double> weights;
    double biasWeight;

    if (state.trainedWeights != null && state.trainedBiasWeight != null) {
      // Eğitim yapılmış ve sonuç state'e yazılmış
      weights = List<double>.from(state.trainedWeights!);
      biasWeight = state.trainedBiasWeight!;
    } else {
      // Eğitim sonucu yok; text alanlarından okumayı dene
      biasWeight = _parseDouble(state.biasText, fallback: double.nan);
      if (biasWeight.isNaN) {
        throw StateError(
          'Test için önce eğitim yapmalı ya da geçerli bir bias (w₀) girmelisin.',
        );
      }

      weights = <double>[];
      for (int j = 0; j < k; j++) {
        final v = _parseDouble(state.weightTexts[j], fallback: double.nan);
        if (v.isNaN) {
          throw StateError(
            'Test için W${j + 1} boş/geçersiz. Lütfen ağırlıkları gir ya da eğitim yap.',
          );
        }
        weights.add(v);
      }
    }

    // 2) Test verisini mevcut tablo (samples) içinden oku
    final X = <List<double>>[];
    final y = <int>[];

    for (int r = 0; r < rows; r++) {
      final row = state.samples[r];
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

    if (X.isEmpty) {
      throw StateError('Test için geçerli satır yok. (x ve y doldurulmalı)');
    }

    // 3) net ve tahmin fonksiyonu
    double net(List<double> xi) {
      double s = biasWeight;
      for (int j = 0; j < k; j++) {
        s += weights[j] * xi[j];
      }
      return s;
    }

    final samples = <PerceptronTestSample>[];
    int correct = 0;

    // 4) Her örnek için ileri besleme (forward pass)
    for (int i = 0; i < X.length; i++) {
      final xi = X[i];
      final yi = y[i];

      final netInput = net(xi);
      final prediction = netInput >= 0 ? 1 : 0;
      final isCorrect = (prediction == yi);
      if (isCorrect) correct++;

      samples.add(
        PerceptronTestSample(
          x: List<double>.from(xi),
          target: yi,
          prediction: prediction,
          netInput: netInput,
          isCorrect: isCorrect,
        ),
      );
    }

    final total = samples.length;
    final accuracy = total == 0 ? 0.0 : correct / total;

    return PerceptronTestResult(
      samples: samples,
      total: total,
      correct: correct,
      incorrect: total - correct,
      accuracy: accuracy,
      usedWeights: List<double>.from(weights),
      usedBiasWeight: biasWeight,
    );
  }

}

// Eğitim sonucu DTO
class PerceptronTrainResult {
  final int epochs;
  final bool converged;
  final List<double> weights; // x ağırlıkları (k adet)
  final double biasWeight; // bias katsayısı (w₀)

  PerceptronTrainResult({
    required this.epochs,
    required this.converged,
    required this.weights,
    required this.biasWeight,
  });
}

// Alt indis helper (w₁, w₂ gibi göstermek için)
String subscript(int n) {
  const subs = {
    0: '₀',
    1: '₁',
    2: '₂',
    3: '₃',
    4: '₄',
    5: '₅',
    6: '₆',
    7: '₇',
    8: '₈',
    9: '₉',
    -1: '₋',
  };
  final s = n.toString();
  return s.split('').map((ch) {
    final d = int.tryParse(ch);
    if (d != null) return subs[d] ?? ch;
    if (ch == '-') return subs[-1]!;
    return ch;
  }).join();
}

class PerceptronTestSample {
  final List<double> x;       // [x1, x2, ..., xk]
  final int target;          // gerçek y
  final int prediction;      // tahmin edilen ŷ
  final double netInput;     // net = w·x + w0
  final bool isCorrect;      // target == prediction ?

  PerceptronTestSample({
    required this.x,
    required this.target,
    required this.prediction,
    required this.netInput,
    required this.isCorrect,
  });
}

class PerceptronTestResult {
  final List<PerceptronTestSample> samples;
  final int total;
  final int correct;
  final int incorrect;
  final double accuracy;           // 0..1
  final List<double> usedWeights;  // kullanılan w1..wk
  final double usedBiasWeight;     // kullanılan w0

  PerceptronTestResult({
    required this.samples,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.accuracy,
    required this.usedWeights,
    required this.usedBiasWeight,
  });
}


// --- TRACE MODELLERİ ---
class StepTrace {
  final int epoch;
  final int step; // 1..N
  final List<double> x; // özellikler
  final int y; // hedef
  final List<double> weightsBefore;
  final double biasBefore;
  final double netInput; // net = w·x + biasWeight
  final int yhat; // 0/1
  final int error; // y - yhat
  final List<double> weightsAfter;
  final double biasAfter;

  StepTrace({
    required this.epoch,
    required this.step,
    required this.x,
    required this.y,
    required this.weightsBefore,
    required this.biasBefore,
    required this.netInput,
    required this.yhat,
    required this.error,
    required this.weightsAfter,
    required this.biasAfter,
  });
}

class EpochTrace {
  final int epoch;
  final int errors;
  final double accuracy; // 0..1
  final List<StepTrace> steps;

  EpochTrace({
    required this.epoch,
    required this.errors,
    required this.accuracy,
    required this.steps,
  });
}

class PerceptronTrace {
  final List<EpochTrace> epochs;
  final List<double> finalWeights;
  final double finalBiasWeight;
  final int totalEpochs;
  final bool converged;

  PerceptronTrace({
    required this.epochs,
    required this.finalWeights,
    required this.finalBiasWeight,
    required this.totalEpochs,
    required this.converged,
  });
}
