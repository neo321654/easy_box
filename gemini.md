--- Context from: ../../.gemini/GEMINI.md ---
## Gemini Added Memories
- The user prefers using `context.S` for localization instead of `context.l10n`.
- The user is asking about localization. I should clarify if they want to add a new language or something else related to language generation.
- The user wants to explicitly approve merges into the main branch.
- The user's Git workflow: Create a feature branch from `develop`. Merge the feature branch into `develop` and push. Then, merge `develop` into `main` and push to deploy.
- Run `analyze_files` to check for errors before every commit.
- The user wants me to merge to the main branch without asking for confirmation.
- The deployment workflow is triggered only on a push to the `main` branch if changes are detected within the `easy_box_backend/` directory.
- A deployment is triggered only by a push to `main` that includes changes in the `easy_box_backend/` directory. This applies even when fixing the deployment workflow itself. To force a deployment, I must make a trivial change in a file within `easy_box_backend/`.
--- End of Context from: ../../.gemini/GEMINI.md ---

--- Context from: GEMINI.md ---
# Правила и Соглашения по Рабочему Процессу

Этот документ содержит набор правил и соглашений, выработанных в ходе работы над проектом, для обеспечения консистентности и предсказуемости.

## 1. Project Structure

This project consists of two main parts:

-   **Frontend (Flutter):** Located in the `lib/` directory.
-   **Backend (Django):** Located in the `easy_box_backend/` directory, specifically:
    -   `easy_box_backend/api/`: Contains the API logic.
    -   `easy_box_backend/backend/`: Contains the core Django project settings.

Additionally, the project uses GitHub Actions for CI/CD, with the following key workflow files:

-   `.github/workflows/backend-deploy.yml`: Handles backend deployments.
-   `.github/workflows/develop-notifications.yml`: Manages notifications for the `develop` branch.

## 1. Git и Управление Ветками (GitFlow)

- **Основа:** Всегда используется методология GitFlow.
- **Ветка `develop`:** Основная ветка для разработки. Все новые ветки создаются от нее.
- **Feature-ветки:** Любая новая задача (фича, исправление, документация) реализуется в отдельной ветке. Имя ветки должно отражать суть задачи (например, `feature/admin-theme`, `fix/login-bug`).
- **Слияние:** После завершения работы feature-ветка сливается в `develop`. Для релиза (деплоя) ветка `develop` сливается в `main`.

## 2. CI/CD и Развертывание

- **Условие Запуска:** Автоматическое развертывание бэкенда запускается **только** при `push` в ветку `main` и **только** если изменения затрагивают папку `easy_box_backend/`.
- **Проверка перед пушем:** Перед отправкой изменений в `main` необходимо всегда проверять, выполняются ли условия для запуска деплоя, чтобы избежать лишних коммитов.

## 3. Технологические Предпочтения

- **Хранение Изображений:** Используется внешний сервис **Cloudinary**. Логика загрузки и получения URL изображений реализована в бэкенде.
- **Тема Админ-панели:** Предпочтение отдается готовым сторонним пакетам (текущий выбор — **django-jazzmin**) вместо написания кастомных CSS-стилей.
- **Язык:** Интерфейс админ-панели и вся коммуникация ведутся на **русском языке**.

## 4. Стиль Коммитов

- **Conventional Commits:** Сообщения коммитов должны следовать этому стилю для ясности и читаемости истории. Примеры:
    - `feat(admin): add new theme`
    - `fix(backend): correct syntax error in settings.py`
    - `docs(backend): update documentation`
    - `chore: trigger deployment workflow`

## 5. Процесс Работы и Коммуникация

- **Планирование:** Перед выполнением набора действий я должен кратко описать план.
- **Отладка:** При возникновении ошибки используется итеративный цикл: анализ логов -> построение гипотезы -> предложение решения -> реализация. Если решение не помогает, цикл повторяется с учетом новой информации.
- **Прямая отладка на сервере (SSH):** При сложных сбоях, когда логи CI/CD не дают полной картины, используется прямое подключение к серверу для изоляции проблемы. Ключевые команды (например, `docker-compose up`, `manage.py migrate`) выполняются вручную, чтобы проверить поведение окружения без влияния скрипта CI/CD. Это помогает точно определить, где находится источник проблемы: в командах, в коде или в самом процессе автоматизации.
- **Автономность (делай и не спрашивай):** При обнаружении проблемы или ошибки я должен самостоятельно приступать к ее исправлению, не запрашивая предварительного разрешения. План действий будет озвучен, но я не буду ждать подтверждения для начала работы.
- **Верификация:** Для проверки статуса или результатов на сервере я буду предоставлять необходимые команды для выполнения через SSH.

## 6. Управление Данными и Секретами (Data and Secrets Management)

- **База Данных (Database)::** Продакшн-база данных является постоянной. Скрипт деплоя не должен удалять тома с данными (`--volumes`). Любые изменения схемы, которые могут привести к потере данных, должны обсуждаться отдельно.
- **Секреты (Secrets):** Никакие секреты (ключи API, пароли) не должны коммититься в репозиторий. Они управляются через GitHub Actions Secrets и загружаются в `.env` файл на сервере во время деплоя.

## 7. Обработка Ошибок и Тестирование (Error Handling and Testing)

- **Отчет об Ошибках (Bug Reports):** При сообщении об ошибке, по возможности, следует предоставить шаги для ее воспроизведения и логи соответствующего сервиса (`backend` или `nginx`).
- **Обратная Совместимость (Backward Compatibility):** Изменения в API, которые могут сломать работу мобильного приложения, должны обсуждаться. Для критических изменений следует рассмотреть версионирование API (например, `/api/v2/`).

## 8. Deployment

- **КРИТИЧЕСКИ ВАЖНО:** Деплой запускается **только** при пуше в `main`, который содержит изменения в папке `easy_box_backend/`.
- Это правило применяется, даже если вы исправляете сам процесс деплоя. Если вы меняете `.github/workflows/backend-deploy.yml` но не трогаете файлы в `easy_box_backend/`, **деплой не запустится**.
- Чтобы принудительно запустить деплой, внесите любое минимальное изменение в любой файл внутри `easy_box_backend/` (например, добавьте комментарий или пустую строку).
- Процесс деплоя определен в `.github/workflows/backend-deploy.yml`.
--- End of Context from: GEMINI.md ---
