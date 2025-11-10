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

        GoRoute(
          path: AppRouteNames.theoryKnowledge,
          name: AppRouteNames.theoryKnowledge,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const TheoryKnowledgeScreen(),
            transitionsBuilder: (ctx, animation, _, child) {
              final offset =
                  Tween(begin: const Offset(0.1, 0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutCubic))
                      .animate(animation);
              final fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );
              return SlideTransition(
                position: offset,
                child: FadeTransition(opacity: fade, child: child),
              );
            },
          ),
        ),
      ],
    );
  }
}
