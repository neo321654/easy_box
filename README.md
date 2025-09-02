# Easy Box

A new Flutter project for a warehouse application.

## Project Structure

This project follows the Clean Architecture principles, with a feature-driven approach.

```
lib/
├── core/               # Core utilities and base classes
├── features/
│   ├── auth/           # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── product/        # Product feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── di/                 # Dependency injection setup (get_it)
└── main.dart           # Main entry point
```

### Layers

- **Domain**: Contains the core business logic, entities, and repository interfaces. It is the innermost layer and has no dependencies on other layers.
- **Data**: Implements the repository interfaces from the domain layer and handles data retrieval from various sources (API, local database).
- **Presentation**: Contains the UI of the application (Widgets, BLoCs/Cubits). It depends on the domain layer.
- **Core**: Shared code and utilities that can be used across the entire application.
- **DI**: Dependency Injection configuration.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.