import 'package:flutter/material.dart';

OutlineInputBorder outlinedBorder({required Color color, double width = 0.5}) =>
    OutlineInputBorder(
      borderRadius: .circular(12),
      borderSide: BorderSide(width: width, color: color),
    );
