import 'package:backpropagation_algorithm/ui/screens/data/export.dart';

class PercentSlider extends StatelessWidget {
  const PercentSlider({
    required this.activeColor,
    required this.title,
    required this.value, // 0..100
    required this.onChanged, // null => disabled
    super.key,
    this.titleColor,
    this.min = 0,
    this.max = 100,
    this.divisions = 100,
  });

  final String title;
  final Color activeColor;
  final Color? titleColor;

  final double value;
  final ValueChanged<double>? onChanged;

  final double min;
  final double max;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(min, max);
    final percentText = '%${clamped.round()}';
    final isDisabled = onChanged == null;

    final base = SliderTheme.of(context);
    final themed = base.copyWith(
      // enabled renkler
      activeTrackColor: activeColor,
      inactiveTrackColor: ColorName.mercury,
      thumbColor: activeColor,

      // disabled renkler (asıl fix burada)
      disabledActiveTrackColor: activeColor,
      disabledInactiveTrackColor: ColorName.mercury,
      disabledThumbColor: activeColor.withValues(alpha: 0.6),

      // disabled iken thumb’ı biraz küçült (istersen tamamen 0 da yapabilirsin)
      thumbShape: isDisabled
          ? const RoundSliderThumbShape(enabledThumbRadius: 0, disabledThumbRadius: 0)
          : base.thumbShape,
      overlayShape: SliderComponentShape.noOverlay,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppPaddings.xXSmallBottom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: titleColor ?? ColorName.paleSky,
                ),
              ),
              Text(
                percentText,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: activeColor),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: themed,
          child: Slider(
            padding: EdgeInsets.zero,
            min: min,
            max: max,
            divisions: divisions,
            value: clamped,
            onChanged: onChanged, // null ise disabled ama renk artık korunuyor
          ),
        ),
      ],
    );
  }
}
