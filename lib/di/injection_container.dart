import 'package:easy_box/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';
import 'package:easy_box/features/auth/domain/usecases/login_usecase.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:easy_box/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_box/features/settings/domain/usecases/load_locale_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/load_theme_mode_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/save_locale_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/save_theme_mode_usecase.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //####################
  //region Features
  //####################

  //--------------------
  //region Settings
  //--------------------
  // Blocs
  sl.registerFactory(() {
    final initialState = SettingsState(
      themeMode: sl<LoadThemeModeUseCase>().call(),
      locale: sl<LoadLocaleUseCase>().call(),
    );
    return SettingsBloc(
      initialState: initialState,
      saveThemeModeUseCase: sl(),
      saveLocaleUseCase: sl(),
    );
  });

  // Use Cases
  sl.registerLazySingleton(() => LoadThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => LoadLocaleUseCase(sl()));
  sl.registerLazySingleton(() => SaveLocaleUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  //endregion

  //--------------------
  //region Auth
  //--------------------
  // Blocs
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  //endregion

  //endregion

  //####################
  //region External
  //####################
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  //endregion
}