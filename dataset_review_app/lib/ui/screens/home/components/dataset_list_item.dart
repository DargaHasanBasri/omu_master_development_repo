import '../export.dart';

class DatasetListItem extends StatelessWidget {
  const DatasetListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Container(
              padding: AppPaddings.mediumAll,
              decoration: BoxDecoration(
                color: ColorName.lavenderMist,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Assets.icons.icDataset.image(
                        package: AppConstants.packageName,
                        height: 24,
                      ),
                      Text(
                        'Internal storage',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: ColorName.blueLotus,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: AppPaddings.mediumVertical,
                    child: LinearProgressBar(
                      progressType: LinearProgressBar.progressTypeLinear,
                      backgroundColor: ColorName.blueLotus.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      progressColor: ColorName.blueLotus,
                      currentStep: 500,
                      maxSteps: 2000,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '64.4 ${AppConstants.gb} ${LocaleKeys.homeScreen_of.locale} 128 ${AppConstants.gb}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ColorName.blueLotus,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Explore',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: ColorName.blueLotus,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: AppPaddings.xXSmallRight + AppPaddings.xSmallTop,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    splashColor: ColorName.blueLotus.withValues(
                      alpha: 0.3,
                    ),
                    child: Ink(
                      padding: AppPaddings.xSmallAll,
                      child: Assets.icons.icTap.image(
                        package: AppConstants.packageName,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
