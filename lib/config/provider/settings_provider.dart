import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

class SettingsNotifier extends StateNotifier<void> {
  SettingsNotifier() : super(null);

  Future<String> getAppTheme() async {
    Box settings = await Hive.openBox('Settings');

    String? appThemeMode = await settings.get('appThemeMode');
    return appThemeMode ?? ThemeMode.system.name;
  }

  Future<void> setAppTheme(ThemeMode appThemeMode) async {
    Box settings = await Hive.openBox('Settings');

    await settings.put('appThemeMode', appThemeMode.name);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, void>(
  (rer) => SettingsNotifier(),
);
