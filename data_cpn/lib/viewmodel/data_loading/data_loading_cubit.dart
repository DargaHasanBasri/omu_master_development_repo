import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';

// xlsx için
import 'package:excel/excel.dart';

part 'data_loading_state.dart';

class DataLoadingCubit extends Cubit<DataLoadingState> {
  DataLoadingCubit() : super(const DataLoadingState());

  /// Hazır (asset) csv yüklemek için:
  /// assetPath örn: 'assets/data/training_data_v1.csv'
  Future<void> loadSampleAsset({
    required String assetPath,
    String fileName = 'training_data_v1.csv',
  }) async {
    emit(state.copyWith(status: DataLoadingStatus.loading, errorMessage: null));
    try {
      final raw = await rootBundle.loadString(assetPath);
      final parsed = _parseCsvString(raw);

      emit(
        state.copyWith(
          status: DataLoadingStatus.ready,
          fileName: fileName,
          fileSizeBytes: raw.length,
          columns: parsed.columns,
          x: parsed.x,
          y: parsed.y, // y listesinde y_norm değerleri var
          rowsRead: parsed.rowsRead,
          rowsSkipped: parsed.rowsSkipped,
          errorMessage: null,
          source: DataSource.sample,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DataLoadingStatus.error,
          errorMessage: 'Hazır dosya okunamadı: $e',
        ),
      );
    }
  }

  /// Kullanıcıdan dosya seçtirir (csv/xlsx)
  Future<void> pickFile() async {
    emit(state.copyWith(status: DataLoadingStatus.loading, errorMessage: null));

    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx'],
        withData: true,
      );

      if (res == null || res.files.isEmpty) {
        emit(state.copyWith(status: DataLoadingStatus.initial));
        return;
      }

      final file = res.files.first;
      final name = file.name;
      final bytes = file.bytes;

      if (bytes == null) {
        emit(
          state.copyWith(
            status: DataLoadingStatus.error,
            errorMessage: 'Dosya okunamadı (bytes null).',
          ),
        );
        return;
      }

      _ParsedData parsed;

      final lower = name.toLowerCase();
      if (lower.endsWith('.csv')) {
        final raw = _decodeUtf8(bytes);
        parsed = _parseCsvString(raw);
      } else if (lower.endsWith('.xlsx')) {
        parsed = _parseXlsx(bytes);
      } else {
        emit(
          state.copyWith(
            status: DataLoadingStatus.error,
            errorMessage: 'Desteklenmeyen dosya formatı: $name',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: DataLoadingStatus.ready,
          fileName: name,
          fileSizeBytes: bytes.length,
          columns: parsed.columns,
          x: parsed.x,
          y: parsed.y,
          rowsRead: parsed.rowsRead,
          rowsSkipped: parsed.rowsSkipped,
          errorMessage: null,
          source: DataSource.picked,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DataLoadingStatus.error,
          errorMessage: 'Dosya seçme/okuma hatası: $e',
        ),
      );
    }
  }

  // ----------------- PARSE HELPERS -----------------

  String _decodeUtf8(Uint8List bytes) {
    final s = utf8.decode(bytes, allowMalformed: true);
    return s.replaceFirst('\uFEFF', '');
  }

  _ParsedData _parseCsvString(String raw) {
    final lines = raw
        .split(RegExp(r'\r\n|\n|\r'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.isEmpty) throw Exception('CSV boş.');

    final delimiter = _detectDelimiter(lines.first);
    final headers = lines.first.split(delimiter).map((e) => e.trim()).toList();

    final headerLower = headers.map((e) => e.toLowerCase()).toList();
    final x1i = headerLower.indexOf('x1');
    final x2i = headerLower.indexOf('x2');
    final yi = headerLower.indexOf('y_norm'); // ✅ y_norm

    if (x1i == -1 || x2i == -1 || yi == -1) {
      throw Exception(
        'Kolonlar bulunamadı. Gerekli: x1, x2, y_norm. Bulunan: $headers',
      );
    }

    final x = <List<double>>[];
    final y = <double>[];

    var read = 0;
    var skipped = 0;

    for (var i = 1; i < lines.length; i++) {
      final parts = lines[i].split(delimiter).map((e) => e.trim()).toList();
      if (parts.length < headers.length) {
        skipped++;
        continue;
      }

      final x1 = _tryParseDouble(parts[x1i]);
      final x2 = _tryParseDouble(parts[x2i]);
      final yy = _tryParseDouble(parts[yi]);

      if (x1 == null || x2 == null || yy == null) {
        skipped++;
        continue;
      }

      x.add([x1, x2]);
      y.add(yy);
      read++;
    }

    if (read == 0) {
      throw Exception('Geçerli satır bulunamadı (sayısal parse edilemedi).');
    }

    return _ParsedData(
      columns: headers,
      x: x,
      y: y,
      rowsRead: read,
      rowsSkipped: skipped,
    );
  }

  _ParsedData _parseXlsx(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) throw Exception('XLSX içinde sheet bulunamadı.');

    final sheetName = excel.tables.keys.first;
    final table = excel.tables[sheetName];
    if (table == null || table.rows.isEmpty) throw Exception('XLSX sheet boş.');

    final headerRow = table.rows.first;
    final headers =
    headerRow.map((c) => (c?.value?.toString() ?? '').trim()).toList();

    final headerLower = headers.map((e) => e.toLowerCase()).toList();
    final x1i = headerLower.indexOf('x1');
    final x2i = headerLower.indexOf('x2');
    final yi = headerLower.indexOf('y_norm'); // ✅ y_norm

    if (x1i == -1 || x2i == -1 || yi == -1) {
      throw Exception(
        'Kolonlar bulunamadı. Gerekli: x1, x2, y_norm. Bulunan: $headers',
      );
    }

    final x = <List<double>>[];
    final y = <double>[];
    var read = 0;
    var skipped = 0;

    for (var r = 1; r < table.rows.length; r++) {
      final row = table.rows[r];

      String cellStr(int idx) =>
          (idx < row.length ? row[idx]?.value?.toString() : '')?.trim() ?? '';

      final x1 = _tryParseDouble(cellStr(x1i));
      final x2 = _tryParseDouble(cellStr(x2i));
      final yy = _tryParseDouble(cellStr(yi));

      if (x1 == null || x2 == null || yy == null) {
        skipped++;
        continue;
      }

      x.add([x1, x2]);
      y.add(yy);
      read++;
    }

    if (read == 0) {
      throw Exception('Geçerli satır bulunamadı (sayısal parse edilemedi).');
    }

    return _ParsedData(
      columns: headers,
      x: x,
      y: y,
      rowsRead: read,
      rowsSkipped: skipped,
    );
  }

  String _detectDelimiter(String headerLine) {
    final comma = ','.allMatches(headerLine).length;
    final semi = ';'.allMatches(headerLine).length;
    return semi > comma ? ';' : ',';
  }

  double? _tryParseDouble(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    final normalized = t.replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}

@immutable
class _ParsedData {
  const _ParsedData({
    required this.columns,
    required this.x,
    required this.y,
    required this.rowsRead,
    required this.rowsSkipped,
  });

  final List<String> columns;
  final List<List<double>> x;
  final List<double> y;
  final int rowsRead;
  final int rowsSkipped;
}
