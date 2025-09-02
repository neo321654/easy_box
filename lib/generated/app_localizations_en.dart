// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Easy Box';

  @override
  String get loginPageTitle => 'Login';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButtonText => 'Login';

  @override
  String get homeMenuInventory => 'Inventory';

  @override
  String get homeMenuReceiving => 'Receiving';

  @override
  String get homeMenuScanning => 'Scanning';

  @override
  String get homeMenuSettings => 'Settings';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsThemeTitle => 'Dark Theme';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';
}
