// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Easy Box';

  @override
  String get loginPageTitle => 'Anmelden';

  @override
  String get loginEmailLabel => 'E-Mail';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginButtonText => 'Anmelden';

  @override
  String get homeMenuInventory => 'Inventar';

  @override
  String get homeMenuReceiving => 'Wareneingang';

  @override
  String get homeMenuScanning => 'Scannen';

  @override
  String get homeMenuSettings => 'Einstellungen';

  @override
  String get settingsPageTitle => 'Einstellungen';

  @override
  String get settingsThemeTitle => 'Dunkles Design';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get languageRussian => 'Russisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Немецкий';

  @override
  String get loginAnonymousButtonText => 'Als Gast fortfahren';

  @override
  String get inventoryPageTitle => 'Inventar';

  @override
  String get retryButtonText => 'Wiederholen';

  @override
  String nPieces(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stücke',
      one: '1 Stück',
    );
    return '$_temp0';
  }

  @override
  String get receiveStockPageTitle => 'Wareneingang';

  @override
  String get productSkuLabel => 'Produkt-SKU';

  @override
  String get quantityLabel => 'Menge';

  @override
  String get addStockButtonText => 'Bestand hinzufügen';

  @override
  String get scanBarcodePageTitle => 'Barcode scannen';

  @override
  String get productNotFound => 'Produkt nicht gefunden';

  @override
  String get okButtonText => 'OK';

  @override
  String get pleaseEnterSkuError => 'Bitte SKU eingeben';

  @override
  String get pleaseEnterQuantityError => 'Bitte Menge eingeben';

  @override
  String get quantityMustBePositiveError => 'Menge muss positiv sein';

  @override
  String get productNotFoundDialogTitle => 'Produkt nicht gefunden';

  @override
  String get productNameLabel => 'Produktname';

  @override
  String get cancelButtonText => 'Abbrechen';

  @override
  String get createAndAddStockButtonText => 'Erstellen & Bestand hinzufügen';

  @override
  String get editProductDialogTitle => 'Produkt bearbeiten';

  @override
  String get saveButtonText => 'Speichern';

  @override
  String get deleteProductDialogTitle => 'Produkt löschen';

  @override
  String deleteConfirmationMessage(String productName) {
    return 'Sind Sie sicher, dass Sie $productName löschen möchten?';
  }

  @override
  String get deleteButtonText => 'Löschen';

  @override
  String get failedToUpdateProductMessage =>
      'Produkt konnte nicht aktualisiert werden.';

  @override
  String get productUpdatedSuccessfullyMessage =>
      'Produkt erfolgreich aktualisiert.';

  @override
  String get failedToDeleteProductMessage =>
      'Produkt konnte nicht gelöscht werden.';

  @override
  String get productDeletedSuccessfullyMessage =>
      'Produkt erfolgreich gelöscht.';
}
