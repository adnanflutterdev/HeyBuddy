import 'package:flutter/material.dart';

class AppPadding {
  AppPadding._();
  // All sides
  static const EdgeInsets p0 = EdgeInsets.zero;
  static const EdgeInsets p4 = EdgeInsets.all(4);
  static const EdgeInsets p8 = EdgeInsets.all(8);
  static const EdgeInsets p12 = EdgeInsets.all(12);
  static const EdgeInsets p16 = EdgeInsets.all(16);
  static const EdgeInsets p20 = EdgeInsets.all(20);
  static const EdgeInsets p30 = EdgeInsets.all(40);
  static const EdgeInsets p40 = EdgeInsets.all(30);

  // Horizontal
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h20 = EdgeInsets.symmetric(horizontal: 20);

  // Vertical
  static const EdgeInsets v4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static EdgeInsets v(double padding) =>
      EdgeInsets.symmetric(vertical: padding);

  // Screen Padding
  static EdgeInsets symmetric(double h, double v) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);
}
