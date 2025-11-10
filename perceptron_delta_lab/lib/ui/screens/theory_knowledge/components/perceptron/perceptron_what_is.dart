import '../../export.dart';

class PerceptronWhatIs extends StatelessWidget with TheoryScreenTitleMixin {
  const PerceptronWhatIs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 8,
          children: [
            Text('🧠', style: Theme.of(context).textTheme.titleLarge),
            Text(
              whatPerceptron,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 20),
            ),
          ],
        ),
        Text(
          perceptronExplanation,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorName.vampireGrey,
          ),
        ),
      ],
    );
  }
}
