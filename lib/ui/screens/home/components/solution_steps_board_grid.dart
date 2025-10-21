import '../export.dart';

class SolutionStepsBoardGrid extends StatelessWidget {
  const SolutionStepsBoardGrid({
    super.key,
    required this.numbers,
    this.stepNum,
    required this.onTapStop,
  });

  final List<int?> numbers;
  final int? stepNum;
  final VoidCallback onTapStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppPaddings.xXSmallVertical,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                LocaleKeys.homeScreen_supervisedNodes.locale,
                style:
                    Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(
                      color: ColorName.white,
                      fontSize: 20,
                    ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: AppPaddings.xXSmallRight,
                  child: CustomButton(
                    onTapButton: () => onTapStop.call(),
                    backgroundColor: Colors.transparent,
                    borderRadius: 24,
                    icon: Assets.icons.icStop.image(
                      package: AppConstants.packageName,
                      scale: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: AppPaddings.smallVertical,
          child: Column(
            children: List.generate(3, (row) {
              return Padding(
                padding: AppPaddings.xSmallVertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (col) {
                    final index = row * 3 + col;
                    return Padding(
                      padding: AppPaddings.xSmallHorizontal,
                      child: NumBox(
                        number: numbers[index],
                        onTapBox: () => null,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: AppPaddings.smallRight + AppPaddings.mediumBottom,
            child: Text(
              "${stepNum ?? 0}",
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(
                    color: ColorName.white,
                    fontSize: 16,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
