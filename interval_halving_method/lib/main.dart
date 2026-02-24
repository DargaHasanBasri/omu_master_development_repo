import 'package:easy_localization/easy_localization.dart';
import 'package:interval_halving_method/export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      home: Column(),
    );
  }
}
