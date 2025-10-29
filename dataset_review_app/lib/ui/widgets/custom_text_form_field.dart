import 'export.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.backgroundColor = ColorName.white,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = '',
    this.hintTextStyle,
    this.borderRadius = 10,
    this.focusedBorderColor = ColorName.lavenderMist,
    this.errorBorderColor = ColorName.redOrange,
    this.textFormTitle,
    this.textFormHeight = 40,
    this.textFormWidth,
    this.textEditingController,
    this.inputType,
    this.textInputAction,
    this.isHaveObscure,
    this.isAutoTrue,
  });

  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final double? borderRadius;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final String? textFormTitle;
  final double? textFormHeight;
  final double? textFormWidth;
  final TextEditingController? textEditingController;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final bool? isHaveObscure;
  final bool? isAutoTrue;

  @override
  Widget build(BuildContext context) {
    return textFormTitle != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppPaddings.smallBottom,
                child: Text(
                  textFormTitle!,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              _buildTextFormField(context),
            ],
          )
        : _buildTextFormField(context);
  }

  Widget _buildTextFormField(BuildContext context) {
    return SizedBox(
      width: textFormWidth,
      height: textFormHeight,
      child: TextFormField(
        cursorColor: ColorName.black,
        controller: textEditingController,
        obscureText: isHaveObscure ?? false,
        autofocus: isAutoTrue ?? false,
        keyboardType: inputType,
        textInputAction: textInputAction,
        style: Theme.of(context).textTheme.labelSmall,
        decoration: InputDecoration(
          contentPadding: _contentPadding(),
          filled: true,
          fillColor: backgroundColor,
          prefixIcon: prefixIcon,
          suffixIcon: Padding(
            padding:
                AppPaddings.smallRight +
                AppPaddings.xSmallVertical +
                AppPaddings.xSmallLeft,
            child: suffixIcon,
          ),
          hintText: hintText,
          hintStyle: _defaultHintTextStyle(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: ColorName.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: focusedBorderColor!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: errorBorderColor!),
          ),
        ),
      ),
    );
  }

  TextStyle? _defaultHintTextStyle(BuildContext context) {
    final defaultHintTextStyle = hintTextStyle == null
        ? Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(
            color: ColorName.boulder,
          )
        : hintTextStyle;
    return defaultHintTextStyle;
  }

  EdgeInsetsGeometry _contentPadding() {
    final isHaveIcon = prefixIcon != null;

    final contentPadding = isHaveIcon
        ? AppPaddings.xXSmallVertical
        : AppPaddings.xSmallVertical +
              AppPaddings.mediumLeft +
              AppPaddings.xSmallRight;

    return contentPadding;
  }
}
