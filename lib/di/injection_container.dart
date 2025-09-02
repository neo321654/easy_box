import 'package:easy_box/features/settings/data/repositories/settings_repository.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() {
    // Load initial state from the repository
    final settingsRepo = sl<SettingsRepository>();
    final themeMode = settingsRepo.loadThemeMode();
    final locale = settingsRepo.loadLocale();
    final initialState = SettingsState(themeMode: themeMode, locale: locale);
    return SettingsBloc(initialState);
  });

  // Repositories
  sl.registerLazySingleton(() => SettingsRepository(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
