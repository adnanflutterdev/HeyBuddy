import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';

class StrokeText extends StatelessWidget {
  const StrokeText({
    super.key,
    required this.text,
    this.style,
    this.strokeWidth = 1.5,
    this.overflow = .visible,
  });
  final String text;
  final TextStyle? style;
  final double strokeWidth;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: (style ?? context.style.b2).copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(text, style: style ?? context.style.b2),
      ],
    );
  }
}
