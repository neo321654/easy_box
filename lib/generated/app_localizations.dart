import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Easy Box'**
  String get appTitle;

  /// No description provided for @loginPageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get loginPageTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get loginPasswordLabel;

  /// No description provided for @loginButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginButtonText;

  /// No description provided for @homeMenuInventory.
  ///
  /// In ru, this message translates to:
  /// **'Инвентаризация'**
  String get homeMenuInventory;

  /// No description provided for @homeMenuReceiving.
  ///
  /// In ru, this message translates to:
  /// **'Приёмка товара'**
  String get homeMenuReceiving;

  /// No description provided for @homeMenuScanning.
  ///
  /// In ru, this message translates to:
  /// **'Сканирование'**
  String get homeMenuScanning;

  /// No description provided for @homeMenuSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get homeMenuSettings;

  /// No description provided for @settingsPageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsPageTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная тема'**
  String get settingsThemeTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguageTitle;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In ru, this message translates to:
  /// **'Немецкий'**
  String get languageGerman;

  /// No description provided for @loginAnonymousButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить как гость'**
  String get loginAnonymousButtonText;

  /// No description provided for @inventoryPageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Инвентарь'**
  String get inventoryPageTitle;

  /// No description provided for @retryButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retryButtonText;

  /// No description provided for @nPieces.
  ///
  /// In ru, this message translates to:
  /// **'{count,plural, one{1 штука} few{{count} штуки} many{{count} штук} other{{count} штуки}}'**
  String nPieces(num count);

  /// No description provided for @receiveStockPageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Приемка товара'**
  String get receiveStockPageTitle;

  /// No description provided for @productSkuLabel.
  ///
  /// In ru, this message translates to:
  /// **'SKU товара'**
  String get productSkuLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Количество'**
  String get quantityLabel;

  /// No description provided for @addStockButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Добавить на склад'**
  String get addStockButtonText;

  /// No description provided for @scanBarcodePageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сканировать штрих-код'**
  String get scanBarcodePageTitle;

  /// No description provided for @productNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Товар не найден'**
  String get productNotFound;

  /// No description provided for @okButtonText.
  ///
  /// In ru, this message translates to:
  /// **'ОК'**
  String get okButtonText;

  /// No description provided for @pleaseEnterSkuError.
  ///
  /// In ru, this message translates to:
  /// **'Пожалуйста, введите SKU'**
  String get pleaseEnterSkuError;

  /// No description provided for @pleaseEnterQuantityError.
  ///
  /// In ru, this message translates to:
  /// **'Пожалуйста, введите количество'**
  String get pleaseEnterQuantityError;

  /// No description provided for @quantityMustBePositiveError.
  ///
  /// In ru, this message translates to:
  /// **'Количество должно быть положительным'**
  String get quantityMustBePositiveError;

  /// No description provided for @productNotFoundDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Товар не найден'**
  String get productNotFoundDialogTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название товара'**
  String get productNameLabel;

  /// No description provided for @cancelButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelButtonText;

  /// No description provided for @createAndAddStockButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Создать и добавить на склад'**
  String get createAndAddStockButtonText;

  /// No description provided for @editProductDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать товар'**
  String get editProductDialogTitle;

  /// No description provided for @saveButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get saveButtonText;

  /// No description provided for @deleteProductDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить товар'**
  String get deleteProductDialogTitle;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите удалить {productName}?'**
  String deleteConfirmationMessage(String productName);

  /// No description provided for @deleteButtonText.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get deleteButtonText;

  /// No description provided for @failedToUpdateProductMessage.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить товар.'**
  String get failedToUpdateProductMessage;

  /// No description provided for @productUpdatedSuccessfullyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Товар успешно обновлен.'**
  String get productUpdatedSuccessfullyMessage;

  /// No description provided for @failedToDeleteProductMessage.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить товар.'**
  String get failedToDeleteProductMessage;

  /// No description provided for @productDeletedSuccessfullyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Товар успешно удален.'**
  String get productDeletedSuccessfullyMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
