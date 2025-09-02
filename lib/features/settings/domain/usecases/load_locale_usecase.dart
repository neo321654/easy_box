import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class LoadLocaleUseCase {
  final SettingsRepository repository;

  LoadLocaleUseCase(this.repository);

  Locale call() {
    return repository.loadLocale();
  }
}
