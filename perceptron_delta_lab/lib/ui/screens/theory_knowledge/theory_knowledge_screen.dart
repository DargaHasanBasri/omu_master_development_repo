import 'export.dart';

class TheoryKnowledgeScreen extends StatelessWidget with TheoryScreenTitleMixin {
  const TheoryKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: ColorName.whiteSmoke,
      appBar: AppBar(
        backgroundColor: ColorName.white,
        title: Text(
          mainTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: CircleBorder(),
            splashColor: ColorName.darkLavender.withValues(alpha: 0.3),
            onTap: () => context.pop(),
            child: Ink(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Assets.icons.icArrowBack.image(
                package: AppConstants.packageName,
                color: ColorName.darkLavender,
                scale: 1.6,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppPaddings.largeAll + AppPaddings.smallBottom,
          child: BlocProvider(
            create: (_) => LabTabCubit(),
            child: Column(
              spacing: 8,
              children: [
                CustomTabBar(),
                Expanded(
                  child: BlocBuilder<LabTabCubit, LabTab>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: ClipRRect(
                          key: ValueKey(state),
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(20),
                          child: SingleChildScrollView(
                            padding: AppPaddings.smallVertical,
                            physics: BouncingScrollPhysics(),
                            child: state == LabTab.perceptron
                                ? _buildPerceptron()
                                : _buildDelta(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerceptron() {
    return Column(
      spacing: 16,
      children: [
        KnowledgeBox(child: PerceptronWhatIs()),
        KnowledgeBox(child: PerceptronMathematicalModel()),
        Padding(
          padding: AppPaddings.mediumBottom,
          child: KnowledgeBox(child: PerceptronNeuralNetworkStructure()),
        ),
      ],
    );
  }

  Widget _buildDelta() {
    return Column(
      spacing: 16,
      children: [
        KnowledgeBox(child: DeltaWhatIs()),
        KnowledgeBox(child: DeltaMathematicalModel()),
        KnowledgeBox(child: DeltaNeuralNetworkStructure()),
      ],
    );
  }
}
