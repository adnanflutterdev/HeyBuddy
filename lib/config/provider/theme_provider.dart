import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/config/provider/settings_provider.dart';

extension ThemeModeX on ThemeMode {
  static ThemeMode getThemeMode(String appThemeMode) {
    return ThemeMode.values.firstWhere((mode) => mode.name == appThemeMode);
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode?> {
  final SettingsNotifier settings;
  ThemeNotifier(this.settings) : super(null) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    String appThemeMode = await settings.getAppTheme();
    state = ThemeModeX.getThemeMode(appThemeMode);
  }

  void changeTheme(ThemeMode themeMode) {
    state = themeMode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode?>((ref) {
  final settings = ref.read(settingsProvider.notifier);
  return ThemeNotifier(settings);
});
