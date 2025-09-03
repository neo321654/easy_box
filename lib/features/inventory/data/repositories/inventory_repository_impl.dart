import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final InventoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        await _syncPendingUpdates();
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } on ServerException {
        // Fallback to cache
      }
    }
    // If offline OR if remote call failed, try to load from cache.
    try {
      final localProducts = await localDataSource.getLastProducts();
      return Right(localProducts);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Product?>> findProductBySku(String sku) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.findProductBySku(sku);
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure()); // Sku lookup offline not supported in this scenario
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(
      {required String name, required String sku}) async {
    if (await networkInfo.isConnected) {
      try {
        final newProduct = await remoteDataSource.createProduct(name: name, sku: sku);
        await localDataSource.saveProduct(newProduct);
        return Right(newProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Offline creation
      try {
        final localId = DateTime.now().millisecondsSinceEpoch.toString(); // Generate a temporary local ID
        final newProduct = ProductModel(id: localId, name: name, sku: sku, quantity: 0);
        await localDataSource.saveProduct(newProduct);
        await localDataSource.addProductCreationToQueue(name, sku, localId);
        return Right(newProduct);
      } on Exception {
        return Left(CacheFailure()); // Or a more specific failure
      }
    }
  }

  @override
  Future<Either<Failure, void>> addStock(String sku, int quantityToAdd) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addStock(sku, quantityToAdd);
        await localDataSource.updateLocalProductStock(sku, quantityToAdd);
        return Right(result);
      } on ProductNotFoundException catch (e) {
        return Left(ProductNotFoundFailure(e.sku));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.addStockToQueue(sku, quantityToAdd);
        await localDataSource.updateLocalProductStock(sku, quantityToAdd);
        return const Right(null);
      } on Exception {
        return Left(CacheFailure());
      }
    }
  }

  Future<void> _syncPendingUpdates() async {
    // Sync product creations first
    final pendingCreations = await localDataSource.getQueuedProductCreations();
    if (pendingCreations.isNotEmpty) {
      for (final creation in pendingCreations) {
        try {
          final remoteProduct = await remoteDataSource.createProduct(
            name: creation['name'],
            sku: creation['sku'],
          );
          // Update local product with real server ID
          await localDataSource.database.rawUpdate(
            'UPDATE products SET id = ? WHERE id = ?',
            [remoteProduct.id, creation['local_id']],
          );
        } catch (e) {
          // Handle creation sync failure (e.g., log, retry later)
        }
      }
      await localDataSource.clearQueuedProductCreations();
    }

    // Sync stock updates
    final pendingStockUpdates = await localDataSource.getQueuedStockUpdates();
    if (pendingStockUpdates.isNotEmpty) {
      for (final update in pendingStockUpdates) {
        try {
          await remoteDataSource.addStock(update['sku'], update['quantity']);
        } catch (e) {
          // Handle stock update sync failure
        }
      }
      await localDataSource.clearQueuedStockUpdates();
    }
  }
}