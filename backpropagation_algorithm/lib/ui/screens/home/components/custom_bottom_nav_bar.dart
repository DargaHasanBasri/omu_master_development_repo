import 'package:backpropagation_algorithm/ui/screens/home/export.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.smallVertical,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: AppPaddings.mediumHorizontal,
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: _buildNavBarItem(
                context,
                'Ana Sayfa',
                () {},
              ),
            ),
            Expanded(
              child: _buildNavBarItem(
                context,
                'Veri',
                () {},
              ),
            ),
            Expanded(
              child: _buildNavBarItem(
                context,
                'Eğit',
                () {},
              ),
            ),
            Expanded(
              child: _buildNavBarItem(
                context,
                'Sonuçlar',
                () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap.call(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: AppPaddings.smallAll,
            decoration: BoxDecoration(
              color: ColorName.warmBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              spacing: 2,
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.icHome.image(package: AppConstants.packageName),
                Text(
                  title,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(
                        color: ColorName.warmBlue,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
