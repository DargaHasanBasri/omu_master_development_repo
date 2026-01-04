import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';

enum FileStatus { idle, picking, loaded, error }

final class FileState extends Equatable {
  const FileState({
    this.status = FileStatus.idle,
    this.fileName,
    this.csvText,
    this.error,
  });

  final FileStatus status;
  final String? fileName;
  final String? csvText;
  final String? error;

  bool get isPicking => status == FileStatus.picking;
  bool get hasCsv => csvText != null && csvText!.isNotEmpty;

  FileState copyWith({
    FileStatus? status,
    String? fileName,
    String? csvText,
    String? error,
    bool clearError = false,
    bool clearCsv = false,
  }) {
    return FileState(
      status: status ?? this.status,
      fileName: fileName ?? this.fileName,
      csvText: clearCsv ? null : (csvText ?? this.csvText),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, fileName, csvText, error];
}

final class FileCubit extends Cubit<FileState> {
  FileCubit() : super(const FileState());

  Future<void> pickCsv() async {
    try {
      emit(state.copyWith(status: FileStatus.picking, clearError: true));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        withData: true, // web için bytes gerekiyor
      );

      if (result == null || result.files.isEmpty) {
        emit(state.copyWith(status: FileStatus.idle));
        return; // kullanıcı iptal etti
      }

      final file = result.files.first;
      final name = file.name;

      String csvText;

      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) throw StateError('Dosya okunamadı (bytes null).');
        csvText = _decodeBytes(bytes);
      } else {
        if (file.path != null) {
          // bazı CSV'ler utf8 dışı olabilir; önce utf8, olmazsa latin1 denenir
          final bytes = await File(file.path!).readAsBytes();
          csvText = _decodeBytes(bytes);
        } else {
          final bytes = file.bytes;
          if (bytes == null) throw StateError('Dosya yolu yok ve bytes da yok.');
          csvText = _decodeBytes(bytes);
        }
      }

      emit(state.copyWith(
        status: FileStatus.loaded,
        fileName: name,
        csvText: csvText,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(status: FileStatus.error, error: e.toString()));
    }
  }

  void clear() {
    emit(const FileState(status: FileStatus.idle));
  }

  String _decodeBytes(Uint8List bytes) {
    // 1) utf8 dene
    try {
      return utf8.decode(bytes);
    } catch (_) {
      // 2) latin1 dene (TR CSV'lerde bazen iş görüyor)
      try {
        return latin1.decode(bytes);
      } catch (_) {
        // 3) en son raw charcodes
        return String.fromCharCodes(bytes);
      }
    }
  }
}
