import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

@immutable
class GetColor {
  final Color neonBlue;
  final Color neonGreen;

  // Backgrounds
  final Color bg;
  final Color card;
  final Color appbar;
  final Color container;
  final Color navbar;

  // Structural Colors
  final Color divider;
  final Color border;
  final Color shadow;

  final Color disabledBg;
  final Color overlay;

  // Text Colors
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color disabledText;

  // Status Colors
  final Color error;
  final Color onError;

  final Color success;
  final Color onSuccess;

  final Color neutral;
  final Color onNeutral;

  const GetColor({
    required this.neonBlue,
    required this.neonGreen,
    required this.bg,
    required this.card,
    required this.appbar,
    required this.container,
    required this.navbar,
    required this.divider,
    required this.border,
    required this.shadow,
    required this.disabledBg,
    required this.overlay,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.disabledText,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,
    required this.neutral,
    required this.onNeutral,
  });
}
