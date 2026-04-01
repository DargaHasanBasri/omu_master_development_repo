import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_halving_method/export.dart';
import 'package:interval_halving_method/routes/app_routes.dart';
import 'package:interval_halving_method/view_model/home/function_cubit.dart';
import 'package:interval_halving_method/view_model/home/objective_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_cubit.dart';

Future<void> main() async {
  await AppStart.init();
  runApp(
    AppLocalization(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ObjectiveCubit()),
          BlocProvider(create: (context) => FunctionCubit()),
          BlocProvider(create: (context) => OptimizationCubit()),
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      },
      routerConfig: AppRoutes.router,
    );
  }
}
