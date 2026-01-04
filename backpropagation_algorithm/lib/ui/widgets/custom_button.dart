import 'package:backpropagation_algorithm/export.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.backgroundColor,
    super.key,
    this.onTapButton,
    this.title,
    this.icon,
    this.borderRadius,
  });

  final VoidCallback? onTapButton;
  final String? title;
  final List<Color> backgroundColor;
  final Image? icon;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTapButton == null;

    return Opacity(
      opacity: isDisabled ? 0.55 : 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            onTap: onTapButton, // ✅ null olunca disable olur
            child: Ink(
              padding: AppPaddings.smallAll + AppPaddings.smallHorizontal,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: backgroundColor,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
                boxShadow: [
                  BoxShadow(
                    color: ColorName.warmBlue.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: _titleOrIcon(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleOrIcon(BuildContext context) {
    final isHaveTitle = title != null;
    return isHaveTitle
        ? Text(
            title ?? '',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: ColorName.white),
            textAlign: TextAlign.center,
          )
        : icon ??
              const Icon(
                Icons.lock_reset,
                color: ColorName.white,
              );
  }
}
