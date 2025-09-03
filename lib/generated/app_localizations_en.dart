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
  String get homeMenuPicking => 'Picking';

  @override
  String get homeMenuSettings => 'Settings';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get loginAnonymousButtonText => 'Continue as Guest';

  @override
  String get inventoryPageTitle => 'Inventory';

  @override
  String get inventorySearchHint => 'Search by name, SKU, or location...';

  @override
  String get orderListPageTitle => 'Orders';

  @override
  String get orderListFailedToLoad => 'Failed to load orders';

  @override
  String orderStatusLabel(Object status) {
    return 'Status: $status';
  }

  @override
  String orderLinesLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines',
      one: '1 line',
    );
    return '$_temp0';
  }

  @override
  String pickingPageTitle(Object orderId) {
    return 'Picking Order: $orderId';
  }

  @override
  String get pickingPageLocationLabel => 'Location';

  @override
  String get pickingPageSkuLabel => 'SKU';

  @override
  String get pickingPageCompleteButton => 'Complete Picking';

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

  @override
  String get pleaseEnterSkuError => 'Please enter a SKU';

  @override
  String get pleaseEnterQuantityError => 'Please enter a quantity';

  @override
  String get quantityMustBePositiveError => 'Quantity must be positive';

  @override
  String get productNotFoundDialogTitle => 'Product Not Found';

  @override
  String get productNameLabel => 'Product Name';

  @override
  String get productLocationLabel => 'Location';

  @override
  String get cancelButtonText => 'Cancel';

  @override
  String get createAndAddStockButtonText => 'Create & Add Stock';

  @override
  String get editProductDialogTitle => 'Edit Product';

  @override
  String get saveButtonText => 'Save';

  @override
  String get deleteProductDialogTitle => 'Delete Product';

  @override
  String deleteConfirmationMessage(String productName) {
    return 'Are you sure you want to delete $productName?';
  }

  @override
  String get deleteButtonText => 'Delete';

  @override
  String get failedToUpdateProductMessage => 'Failed to update product.';

  @override
  String get productUpdatedSuccessfullyMessage =>
      'Product updated successfully.';

  @override
  String get failedToDeleteProductMessage => 'Failed to delete product.';

  @override
  String get productDeletedSuccessfullyMessage =>
      'Product deleted successfully.';

  @override
  String welcomeMessage(Object userName) {
    return 'Welcome, $userName';
  }

  @override
  String skuLabelWithColon(Object sku) {
    return 'SKU: $sku';
  }

  @override
  String productSkuLabelWithColon(Object productSkuLabel, Object sku) {
    return '$productSkuLabel: $sku';
  }

  @override
  String quantityLabelWithColon(Object quantityLabel, Object quantity) {
    return '$quantityLabel: $quantity';
  }

  @override
  String productLocationLabelWithColon(Object location) {
    return 'Location: $location';
  }

  @override
  String get serverError => 'Server Error';

  @override
  String get offlineIndicator => ' (Offline)';

  @override
  String get failedToAddStock => 'Failed to add stock.';

  @override
  String stockAddedSuccessfully(Object sku) {
    return 'Stock added successfully for SKU: $sku';
  }

  @override
  String get failedToCreateProduct => 'Failed to create product.';

  @override
  String get failedToAddStockAfterCreatingProduct =>
      'Failed to add stock after creating product.';

  @override
  String productCreatedAndStockAddedSuccessfully(Object sku) {
    return 'Product created and stock added successfully for SKU: $sku';
  }
}
