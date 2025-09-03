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
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } on ServerException {
        // If server fails, do nothing, just fall through to load from cache.
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
    // For this method, we might always want to check online first if possible,
    // or check cache first. Let's assume online-first for now.
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.findProductBySku(sku);
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Sku lookup offline is not implemented in this scenario, returning failure.
      return Left(ServerFailure()); // Or a specific NetworkFailure
    }
  }

  @override
  Future<Either<Failure, void>> addStock(String sku, int quantityToAdd) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addStock(sku, quantityToAdd);
        // Optionally, invalidate or update cache here
        return Right(result);
      } on ProductNotFoundException {
        return Left(ServerFailure()); // Or a more specific failure
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure()); // Or a specific NetworkFailure
    }
  }
}
