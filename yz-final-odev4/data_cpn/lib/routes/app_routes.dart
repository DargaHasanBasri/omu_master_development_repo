import 'package:data_cpn/routes/export.dart';

final class AppRoutes {
  AppRoutes._();

  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: AppRouteNames.welcomeScreen,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        /// Home Screen
        GoRoute(
          path: AppRouteNames.welcomeScreen,
          name: AppRouteNames.welcomeScreen,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const WelcomeScreen(),
            );
          },
        ),

        /// Data Loading Screen
        GoRoute(
          path: AppRouteNames.dataLoadingScreen,
          name: AppRouteNames.dataLoadingScreen,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const DataLoadingScreen(),
            );
          },
        ),

        /// Parameter Settings Screen
        GoRoute(
          path: AppRouteNames.parameterSettings,
          name: AppRouteNames.parameterSettings,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const ParameterSettingsScreen(),
            );
          },
        ),

        /// Model Training Screen
        GoRoute(
          path: AppRouteNames.modelTraining,
          name: AppRouteNames.modelTraining,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const ModelTrainingScreen(),
            );
          },
        ),

        /// Reporting Screen
        GoRoute(
          path: AppRouteNames.reporting,
          name: AppRouteNames.reporting,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(
              key: state.pageKey,
              child: const ReportingScreen(),
            );
          },
        ),
      ],
    );
  }
}
