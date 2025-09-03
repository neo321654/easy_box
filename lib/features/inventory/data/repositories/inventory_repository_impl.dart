import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
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
        await _syncPendingStockUpdates();
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
      return Left(ServerFailure()); // Or a specific NetworkFailure
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(
      {required String name, required String sku}) async {
    if (await networkInfo.isConnected) {
      try {
        final newProduct = await remoteDataSource.createProduct(name: name, sku: sku);
        return Right(newProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure()); // Or a specific NetworkFailure
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

  Future<void> _syncPendingStockUpdates() async {
    final pendingUpdates = await localDataSource.getQueuedStockUpdates();
    if (pendingUpdates.isNotEmpty) {
      for (final update in pendingUpdates) {
        try {
          await remoteDataSource.addStock(update['sku'], update['quantity']);
        } catch (e) {
          // In a real app, we might want to handle this more gracefully,
          // e.g., retry logic, or marking specific updates as failed.
          // For now, we'll assume it continues and will be cleared.
        }
      }
      await localDataSource.clearQueuedStockUpdates();
    }
  }
}