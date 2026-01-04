import 'package:backpropagation_algorithm/ui/screens/data/components/percent_slider.dart';
import 'package:backpropagation_algorithm/ui/screens/data/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';

class DataPartitionSettings extends StatelessWidget {
  const DataPartitionSettings({super.key});

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
      child: BlocBuilder<BackpropCubit, BackpropState>(
        builder: (context, state) {
          final trainPercent = state.trainRatio * 100.0;
          final testPercent = (1.0 - state.trainRatio) * 100.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Veri Bölme Ayarları',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Padding(
                padding: AppPaddings.mediumVertical,
                child: PercentSlider(
                  activeColor: ColorName.blueViolet,
                  title: 'Eğitim Seti',
                  value: trainPercent,
                  min: 10,
                  max: 90,
                  divisions: 80,
                  onChanged: (v) =>
                      context.read<BackpropCubit>().setTrainRatio(v / 100.0),
                ),
              ),
              PercentSlider(
                activeColor: ColorName.pumpkinOrange,
                title: 'Test Seti',
                value: testPercent,
                min: 10,
                max: 90,
                divisions: 80,
                onChanged: null,
              ),
            ],
          );
        },
      ),
    );
  }
}
