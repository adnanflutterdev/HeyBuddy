import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/get_text_style.dart';

extension TextThemeExtention on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  GetTextStyle get style => GetTextStyle(
    heading: textTheme.headlineLarge!,
    h1: textTheme.titleLarge!,
    h2: textTheme.titleMedium!,
    h3: textTheme.titleSmall!,
    b1: textTheme.bodyLarge!,
    b2: textTheme.bodyMedium!,
    b3: textTheme.bodySmall!,
    bs1: textTheme.labelLarge!,
    bs2: textTheme.labelMedium!,
    bs3: textTheme.labelSmall!,
  );
}
