import 'package:flutter/material.dart';
import 'package:hey_buddy/config/theme/app_color_scheme.dart';
import 'package:hey_buddy/config/theme/text_theme.dart';
import 'package:hey_buddy/core/const/app_colors.dart';
import 'package:hey_buddy/core/const/outlined_border.dart';

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
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      errorBorder: outlinedBorder(color: AppLightColors.error),
      prefixIconColor: AppLightColors.neonGreen,
      suffixIconColor: AppLightColors.neonGreen,
      fillColor: AppLightColors.card,
      focusedErrorBorder: outlinedBorder(color: AppLightColors.error),
      enabledBorder: outlinedBorder(color: AppLightColors.bg),
      focusedBorder: outlinedBorder(color: AppLightColors.neonBlue, width: 1),
      hintStyle: textTheme.bodySmall?.copyWith(
        color: AppLightColors.secondaryText,
      ),
    ),
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
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      errorBorder: outlinedBorder(color: AppDarkColors.error),
      prefixIconColor: AppDarkColors.neonGreen,
      suffixIconColor: AppDarkColors.neonGreen,
      fillColor: AppDarkColors.card,
      focusedErrorBorder: outlinedBorder(color: AppDarkColors.error),
      enabledBorder: outlinedBorder(color: AppDarkColors.bg),
      focusedBorder: outlinedBorder(color: AppDarkColors.neonBlue, width: 1),
      hintStyle: textTheme.bodySmall?.copyWith(
        color: AppDarkColors.secondaryText,
      ),
    ),
  );
}
