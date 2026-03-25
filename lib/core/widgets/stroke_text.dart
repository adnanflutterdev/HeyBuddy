import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  const StrokeText({
    super.key,
    required this.text,
    required this.style,
    this.strokeWidth = 1.5,
  });
  final String text;
  final TextStyle style;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = Colors.black,
          ),
        ),
        Text(text, style: style),
      ],
    );
  }
}
