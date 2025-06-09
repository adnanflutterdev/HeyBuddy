import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:stroke_text/stroke_text.dart';

Widget coloredText({required text1, required text2, required double fontSize}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      StrokeText(
        text: text1,
        overflow: TextOverflow.ellipsis,
        textStyle: jotiOne(color: const Color(0xff00C2FF), fontSize: fontSize),
      ),
      StrokeText(
        text: text2,
        overflow: TextOverflow.ellipsis,
        textStyle: jotiOne(
          color: const Color(0xff61FF00),
          fontSize: fontSize,
        ),
      )
    ],
  );
}
