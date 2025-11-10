import '../../export.dart';

class DeltaMathematicalModel extends StatelessWidget
    with TheoryScreenTitleMixin {
  const DeltaMathematicalModel({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ŷ = Σ wᵢ xᵢ  +  b",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "e = t − ŷ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "w ← w + η · e · x\nb ← b + η · e",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        Text(
          "• $deltaMsgFirst  E = ½ (t − ŷ)²\n"
          "• $deltaMsgSecond\n"
          "• $deltaMsgThird",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorName.vampireGrey,
          ),
        ),
      ],
    );
  }
}
