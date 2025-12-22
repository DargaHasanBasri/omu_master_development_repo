import 'package:perceptron_delta_lab/ui/screens/delta_trace/delta_test_screen.dart';
import 'package:perceptron_delta_lab/ui/screens/perceptron_trace/perceptron_test_screen.dart';

import '../ui/screens/delta_data_set/delta_data_set_screen.dart';
import '../ui/screens/delta_trace/delta_trace_screen.dart';
import '../ui/screens/perceptron_trace/perceptron_trace_screen.dart';
import '../viewmodel/data_set/data_set_table_cubit.dart';
import '../viewmodel/delta_data_set/delta_data_set_table_cubit.dart';
import 'export.dart';

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
            return MaterialPage(child: HomeScreen());
          },
        ),

        /// TheoryKnowledge Screen
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

        /// DataSet Screen
        GoRoute(
          path: AppRouteNames.dataSet,
          name: AppRouteNames.dataSet,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const DataSetScreen(),
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

        /// Perceptron Trace Screen
        GoRoute(
          path: AppRouteNames.perceptronTrace,
          name: AppRouteNames.perceptronTrace,
          pageBuilder: (context, state) {
            final trace = state.extra as PerceptronTrace;
            return CustomTransitionPage(
              child: PerceptronTraceScreen(trace: trace),
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
            );
          },
        ),

        /// Perceptron Trace test Screen
        GoRoute(
          path: AppRouteNames.perceptronTest,
          name: AppRouteNames.perceptronTest,
          pageBuilder: (context, state) {
            final result = state.extra as PerceptronTestResult;
            return CustomTransitionPage(
              child: PerceptronTestScreen(result: result),
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
            );
          },
        ),

        /// DeltaDataSet Screen
        GoRoute(
          path: AppRouteNames.dataSetDelta,
          name: AppRouteNames.dataSetDelta,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const DeltaDataSetScreen(),
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

        /// Delta (Adaline) Trace Screen
        GoRoute(
          path: AppRouteNames.deltaTrace,
          name: AppRouteNames.deltaTrace,
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! DeltaTrace) {
              return const MaterialPage(
                child: Scaffold(
                  body: Center(child: Text('Delta trace verisi bulunamadı')),
                ),
              );
            }
            return CustomTransitionPage(
              child: DeltaTraceScreen(trace: extra),
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
            );
          },
        ),

        /// Delta (Adaline) test Screen
        GoRoute(
          path: AppRouteNames.deltaTest,
          name: AppRouteNames.deltaTest,
          pageBuilder: (context, state) {
            final result = state.extra as DeltaTestResult;
            return CustomTransitionPage(
              child: DeltaTestScreen(result: result),
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
            );
          },
        ),


      ],
    );
  }
}
