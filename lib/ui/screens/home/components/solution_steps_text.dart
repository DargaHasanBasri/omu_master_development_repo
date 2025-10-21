import 'package:eight_stone_problem/export.dart';

class SolutionStepsText extends StatelessWidget {
  const SolutionStepsText({
    super.key,
    required this.itemCount,
    required this.stepsText,
  });

  final int itemCount;
  final List<String> stepsText;

  @override
  Widget build(BuildContext context) {
    return itemCount != 0
        ? Column(
          children: [
            Padding(
              padding: AppPaddings.smallTop,
              child: Text(
                LocaleKeys.homeScreen_numberOfSteps.locale,
                style:
                Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(
                  color: ColorName.white,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: AppPaddings.mediumAll,
                  physics: BouncingScrollPhysics(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return Text(
                      stepsText[index],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
            ),
          ],
        )
        : Center(
            child: Text(
              "Henüz işlem gerçekleştirilmemiş!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          );
  }
}
