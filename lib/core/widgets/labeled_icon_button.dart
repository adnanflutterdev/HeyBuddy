import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';

class LabeledIconButton extends StatelessWidget {
  const LabeledIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });
  final Function() onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: .min,
        spacing: 4,
        children: [
          Container(
            decoration: BoxDecoration(shape: .circle, color: context.colors.bg),
            padding: AppPadding.p8,
            child: Icon(icon, size: 30),
          ),
          Text(label, style: context.style.h3),
        ],
      ),
    );
  }
}
