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
  String get homeMenuPicking => 'Сборка';

  @override
  String get homeMenuSettings => 'Настройки';

  @override
  String get settingsPageTitle => 'Настройки';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Темная';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageGerman => 'Немецкий';

  @override
  String get loginAnonymousButtonText => 'Продолжить как гость';

  @override
  String get inventoryPageTitle => 'Инвентарь';

  @override
  String get inventorySearchHint => 'Поиск по имени, SKU или местоположению...';

  @override
  String get addProductPageTitle => 'Добавить новый товар';

  @override
  String get addProductButtonText => 'Добавить товар';

  @override
  String get pleaseEnterProductNameError =>
      'Пожалуйста, введите название товара';

  @override
  String get productCreatedSuccessfully => 'Товар успешно создан';

  @override
  String get orderListPageTitle => 'Заказы';

  @override
  String get orderListFailedToLoad => 'Не удалось загрузить заказы';

  @override
  String orderStatusLabel(Object status) {
    return 'Статус: $status';
  }

  @override
  String orderLinesLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиции',
      many: '$count позиций',
      few: '$count позиции',
      one: '$count позиция',
    );
    return '$_temp0';
  }

  @override
  String pickingPageTitle(Object orderId) {
    return 'Сборка заказа: $orderId';
  }

  @override
  String get pickingPageLocationLabel => 'Место';

  @override
  String get pickingPageSkuLabel => 'SKU';

  @override
  String get pickingPageCompleteButton => 'Завершить сборку';

  @override
  String get pickingCompleteConfirmation =>
      'Вы уверены, что хотите завершить сборку этого заказа?';

  @override
  String get retryButtonText => 'Повторить';

  @override
  String nPieces(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count штуки',
      many: '$count штук',
      few: '$count штуки',
      one: '$count штука',
    );
    return '$_temp0';
  }

  @override
  String get receiveStockPageTitle => 'Приемка товара';

  @override
  String get productSkuLabel => 'SKU товара';

  @override
  String get quantityLabel => 'Количество';

  @override
  String get addStockButtonText => 'Добавить на склад';

  @override
  String get scanBarcodePageTitle => 'Сканировать штрих-код';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String get okButtonText => 'ОК';

  @override
  String get pleaseEnterSkuError => 'Пожалуйста, введите SKU';

  @override
  String get pleaseEnterQuantityError => 'Пожалуйста, введите количество';

  @override
  String get quantityMustBePositiveError =>
      'Количество должно быть положительным';

  @override
  String get productNotFoundDialogTitle => 'Товар не найден';

  @override
  String get productNameLabel => 'Название товара';

  @override
  String get productLocationLabel => 'Местоположение';

  @override
  String get productImageUrlLabel => 'URL изображения';

  @override
  String get cancelButtonText => 'Отмена';

  @override
  String get createAndAddStockButtonText => 'Создать и добавить на склад';

  @override
  String get editProductDialogTitle => 'Редактировать товар';

  @override
  String get saveButtonText => 'Сохранить';

  @override
  String get deleteProductDialogTitle => 'Удалить товар';

  @override
  String deleteConfirmationMessage(String productName) {
    return 'Вы уверены, что хотите удалить $productName?';
  }

  @override
  String get deleteButtonText => 'Удалить';

  @override
  String get failedToUpdateProductMessage => 'Не удалось обновить товар.';

  @override
  String get productUpdatedSuccessfullyMessage => 'Товар успешно обновлен.';

  @override
  String get failedToDeleteProductMessage => 'Не удалось удалить товар.';

  @override
  String get productDeletedSuccessfullyMessage => 'Товар успешно удален.';

  @override
  String welcomeMessage(Object userName) {
    return 'Добро пожаловать, $userName';
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
    return 'Местоположение: $location';
  }

  @override
  String get serverError => 'Ошибка сервера';

  @override
  String get offlineIndicator => ' (Офлайн)';

  @override
  String get failedToAddStock => 'Не удалось добавить товар на склад.';

  @override
  String stockAddedSuccessfully(Object sku) {
    return 'Товар для SKU: $sku успешно добавлен на склад';
  }

  @override
  String get failedToCreateProduct => 'Не удалось создать товар.';

  @override
  String get failedToAddStockAfterCreatingProduct =>
      'Не удалось добавить товар на склад после создания товара.';

  @override
  String productCreatedAndStockAddedSuccessfully(Object sku) {
    return 'Товар создан и успешно добавлен на склад для SKU: $sku';
  }
}
