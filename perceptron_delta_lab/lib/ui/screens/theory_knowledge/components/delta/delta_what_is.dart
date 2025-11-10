import '../../export.dart';

class DeltaWhatIs extends StatelessWidget with TheoryScreenTitleMixin {
  const DeltaWhatIs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 8,
          children: [
            Text('Δ', style: Theme.of(context).textTheme.titleLarge),
            Text(
              whatDelta,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 20),
            ),
          ],
        ),
        Text(
          deltaExplanation,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorName.vampireGrey,
          ),
        ),
      ],
    );
  }
}
