import 'export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.ebonyClay,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: AppPaddings.mediumAll,
            child: BlocBuilder<CubitHome, List<int?>>(
              builder: (context, numbers) {
                final cubitWatch = context.watch<CubitHome>();
                final cubitRead = context.read<CubitHome>();
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
                                  isFlipped: cubitWatch.isFlipped,
                                ),
                            child: cubitWatch.isFlipped
                                ? PlacementBoardGrid(
                                    key: ValueKey(
                                      AppConstants.valueKeyPlacement,
                                    ),
                                    numbers: numbers,
                                    onTapBox: (index) {
                                      cubitRead.selectBox(index);
                                    },
                                  )
                                : TargetBoardGrid(
                                    key: ValueKey(
                                      AppConstants.valueKeyPlacement,
                                    ),
                                  ),
                          ),

                          /// Container Rotation Button
                          Padding(
                            padding: AppPaddings.xXSmallAll,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                onTapButton: () => cubitRead.toggleFlip(),
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

                    /// Start Button and Solution Steps Board Grid
                    Visibility(
                      visible: cubitWatch.isFlipped,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: AppPaddings.smallVertical,
                            child: CustomButton(
                              onTapButton: () {
                                final filledCount = cubitRead.state
                                    .where((e) => e != null)
                                    .length;
                                if (cubitRead.isSolving || filledCount < 8)
                                  return;
                                cubitRead.solveBoard();
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              title: LocaleKeys.buttonTitle_start.locale,
                              backgroundColor: ColorName.toolbox,
                            ),
                          ),
                          Padding(
                            padding: AppPaddings.smallBottom,
                            child: _solutionMessage(cubitWatch, context),
                          ),
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
                                        isFlipped: cubitWatch.isFlippedSteps,
                                      ),
                                  child: cubitWatch.isFlippedSteps
                                      ? Container(
                                          height: 355,
                                          child: SolutionStepsText(
                                            key: ValueKey(
                                              AppConstants
                                                  .valueKeySolutionStepsText,
                                            ),
                                            itemCount: cubitWatch
                                                .solutionInstructions
                                                .length,
                                            stepsText:
                                                cubitWatch.solutionInstructions,
                                          ),
                                        )
                                      : SolutionStepsBoardGrid(
                                          key: ValueKey(
                                            AppConstants
                                                .valueKeySolutionStepsBoardGrid,
                                          ),
                                          numbers:
                                              cubitWatch.currentVisitedNode,
                                          stepNum: cubitWatch.currentStepNum,
                                          onTapStop: () {
                                            cubitRead.stopSolution();
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position
                                                  .minScrollExtent,
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        ),
                                ),
                                Padding(
                                  padding: AppPaddings.xXSmallAll,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomButton(
                                      onTapButton: () =>
                                          cubitRead.toggleFlipSteps(),
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
                        ],
                      ),
                    ),

                    Visibility(
                      visible: !cubitWatch.isFlipped,
                      child: Padding(
                        padding: AppPaddings.mediumTop,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorName.tuna,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: HowToPlayText(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _solutionMessage(CubitHome cubitWatch, BuildContext context) {
    return Container(
      padding: AppPaddings.xSmallAll,
      decoration: BoxDecoration(
        color: ColorName.tuna,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            cubitWatch.solutionFound == null
                ? LocaleKeys.homeScreen_noSolutionFoundYet.locale
                : cubitWatch.solutionFound == true
                ? "✅ ${LocaleKeys.homeScreen_solutionFound.locale}"
                : "❌ ${LocaleKeys.homeScreen_noSolutionFound.locale}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ColorName.white,
            ),
          ),
          Text(
            "${LocaleKeys.homeScreen_supervisedNode.locale}: ${cubitWatch.checkedNodes}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorName.white,
            ),
          ),
          Text(
            "${LocaleKeys.homeScreen_numberOfSteps.locale}: ${cubitWatch.totalSteps}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorName.white,
            ),
          ),
          if (cubitWatch.solutionFound == false && cubitWatch.checkedNodes == 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "⚠️ ${LocaleKeys.homeScreen_message.locale}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.orangeAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
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
