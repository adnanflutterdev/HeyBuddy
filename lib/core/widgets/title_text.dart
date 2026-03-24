import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.text, this.fontSize});
  final (String, String) text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..color = Colors.black,
            ),
            children: [
              TextSpan(
                text: text.$1,
                style: context.style.h1.copyWith(fontSize: fontSize),
              ),
              TextSpan(
                text: text.$2,
                style: context.style.h1.copyWith(fontSize: fontSize),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text.$1,
                style: context.style.h1.copyWith(
                  color: context.colors.neonBlue,
                  fontSize: fontSize,
                ),
              ),
              TextSpan(
                text: text.$2,
                style: context.style.h1.copyWith(
                  color: context.colors.neonGreen,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
