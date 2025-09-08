# Gemini Code Assistant Context

## Project Overview

This is a warehouse management application called "Easy Box". It consists of a Flutter mobile application and a Django backend. The application helps users manage products, orders, and warehouse operations.

### Frontend (Flutter)

*   **State Management:** BLoC
*   **Routing:** go_router
*   **Dependencies:** See `pubspec.yaml` for a full list.
*   **Structure:** The main application logic is in the `lib` directory. The entry point is `lib/main.dart`.
*   **Localization:** The app supports English, German, and Russian. Localization files are in `lib/l10n`.

### Backend (Django)

*   **Framework:** Django REST Framework
*   **Database:** PostgreSQL
*   **Authentication:** JWT
*   **Dependencies:** See `easy_box_backend/requirements.txt` for a full list.
*   **API Specification:** The API is documented in `BACKEND_SPECS.md`.

## Building and Running



## Development Conventions

*   **State Management:** Follow the BLoC pattern for new features.
*   **API Interaction:** Use the API specification in `BACKEND_SPECS.md` as a reference when working on features that interact with the backend.
*   **Localization:** When adding new user-facing strings, add them to the `.arb` files in `lib/l10n` and use `context.S` to display them.
