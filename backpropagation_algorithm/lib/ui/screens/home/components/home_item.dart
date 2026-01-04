import 'package:backpropagation_algorithm/ui/screens/home/export.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
    required this.subTitle,
    required this.title,
    super.key,
  });

  final String title;
  final String subTitle;
  final Image icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap.call,
          child: Ink(
            padding: AppPaddings.largeAll,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  color: ColorName.black.withValues(alpha: 0.1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                icon,
                Text(
                  title,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(
                        color: ColorName.white,
                      ),
                ),
                Text(
                  subTitle,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(
                        color: ColorName.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
