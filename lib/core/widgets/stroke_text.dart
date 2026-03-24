import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  const StrokeText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5
              ..color = Colors.black,
          ),
        ),
        Text(text, style: style),
      ],
    );
  }
}
