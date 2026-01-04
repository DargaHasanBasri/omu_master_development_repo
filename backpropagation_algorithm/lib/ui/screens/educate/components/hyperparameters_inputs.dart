import 'package:backpropagation_algorithm/ui/screens/data/export.dart';
import 'package:backpropagation_algorithm/ui/screens/educate/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:backpropagation_algorithm/ui/screens/educate/components/activation_radio_group.dart';


class HyperparametersInputs extends StatelessWidget {
  const HyperparametersInputs({
    required this.numberNeurons,
    required this.totalEpoch,
    required this.learningRate,
    super.key,
  });

  final TextEditingController learningRate;
  final TextEditingController totalEpoch;
  final TextEditingController numberNeurons;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackpropCubit, BackpropState>(
      builder: (context, state) {
        _syncController(learningRate, state.learningRate.toString());
        _syncController(totalEpoch, state.epochs.toString());
        _syncController(
          numberNeurons,
          state.hiddenLayers.isEmpty ? '' : state.hiddenLayers.first.toString(),
        );

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
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hiperparametreler',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const ActivationRadioGroup(),

              CustomTextFormField(
                controller: learningRate,
                textFieldTitle: 'Öğrenme Oranı (α)',
                hintText: '0.05',
                inputType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (txt) {
                  final v = double.tryParse(txt.replaceAll(',', '.'));
                  if (v != null && v > 0) {
                    context.read<BackpropCubit>().setHyperparameters(
                      learningRate: v,
                    );
                  }
                },
              ),

              CustomTextFormField(
                controller: totalEpoch,
                textFieldTitle: 'Epoch Sayısı',
                hintText: '500',
                inputType: TextInputType.number,
                onChanged: (txt) {
                  final v = int.tryParse(txt);
                  if (v != null && v > 0) {
                    context.read<BackpropCubit>().setHyperparameters(epochs: v);
                  }
                },
              ),

              CustomTextFormField(
                controller: numberNeurons,
                textFieldTitle: 'Gizli Katman Nöron Sayısı',
                hintText: 'Boş bırak = tek katman',
                inputType: TextInputType.number,
                onChanged: (txt) {
                  final t = txt.trim();
                  if (t.isEmpty) {
                    context.read<BackpropCubit>().setHiddenLayers(const []);
                    return;
                  }
                  final n = int.tryParse(t);
                  if (n != null) {
                    context.read<BackpropCubit>().setSingleHiddenNeurons(n);
                  }
                },
              ),

              CustomButton(
                backgroundColor: const [
                  ColorName.shamrockGreen,
                  ColorName.greenTeal,
                ],
                onTapButton: state.isTraining
                    ? null
                    : () => context.read<BackpropCubit>().train(),
                title: state.isTraining
                    ? 'Eğitim Devam Ediyor...'
                    : 'Eğitimi Başlat',
              ),

              CustomButton(
                backgroundColor: [
                  ColorName.paleSky.withValues(alpha: 0.3),
                  ColorName.paleSky.withValues(alpha: 0.5),
                ],
                onTapButton: state.isTraining
                    ? null
                    : () =>
                          context.read<BackpropCubit>().resetHyperparameters(),
                title: 'Ayarları Sıfırla',
              ),
            ],
          ),
        );
      },
    );
  }

  static void _syncController(TextEditingController c, String next) {
    if (c.text == next) return;
    c.value = c.value.copyWith(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
      composing: TextRange.empty,
    );
  }
}
