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
                        onTapButton: () =>
                            context.read<CubitHome>().solvePuzzle(),
                        title: LocaleKeys.buttonTitle_start.locale,
                      ),
                    ),
                  ),

                  if (context.watch<CubitHome>().showIncompleteWarning)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "⚠️ Lütfen önce tüm taşları yerleştirin.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.orangeAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  Padding(
                    padding: AppPaddings.smallVertical,
                    child: Column(
                      children: [
                        Text(
                          context.watch<CubitHome>().solutionFound == null
                              ? "Henüz çözüm aranmadı."
                              : context.watch<CubitHome>().solutionFound == true
                              ? "✅ Çözüm bulundu!"
                              : "❌ Çözüm bulunamadı.",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: ColorName.white,
                              ),
                        ),
                        Text(
                          "Denetlenen düğüm: ${context.watch<CubitHome>().checkedNodes}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: ColorName.white,
                              ),
                        ),
                        Text(
                          "Adım sayısı: ${context.watch<CubitHome>().totalSteps}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: ColorName.white,
                              ),
                        ),

                        // 👇 Buraya ekliyoruz
                        if (context.watch<CubitHome>().solutionFound == false &&
                            context.watch<CubitHome>().checkedNodes == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "⚠️ Bu diziliş matematiksel olarak çözülemez.",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.orangeAccent,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
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
