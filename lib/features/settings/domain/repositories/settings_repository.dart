import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> saveThemeMode(ThemeMode themeMode);
  ThemeMode loadThemeMode();
  Future<void> saveLocale(Locale locale);
  Locale? loadLocale();
}
