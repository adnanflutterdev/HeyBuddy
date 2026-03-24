import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_colors.dart';

TextTheme textTheme = const TextTheme(
  // Headings
  // For Big Headings
  headlineLarge: TextStyle(
    fontSize: 30,
    letterSpacing: 2,
    fontFamily: 'Joti',
    color: AppDarkColors.neonBlue,
  ),

  // For AppBar Titles
  titleLarge: TextStyle(fontSize: 24, letterSpacing: 2, fontFamily: 'Joti'),

  // For Body Headings
  titleMedium: TextStyle(
    fontSize: 18,
    letterSpacing: 2,
    fontFamily: 'PoppinsBold',
  ),

  // For Body Sub Headings
  titleSmall: TextStyle(
    fontSize: 16,
    letterSpacing: 2,
    fontFamily: 'PoppinsBold',
  ),

  // Body
  // List tile titles, body big text etc
  bodyLarge: TextStyle(fontSize: 14, fontFamily: 'PoppinsBold'),

  // Medium body text
  bodyMedium: TextStyle(fontSize: 14, fontWeight: .w500),

  // Normal body text
  bodySmall: TextStyle(fontSize: 14),

  // Body Small texts
  //
  labelLarge: TextStyle(fontSize: 12, fontWeight: .w600),
  labelMedium: TextStyle(fontSize: 12),
  labelSmall: TextStyle(fontSize: 10),
);

/*
import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_colors.dart';

TextTheme textTheme(Color defaultColor) => TextTheme(
  // Headings
  // For Big Headings
  headlineLarge: const TextStyle(
    fontSize: 30,
    letterSpacing: 2,
    fontFamily: 'Joti',
    color: AppDarkColors.neonBlue,
  ),

  // For AppBar Titles
  titleLarge: TextStyle(
    fontSize: 22,
    letterSpacing: 2,
    fontFamily: 'PoppinsBold',
    color: defaultColor,
  ),

  // For Body Headings
  titleMedium: TextStyle(
    fontSize: 18,
    letterSpacing: 2,
    fontFamily: 'PoppinsBold',
    color: defaultColor,
  ),

  // For Body Sub Headings
  titleSmall: TextStyle(
    fontSize: 16,
    letterSpacing: 2,
    fontFamily: 'PoppinsBold',
    color: defaultColor,
  ),

  // Body
  // List tile titles, body big text etc
  bodyLarge: TextStyle(
    fontSize: 14,
    fontFamily: 'PoppinsBold',
    color: defaultColor,
  ),

  // Medium body text
  bodyMedium: TextStyle(fontSize: 14, fontWeight: .w600, color: defaultColor),

  // Normal body text
  bodySmall: TextStyle(fontSize: 14, color: defaultColor),

  // Body Small texts
  //
  labelLarge: TextStyle(fontSize: 12, fontWeight: .w600, color: defaultColor),
  labelMedium: TextStyle(fontSize: 12, color: defaultColor),
  labelSmall: TextStyle(fontSize: 10, color: defaultColor),
);
*/
