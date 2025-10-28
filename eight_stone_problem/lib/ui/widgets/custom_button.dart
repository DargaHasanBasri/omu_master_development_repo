import 'package:eight_stone_problem/utils/constants/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTapButton,
    this.title,
    this.backgroundColor,
    this.icon,
    this.borderRadius,
  });

  final VoidCallback onTapButton;
  final String? title;
  final Color? backgroundColor;
  final Image? icon;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        onTap: () => onTapButton.call(),
        child: Ink(
          padding: AppPaddings.smallAll,
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorName.tuna,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: _titleOrIcon(context),
        ),
      ),
    );
  }

  Widget _titleOrIcon(BuildContext context) {
    final bool isHaveTitle = title != null;
    return isHaveTitle
        ? Text(
            title ?? '',
            style:
                Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(
                  color: ColorName.white,
                ),
            textAlign: TextAlign.center,
          )
        : icon ??
              Icon(
                Icons.lock_reset,
                color: ColorName.white,
              );
  }
}
