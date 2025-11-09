import 'export.dart';

final class AppRoutes {
  AppRoutes._();

  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: AppRouteNames.home,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          path: AppRouteNames.home,
          name: AppRouteNames.home,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage(child: HomeScreen());
          },
        ),
      ],
    );
  }
}
