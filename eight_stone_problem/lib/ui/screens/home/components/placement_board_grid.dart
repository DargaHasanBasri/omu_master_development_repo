import '../export.dart';

class PlacementBoardGrid extends StatelessWidget {
  final List<int?> numbers;
  final void Function(int index) onTapBox;

  const PlacementBoardGrid({
    super.key,
    required this.numbers,
    required this.onTapBox,
  });

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
                LocaleKeys.homeScreen_placement.locale,
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
                    onTapButton: () => context.read<CubitHome>().reset(),
                    backgroundColor: Colors.transparent,
                    borderRadius: 24,
                    icon: Assets.icons.icReset.image(
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
                        onTapBox: () => onTapBox(index),
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
