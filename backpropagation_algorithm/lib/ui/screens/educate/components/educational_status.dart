import 'package:backpropagation_algorithm/ui/screens/educate/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationalStatus extends StatelessWidget {
  const EducationalStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackpropCubit, BackpropState>(
      builder: (context, state) {
        final progressPercent = (state.progress * 100).clamp(0, 100);
        final epochText = state.totalEpochs > 0
            ? 'Epoch ${state.currentEpoch}/${state.totalEpochs}'
            : 'Epoch 0/${state.epochs}';

        final etaText = _formatDuration(state.eta);
        final elapsedText = _formatDuration(state.elapsed);

        final statusText = state.isTraining
            ? 'Kalan süre: $etaText • Geçen: $elapsedText'
            : (state.dataset == null
            ? 'Önce veri yükle'
            : 'Hazır • Eğitim başlatılmadı');

        return Container(
          padding: AppPaddings.largeAll,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorName.blueViolet.withValues(alpha: 0.3),
                offset: const Offset(0, 10),
                blurRadius: 25,
              ),
            ],
            gradient: LinearGradient(
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
              colors: [
                ColorName.warmBlue.withValues(alpha: 0.9),
                ColorName.blueViolet.withValues(alpha: 0.8),
                ColorName.raspberryPink.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Eğitim Durumu',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: ColorName.white),
                  ),
                  Assets.icons.icHome.image(package: AppConstants.packageName),
                ],
              ),

              PercentSlider(
                activeColor: ColorName.white,
                title: epochText,
                titleColor: ColorName.white,
                value: progressPercent.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: null, // sadece gösterim
              ),

              Text(
                statusText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: ColorName.white),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDuration(Duration d) {
    final totalSeconds = d.inSeconds;
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    if (m <= 0) return '${s}s';
    return '${m}dk ${s}s';
  }
}
