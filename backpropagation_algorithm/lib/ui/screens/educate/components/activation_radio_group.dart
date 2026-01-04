import 'package:backpropagation_algorithm/export.dart';
import 'package:backpropagation_algorithm/utils/backpropagation/activation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';

class ActivationRadioGroup extends StatelessWidget {
  const ActivationRadioGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackpropCubit, BackpropState>(
      buildWhen: (p, c) => p.activation != c.activation || p.isTraining != c.isTraining,
      builder: (context, state) {
        final disabled = state.isTraining;

        return Container(
          padding: AppPaddings.mediumAll,
          decoration: BoxDecoration(
            color: ColorName.alabaster,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Aktivasyon Fonksiyonu',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: ColorName.paleSky),
              ),
              const SizedBox(height: 8),

              _ActivationRadioTile(
                title: 'Doğrusal (Linear)',
                value: ActivationType.linear,
                groupValue: state.activation,
                disabled: disabled,
                onChanged: (v) =>
                    context.read<BackpropCubit>().setActivation(v),
              ),
              _ActivationRadioTile(
                title: 'Logaritmik Sigmoid (Sigmoid)',
                value: ActivationType.sigmoid,
                groupValue: state.activation,
                disabled: disabled,
                onChanged: (v) =>
                    context.read<BackpropCubit>().setActivation(v),
              ),
              _ActivationRadioTile(
                title: 'Tanjant Sigmoid (Tanh)',
                value: ActivationType.tanh,
                groupValue: state.activation,
                disabled: disabled,
                onChanged: (v) =>
                    context.read<BackpropCubit>().setActivation(v),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivationRadioTile extends StatelessWidget {
  const _ActivationRadioTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.disabled,
  });

  final String title;
  final ActivationType value;
  final ActivationType groupValue;
  final ValueChanged<ActivationType> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: disabled ? null : () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? ColorName.blueViolet : ColorName.mercury,
          ),
          color: selected
              ? ColorName.blueViolet.withValues(alpha: 0.08)
              : ColorName.white.withValues(alpha: 0.0),
        ),
        child: Row(
          children: [
            Radio<ActivationType>(
              value: value,
              groupValue: groupValue,
              onChanged: disabled ? null : (v) => onChanged(v!),
              activeColor: ColorName.blueViolet,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: disabled ? ColorName.paleSky : ColorName.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
