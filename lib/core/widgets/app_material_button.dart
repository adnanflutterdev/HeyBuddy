import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';

class AppMeterialButton extends StatelessWidget {
  const AppMeterialButton({
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
    this.iconSize = 18,
    this.iconAlignment = .start,
    this.borderRadius = 20,
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
  final double? iconSize;
  final IconAlignment iconAlignment;
  final double borderRadius;

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

    ShapeBorder? getBorder = (hasCircularBorder || text == null)
        ? CircleBorder(
            side: BorderSide(
              color: isTransparent ? Colors.transparent : colors.border,
            ),
          )
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          );
    return Material(
      color: isTransparent ? Colors.transparent : colors.bg,
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
