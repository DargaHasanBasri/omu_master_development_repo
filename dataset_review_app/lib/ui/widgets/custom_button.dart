import 'export.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.title,
    required this.onTap,
  });

  final String? title;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      child: InkWell(
        onTap: () => onTap.call(),
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorName.blueLotus,
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
          ),
          child: Padding(
            padding: AppPaddings.largeVertical,
            child: Text(
              "${title ?? '${LocaleKeys.buttonTitle_getStarted.locale}'}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: ColorName.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
