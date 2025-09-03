import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
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
        await _syncPendingUpdates(); // 1. PUSH local changes to remote
        final remoteProducts = await remoteDataSource.getProducts(); // 2. PULL latest from remote
        await localDataSource.cacheProducts(remoteProducts); // 3. Cache latest remote data
        return Right(remoteProducts); // 4. Return fresh data
      } on ServerException {
        // If server fails (either sync or pull), fall through to load from cache below
      }
    }
    // Always read from local cache (either because offline, or remote failed)
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
  Future<Either<Failure, OperationResult>> createProduct(
      {required String name, required String sku}) async {
    if (await networkInfo.isConnected) {
      try {
        final newProduct = await remoteDataSource.createProduct(name: name, sku: sku);
        await localDataSource.saveProduct(newProduct);
        return const Right(OperationResult(isQueued: false));
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
        return const Right(OperationResult(isQueued: true)); // Fixed: return OperationResult
      } on Exception {
        return Left(CacheFailure()); // Or a more specific failure
      }
    }
  }

  @override
  Future<Either<Failure, OperationResult>> addStock(String sku, int quantityToAdd) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addStock(sku, quantityToAdd);
        await localDataSource.updateLocalProductStock(sku, quantityToAdd);
        return const Right(OperationResult(isQueued: false));
      } on ProductNotFoundException catch (e) {
        return Left(ProductNotFoundFailure(e.sku));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.addStockToQueue(sku, quantityToAdd);
        await localDataSource.updateLocalProductStock(sku, quantityToAdd);
        return const Right(OperationResult(isQueued: true));
      } on Exception {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, OperationResult>> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      sku: product.sku,
      quantity: product.quantity,
    );
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProduct(productModel);
        await localDataSource.updateProduct(productModel);
        return const Right(OperationResult(isQueued: false));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Offline update - queue it
      try {
        await localDataSource.addProductUpdateToQueue(productModel);
        await localDataSource.updateProduct(productModel);
        return const Right(OperationResult(isQueued: true));
      } on Exception {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, OperationResult>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        await localDataSource.deleteProduct(id);
        return const Right(OperationResult(isQueued: false));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Offline delete - queue it
      try {
        await localDataSource.addProductDeletionToQueue(id);
        await localDataSource.deleteProduct(id);
        return const Right(OperationResult(isQueued: true));
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
          await localDataSource.updateProductId(creation['local_id'], remoteProduct.id);
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

    // Sync product updates
    final pendingUpdates = await localDataSource.getQueuedProductUpdates();
    if (pendingUpdates.isNotEmpty) {
      for (final update in pendingUpdates) {
        try {
          final productModel = ProductModel(
            id: update['product_id'],
            name: update['name'],
            sku: update['sku'],
            quantity: update['quantity'],
          );
          await remoteDataSource.updateProduct(productModel);
        } catch (e) {
          // Handle update sync failure
        }
      }
      await localDataSource.clearQueuedProductUpdates();
    }

    // Sync product deletions
    final pendingDeletions = await localDataSource.getQueuedProductDeletions();
    if (pendingDeletions.isNotEmpty) {
      for (final deletion in pendingDeletions) {
        try {
          await remoteDataSource.deleteProduct(deletion['product_id']);
        } catch (e) {
          // Handle deletion sync failure
        }
      }
      await localDataSource.clearQueuedProductDeletions();
    }
  }
}
