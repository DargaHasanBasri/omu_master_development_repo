import 'package:backpropagation_algorithm/routes/app_route_names.dart';
import 'package:backpropagation_algorithm/ui/screens/results/components/charts.dart';
import 'package:backpropagation_algorithm/ui/screens/results/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.mediumAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppPaddings.xSmallBottom,
                child: Row(
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
                      'Grafikler',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SingleChildScrollView(
                    padding: AppPaddings.smallAll,
                    physics: const BouncingScrollPhysics(),
                    child: BlocBuilder<BackpropCubit, BackpropState>(
                      builder: (context, state) {
                        final hasPred =
                            state.trainTrue.isNotEmpty && state.trainPred.isNotEmpty;

                        if (!hasPred) {
                          return _EmptyGraphs();
                        }

                        return Column(
                          spacing: 24,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GraphicItem(
                              title: 'Eğitim: Gerçek vs Model Çıkışı',
                              child: LineChartCard.fromSeries(
                                series: [
                                  ChartSeries(
                                    name: 'Gerçek',
                                    values: state.trainTrue,
                                    color: ColorName.blueViolet,
                                  ),
                                  ChartSeries(
                                    name: 'Model',
                                    values: state.trainPred,
                                    color: ColorName.shamrockGreen,
                                  ),
                                ],
                              ),
                            ),

                            GraphicItem(
                              title: 'Test: Gerçek vs Model Çıkışı',
                              child: LineChartCard.fromSeries(
                                series: [
                                  ChartSeries(
                                    name: 'Gerçek',
                                    values: state.testTrue,
                                    color: ColorName.blueViolet,
                                  ),
                                  ChartSeries(
                                    name: 'Model',
                                    values: state.testPred,
                                    color: ColorName.shamrockGreen,
                                  ),
                                ],
                              ),
                            ),

                            GraphicItem(
                              title: 'Hata Grafiği (Loss)',
                              child: LossChartCard(
                                epochs: state.lossEpochs,
                                trainLoss: state.trainLoss,
                                testLoss: state.testLoss,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyGraphs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(
        'Henüz grafik yok.\nÖnce eğitimi tamamla.',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: ColorName.paleSky),
        textAlign: TextAlign.center,
      ),
    );
  }
}
