import 'package:flutter/material.dart';

TextStyle jotiOne({required color, required double fontSize}) {
  return TextStyle(fontFamily: 'JotiOne', fontSize: fontSize, color: color,overflow: TextOverflow.ellipsis);
}

TextStyle roboto(
    {required double fontSize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    Color bgColor = Colors.transparent}) {
  return TextStyle(
      fontFamily: 'Roboto',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      backgroundColor: bgColor,
      overflow: TextOverflow.ellipsis
      );
}
