import '../export.dart';

class TargetBoardGrid extends StatelessWidget {
  const TargetBoardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final targetNumbers = List<int?>.generate(8, (i) => i + 1)..add(null);
    return Column(
      children: [
        Padding(
          padding: AppPaddings.xXSmallVertical,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                LocaleKeys.homeScreen_targeted.locale,
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
                    onTapButton: () {},
                    backgroundColor: Colors.transparent,
                    borderRadius: 24,
                    icon: Assets.icons.icTarget.image(
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
                        number: targetNumbers[index],
                        onTapBox: () => null,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
