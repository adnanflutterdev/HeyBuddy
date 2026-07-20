import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onSuffixIconTapped,
    this.textInputType,
    this.textStyle,
    this.iconWidth,
    this.onChanged,
    this.focusNode,
    this.isObscure = false,
    this.isReadOnly = false,
    this.isSuffixIconLoading = false,
    this.unfocusOnTapOutside = false,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.onTap,
    this.secondaryLabel,
    this.showOptional = false,
    this.textInputAction,
    this.iconSize = 20,
    this.iconColor,
    this.disableBorder = false,
    this.validator,
    this.maxLengths,
    this.forceErrorText,
  });
  final String? label;
  final double iconSize;
  final Color? iconColor;
  final bool isObscure;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isSuffixIconLoading;
  final VoidCallback? onSuffixIconTapped;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final double? iconWidth;
  final TextStyle? textStyle;
  final Function(String value)? onChanged;
  final Function(String? value)? onSubmitted;
  final FocusNode? focusNode;
  final bool isReadOnly;
  final bool unfocusOnTapOutside;
  final int? maxLines;
  final int? minLines;
  final int? maxLengths;
  final VoidCallback? onTap;
  final Widget? secondaryLabel;
  final bool showOptional;
  final TextInputAction? textInputAction;
  final bool disableBorder;
  final FormFieldValidator<String>? validator;
  final String? forceErrorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(label!, style: context.style.b3),
              if (showOptional)
                Text(
                  ' (Optional)',
                  style: context.style.bs2.copyWith(
                    color: context.colors.secondaryText,
                  ),
                ),
              const Spacer(),
              ?secondaryLabel,
            ],
          ),
          AppSpacing.h8,
        ],
        TextFormField(
          maxLines: maxLines,
          minLines: minLines,
          focusNode: focusNode,
          readOnly: isReadOnly,
          textInputAction: textInputAction,
          controller: controller,
          keyboardType: textInputType,
          obscureText: isObscure,
          obscuringCharacter: '●',
          style: textStyle ?? context.style.b2,
          maxLength: maxLengths,

          decoration: InputDecoration(
            hintText: hintText,
            prefixIconConstraints: BoxConstraints(
              maxWidth:
                  iconWidth ?? (prefixIcon != null ? (iconSize + 20) : 16),
            ),
            suffixIconConstraints: BoxConstraints(
              maxWidth:
                  iconWidth ?? (suffixIcon != null ? (iconSize + 20) : 16),
            ),
            prefixIcon: IconButton(
              onPressed: () {},
              icon: Icon(prefixIcon, size: iconSize, color: iconColor),
            ),
            suffixIcon: isSuffixIconLoading
                ? const CircularProgressIndicator()
                : IconButton(
                    onPressed: onSuffixIconTapped,
                    icon: Icon(suffixIcon, size: iconSize, color: iconColor),
                  ),
          ),

          forceErrorText: forceErrorText,
          errorBuilder: (context, errorText) {
            return Text(
              errorText,
              style: context.style.bs2.copyWith(color: context.colors.error),
            );
          },

          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          onTapOutside: (event) {
            if (unfocusOnTapOutside) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }
}
