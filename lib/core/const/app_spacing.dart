import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();
  // Vertical gaps
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h30 = SizedBox(height: 30);
  static const SizedBox h40 = SizedBox(height: 40);
  static const SizedBox h50 = SizedBox(height: 50);

  // Horizontal gaps
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w20 = SizedBox(width: 20);
  static const SizedBox w30 = SizedBox(width: 30);
  static const SizedBox w40 = SizedBox(width: 40);

  // Zero gap (useful in conditions)
  static const SizedBox zero = SizedBox.shrink();
}
