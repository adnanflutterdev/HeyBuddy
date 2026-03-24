import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/get_color.dart';

extension ColorExtension on BuildContext {
  ColorScheme get _colorScheme => Theme.of(this).colorScheme;

  GetColor get colors => GetColor(
    neonBlue: _colorScheme.primary,
    neonGreen: _colorScheme.secondary,
    bg: _colorScheme.surface,
    card: _colorScheme.surfaceContainerLow,
    appbar: _colorScheme.surfaceContainerHigh,
    container: _colorScheme.surfaceContainerLowest,
    navbar: _colorScheme.onPrimaryFixed,
    border: _colorScheme.outline,
    divider: _colorScheme.surfaceTint,
    shadow: _colorScheme.shadow,
    disabledBg: _colorScheme.surfaceDim,
    overlay: _colorScheme.surfaceContainerHighest,
    primaryText: _colorScheme.onSurface,
    secondaryText: _colorScheme.onSurfaceVariant,
    tertiaryText: _colorScheme.onInverseSurface,
    disabledText: _colorScheme.inverseSurface,
    error: _colorScheme.error,
    onError: _colorScheme.onError,
    success: _colorScheme.onSecondaryContainer,
    onSuccess: _colorScheme.onSecondary,
    neutral: _colorScheme.onPrimaryContainer,
    onNeutral: _colorScheme.onPrimary,
  );
}
