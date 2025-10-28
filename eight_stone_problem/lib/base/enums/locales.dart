import 'dart:ui';

enum Locales {
  tr(Locale('tr', 'TR')),
  en(Locale('en', 'US'));

  final Locale locale;

  const Locales(this.locale);
}
