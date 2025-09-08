# План по исправлению проблем с изображениями товаров

## 1. Анализ обработки изображений на бэкенде

- **Цель:** Понять, как изображения товаров хранятся, сериализуются и отдаются бэкендом Django.
- **Файлы для проверки:**
    - `easy_box_backend/api/models.py`: Проверить модель `Product` на наличие поля `image`. Скорее всего, это `ImageField`.
    - `easy_box_backend/api/serializers.py`: Проверить `ProductSerializer`. Сериализация поля `image` критически важна. Оно должно генерировать полный, доступный URL.
    - `easy_box_backend/backend/settings.py`: Проверить настройки `MEDIA_URL` и `MEDIA_ROOT`.
    - `easy_box_backend/backend/urls.py`: Убедиться, что медиафайлы корректно раздаются в режиме разработки.

## 2. Анализ отображения изображений на фронтенде

- **Цель:** Определить, почему виджет `ProductImage` не может отобразить изображение и показывает индикатор загрузки.
- **Файл для проверки:** `lib/features/inventory/presentation/widgets/product_image.dart`.
- **Гипотеза:** Неправильно конструируется URL изображения. Виджет может некорректно добавлять базовый URL к уже полному URL, полученному от бэкенда, или же URL от бэкенда является неверным/неполным.
- **Действие:**
    - Вывести в лог `imageUrl`, который передается в виджет `CachedNetworkImage`.
    - Исправить логику конструирования URL. В идеале, бэкенд должен предоставлять полный URL. Если он предоставляет относительный путь, фронтенд должен корректно добавлять базовый URL.

## 3. Анализ загрузки изображений с фронтенда

- **Цель:** Определить, почему загрузка изображения из приложения не работает.
- **Файлы для проверки:**
    - `lib/features/inventory/presentation/widgets/add_product_form.dart`
    - `lib/features/inventory/presentation/pages/product_detail_page.dart`
    - `lib/features/inventory/data/repositories/inventory_repository_impl.dart`
    - `lib/features/inventory/data/datasources/inventory_remote_data_source_api_impl.dart`
- **Гипотеза:** Проблема может быть в том, как конструируется `FormData` или как создается `MultipartFile`. Также это может быть проблема на бэкенде, где view не обрабатывает загрузку файла должным образом.
- **Действие:**
    - Проверить методы `createProduct` и `uploadProductImage` в `InventoryRemoteDataSourceApiImpl`.
    - Проверить соответствующее view в `easy_box_backend/api/views.py`, чтобы увидеть, как оно обрабатывает входящие `FormData`.

## 4. Шаги по реализации

1.  **Исправление на бэкенде:**
    - В `easy_box_backend/api/serializers.py` изменить `ProductSerializer`, чтобы поле `image` возвращало полный URL. Использовать `request.build_absolute_uri(obj.image.url)`, если это еще не сделано.
    - В `easy_box_backend/backend/urls.py` добавить необходимую конфигурацию для раздачи медиафайлов в режиме разработки:
      ```python
      from django.conf import settings
      from django.conf.urls.static import static

      urlpatterns = [
          # ... другие url
      ] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
      ```

2.  **Исправление на фронтенде (Отображение):**
    - В `lib/features/inventory/presentation/widgets/product_image.dart` упростить логику URL. Если бэкенд предоставляет полный URL, никаких манипуляций не требуется. Удалить жестко закодированный базовый URL.

3.  **Исправление на фронтенде (Загрузка):**
    - Логика загрузки в `inventory_remote_data_source_api_impl.dart` для `createProduct`, кажется, имеет проблему. Он передает `imageUrl`, который является путем, но имя поля - `image`. Бэкенд ожидает файл под ключом `image`. Давайте также проверим методы `updateProduct` и `uploadProductImage`.
    - В `createProduct` `FormData` корректен: `if (imageUrl != null) 'image': await MultipartFile.fromFile(imageUrl)`. Это выглядит правильно.
    - Метод `uploadProductImage` также выглядит корректно.
    - Проблема может быть в представлении бэкенда. Давайте пока предположим, что фронтенд корректен, и сосредоточимся сначала на части отображения.

## 5. Рабочий процесс Git

1.  Создать новую ветку `feature/fix-product-image` от `develop`.
2.  Внести исправления.
3.  Закоммитить изменения.
4.  Слить `feature/fix-product-image` в `develop`.
5.  Отправить `develop` в удаленный репозиторий.
6.  Слить `develop` в `main`.
7.  Отправить `main` в удаленный репозиторий.
8.  Подождать 3 минуты для завершения деплоя.

## 6. Тестирование

1.  Запустить приложение на эмуляторе.
2.  Перейти на страницу инвентаризации.
3.  Убедиться, что существующие изображения (загруженные через админку) теперь отображаются корректно.
4.  Попробовать создать новый товар с изображением из приложения.
5.  Убедиться, что новый товар и его изображение отображаются корректно.
6.  Попробовать отредактировать существующий товар и изменить его изображение.
7.  Убедиться, что обновленное изображение отображается корректно.