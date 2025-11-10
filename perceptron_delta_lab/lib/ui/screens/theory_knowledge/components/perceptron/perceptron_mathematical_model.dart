import '../../export.dart';

class PerceptronMathematicalModel extends StatelessWidget
    with TheoryScreenTitleMixin {
  const PerceptronMathematicalModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 8,
          children: [
            Text('📐', style: Theme.of(context).textTheme.titleLarge),
            Text(
              mathematicalModel,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 20),
            ),
          ],
        ),
        Container(
          padding: AppPaddings.mediumVertical,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorName.whiteSmoke,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "y = f( Σ wᵢ xᵢ  +  b )",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Text(
          "• xᵢ: ${perceptronMsgFirst}\n• wᵢ: ${perceptronMsgSecond}\n• b: ${perceptronMsgThird}\n"
          "• f: ${perceptronMsgFourth}\n"
          "• ${perceptronMsgNote}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorName.vampireGrey,
          ),
        ),
      ],
    );
  }
}
