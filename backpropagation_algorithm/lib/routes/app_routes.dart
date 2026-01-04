import 'package:backpropagation_algorithm/routes/export.dart';
import 'package:backpropagation_algorithm/ui/screens/metrics/metrics_screen.dart';

final class AppRoutes {
  AppRoutes._();

  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: AppRouteNames.home,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        /// Home Screen
        GoRoute(
          path: AppRouteNames.home,
          name: AppRouteNames.home,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const HomeScreen(),
            );
          },
        ),

        /// Data Screen
        GoRoute(
          path: AppRouteNames.data,
          name: AppRouteNames.data,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const DataScreen(),
            );
          },
        ),

        /// Educate Screen
        GoRoute(
          path: AppRouteNames.educate,
          name: AppRouteNames.educate,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const EducateScreen(),
            );
          },
        ),

        /// Results Screen
        GoRoute(
          path: AppRouteNames.results,
          name: AppRouteNames.results,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const ResultsScreen(),
            );
          },
        ),

        /// Metrics Screen
        GoRoute(
          path: AppRouteNames.metrics,
          name: AppRouteNames.metrics,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const MetricsScreen(),
            );
          },
        ),
      ],
    );
  }
}
