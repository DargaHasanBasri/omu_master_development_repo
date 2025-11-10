import 'export.dart';

class HomeScreen extends StatelessWidget with HomeScreenTitleMixin {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorName.cornflower, ColorName.darkLavender],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: AppPaddings.largeHorizontal,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: AppPaddings.largeTop,
                    child: _screenTitleSubtitle(context),
                  ),
                  Expanded(child: _labFeatureMenu(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _screenTitleSubtitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          mainTitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: ColorName.white),
        ),
        Text(
          mainSubtitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: ColorName.white),
        ),
        Padding(
          padding: AppPaddings.xXLargeTop,
          child: Container(
            child: Column(
              spacing: 10,
              children: [
                Text('🧠', style: TextStyle(fontSize: 48)),
                Padding(
                  padding: AppPaddings.xLargeTop,
                  child: Text(
                    centerTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(color: ColorName.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  centerSubtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: ColorName.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _labFeatureMenu(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(20),
      child: SingleChildScrollView(
        padding: AppPaddings.xXLargeVertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          spacing: 16,
          children: [
            LabFeatureCard(
              onTap: () {},
              icon: Assets.icons.dataSet,
              title: cardFirstTitle,
              subtitle: cardFirstSubtitle,
            ),
            LabFeatureCard(
              onTap: () {},
              icon: Assets.icons.dataSet,
              title: cardSecondTitle,
              subtitle: cardSecondSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorName.lightFuchsiaPink, ColorName.beanRed],
              ),
            ),
            LabFeatureCard(
              onTap: () => context.pushNamed(AppRouteNames.theoryKnowledge),
              icon: Assets.icons.dataSet,
              title: cardThirdTitle,
              subtitle: cardThirdSubtitle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorName.crystalBlue, ColorName.brightAqua],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
