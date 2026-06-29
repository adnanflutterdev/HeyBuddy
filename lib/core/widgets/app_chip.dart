import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.radius,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.strokeWidth = 0,
  });
  final String label;
  final IconData? icon;
  final double? radius;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 12),
      side: BorderSide(color: foregroundColor ?? context.colors.tertiaryText),
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
                child: StrokeText(
                  text: label,
                  strokeWidth: strokeWidth,
                  style: context.style.b3.copyWith(color: foregroundColor),
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
