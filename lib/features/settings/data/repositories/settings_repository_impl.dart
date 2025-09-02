import 'package:easy_box/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(_themeModeKey, themeMode.index);
  }

  @override
  ThemeMode loadThemeMode() {
    final themeIndex = _prefs.getInt(_themeModeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  @override
  Locale loadLocale() {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode == null) return const Locale('ru'); // Default to Russian
    return Locale(languageCode);
  }
}
