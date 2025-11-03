import '../export.dart';

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final AssetGenImage icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: CircleBorder(),
        splashColor: ColorName.blueLotus.withValues(
          alpha: 0.3,
        ),
        onTap: () => onTap.call(),
        child: Ink(
          padding: AppPaddings.smallAll,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: icon.image(
            package: 'gen',
            color: ColorName.white,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}
