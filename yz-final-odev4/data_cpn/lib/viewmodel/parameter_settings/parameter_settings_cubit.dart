import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'parameter_settings_state.dart';

class ParameterSettingsCubit extends Cubit<ParameterSettingsState> {
  ParameterSettingsCubit() : super(const ParameterSettingsState.initial());

  static const int _defaultEpochPerRadius = 500;

  void initFromExtra(Map<String, dynamic>? extra) {
    if (extra == null) {
      emit(state.copyWith(
        errorMessage: 'Veri bulunamadı. Lütfen geri dönüp dosyayı tekrar seçin.',
      ));
      return;
    }

    final x = _cast2D(extra['x']);
    final y = _cast1D(extra['y']);
    final fileName = extra['fileName'] as String?;

    if (x == null || y == null || x.isEmpty || y.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Veri boş geldi. Lütfen dosyayı tekrar seçin.',
      ));
      return;
    }

    emit(
      state.copyWith(
        status: ParameterSettingsStatus.ready,
        x: x,
        y: y,
        fileName: fileName,

        // radius inputlar
        radiusTexts: const ['', '', '', ''],
        radii: const [],

        // ✅ epoch default: boşsa da 500 say
        epochLimitText: '',
        maxEpochPerRadius: _defaultEpochPerRadius,

        isValid: false,
        validationMessage: null,
        errorMessage: null,
      ),
    );

    _validate();
  }

  void setRadiusText(int index, String text) {
    final list = [...state.radiusTexts];
    if (index < 0 || index >= list.length) return;
    list[index] = text;
    emit(state.copyWith(radiusTexts: list, errorMessage: null));
    _validate();
  }

  void addRadiusField() {
    final list = [...state.radiusTexts, ''];
    emit(state.copyWith(radiusTexts: list, errorMessage: null));
    _validate();
  }

  // ✅ epoch limit input (opsiyonel)
  void setEpochLimitText(String text) {
    emit(state.copyWith(epochLimitText: text, errorMessage: null));
    _validate();
  }

  bool validateNow() {
    _validate();
    return state.isValid;
  }

  void _validate() {
    // 1) radius parse
    final parsed = <double>[];
    for (final t in state.radiusTexts) {
      final v = _tryParseDouble(t);
      if (v != null) parsed.add(v);
    }

    if (parsed.length < 4) {
      emit(state.copyWith(
        isValid: false,
        validationMessage: 'En az 4 adet yarıçap değeri gir.',
        radii: const [],
      ));
      return;
    }

    if (parsed.any((e) => e <= 0)) {
      emit(state.copyWith(
        isValid: false,
        validationMessage: 'Yarıçap değerleri 0’dan büyük olmalı.',
        radii: const [],
      ));
      return;
    }

    final unique = parsed.toSet().toList()..sort();
    if (unique.length < 4) {
      emit(state.copyWith(
        isValid: false,
        validationMessage: 'Yarıçap değerleri birbirinden farklı olmalı.',
        radii: const [],
      ));
      return;
    }

    const minDiff = 0.10;
    for (var i = 0; i < unique.length; i++) {
      for (var j = i + 1; j < unique.length; j++) {
        if ((unique[i] - unique[j]).abs() < minDiff) {
          emit(state.copyWith(
            isValid: false,
            validationMessage:
            'Yarıçap değerleri birbirine çok yakın. (Min fark: $minDiff)',
            radii: const [],
          ));
          return;
        }
      }
    }

    // 2) epoch parse (boşsa => 500)
    final epochText = state.epochLimitText.trim();
    int maxEpochPerRadius = _defaultEpochPerRadius;

    if (epochText.isNotEmpty) {
      final v = int.tryParse(epochText);
      if (v == null) {
        emit(state.copyWith(
          isValid: false,
          validationMessage: 'Epoch sınırı sayı olmalı. (örn: 200)',
          radii: unique,
          maxEpochPerRadius: _defaultEpochPerRadius,
        ));
        return;
      }
      if (v < 1) {
        emit(state.copyWith(
          isValid: false,
          validationMessage: 'Epoch sınırı en az 1 olmalı.',
          radii: unique,
          maxEpochPerRadius: _defaultEpochPerRadius,
        ));
        return;
      }
      maxEpochPerRadius = v;
    }

    emit(state.copyWith(
      isValid: true,
      validationMessage: null,
      radii: unique,
      maxEpochPerRadius: maxEpochPerRadius,
    ));
  }

  double? _tryParseDouble(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    final normalized = t.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

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
}
