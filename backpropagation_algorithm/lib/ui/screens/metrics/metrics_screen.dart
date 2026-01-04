import 'dart:math' as math;

import 'package:backpropagation_algorithm/routes/app_route_names.dart';
import 'package:backpropagation_algorithm/ui/screens/results/export.dart';
import 'package:backpropagation_algorithm/ui/widgets/custom_button.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MetricsScreen extends StatefulWidget {
  const MetricsScreen({super.key});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  int _selectedStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.mediumAll,
          child: BlocBuilder<BackpropCubit, BackpropState>(
            builder: (context, state) {
              final steps = state.lossEpochs.isNotEmpty
                  ? state.lossEpochs
                  : List<int>.generate(state.trainLoss.length, (i) => i + 1);

              final len = math.min(
                steps.length,
                math.min(state.trainLoss.length, state.testLoss.length),
              );

              if (len == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz sonuç yok. Önce eğitimi başlat.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              }

              // seçilen adım
              final clamped = _selectedStep.clamp(0, len - 1);
              final epoch = steps[clamped];
              final trainMseAt = state.trainLoss[clamped];
              final testMseAt = state.testLoss[clamped];

              // ✅ en iyi (min) test MSE + hangi epoch
              int bestIdx = 0;
              double bestTestMse = double.infinity;
              for (int i = 0; i < len; i++) {
                final v = state.testLoss[i];
                if (v < bestTestMse) {
                  bestTestMse = v;
                  bestIdx = i;
                }
              }
              final bestEpoch = steps[bestIdx];

              final train = state.metricsTrain;
              final test = state.metricsTest;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context),
                    const SizedBox(height: 24),

                    // =========================
                    // TRAIN METRICS
                    // =========================
                    Text(
                      'Eğitim Metrikleri',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.greenTeal,
                            titleValue: _fmt(train['R2']),
                            title: 'Train R2',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.dodgerBlue,
                            titleValue: _fmt(train['RMSE']),
                            title: 'Train RMSE',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.pumpkinOrange,
                            titleValue: _fmt(train['MAE']),
                            title: 'Train MAE',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.purpleDaffodil,
                            titleValue: _formatDurationMs(state.elapsed),
                            title: 'Eğitim Süresi',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // TEST METRICS
                    // =========================
                    Text(
                      'Test Metrikleri',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.greenTeal,
                            titleValue: _fmt(test['R2']),
                            title: 'Test R2',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.dodgerBlue,
                            titleValue: _fmt(test['RMSE']),
                            title: 'Test RMSE',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.pumpkinOrange,
                            titleValue: _fmt(test['MAE']),
                            title: 'Test MAE',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ResultItem(
                            backgroundColor: ColorName.blueViolet,
                            titleValue: bestTestMse.toStringAsFixed(6),
                            title: 'En iyi Test MSE (E$bestEpoch)',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // EPOCH STEPS / LOSSES (seçilen epoch burada)
                    // =========================
                    Container(
                      padding: AppPaddings.largeAll,
                      decoration: BoxDecoration(
                        color: ColorName.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorName.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Epoch Adımları',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Seçili epoch: $epoch / ${state.totalEpochs > 0 ? state.totalEpochs : state.epochs}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 12),

                          Slider(
                            min: 0,
                            max: (len - 1).toDouble(),
                            divisions: len - 1,
                            value: clamped.toDouble(),
                            onChanged: (v) => setState(() {
                              _selectedStep = v.round();
                            }),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ResultItem(
                                  backgroundColor: ColorName.raspberryPink,
                                  titleValue: trainMseAt.toStringAsFixed(6),
                                  title: 'Train MSE (bu adım)',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ResultItem(
                                  backgroundColor: ColorName.pumpkinOrange,
                                  titleValue: testMseAt.toStringAsFixed(6),
                                  title: 'Test MSE (bu adım)',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  backgroundColor: const [
                                    ColorName.warmBlue,
                                    ColorName.blueViolet,
                                  ],
                                  onTapButton: () => setState(() {
                                    _selectedStep = 0;
                                  }),
                                  title: 'İlk Epoca Git',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomButton(
                                  backgroundColor: const [
                                    ColorName.shamrockGreen,
                                    ColorName.greenTeal,
                                  ],
                                  onTapButton: () => setState(() {
                                    _selectedStep = len - 1;
                                  }),
                                  title: 'Son Epoca Git',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouteNames.home);
            }
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          'Metrikler',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }

  static String _fmt(double? v) => v == null ? '-' : v.toStringAsFixed(4);
  static String _formatDurationMs(Duration d) => '${d.inMilliseconds} ms';
}
