import 'package:flutter/material.dart';
import 'package:hey_buddy/config/theme/app_color_scheme.dart';
import 'package:hey_buddy/config/theme/text_theme.dart';
import 'package:hey_buddy/core/const/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarThemeData(
      elevation: 0,
      backgroundColor: AppLightColors.appbar,
      iconTheme: IconThemeData(color: AppLightColors.neonGreen, size: 25),
    ),
    colorScheme: AppColorScheme.light,
    cardColor: AppLightColors.container,
    scaffoldBackgroundColor: AppLightColors.bg,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarThemeData(
      elevation: 0,
      iconTheme: IconThemeData(color: AppDarkColors.neonGreen, size: 25),
      backgroundColor: AppDarkColors.appbar,
    ),
    colorScheme: AppColorScheme.dark,
    cardColor: AppDarkColors.container,
    scaffoldBackgroundColor: AppDarkColors.bg,
  );
}
