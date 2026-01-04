import 'package:backpropagation_algorithm/theme/export.dart';

final class CustomLightTheme implements CustomTheme {
  late final ThemeData _themeData = ThemeData(
    useMaterial3: true,
    colorScheme: CustomColorScheme.lightColorScheme,
    scaffoldBackgroundColor: CustomColorScheme.lightColorScheme.primary,
    fontFamily: 'Roboto',
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
      color: ColorName.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: ColorName.black,
    ),
    bodySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      color: ColorName.black,
    ),

    /// Display light
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: ColorName.black,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: ColorName.black,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: ColorName.black,
    ),

    /// Headline light
    headlineLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: ColorName.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorName.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorName.black,
    ),

    /// Label light
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: ColorName.black,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: ColorName.black,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: ColorName.black,
    ),

    /// Title light
    titleLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: ColorName.black,
    ),
    titleMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: ColorName.black,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: ColorName.black,
    ),
  );
}
