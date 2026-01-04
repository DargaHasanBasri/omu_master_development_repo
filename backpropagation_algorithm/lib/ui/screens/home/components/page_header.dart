import 'package:backpropagation_algorithm/ui/screens/home/export.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.largeAll,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        gradient: LinearGradient(
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
          colors: [
            ColorName.warmBlue.withValues(alpha: 0.9),
            ColorName.blueViolet.withValues(alpha: 0.8),
            ColorName.raspberryPink.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        spacing: 36,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPaddings.mediumTop,
            child: Row(
              children: [
                Text(
                  'Neural Trainer',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: ColorName.white),
                ),
              ],
            ),
          ),
          Text(
            'Geriye Yayılım ile Sinir Ağı Eğitimi',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: ColorName.white),
          ),
        ],
      ),
    );
  }
}
