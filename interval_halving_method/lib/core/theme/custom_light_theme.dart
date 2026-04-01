import 'package:interval_halving_method/core/theme/export.dart';

final class CustomLightTheme implements CustomTheme {
  late final ThemeData _themeData = ThemeData(
    useMaterial3: true,
    colorScheme: CustomColorScheme.lightColorScheme,
    scaffoldBackgroundColor: CustomColorScheme.lightColorScheme.primary,
    fontFamily: 'Lexend',
    appBarTheme: appBarTheme,
    textTheme: textTheme,
  );

  @override
  ThemeData get themeData => _themeData;

  @override
  final AppBarTheme appBarTheme = const AppBarTheme(
    toolbarHeight: 60,
    scrolledUnderElevation: 0,
    centerTitle: true,
  );

  @override
  final TextTheme textTheme = const TextTheme(
    /// Body light
    bodyLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: ColorName.mirage,
    ),
    bodyMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: ColorName.mirage,
    ),
    bodySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      color: ColorName.mirage,
    ),

    /// Display light
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: ColorName.mirage,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: ColorName.mirage,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: ColorName.mirage,
    ),

    /// Headline light
    headlineLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: ColorName.mirage,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorName.mirage,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorName.mirage,
    ),

    /// Label light
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: ColorName.mirage,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: ColorName.mirage,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: ColorName.mirage,
    ),

    /// Title light
    titleLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: ColorName.mirage,
    ),
    titleMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: ColorName.mirage,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: ColorName.mirage,
    ),
  );
}
