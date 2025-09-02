import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  const SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';

  // Theme
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(_themeModeKey, themeMode.index);
  }

  ThemeMode loadThemeMode() {
    final themeIndex = _prefs.getInt(_themeModeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  // Locale
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  Locale loadLocale() {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode == null) return const Locale('ru'); // Default to Russian
    return Locale(languageCode);
  }
}
