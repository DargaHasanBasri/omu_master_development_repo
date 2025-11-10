import '../export.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabTabCubit, LabTab>(
      builder: (context, state) {
        final isPerceptron = state == LabTab.perceptron;
        final isDelta = state == LabTab.delta;
        return Container(
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ColorName.black.withValues(alpha: 0.08),
                offset: Offset(0, 4),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        context.read<LabTabCubit>().select(LabTab.perceptron),
                    splashColor: ColorName.cornflower.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    child: Ink(
                      padding: AppPaddings.smallVertical,
                      decoration: BoxDecoration(
                        gradient: isPerceptron
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorName.cornflower,
                                  ColorName.darkLavender,
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        AppConstants.tabPerceptron,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontSize: 22,
                              color: isPerceptron
                                  ? ColorName.white
                                  : ColorName.black,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        context.read<LabTabCubit>().select(LabTab.delta),
                    splashColor: ColorName.cornflower.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    child: Ink(
                      padding: AppPaddings.smallVertical,
                      decoration: BoxDecoration(
                        gradient: isDelta
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorName.cornflower,
                                  ColorName.darkLavender,
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        AppConstants.tabDelta,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontSize: 22,
                              color: isDelta
                                  ? ColorName.white
                                  : ColorName.black,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
