import 'package:easy_box/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';
import 'package:easy_box/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:easy_box/features/auth/domain/usecases/login_anonymously_usecase.dart';
import 'package:easy_box/features/auth/domain/usecases/login_usecase.dart';
import 'package:easy_box/features/auth/domain/usecases/logout_usecase.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source_impl.dart';
import 'package:easy_box/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:easy_box/features/inventory/domain/usecases/add_stock_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/find_product_by_sku_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/create_product_usecase.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/receiving/presentation/bloc/receiving_bloc.dart';
import 'package:easy_box/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:easy_box/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:easy_box/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_box/features/settings/domain/usecases/load_locale_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/load_theme_mode_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/save_locale_usecase.dart';
import 'package:easy_box/features/settings/domain/usecases/save_theme_mode_usecase.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source_impl.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //####################
  //region Features
  //####################

  //--------------------
  //region Receiving
  //--------------------
  // Blocs
  sl.registerFactory(() => ReceivingBloc(addStockUseCase: sl(), createProductUseCase: sl()));
  //endregion

  //--------------------
  //region Scanning
  //--------------------
  // Blocs
  sl.registerFactory(() => ScanningBloc(findProductBySkuUseCase: sl()));
  //endregion

  //--------------------
  //region Inventory
  //--------------------
  // Blocs
  sl.registerFactory(() => InventoryBloc(getProductsUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => FindProductBySkuUseCase(sl()));
  sl.registerLazySingleton(() => AddStockUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl());

  // Local Data Sources
  sl.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSourceImpl(database: sl()),
  );
  //endregion

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
  sl.registerLazySingleton(() => AuthBloc(
        loginUseCase: sl(),
        getMeUseCase: sl(),
        logoutUseCase: sl(),
        loginAnonymouslyUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => LoginAnonymouslyUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  //endregion

  //endregion

  //####################
  //region External
  //####################
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final db = await openDatabase(
    join(await getDatabasesPath(), 'easy_box_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, sku TEXT, quantity INTEGER)',
      );
      db.execute(
        'CREATE TABLE stock_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, sku TEXT, quantity INTEGER, timestamp INTEGER)',
      );
    },
    version: 2,
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute(
          'CREATE TABLE stock_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, sku TEXT, quantity INTEGER, timestamp INTEGER)',
        );
      }
    },
  );
  sl.registerLazySingleton<Database>(() => db);

  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //endregion
}
