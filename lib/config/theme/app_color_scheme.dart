import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_colors.dart';

class AppColorScheme {
  AppColorScheme._();

  static ColorScheme light = const ColorScheme(
    brightness: .light,
    // Brand Colors
    primary: AppLightColors.neonBlue,
    secondary: AppLightColors.neonGreen,

    // Backgrounds
    surface: AppLightColors.bg,
    surfaceContainerHigh: AppLightColors.appbar,
    surfaceContainerLow: AppLightColors.card,
    surfaceContainerLowest: AppLightColors.container,

    // Structural Colors
    outline: AppLightColors.border,
    surfaceTint: AppLightColors.divider,
    shadow: AppLightColors.shadow,

    surfaceContainerHighest: AppLightColors.overlay,
    surfaceDim: AppLightColors.disabledBg,

    // Text Colors
    onSurface: AppLightColors.primaryText,
    onSurfaceVariant: AppLightColors.secondaryText,
    onInverseSurface: AppLightColors.tertiaryText,
    inverseSurface: AppLightColors.disabledText,

    // Status Colors
    error: AppLightColors.error,
    onError: AppLightColors.onError,

    onSecondaryContainer: AppLightColors.success,
    onSecondary: AppLightColors.onSuccess,

    onPrimaryContainer: AppLightColors.neutral,
    onPrimary: AppLightColors.onNeutral,
  );

  static ColorScheme dark = const ColorScheme(
    brightness: .dark,
    // Brand Colors
    primary: AppDarkColors.neonBlue,
    secondary: AppDarkColors.neonGreen,

    // Backgrounds
    surface: AppDarkColors.bg,
    surfaceContainerHigh: AppDarkColors.appbar,
    surfaceContainerLow: AppDarkColors.card,
    surfaceContainerLowest: AppDarkColors.container,

    // Structural Colors
    outline: AppDarkColors.border,
    surfaceTint: AppDarkColors.divider,
    shadow: AppDarkColors.shadow,

    surfaceContainerHighest: AppDarkColors.overlay,
    surfaceDim: AppDarkColors.disabledBg,

    // Text Colors
    onSurface: AppDarkColors.primaryText,
    onSurfaceVariant: AppDarkColors.secondaryText,
    onInverseSurface: AppDarkColors.tertiaryText,
    inverseSurface: AppDarkColors.disabledText,

    // Status Colors
    error: AppDarkColors.error,
    onError: AppDarkColors.onError,

    onSecondaryContainer: AppDarkColors.success,
    onSecondary: AppDarkColors.onSuccess,

    onPrimaryContainer: AppDarkColors.neutral,
    onPrimary: AppDarkColors.onNeutral,
  );
}
