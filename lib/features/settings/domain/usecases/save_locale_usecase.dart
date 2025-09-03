import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class SaveLocaleUseCase {
  final SettingsRepository repository;

  SaveLocaleUseCase(this.repository);

  Future<void> call(Locale locale) {
    return repository.saveLocale(locale);
  }
}
