import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class SaveThemeModeUseCase {
  final SettingsRepository repository;

  SaveThemeModeUseCase(this.repository);

  Future<void> call(ThemeMode themeMode) {
    return repository.saveThemeMode(themeMode);
  }
}
