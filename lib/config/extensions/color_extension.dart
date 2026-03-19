import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/get_color.dart';

extension ColorExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  GetColor get colors => GetColor(
    neonBlue: colorScheme.primary,
    neonGreen: colorScheme.secondary,
    bg: colorScheme.surface,
    card: colorScheme.surfaceContainerLow,
    appbar: colorScheme.surfaceContainerHigh,
    container: colorScheme.surfaceContainerLowest,
    navbar: colorScheme.onPrimaryFixed,
    border: colorScheme.outline,
    divider: colorScheme.surfaceTint,
    shadow: colorScheme.shadow,
    disabledBg: colorScheme.surfaceDim,
    overlay: colorScheme.surfaceContainerHighest,
    primaryText: colorScheme.onSurface,
    secondaryText: colorScheme.onSurfaceVariant,
    tertiaryText: colorScheme.onInverseSurface,
    disabledText: colorScheme.inverseSurface,
    error: colorScheme.error,
    onError: colorScheme.onError,
    success: colorScheme.onSecondaryContainer,
    onSuccess: colorScheme.onSecondary,
    neutral: colorScheme.onPrimaryContainer,
    onNeutral: colorScheme.onPrimary,
  );
}
