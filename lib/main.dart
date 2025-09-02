import 'package:easy_box/features/settings/data/repositories/settings_repository.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load preferences
  final prefs = await SharedPreferences.getInstance();
  final settingsRepository = SettingsRepository(prefs);

  // Load initial settings
  final themeMode = settingsRepository.loadThemeMode();
  final locale = settingsRepository.loadLocale();
  final initialState = SettingsState(themeMode: themeMode, locale: locale);

  runApp(MyAppWrapper(
    settingsRepository: settingsRepository,
    initialState: initialState,
  ));
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({
    super.key,
    required this.settingsRepository,
    required this.initialState,
  });

  final SettingsRepository settingsRepository;
  final SettingsState initialState;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: settingsRepository,
      child: BlocProvider(
        create: (context) => SettingsBloc(initialState),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: appRouter,
          title: 'Easy Box',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          themeMode: state.themeMode,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
