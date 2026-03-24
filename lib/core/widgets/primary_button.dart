import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,

    this.icon,
    this.style,
    this.iconSize,
    this.isLoading = false,
    this.alignment = .start,
  });
  final Function()? onPressed;
  final String label;

  final IconData? icon;
  final bool isLoading;
  final double? iconSize;
  final TextStyle? style;
  final IconAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      label: StrokeText(
        text: label,
        style:
            style ??
            context.style.h1.copyWith(
              color: context.colors.neonGreen,
              fontFamily: 'Joti',
            ),
      ),

      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: context.colors.neonGreen),
            )
          : (icon != null)
          ? Icon(icon)
          : null,

      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.neonBlue,
        shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        iconAlignment: alignment,
        iconSize: iconSize,
        disabledBackgroundColor: context.colors.neonBlue,
      ),
    );
  }
}
