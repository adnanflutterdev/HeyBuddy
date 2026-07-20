import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';

class AppMaterialButton extends StatelessWidget {
  const AppMaterialButton({
    super.key,
    this.style,
    this.padding,
    this.onPressed,
    this.onTapDown,
    this.text,
    this.hasCircularBorder = false,
    this.isTransparent = false,
    this.icon,
    this.iconColor,
    this.bgColor,
    this.iconSize = 18,
    this.iconAlignment = .start,
    this.borderRadius = 20,
    this.borderColor,
  });
  final VoidCallback? onPressed;
  final Function(TapDownDetails details)? onTapDown;
  final String? text;
  final TextStyle? style;
  final bool isTransparent;
  final EdgeInsets? padding;
  final bool hasCircularBorder;
  final IconData? icon;
  final Color? iconColor;
  final Color? bgColor;
  final double? iconSize;
  final IconAlignment iconAlignment;
  final double borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final GetColor colors = context.colors;
    List<Widget> children = [
      if (icon != null && iconAlignment == .start) ...[
        Icon(icon, color: iconColor, size: iconSize),
        if (text != null) AppSpacing.w8,
      ],

      if (text != null) Text(text!, style: style ?? context.style.b2),

      if (icon != null && iconAlignment == .end) ...[
        if (text != null) AppSpacing.w8,
        Icon(icon, color: iconColor, size: iconSize),
      ],
    ];

    Color colorOfBorder = isTransparent
        ? Colors.transparent
        : (borderColor ?? colors.border);

    Color colorOfBG = isTransparent
        ? Colors.transparent
        : (bgColor ?? colors.bg);

    ShapeBorder? getBorder = (hasCircularBorder || text == null)
        ? CircleBorder(side: BorderSide(color: colorOfBorder))
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: colorOfBorder),
          );
    return Material(
      color: colorOfBG,
      shape: getBorder,
      child: InkWell(
        onTap: onPressed,
        onTapDown: onTapDown,
        customBorder: getBorder,
        splashColor: isTransparent ? colors.bg : colors.disabledText,
        child: Padding(
          padding: padding ?? AppPadding.symmetric(text == null ? 8 : 12, 8),
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: children,
          ),
        ),
      ),
    );
  }
}
