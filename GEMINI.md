# GEMINI — EasyBox Warehouse

## Project Overview

EasyBox Warehouse is a warehouse management application composed of a Flutter mobile app and a Django REST backend. The app helps users manage products, orders and warehouse operations.

* **Frontend:** Flutter (BLoC, go\_router)
* **Backend:** Django REST Framework (PostgreSQL, JWT auth)
* **Architecture:** Clean Architecture (modular layers, separation of concerns)
* **Repo layout:**

    * `lib/` — mobile application source (entry point: `lib/main.dart`)
    * `easy_box_backend/app/` — backend source
    * `.github/workflows/` — CI/CD workflows
    * `lib/l10n/` — localization files (.arb)
    * `BACKEND_SPECS.md` — API specification

---

## Frontend (Flutter)

* **State management:** BLoC pattern — follow the existing folder and naming conventions when adding new features.
* **Routing:** `go_router` is used for navigation.
* **Entry point:** `lib/main.dart`.
* **Localization:** English, German, Russian. Add user-facing strings to `.arb` files in `lib/l10n` and use `context.S` (or your localization helper) to display them.
* **Dependencies:** See `pubspec.yaml` for the full list.

---

## Backend (Django)

* **Framework:** Django + Django REST Framework.
* **Database:** PostgreSQL.
* **Authentication:** JWT.
* **Dependencies:** See `easy_box_backend/requirements.txt`.
* **API:** See `BACKEND_SPECS.md` for endpoints, payload formats and examples.

---

## Building & Running

> NOTE: Many development tasks for Dart/Flutter must be executed via the MCP server (see section below).

Typical local steps (examples):

```bash
# fetch flutter packages
flutter pub get

# run the app on the default device
flutter run
```


## Git workflow & branching

The project uses a simple branch-based workflow without pull requests.

1. **Main branches:**

    * `develop` — primary development branch. All day-to-day work is based on this branch.
    * `main` — production-ready branch.

2. **Feature branches:**

    * Create a new branch from `develop` for each task/feature, e.g. `feature/sku-lookup` or `fix/login-timeout`.

3. **Merging:**

    * When the feature is complete, merge the feature branch back into `develop` and `git push` to the remote.
    * After `develop` has the desired changes, merge `develop` into `main` and `git push`.

4. **No Pull Requests:**

    * Pull requests are not used. Merges are performed directly (keep branch history visible — avoid squash merges if you want branch history preserved).

## CI/CD

Workflows are defined in `.github/workflows/`:

* **`mainnew.yml`** — deploy script triggered on merges to `main`. This workflow performs deployment to the production server.
* **`develop-notifications.yml`** — triggered on merges to `develop`. This workflow sends notifications to a configured Telegram chat.

Keep these files unchanged unless you know the deployment and notification requirements. If you modify them, test changes carefully.

---

## MCP server & Dart/Flutter tool usage

The project integrates with a Dart/Flutter MCP server. All Dart/Flutter developer tasks (analysis, formatting, dependency management, tests, running the app, hot reload, widget tree inspection) must be performed via MCP. This allows Gemini CLI and other tools to interact reliably with the project.

Common MCP commands and examples (use with the MCP interface):

```text
/mcp analyze      # run static analysis (equivalent of `flutter analyze` or `dart analyze`)
/mcp format       # auto-format Dart code (equivalent of `dart format .`)
/mcp pub_get      # fetch dependencies (equivalent of `flutter pub get`)
/mcp test         # run unit/widget tests (equivalent of `flutter test`)
/mcp run          # launch the application on the selected device/emulator
/mcp hot_reload   # perform a hot reload on a running app
```

When responding with commands via Gemini CLI, always include the command first in a code block and follow it with a short explanation in plain text.

Example:

```text
/mcp analyze  # Analyze the project for errors and warnings
```

This format helps other team members and automation understand what you executed.

---

## Emulators & device management

If a task requires an emulator, check and manage device state via MCP or Flutter tools.

Example steps (MCP + Flutter hybrid - adapt to your tooling):

```text
/flutter emulators                # list emulators
/flutter emulators --launch <id>  # launch emulator if not running
/mcp run                          # run the app on the running emulator
/mcp hot_reload                   # hot reload the running app
```

If the emulator is not running, the MCP-run should fail with a helpful message — then launch the emulator and retry.

---

## Development conventions

* **BLoC:** Use the existing BLoC conventions and structure for state, events and states.
* **API usage:** Follow `BACKEND_SPECS.md` for contracts and payloads when calling backend endpoints.
* **Localization:** Add new strings to `.arb` files in `lib/l10n` and update generated localization code if needed.
* **Code style:** Use null-safety, prefer `const` constructors, document public APIs and widgets with `///` comments.

---

## Gemini CLI response style

When Gemini CLI provides instructions or performs actions, follow this style:

1. Show the exact command(s) in a code block.
2. Provide a concise explanation of what the command does and the expected result.
3. If MCP commands are used, include both the MCP command and a short plain-language note.

Example:

```text
/mcp pub_get  # fetch Flutter/Dart dependencies via MCP
```

Explanation: This will download dependencies listed in `pubspec.yaml`. After success, you can run `/mcp run` to launch the app.

---

## Other notes

* If a request is **not** related to Dart/Flutter (e.g. high-level architecture, business logic, or backend-only changes), respond with normal text and standard commands for the backend (e.g. Python/Django commands) — do not use MCP for non-Dart tasks.
* Do not suggest or create pull requests — all merges are direct by project policy.
* Preserve branch history and clear commit messages to make manual merges traceable.

* запускай анализатор и фикси ошибки прежде чем сделать коммит


