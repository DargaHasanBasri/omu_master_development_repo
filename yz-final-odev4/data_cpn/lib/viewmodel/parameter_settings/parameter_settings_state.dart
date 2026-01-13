part of 'parameter_settings_cubit.dart';

enum ParameterSettingsStatus { initial, ready }

@immutable
class ParameterSettingsState {
  const ParameterSettingsState({
    required this.status,
    required this.radiusTexts,
    required this.radii,
    required this.isValid,
    required this.epochLimitText,
    required this.maxEpochPerRadius,
    this.validationMessage,
    this.errorMessage,
    this.x,
    this.y,
    this.fileName,
  });

  const ParameterSettingsState.initial()
      : status = ParameterSettingsStatus.initial,
        radiusTexts = const ['', '', '', ''],
        radii = const [],
        isValid = false,

  // ✅ kullanıcı boş bırakabilir, yine de maxEpochPerRadius 500 olarak tutulur
        epochLimitText = '',
        maxEpochPerRadius = 500,

        validationMessage = null,
        errorMessage = null,
        x = null,
        y = null,
        fileName = null;

  final ParameterSettingsStatus status;

  final List<String> radiusTexts;
  final List<double> radii;

  // ✅ epoch limit
  final String epochLimitText;
  final int maxEpochPerRadius; // boşsa 500

  final bool isValid;
  final String? validationMessage;

  final String? errorMessage;

  final List<List<double>>? x;
  final List<double>? y;
  final String? fileName;

  int get sampleCount => x?.length ?? 0;

  ParameterSettingsState copyWith({
    ParameterSettingsStatus? status,
    List<String>? radiusTexts,
    List<double>? radii,
    bool? isValid,
    String? epochLimitText,
    int? maxEpochPerRadius,
    String? validationMessage,
    String? errorMessage,
    List<List<double>>? x,
    List<double>? y,
    String? fileName,
  }) {
    return ParameterSettingsState(
      status: status ?? this.status,
      radiusTexts: radiusTexts ?? this.radiusTexts,
      radii: radii ?? this.radii,
      isValid: isValid ?? this.isValid,
      epochLimitText: epochLimitText ?? this.epochLimitText,
      maxEpochPerRadius: maxEpochPerRadius ?? this.maxEpochPerRadius,
      validationMessage: validationMessage,
      errorMessage: errorMessage,
      x: x ?? this.x,
      y: y ?? this.y,
      fileName: fileName ?? this.fileName,
    );
  }
}
