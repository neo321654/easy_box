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

  @override
  String get loginAnonymousButtonText => 'Продолжить как гость';

  @override
  String get inventoryPageTitle => 'Инвентарь';

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
      one: '1 штука',
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
}
