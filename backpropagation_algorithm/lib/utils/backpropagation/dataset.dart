import 'dart:math' as Math;
import 'package:csv/csv.dart';

final class Dataset {
  const Dataset({required this.x, required this.y, required this.featureNames});
  final List<List<double>> x;
  final List<double> y;
  final List<String> featureNames;

  int get n => y.length;
  int get d => x.isEmpty ? 0 : x.first.length;
}

final class SplitDataset {
  const SplitDataset({
    required this.trainX,
    required this.trainY,
    required this.testX,
    required this.testY,
  });

  final List<List<double>> trainX;
  final List<double> trainY;
  final List<List<double>> testX;
  final List<double> testY;

  int get trainN => trainY.length;
  int get testN => testY.length;
}

abstract final class CsvDatasetParser {
  /// targetColumnName varsa onu bulur, yoksa SON sütunu hedef alır.
  static Dataset parse(
      String csvText, {
        String targetColumnName = 'y',
        String delimiter = ',',
      }) {
    final rows = CsvToListConverter(
      shouldParseNumbers: true,
      fieldDelimiter: delimiter,
      eol: '\n',
    ).convert(csvText.trim());

    if (rows.length < 2) {
      throw StateError('CSV içinde veri yok (başlık + en az 1 satır olmalı).');
    }

    final header = rows.first.map((e) => e.toString().trim()).toList();

    int targetIdx = header.indexWhere(
          (h) => h.toLowerCase() == targetColumnName.toLowerCase(),
    );
    if (targetIdx == -1) targetIdx = header.length - 1;

    final featureIdxs = <int>[];
    final featureNames = <String>[];
    for (int i = 0; i < header.length; i++) {
      if (i == targetIdx) continue;
      featureIdxs.add(i);
      featureNames.add(header[i]);
    }

    final x = <List<double>>[];
    final y = <double>[];

    for (int r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.length != header.length) continue; // bozuk satırları atla

      final yi = _toDouble(row[targetIdx]);
      final xi = <double>[];
      for (final fi in featureIdxs) {
        xi.add(_toDouble(row[fi]));
      }

      x.add(xi);
      y.add(yi);
    }

    if (x.isEmpty) {
      throw StateError('CSV parse edildi ama hiç geçerli satır bulunamadı.');
    }

    return Dataset(x: x, y: y, featureNames: featureNames);
  }

  static double _toDouble(Object? v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

abstract final class DatasetSplitter {
  /// trainRatio: 0.7 => %70 eğitim, %30 test
  static SplitDataset splitByRatio(
      Dataset ds, {
        required double trainRatio,
        int seed = 42,
      }) {
    final n = ds.n;
    final idx = List<int>.generate(n, (i) => i);

    final rng = Math.Random(seed);
    idx.shuffle(rng);

    // en az 1 train, en az 1 test kalsın
    final ratio = trainRatio.clamp(0.1, 0.9);
    final trainCount = (n * ratio).round().clamp(1, n - 1);

    final trainIdx = idx.take(trainCount).toList();
    final testIdx = idx.skip(trainCount).toList();

    List<List<double>> pickX(List<int> ids) => ids.map((i) => ds.x[i]).toList();
    List<double> pickY(List<int> ids) => ids.map((i) => ds.y[i]).toList();

    return SplitDataset(
      trainX: pickX(trainIdx),
      trainY: pickY(trainIdx),
      testX: pickX(testIdx),
      testY: pickY(testIdx),
    );
  }

  static SplitDataset split70_30(Dataset ds, {int seed = 42}) {
    return splitByRatio(ds, trainRatio: 0.7, seed: seed);
  }
}
