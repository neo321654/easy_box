# План создания и развертывания Django бэкенда для Easy Box

## Фаза 1: Анализ и подготовка

1.  **Анализ Flutter-приложения (lib/):**
    *   Изучить модели данных (`Product`, `Order`, `User` и т.д.).
    *   Определить все API-запросы (endpoints), которые использует приложение (`inventory_remote_data_source_api_impl.dart`, `auth_repository_api_impl.dart` и др.).
    *   Проанализировать логику оффлайн-режима и синхронизации для корректной реализации API.

2.  **Анализ существующего бэкенда (easy_box_backend/):**
    *   Оценить текущую структуру проекта Django.
    *   Проверить существующие модели, сериализаторы и представления (views) на соответствие требованиям Flutter-приложения.
    *   Изучить `requirements.txt` для понимания зависимостей.

3.  **Настройка Git-процесса (GitFlow):**
    *   Создать ветку `develop` от `main`.
    *   Создать ветку `feature/backend-setup` от `develop` для всей работы над бэкендом.

## Фаза 2: Разработка Django бэкенда

1.  **Настройка проекта:**
    *   Убедиться, что все необходимые зависимости указаны в `requirements.txt`.
    *   Настроить `backend/settings.py` для работы с PostgreSQL в продакшене и SQLite для локальной разработки.
    *   Настроить обработку статических файлов и медиафайлов (для изображений товаров).

2.  **Реализация моделей (api/models.py):**
    *   Создать/обновить модели Django (`Product`, `Order`, `OrderLine`, `User`), полностью соответствующие структурам данных в Flutter-приложении.
    *   Особое внимание уделить полям, таким как `ImageField` для изображений.

3.  **Реализация API (api/views.py, api/serializers.py, api/urls.py):**
    *   **Аутентификация:** Реализовать аутентификацию по токенам (`TokenAuthentication`). Создать эндпоинты `/api/auth/token/` и `/api/users/me/`.
    *   **Товары (Products):**
        *   `GET /api/products/`: Список всех товаров.
        *   `POST /api/products/`: Создание нового товара (с загрузкой изображения).
        *   `GET /api/products/?sku={sku}`: Поиск товара по SKU.
        *   `PUT /api/products/{id}/`: Обновление товара.
        *   `DELETE /api/products/{id}/`: Удаление товара.
        *   `POST /api/products/{id}/add_stock/`: Добавление товара на склад.
        *   `POST /api/products/{id}/upload_image/`: Загрузка/обновление изображения для товара.
    *   **Заказы (Orders):**
        *   `GET /api/orders/`: Список заказов.
        *   `PUT /api/orders/{id}/`: Обновление статуса и состава заказа.
    *   **Логирование:** Настроить эндпоинт `/log-client-error` для приема ошибок от клиента.

## Фаза 3: Докеризация

1.  **Dockerfile:** Создать/обновить `easy_box_backend/Dockerfile` для сборки production-ready образа.
2.  **Docker Compose:**
    *   `easy_box_backend/docker-compose.yml`: Для локальной разработки. Будет использовать SQLite и запускать Django development server.
    *   `easy_box_backend/docker-compose.prod.yml`: Для продакшена. Будет включать сервисы:
        *   `db`: PostgreSQL.
        *   `backend`: Gunicorn + Django.
        *   `nginx`: Веб-сервер и реверс-прокси для раздачи статики и проксирования запросов к Gunicorn.

## Фаза 4: Настройка CI/CD (GitHub Actions)

1.  **Создание нового workflow:** Создать файл `.github/workflows/backend-deploy.yml`.
2.  **Триггеры:**
    *   **`push` в `main`:** Запускает деплой на продакшн-сервер.
    *   **`push` в `develop`:** (Опционально, но рекомендуется) Запускает тесты и, возможно, деплой на staging-сервер.
3.  **Шаги workflow:**
    *   Checkout кода.
    *   Логин в Docker Hub (потребуются `DOCKER_USERNAME`, `DOCKER_PASSWORD`).
    *   Сборка и пуш Docker-образа с тегом `latest` и тегом по SHA коммита.
    *   SSH-подключение к серверу (потребуются `SERVER_HOST`, `SERVER_USER`, `SSH_PRIVATE_KEY`).
    *   На сервере:
        *   `git pull` последней версии из `main`.
        *   Создание `.env` файла из секретов GitHub (`SECRET_KEY`, `DATABASE_URL` и т.д.).
        *   Остановка, обновление и запуск сервисов через `docker-compose -f docker-compose.prod.yml up -d`.
        *   Очистка старых Docker-образов.
    *   Отправка уведомлений в Telegram об успехе или провале.

4.  **Настройка секретов в GitHub:** Вам нужно будет добавить следующие секреты в настройках репозитория (`Settings -> Secrets and variables -> Actions`):
    *   `DOCKER_USERNAME`: Ваш логин в Docker Hub.
    *   `DOCKER_PASSWORD`: Ваш пароль или токен доступа в Docker Hub.
    *   `SERVER_HOST`: IP-адрес вашего сервера.
    *   `SERVER_USER`: Имя пользователя для SSH-подключения.
    *   `SSH_PRIVATE_KEY`: Приватный SSH-ключ для доступа к серверу.
    *   `SERVER_PORT`: Порт для SSH (обычно 22).
    *   `SECRET_KEY`: Секретный ключ Django.
    *   `DATABASE_URL`: URL для подключения к PostgreSQL (например, `postgres://user:password@db:5432/easyboxdb`).
    *   `TELEGRAM_BOT_TOKEN`: Токен вашего Telegram-бота.
    *   `TELEGRAM_CHAT_ID`: ID чата для отправки уведомлений.
    *   ... и другие секреты из `mainnew.yml`.

## Фаза 5: Настройка сервера

1.  **Установка ПО:** Установить `git`, `docker` и `docker-compose` на сервере.
2.  **Клонирование репозитория:** `git clone [your-repo-url] ~/easy_box`.
3.  **Настройка Docker:** Убедиться, что пользователь, из-под которого будет выполняться деплой, имеет права на запуск docker-команд.

## План выполнения

1.  Создать и записать этот план в `PLAN.md`.
2.  Настроить ветки `develop` и `feature/backend-setup` согласно GitFlow.
3.  Проанализировать и доработать существующий Django-проект для полного соответствия API, требуемому Flutter-приложением.
4.  Создать `docker-compose.prod.yml` и обновить `Dockerfile`.
5.  Создать новый workflow-файл `.github/workflows/backend-deploy.yml`.
6.  Уведомить вас о необходимости настройки секретов в GitHub.
7.  После настройки секретов инициировать первый деплой через слияние веток.
