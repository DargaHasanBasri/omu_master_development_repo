import 'package:backpropagation_algorithm/export.dart';
import 'package:backpropagation_algorithm/ui/screens/data/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/file_cubit.dart';

Future<void> main() async {
  await AppStart.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FileCubit()),
        BlocProvider(create: (_) => BackpropCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRoutes.returnRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      routerConfig: router,
    );
  }
}
