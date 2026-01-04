import 'package:backpropagation_algorithm/ui/screens/home/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectStatus extends StatelessWidget {
  const ProjectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackpropCubit, BackpropState>(
      builder: (context, state) {
        final datasetCount = state.dataset?.n ?? 0;

        final totalLayers = 2 + state.hiddenLayers.length;

        final statusText = state.dataset == null ? 'Hazır' : 'Veri Yüklü';
        final statusColor =
        state.dataset == null ? ColorName.shamrockGreen : ColorName.dodgerBlue;
        final statusBg =
        state.dataset == null ? ColorName.water : ColorName.alabaster;

        return Container(
          padding: AppPaddings.largeAll,
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ColorName.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Proje Durumu',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Container(
                    padding:
                    AppPaddings.xSmallVertical + AppPaddings.smallHorizontal,
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      statusText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 24,
                children: [
                  Expanded(
                    child: _InfoCard(
                      title: 'Veri Seti',
                      value: datasetCount.toString(),
                      suffix: 'Örnek Yüklü',
                    ),
                  ),
                  Expanded(
                    child: _InfoCard(
                      title: 'Model',
                      value: totalLayers.toString(),
                      suffix: 'Katman',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.suffix,
  });

  final String title;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.water,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ColorName.shamrockGreen,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            suffix,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ColorName.shamrockGreen,
            ),
          ),
        ],
      ),
    );
  }
}
