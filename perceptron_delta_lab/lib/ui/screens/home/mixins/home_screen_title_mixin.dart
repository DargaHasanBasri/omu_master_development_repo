import 'package:gen/generated/locale_keys.g.dart';
import 'package:perceptron_delta_lab/utils/extensions/string_localizations.dart';

mixin HomeScreenTitleMixin {
  String get mainTitle => LocaleKeys.home_mainTitle.locale;

  String get mainSubtitle => LocaleKeys.home_mainSubtitle.locale;

  String get centerTitle => LocaleKeys.home_centerTitle.locale;

  String get centerSubtitle => LocaleKeys.home_centerSubtitle.locale;

  String get cardFirstTitle =>
      LocaleKeys.home_labFeatureCard_cardFirstTitle.locale;

  String get cardFirstSubtitle =>
      LocaleKeys.home_labFeatureCard_cardFirstSubtitle.locale;

  String get cardSecondTitle =>
      LocaleKeys.home_labFeatureCard_cardSecondTitle.locale;

  String get cardSecondSubtitle =>
      LocaleKeys.home_labFeatureCard_cardSecondSubtitle.locale;

  String get cardThirdTitle =>
      LocaleKeys.home_labFeatureCard_cardThirdTitle.locale;

  String get cardThirdSubtitle =>
      LocaleKeys.home_labFeatureCard_cardThirdSubtitle.locale;
}
