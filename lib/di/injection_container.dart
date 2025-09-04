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
import 'package:easy_box/features/inventory/domain/usecases/update_product_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/delete_product_usecase.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_detail_bloc.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_creation_bloc.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart'; // Added for initial mock data
import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/data/datasources/order_remote_data_source_impl.dart';
import 'package:easy_box/features/order/data/repositories/order_repository_impl.dart';
import 'package:easy_box/features/order/domain/repositories/order_repository.dart';
import 'package:easy_box/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:easy_box/features/order/domain/usecases/update_order_usecase.dart';
import 'package:easy_box/features/order/presentation/bloc/order_list_bloc.dart';
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
import 'package:flutter/material.dart';

final sl = GetIt.instance;

Future<void> init({Locale? systemLocale}) async {
  // Initial mock data for the persistent mock backend
  final List<ProductModel> initialMockProducts = [
    const ProductModel(id: '1', name: 'Red T-Shirt, Size L', sku: 'SKU-TS-RED-L', quantity: 150, location: 'A1-01-01'),
    const ProductModel(id: '2', name: 'Blue Jeans, Size 32', sku: 'SKU-JN-BLU-32', quantity: 85, location: 'A1-01-02'),
    const ProductModel(id: '3', name: 'Green Hoodie, Size M', sku: 'SKU-HD-GRN-M', quantity: 110, location: 'A2-03-05'),
    const ProductModel(id: '4', name: 'Black Sneakers, Size 42', sku: 'SKU-SN-BLK-42', quantity: 200, location: 'C4-02-01'),
    const ProductModel(id: '5', name: 'White Socks (3-pack)', sku: 'SKU-SK-WHT-3P', quantity: 350, location: 'C4-02-02'),
  ];

  //####################
  //region Features
  //####################

  //--------------------
  //region Order
  //--------------------
  // Blocs
  sl.registerFactory(() => OrderListBloc(getOrdersUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl());
  //endregion

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
  sl.registerFactory(() => InventoryBloc(getProductsUseCase: sl(), findProductBySkuUseCase: sl()));
  sl.registerFactory(() => ProductDetailBloc(updateProductUseCase: sl(), deleteProductUseCase: sl()));
  sl.registerFactory(() => ProductCreationBloc(createProductUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => FindProductBySkuUseCase(sl()));
  sl.registerLazySingleton(() => AddStockUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl(database: sl(instanceName: 'mockBackendDb')));

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
      systemLocale: systemLocale,
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

  // App's local cache database
  final appDb = await openDatabase(
    join(await getDatabasesPath(), 'easy_box_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, sku TEXT, quantity INTEGER, location TEXT, image_url TEXT)',
      );
      db.execute(
        'CREATE TABLE stock_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, sku TEXT, quantity INTEGER, timestamp INTEGER)',
      );
      db.execute(
        'CREATE TABLE product_creations_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sku TEXT, location TEXT, local_id TEXT, timestamp INTEGER)',
      );
      db.execute(
        'CREATE TABLE product_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id TEXT, name TEXT, sku TEXT, quantity INTEGER, location TEXT, timestamp INTEGER)',
      );
      db.execute(
        'CREATE TABLE product_deletions_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id TEXT, timestamp INTEGER)',
      );
    },
    version: 6,
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute(
          'CREATE TABLE stock_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, sku TEXT, quantity INTEGER, timestamp INTEGER)',
        );
      }
      if (oldVersion < 3) {
        db.execute(
          'CREATE TABLE product_creations_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sku TEXT, local_id TEXT, timestamp INTEGER)',
        );
      }
      if (oldVersion < 4) {
        db.execute(
          'CREATE TABLE product_updates_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id TEXT, name TEXT, sku TEXT, quantity INTEGER, timestamp INTEGER)',
        );
        db.execute(
          'CREATE TABLE product_deletions_queue(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id TEXT, timestamp INTEGER)',
        );
      }
      if (oldVersion < 5) {
        db.execute('ALTER TABLE products ADD COLUMN location TEXT');
        db.execute('ALTER TABLE product_creations_queue ADD COLUMN location TEXT');
        db.execute('ALTER TABLE product_updates_queue ADD COLUMN location TEXT');
      }
      if (oldVersion < 6) {
        db.execute('ALTER TABLE products ADD COLUMN image_url TEXT');
      }
    },
  );
  sl.registerLazySingleton<Database>(() => appDb); // Register app's DB

  // Mock backend database
  final mockBackendDb = await openDatabase(
    join(await getDatabasesPath(), 'easy_box_mock_backend_database.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, sku TEXT, quantity INTEGER, location TEXT, image_url TEXT)',
      );
      // Populate with initial mock data
      for (final product in initialMockProducts) {
        await db.insert('products', product.toJson());
      }
    },
    version: 3, // Separate version for mock backend DB
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute('ALTER TABLE products ADD COLUMN location TEXT');
      }
      if (oldVersion < 3) {
        db.execute('ALTER TABLE products ADD COLUMN image_url TEXT');
      }
    },
  );
  sl.registerLazySingleton<Database>(
      () => mockBackendDb, instanceName: 'mockBackendDb'); // Register mock backend DB

  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //endregion
}


