import 'package:backpropagation_algorithm/utils/backpropagation/activation.dart';
import 'package:backpropagation_algorithm/utils/backpropagation/dataset.dart';
import 'package:backpropagation_algorithm/utils/backpropagation/mpl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class BackpropState extends Equatable {
  const BackpropState({
    this.dataset,
    this.split,
    this.activation = ActivationType.linear,
    this.hiddenLayers = const [],
    this.learningRate = 0.05,
    this.epochs = 500,
    this.batchSize = 1,
    this.trainRatio = 0.7,

    // Eğitim durumu
    this.isTraining = false,
    this.progress = 0.0,
    this.currentEpoch = 0,
    this.totalEpochs = 0,
    this.elapsed = Duration.zero,
    this.eta = Duration.zero,

    // ✅ loss hangi epochlarda hesaplandı?
    this.lossEpochs = const [],

    // Kayıtlar
    this.trainLoss = const [],
    this.testLoss = const [],
    this.trainTrue = const [],
    this.trainPred = const [],
    this.testTrue = const [],
    this.testPred = const [],
    this.metricsTrain = const {},
    this.metricsTest = const {},
    this.error,
  });

  final Dataset? dataset;
  final SplitDataset? split;

  final ActivationType activation;
  final List<int> hiddenLayers;

  final double learningRate;
  final int epochs;
  final int batchSize;

  final double trainRatio;

  final bool isTraining;
  final double progress;

  final int currentEpoch;
  final int totalEpochs;
  final Duration elapsed;
  final Duration eta;

  final List<int> lossEpochs;

  final List<double> trainLoss;
  final List<double> testLoss;

  final List<double> trainTrue;
  final List<double> trainPred;
  final List<double> testTrue;
  final List<double> testPred;

  final Map<String, double> metricsTrain;
  final Map<String, double> metricsTest;

  final String? error;

  BackpropState copyWith({
    Dataset? dataset,
    SplitDataset? split,
    ActivationType? activation,
    List<int>? hiddenLayers,
    double? learningRate,
    int? epochs,
    int? batchSize,
    double? trainRatio,
    bool? isTraining,
    double? progress,
    int? currentEpoch,
    int? totalEpochs,
    Duration? elapsed,
    Duration? eta,
    List<int>? lossEpochs,
    List<double>? trainLoss,
    List<double>? testLoss,
    List<double>? trainTrue,
    List<double>? trainPred,
    List<double>? testTrue,
    List<double>? testPred,
    Map<String, double>? metricsTrain,
    Map<String, double>? metricsTest,
    String? error,
    bool clearError = false,
  }) {
    return BackpropState(
      dataset: dataset ?? this.dataset,
      split: split ?? this.split,
      activation: activation ?? this.activation,
      hiddenLayers: hiddenLayers ?? this.hiddenLayers,
      learningRate: learningRate ?? this.learningRate,
      epochs: epochs ?? this.epochs,
      batchSize: batchSize ?? this.batchSize,
      trainRatio: trainRatio ?? this.trainRatio,
      isTraining: isTraining ?? this.isTraining,
      progress: progress ?? this.progress,
      currentEpoch: currentEpoch ?? this.currentEpoch,
      totalEpochs: totalEpochs ?? this.totalEpochs,
      elapsed: elapsed ?? this.elapsed,
      eta: eta ?? this.eta,
      lossEpochs: lossEpochs ?? this.lossEpochs,
      trainLoss: trainLoss ?? this.trainLoss,
      testLoss: testLoss ?? this.testLoss,
      trainTrue: trainTrue ?? this.trainTrue,
      trainPred: trainPred ?? this.trainPred,
      testTrue: testTrue ?? this.testTrue,
      testPred: testPred ?? this.testPred,
      metricsTrain: metricsTrain ?? this.metricsTrain,
      metricsTest: metricsTest ?? this.metricsTest,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    dataset,
    split,
    activation,
    hiddenLayers,
    learningRate,
    epochs,
    batchSize,
    trainRatio,
    isTraining,
    progress,
    currentEpoch,
    totalEpochs,
    elapsed,
    eta,
    lossEpochs,
    trainLoss,
    testLoss,
    trainTrue,
    trainPred,
    testTrue,
    testPred,
    metricsTrain,
    metricsTest,
    error,
  ];
}

final class BackpropCubit extends Cubit<BackpropState> {
  BackpropCubit() : super(const BackpropState());

  void setActivation(ActivationType t) => emit(state.copyWith(activation: t));

  void setHiddenLayers(List<int>? layers) {
    emit(state.copyWith(hiddenLayers: layers ?? const []));
  }

