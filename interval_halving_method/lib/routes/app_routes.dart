import 'package:go_router/go_router.dart';
import 'package:interval_halving_method/core/models/iteration_step.dart';
import 'package:interval_halving_method/routes/app_route_names.dart';
import 'package:interval_halving_method/ui/screens/graphics/graphics_screen.dart';
import 'package:interval_halving_method/ui/screens/home/home_screen.dart';
import 'package:interval_halving_method/ui/screens/iteration/iteration_screen.dart';
import 'package:interval_halving_method/ui/screens/optimization_report/optimization_report_screen.dart';

final class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRouteNames.homePath,
    routes: [
      GoRoute(
        path: AppRouteNames.homePath,
        name: AppRouteNames.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRouteNames.reportPath,
        name: AppRouteNames.reportName,
        builder: (context, state) => const OptimizationReportScreen(),
      ),
      GoRoute(
        path: AppRouteNames.iterationPath,
        name: AppRouteNames.iterationName,
        builder: (context, state) => const IterationScreen(),
      ),
      GoRoute(
        path: AppRouteNames.graphicsPath,
        name: AppRouteNames.graphicsName,
        builder: (context, state) {
          // Extra üzerinden gelen veriyi Map olarak alıp ekrana aktarıyoruz
          final args = state.extra as Map<String, dynamic>;

          return GraphicsScreen(
            initialStepIndex: args['initialStepIndex'] as int,
            steps: args['steps'] as List<IterationStep>, // Import etmeyi unutma
            functionString: args['functionString'] as String,
          );
        },
      ),
    ],
  );
}
