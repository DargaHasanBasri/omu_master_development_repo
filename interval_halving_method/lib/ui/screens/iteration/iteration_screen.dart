import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_halving_method/routes/app_route_names.dart';
import 'package:interval_halving_method/ui/screens/iteration/export.dart';
import 'package:interval_halving_method/view_model/home/function_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_state.dart';

// 1. StatefulWidget'a dönüştürdük çünkü ScrollController'ın state'ini tutmamız gerekiyor.
class IterationScreen extends StatefulWidget {
  const IterationScreen({super.key});

  @override
  State<IterationScreen> createState() => _IterationScreenState();
}

class _IterationScreenState extends State<IterationScreen> {
  // 2. ScrollController tanımlıyoruz
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController
        .dispose(); // Bellek sızıntısını önlemek için dispose ediyoruz
    super.dispose();
  }

  // En başa (İlk İterasyona) kaydırma fonksiyonu
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // En sona (Son İterasyona) kaydırma fonksiyonu
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: ColorName.white,
        leading: IconButton(
          icon: Assets.icons.icArrowBack.image(
            package: AppConstants.packageGenName,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Iterations',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),

      // 3. Sağ alt köşeye yönlendirme butonlarını (FloatingActionButton) ekliyoruz
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'btnTop',
            // Birden fazla FAB varsa heroTag vermeliyiz
            backgroundColor: ColorName.white,
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: _scrollToTop,
            child: Icon(
              Icons.keyboard_double_arrow_up_rounded,
              color: ColorName.blueDress,
            ),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'btnBottom',
            backgroundColor: ColorName.white,
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: _scrollToBottom,
            child: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: ColorName.blueDress,
            ),
          ),
        ],
      ),

      body: BlocBuilder<OptimizationCubit, OptimizationState>(
        builder: (context, state) {
          if (state is! OptimizationSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final steps = state.steps;

          return ListView.separated(
            controller: _scrollController,
            // 4. Controller'ı ListView'a bağlıyoruz
            padding: AppPaddings.largeAll.copyWith(bottom: 80),
            // Butonların listeyi kapatmaması için alt padding'i artırdık
            itemCount: steps.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(color: Colors.white24, thickness: 2),
            ),
            itemBuilder: (context, index) {
              final step = steps[index];

              String elimSide = 'Both';
              String elimInterval = '[a, x1] & [x2, b]';
              if (step.eliminatedInterval.contains('Right')) {
                elimSide = 'Right';
                elimInterval = step.eliminatedInterval.replaceFirst(
                  'Right ',
                  '',
                );
              } else if (step.eliminatedInterval.contains('Left')) {
                elimSide = 'Left';
                elimInterval = step.eliminatedInterval.replaceFirst(
                  'Left ',
                  '',
                );
              }

              double progressValue = step.iteration / state.totalIterations;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IterationStatusCard(
                    progress: progressValue,
                    iterationNumber: step.iteration,
                    isActive: step.iteration != state.totalIterations,
                    currentWidth: step.l.toStringAsFixed(4),
                  ),

                  Padding(
                    padding: AppPaddings.mediumVertical,
                    child: Text(
                      'KARAR MEKANİZMASI',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge,
                    ),
                  ),

                  IntervalResultCard(
                    eliminatedSide: elimSide,
                    eliminatedInterval: elimInterval,
                    newInterval: step.newInterval,
                  ),

                  Padding(
                    padding: AppPaddings.mediumVertical,
                    child: StepDetailsHeader(
                      onShowGraphPressed: () {
                        // Seçilen adımı, tüm listeyi ve fonksiyon stringini gönderiyoruz
                        context.pushNamed(
                          AppRouteNames.graphicsName,
                          extra: {
                            'initialStepIndex': index,
                            // O anki listenin indeksi
                            'steps': steps,
                            // Tüm adımlar listesi
                            'functionString': context
                                .read<FunctionCubit>()
                                .state,
                          },
                        );
                      },
                    ),
                  ),

                  PointDetailsCard(
                    type: PointCardType.lower,
                    title: 'POINT X1 (LOWER)',
                    xValue: step.x1.toStringAsFixed(4),
                    fxValue: step.fx1.toStringAsFixed(4),
                  ),
                  PointDetailsCard(
                    type: PointCardType.mid,
                    title: 'POINT XM (MID)',
                    xValue: step.xm.toStringAsFixed(4),
                    fxValue: step.fxm.toStringAsFixed(4),
                  ),
                  PointDetailsCard(
                    type: PointCardType.upper,
                    title: 'POINT X3 (UPPER)',
                    xValue: step.x2.toStringAsFixed(4),
                    fxValue: step.fx2.toStringAsFixed(4),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
