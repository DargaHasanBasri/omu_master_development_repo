import 'export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.ebonyClay,
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.mediumAll,
          child: BlocBuilder<CubitHome, List<int?>>(
            builder: (context, numbers) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Main Title "8 Taş"
                  Padding(
                    padding: AppPaddings.smallVertical,
                    child: _buildScreenTitle(context),
                  ),

                  /// Target and Placement Num Boxes
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorName.tuna,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              CustomFlipTransition(
                                animation: animation,
                                child: child,
                                isFlipped: context.watch<CubitHome>().isFlipped,
                              ),
                          child: context.watch<CubitHome>().isFlipped
                              ? PlacementBoardGrid(
                                  key: ValueKey(AppConstants.valueKeyPlacement),
                                  numbers: numbers,
                                  onTapBox: (index) {
                                    context.read<CubitHome>().selectBox(index);
                                  },
                                )
                              : TargetBoardGrid(
                                  key: ValueKey(AppConstants.valueKeyPlacement),
                                ),
                        ),

                        /// Container Rotation Button
                        Padding(
                          padding: AppPaddings.xXSmallAll,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              onTapButton: () =>
                                  context.read<CubitHome>().toggleFlip(),
                              backgroundColor: Colors.transparent,
                              borderRadius: 24,
                              icon: Assets.icons.icChange.image(
                                package: AppConstants.packageName,
                                scale: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Start Button
                  Visibility(
                    visible: context.watch<CubitHome>().isFlipped,
                    child: Padding(
                      padding: AppPaddings.smallVertical,
                      child: CustomButton(
                        onTapButton: () {},
                        title: LocaleKeys.buttonTitle_start.locale,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: AppPaddings.smallAll,
      decoration: BoxDecoration(
        color: ColorName.tuna,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        LocaleKeys.appName.locale,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: ColorName.white),
      ),
    );
  }
}
