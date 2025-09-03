import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class LoadThemeModeUseCase {
  final SettingsRepository repository;

  LoadThemeModeUseCase(this.repository);

  ThemeMode call() {
    return repository.loadThemeMode();
  }
}
