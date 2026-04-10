import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.radius,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
  final String label;
  final IconData? icon;
  final double? radius;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 12),
      side: BorderSide(color: context.colors.tertiaryText),
    );
    return Material(
      color: backgroundColor ?? context.colors.bg,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        splashColor: context.colors.disabledText,
        child: Padding(
          padding: AppPadding.symmetric(12, 8),
          child: Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: context.style.bs1.copyWith(color: foregroundColor),
                ),
              ),
              if (icon != null) Icon(icon, size: 18, color: foregroundColor),
            ],
          ),
        ),
      ),
    );
  }
}
