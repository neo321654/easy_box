# План Улучшений Проекта "Easy Box"

Этот документ описывает план работ по рефакторингу и улучшению кодовой базы проекта.

## 1. Централизация конфигурации

**Задача:** Устранить жестко закодированные `baseUrl` и вынести их в единое место.

**Шаги:**
1.  Создать файл `lib/core/config/env_config.dart`.
2.  В `EnvConfig` определить статическое поле для `baseUrl`.
3.  Заменить все жестко закодированные URL в следующих файлах на `EnvConfig.baseUrl`:
    *   `lib/core/config/app_config.dart` (этот файл можно будет удалить или переделать)
    *   `lib/features/auth/data/repositories/auth_repository_api_impl.dart`
    *   `lib/features/inventory/data/datasources/inventory_remote_data_source_api_impl.dart`
    *   `lib/features/order/data/datasources/order_remote_data_source_api_impl.dart`
    *   `lib/core/talker/telegram_talker_observer.dart`
    *   `lib/features/inventory/data/models/product_model.dart`
4.  (Опционально) В будущем можно будет рассмотреть использование `flutter_dotenv` для загрузки конфигурации из `.env` файла, чтобы не хранить ее в коде.

## 2. Рефакторинг Dependency Injection

**Задача:** Улучшить читаемость и структуру файла `lib/di/injection_container.dart`.

**Шаги:**
1.  Разделить большую функцию `init` на несколько приватных функций по фичам:
    *   `_initAuth()`
    *   `_initOrder()`
    *   `_initInventory()`
    *   `_initSettings()`
    *   `_initReceiving()`
    *   `_initScanning()`
    *   `_initCore()` (для `Dio`, `SharedPreferences`, `Talker`, `Database` и т.д.)
2.  Вызвать эти функции из основной функции `init`.
3.  Заменить "магическую строку" `'mockBackendDb'` на именованную константу для избежания ошибок.

## 3. Централизация HTTP-клиента (Dio)

**Задача:** Использовать единый экземпляр `Dio` во всем приложении.

**Шаги:**
1.  Изменить конструктор `TelegramTalkerObserver` в `lib/core/talker/telegram_talker_observer.dart`, чтобы он принимал `Dio` как зависимость.
2.  Удалить создание нового экземпляра `Dio` внутри `TelegramTalkerObserver`.
3.  При регистрации `TelegramTalkerObserver` в `injection_container.dart`, передать ему уже существующий экземпляр `Dio` из `sl()`.

## 4. Удаление отладочной информации

**Задача:** Заменить вызовы `print()` на логгер `Talker`.

**Шаги:**
1.  Найти все вхождения `print()` в коде.
2.  Заменить их на `sl<Talker>().debug(...)` или другой подходящий метод логгера (`info`, `warning`, `error`).
    *   `lib/features/inventory/data/repositories/inventory_repository_impl.dart`
    *   `lib/features/inventory/presentation/bloc/inventory_bloc.dart`
    *   `lib/features/inventory/presentation/widgets/product_image.dart`
    *   `lib/features/inventory/presentation/widgets/product_list_item.dart`
    *   `lib/core/talker/telegram_talker_observer.dart`

---

Я начну с первого пункта: **Централизация конфигурации**.
