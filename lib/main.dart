import 'package:easy_localization/easy_localization.dart';
import 'export.dart';

Future<void> main() async {
  await AppStart.init();
  runApp(
    AppLocalization(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CubitHome>(
            create: (_) => CubitHome(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
      themeMode: ThemeMode.dark,
      home: HomeScreen(),
    );
  }
}
