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

  @override
  String get loginAnonymousButtonText => 'Continue as Guest';

  @override
  String get inventoryPageTitle => 'Inventory';

  @override
  String get retryButtonText => 'Retry';

  @override
  String nPieces(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0';
  }

  @override
  String get receiveStockPageTitle => 'Receive Stock';

  @override
  String get productSkuLabel => 'Product SKU';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get addStockButtonText => 'Add Stock';

  @override
  String get scanBarcodePageTitle => 'Scan Barcode';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get okButtonText => 'OK';
}
