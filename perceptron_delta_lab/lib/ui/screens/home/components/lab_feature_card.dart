import '../../../../export.dart';

class LabFeatureCard extends StatelessWidget {
  const LabFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [ColorName.cornflower, ColorName.darkLavender],
    ),
    this.radius = 20,
  });

  final String title;
  final String subtitle;
  final AssetGenImage icon;
  final VoidCallback onTap;
  final Gradient gradient;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.largeAll,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 12,
                children: [
                  Container(
                    padding: AppPaddings.mediumAll,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: icon.image(
                      package: AppConstants.packageName,
                      scale: 0.8,
                    ),
                  ),
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onTap.call(),
                  splashColor: ColorName.darkLavender.withValues(alpha: 0.3),
                  child: Ink(
                    padding: AppPaddings.xSmallAll,
                    child: Assets.icons.icTap.image(
                      package: AppConstants.packageName,
                      color: ColorName.darkLavender,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorName.monsoon,
            ),
          ),
        ],
      ),
    );
  }
}
