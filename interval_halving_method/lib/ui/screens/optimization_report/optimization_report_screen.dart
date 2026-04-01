import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_halving_method/core/enums/optimization_objective.dart';

// Kendi export ve route yollarını kontrol et
import 'package:interval_halving_method/routes/app_route_names.dart';
import 'package:interval_halving_method/ui/screens/optimization_report/export.dart';
import 'package:interval_halving_method/view_model/home/function_cubit.dart';
import 'package:interval_halving_method/view_model/home/objective_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_state.dart';

class OptimizationReportScreen extends StatelessWidget {
  const OptimizationReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fonksiyon stringini başlıkta göstermek için FunctionCubit'ten alıyoruz
    final functionString = context.read<FunctionCubit>().state;
    final objective = context.read<ObjectiveCubit>().state;
    final isMinimize = objective == OptimizationObjective.minimize;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: ColorName.white,
        leading: IconButton(
          icon: Assets.icons.icArrowBack.image(
            package: AppConstants.packageGenName,
          ),
          onPressed: () => context.pop(), // Geri Dönüş
        ),
        title: Text(
          'Optimization Report',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      // GERÇEK VERİLERİ ÇEKMEK İÇİN BLOCBUILDER EKLENDİ
      body: BlocBuilder<OptimizationCubit, OptimizationState>(
        builder: (context, state) {
          if (state is! OptimizationSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: AppPaddings.largeAll,
              child: Column(
                children: [
                  const Padding(
                    padding: AppPaddings.mediumBottom,
                    child: OptimizationResultHeader(),
                  ),

                  ResultDetailCard(
                    // Başlık dinamik oldu
                    title: isMinimize
                        ? 'MINIMUM POINT (X*)'
                        : 'MAXIMUM POINT (X*)',
                    value: state.optimalX.toStringAsFixed(5),
                    valueColor: const Color(0xFF2563EB),
                    subtitleText: 'Converged successfully',
                    subtitleColor: const Color(0xFF12B76A),
                    // İkon da yön değiştiriyor (Aşağı ok veya Yukarı ok)
                    subtitleIcon: isMinimize
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                  ),

                  // 2. OPTİMAL FONKSİYON SONUCU F(X*)
                  ResultDetailCard(
                    // Başlık dinamik oldu
                    title: isMinimize
                        ? 'MINIMUM VALUE F(X*)'
                        : 'MAXIMUM VALUE F(X*)',
                    value: state.optimalFx.toStringAsFixed(5),
                    valueColor: const Color(0xFF101828),
                    subtitleText: 'Target function: f(x) = $functionString',
                    subtitleColor: const Color(0xFF64748B),
                  ),

                  // 3. PERFORMANS METRİKLERİ
                  PerformanceMetricsCard(
                    totalIterations: state.totalIterations, // Gerçek iterasyon
                    processTimeMs: state.processTimeMs, // Gerçek süre
                  ),

                  // 4. BAŞA DÖNME BUTONU
                  Padding(
                    padding: AppPaddings.largeVertical,
                    child: OutlinedActionButton(
                      text: 'Re-run with different parameters',
                      icon: Icons.refresh_rounded,
                      onPressed: () {
                        // Ana Sayfaya tamamen geri dönüp stack'i temizler
                        context.goNamed(AppRouteNames.homeName);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
