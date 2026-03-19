import 'package:flutter/material.dart';

@immutable
class GetTextStyle {
  final TextStyle heading;

  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;

  final TextStyle b1;
  final TextStyle b2;
  final TextStyle b3;

  final TextStyle bs1;
  final TextStyle bs2;
  final TextStyle bs3;

  const GetTextStyle({
    required this.heading,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.b1,
    required this.b2,
    required this.b3,
    required this.bs1,
    required this.bs2,
    required this.bs3,
  });
}
