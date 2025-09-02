// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Easy Box';

  @override
  String get loginPageTitle => 'Вход';

  @override
  String get loginEmailLabel => 'Электронная почта';

  @override
  String get loginPasswordLabel => 'Пароль';

  @override
  String get loginButtonText => 'Войти';

  @override
  String get homeMenuInventory => 'Инвентаризация';

  @override
  String get homeMenuReceiving => 'Приёмка товара';

  @override
  String get homeMenuScanning => 'Сканирование';

  @override
  String get homeMenuSettings => 'Настройки';

  @override
  String get settingsPageTitle => 'Настройки';

  @override
  String get settingsThemeTitle => 'Тёмная тема';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';
}
