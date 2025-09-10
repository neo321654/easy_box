# Документация по бэкенду Easy Box

## 1. Обзор

Этот документ описывает архитектуру и принципы работы бэкенд-сервиса для мобильного приложения Easy Box.

- **Технологический стек:**
  - **Фреймворк:** Django & Django Rest Framework
  - **База данных:** PostgreSQL
  - **Хранение изображений:** Cloudinary
  - **Веб-сервер:** Nginx
  - **Сервер приложения:** Gunicorn
  - **Окружение:** Docker & Docker Compose

## 2. Структура проекта (`easy_box_backend/`)

- `api/`: Основное Django-приложение, содержащее всю бизнес-логику.
  - `models.py`: Определяет модели (`User`, `Product`, `Order`, `OrderLine`).
  - `views.py`: Содержит `ViewSet`'ы для обработки API-запросов.
  - `serializers.py`: Отвечает за преобразование объектов Django в JSON и обратно. Содержит логику загрузки изображений в Cloudinary.
  - `admin.py`: Настраивает отображение моделей в админ-панели Django.
  - `urls.py`: Определяет маршруты (endpoints) API.
- `backend/`: Папка с настройками Django-проекта.
  - `settings.py`: Главный конфигурационный файл. Настройки базы данных, CORS, Cloudinary и другие переменные окружения загружаются из переменных окружения (с помощью `dj-database-url` и `os.getenv`).
  - `urls.py`: Корневой файл маршрутизации проекта.
- `Dockerfile`: Инструкция для сборки Docker-образа приложения. Миграции НЕ применяются на этапе сборки.
- `docker-compose.yml`: Файл для запуска проекта в локальном окружении.
- `docker-compose.prod.yml`: Файл для развертывания на продакшн-сервере. Запускает 3 сервиса: `db` (PostgreSQL), `backend` (Gunicorn + Django), `nginx`. Использует образ, собранный в CI/CD.
- `nginx/nginx.prod.conf`: Конфигурация Nginx для продакшена. Выполняет роль реверс-прокси.

## 3. API Endpoints

Аутентификация происходит по токену. Для всех запросов (кроме получения токена) требуется заголовок `Authorization: Token <ваш_токен>`.

- **Аутентификация**
  - `POST /api/auth/token/`: Получение токена аутентификации. Принимает `email` и `password`.
  - `GET /api/users/me/`: Получение информации о текущем пользователе.

- **Товары (Products)**
  - `GET /api/products/`: Получить список всех товаров.
  - `POST /api/products/`: Создать новый товар. Для загрузки изображения используется `multipart/form-data`.
  - `GET /api/products/{id}/`: Получить детальную информацию о товаре.
  - `PUT /api/products/{id}/`: Обновить информацию о товаре.
  - `DELETE /api/products/{id}/`: Удалить товар.
  - `POST /api/products/{id}/add_stock/`: Увеличить количество товара на складе.

- **Заказы (Orders)**
  - `GET /api/orders/`: Получить список заказов.
  - `PUT /api/orders/{id}/`: Обновить заказ (например, изменить его статус).

## 4. Локальная разработка

Для запуска проекта на локальной машине необходимы Docker и Docker Compose.

1.  **Создайте файл `.env`** в корне папки `easy_box_backend/` со следующим содержимым (для работы с Cloudinary):
    ```
    SECRET_KEY=your_secret_local_key
    CLOUDINARY_CLOUD_NAME=your_cloud_name
    CLOUDINARY_API_KEY=your_api_key
    CLOUDINARY_API_SECRET=your_api_secret
    # DATABASE_URL можно не указывать, по умолчанию будет использоваться db.sqlite3
    ```
2.  **Запустите сервисы:**
    ```bash
    docker-compose up --build
    ```
3.  **Выполните миграции базы данных** (в отдельном терминале):
    ```bash
    docker-compose exec web python manage.py migrate
    ```
4.  **Создайте суперпользователя** для доступа к админке:
    ```bash
    docker-compose exec web python manage.py createsuperuser
    ```
5.  Проект будет доступен по адресу `http://localhost:8000`.

## 5. Развертывание (CI/CD)

Процесс развертывания полностью автоматизирован с помощью GitHub Actions.

- **Триггер:** Деплой запускается автоматически при каждом `push` в ветку `main`, если изменения затрагивают папку `easy_box_backend/`.
- **Workflow:** Процесс описан в файле `.github/workflows/backend-deploy.yml`.
- **Процесс:**
  1.  Собирается Docker-образ приложения на основе актуального кода.
  2.  Образ загружается в Docker Hub (`321654neo/easy_box_backend:latest`).
  3.  Скрипт подключается к продакшн-серверу по SSH.
  4.  На сервере обновляется код из репозитория (`git reset --hard origin/main`) для получения актуального `docker-compose.prod.yml`.
  5.  Создается актуальный `.env` файл из секретов GitHub.
  6.  С сервера принудительно скачивается последняя версия образа из Docker Hub (`docker pull`).
  7.  **Создается резервная копия базы данных** (`pg_dump`).
  8.  **Безопасно перезапускается только контейнер приложения:** старый контейнер `backend` останавливается и удаляется, `db` и `nginx` не затрагиваются.
  9.  Запускается новый контейнер `backend` на основе скачанного образа (`docker-compose up -d`).
  10. **Применяются миграции базы данных.** В команду миграции принудительно передается `DATABASE_URL` для гарантии подключения к PostgreSQL.
- **Секреты GitHub:** Для работы CI/CD в настройках репозитория (`Settings -> Secrets and variables -> Actions`) должны быть заданы все необходимые переменные, включая:
  - `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`
  - `SECRET_KEY`
  - `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`
