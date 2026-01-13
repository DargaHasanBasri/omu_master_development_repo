part of 'data_loading_cubit.dart';

enum DataLoadingStatus { initial, loading, ready, error }
enum DataSource { none, sample, picked }

@immutable
class DataLoadingState {
  const DataLoadingState({
    this.status = DataLoadingStatus.initial,
    this.source = DataSource.none,
    this.fileName,
    this.fileSizeBytes,
    this.columns = const [],
    this.x,
    this.y,
    this.rowsRead = 0,
    this.rowsSkipped = 0,
    this.errorMessage,
  });

  final DataLoadingStatus status;
  final DataSource source;

  final String? fileName;
  final int? fileSizeBytes;

  final List<String> columns;
  final List<List<double>>? x;
  final List<double>? y;

  final int rowsRead;
  final int rowsSkipped;

  final String? errorMessage;

  bool get hasData => x != null && y != null && x!.isNotEmpty && y!.isNotEmpty;

  bool get hasRequiredColumns {
    final lower = columns.map((e) => e.toLowerCase()).toList();
    return lower.contains('x1') && lower.contains('x2') && lower.contains('y_norm');
    // İstersen esnek:
    // final hasY = lower.contains('y_norm') || lower.contains('y');
    // return lower.contains('x1') && lower.contains('x2') && hasY;
  }

  bool get isValid => hasData && hasRequiredColumns;

  String get prettySize {
    final b = fileSizeBytes;
    if (b == null) return '';
    if (b < 1024) return '${b}b';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)}kb';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)}mb';
  }

  DataLoadingState copyWith({
    DataLoadingStatus? status,
    DataSource? source,
    String? fileName,
    int? fileSizeBytes,
    List<String>? columns,
    List<List<double>>? x,
    List<double>? y,
    int? rowsRead,
    int? rowsSkipped,
    String? errorMessage,
  }) {
    return DataLoadingState(
      status: status ?? this.status,
      source: source ?? this.source,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      columns: columns ?? this.columns,
      x: x ?? this.x,
      y: y ?? this.y,
      rowsRead: rowsRead ?? this.rowsRead,
      rowsSkipped: rowsSkipped ?? this.rowsSkipped,
      errorMessage: errorMessage,
    );
  }
}
