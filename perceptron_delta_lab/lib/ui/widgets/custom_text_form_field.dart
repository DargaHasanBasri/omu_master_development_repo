import '../../export.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.backgroundColor = ColorName.whiteLilac,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = '',
    this.hintTextStyle,
    this.borderRadius = 8,
    this.focusedBorderColor = ColorName.darkLavender,
    this.errorBorderColor = ColorName.beanRed,
    this.textFormTitle,
    this.textFormHeight = 40,
    this.textFormWidth,
    this.textEditingController,
    this.inputType,
    this.textInputAction = TextInputAction.next,
    this.isHaveObscure,
    this.isAutoTrue,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.textAlignVertical = TextAlignVertical.center,
    this.onChanged,
    this.inputFormatters,
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
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

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
        keyboardType:
            inputType ??
            TextInputType.numberWithOptions(signed: false, decimal: false),
        textInputAction: textInputAction,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        style:
            textStyle ??
            Theme.of(context)
                .textTheme
                .labelLarge // görünür ve okunur bir boy
                ?.copyWith(color: ColorName.black),
        onChanged: onChanged,
        inputFormatters:
            inputFormatters ??
            [
              FilteringTextInputFormatter.allow(RegExp(r'[01]')),
              LengthLimitingTextInputFormatter(1),
            ],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          filled: true,
          fillColor: backgroundColor,
          prefixIcon: prefixIcon,
          // ÖNEMLİ: suffix null ise hiç vermeyelim, yer kaplamasın
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
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
            borderSide: const BorderSide(color: ColorName.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: ColorName.periwinkleGrey.withValues(alpha: 0.4),
            ),
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
    final defaultHintTextStyle =
        hintTextStyle ??
        Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: ColorName.periwinkleGrey);
    return defaultHintTextStyle;
  }
}