  void setSingleHiddenNeurons(int n) {
    if (n <= 0) {
      emit(state.copyWith(hiddenLayers: const []));
      return;
    }
    emit(state.copyWith(hiddenLayers: [n]));
  }

  void setHyperparameters({
    double? learningRate,
    int? epochs,
    int? batchSize,
  }) {
    emit(state.copyWith(
      learningRate: learningRate,
      epochs: epochs,
      batchSize: batchSize,
    ));
  }

  void resetHyperparameters() {
    emit(state.copyWith(
      activation: ActivationType.linear,
      hiddenLayers: const [],
      learningRate: 0.05,
      epochs: 500,
      batchSize: 1,
      clearError: true,
    ));
  }

  void setTrainRatio(double ratio) {
    final r = ratio.clamp(0.1, 0.9);

    final ds = state.dataset;
    if (ds == null) {
      emit(state.copyWith(trainRatio: r));
      return;
    }

    final newSplit = DatasetSplitter.splitByRatio(ds, trainRatio: r, seed: 42);
    emit(state.copyWith(trainRatio: r, split: newSplit));
  }

  void loadCsv(String csvText) {
    try {
      final ds = CsvDatasetParser.parse(csvText, targetColumnName: 'y');
      final split = DatasetSplitter.splitByRatio(
        ds,
        trainRatio: state.trainRatio,
        seed: 42,
      );
      emit(state.copyWith(dataset: ds, split: split, clearError: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> train() async {
    final ds = state.dataset;
    final split = state.split;
    if (ds == null || split == null) {
      emit(state.copyWith(error: 'Önce CSV yüklemelisin.'));
      return;
    }

    final epochs = state.epochs;
    final lr = state.learningRate;
    final batchSize = state.batchSize;
    final activation = state.activation;
    final hidden = state.hiddenLayers;

    final sw = Stopwatch()..start();

    final localTrainLoss = <double>[];
    final localTestLoss = <double>[];
    final localEpochs = <int>[];

    emit(state.copyWith(
      isTraining: true,
      progress: 0.0,
      currentEpoch: 0,
      totalEpochs: epochs,
      elapsed: Duration.zero,
      eta: Duration.zero,
      lossEpochs: const [],
      trainLoss: const [],
      testLoss: const [],
      trainTrue: const [],
      trainPred: const [],
      testTrue: const [],
      testPred: const [],
      metricsTrain: const {},
      metricsTest: const {},
      clearError: true,
    ));

    // UI ilk state'i çizebilsin
    await Future<void>.delayed(Duration.zero);

    try {
      final mlp = Mlp(
        MlpConfig(
          inputSize: ds.d,
          hiddenLayers: hidden,
          activation: activation,
          learningRate: lr,
          epochs: epochs,
          batchSize: batchSize,
          seed: 42,
        ),
      );

      final history = await mlp.fitAsync(
        trainX: split.trainX,
        trainY: split.trainY,
        testX: split.testX,
        testY: split.testY,
        evalEvery: 10, // öneri: 10 epoch'ta bir loss ölç
        yieldEveryBatches: 20,
        onEpoch: (epoch, trainMse, testMse) {
          final elapsed = sw.elapsed;

          final avgMsPerEpoch = elapsed.inMilliseconds / epoch;
          final remaining = (epochs - epoch).clamp(0, epochs);
          final etaMs = (avgMsPerEpoch * remaining).round();

          localEpochs.add(epoch);
          localTrainLoss.add(trainMse);
          localTestLoss.add(testMse);

          emit(state.copyWith(
            progress: epoch / epochs,
            currentEpoch: epoch,
            totalEpochs: epochs,
            elapsed: elapsed,
            eta: Duration(milliseconds: etaMs),
            lossEpochs: List<int>.from(localEpochs),
            trainLoss: List<double>.from(localTrainLoss),
            testLoss: List<double>.from(localTestLoss),
          ));
        },
      );

      final elapsedAtEnd = sw.elapsed;
      sw.stop();

      emit(state.copyWith(
        isTraining: false,
        progress: 1.0,
        currentEpoch: epochs,
        totalEpochs: epochs,
        elapsed: elapsedAtEnd,
        eta: Duration.zero,
        trainTrue: history.trainTrue,
        trainPred: history.trainPred,
        testTrue: history.testTrue,
        testPred: history.testPred,
        metricsTrain: history.metricsTrain,
        metricsTest: history.metricsTest,
      ));
    } catch (e) {
      final elapsedAtError = sw.elapsed;
      sw.stop();
      emit(state.copyWith(
        isTraining: false,
        elapsed: elapsedAtError,
        error: e.toString(),
      ));
    }
  }
}
