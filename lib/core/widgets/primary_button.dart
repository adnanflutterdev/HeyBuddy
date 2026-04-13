import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,

    this.icon,
    this.style,
    this.width,
    this.height,
    this.iconSize,
    this.progress,
    this.backgroundColor,
    this.foregroundColor,
    this.buildFull = false,
    this.isLoading = false,
    this.alignment = .start,
  });
  final Function()? onPressed;
  final String label;

  final IconData? icon;
  final double? width;
  final double? height;
  final bool buildFull;
  final bool isLoading;
  final double? progress;
  final double? iconSize;
  final TextStyle? style;
  final IconAlignment alignment;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (buildFull ? double.infinity : null),
      height: height,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        label: StrokeText(
          text: (isLoading && progress != null && progress! < 100)
              ? '${progress!.toStringAsFixed(2)} %'
              : label,
          style:
              style ??
              context.style.h1.copyWith(
                color: foregroundColor ?? context.colors.neonGreen,
                fontFamily: 'Joti',
              ),
        ),

        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: (progress != null && progress! > 0)
                      ? (progress! / 100)
                      : null,
                  color: context.colors.neonGreen,
                ),
              )
            : (icon != null)
            ? Icon(icon)
            : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colors.neonBlue,
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
          padding: AppPadding.symmetric(12, 6),
          iconAlignment: alignment,
          iconSize: iconSize,
          iconColor: foregroundColor ?? context.colors.neonGreen,
          disabledBackgroundColor: context.colors.neonBlue.withValues(
            alpha: 0.5,
          ),
        ),
      ),
    );
  }
}
