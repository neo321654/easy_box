import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

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
        // ignore: avoid_print
        print('[DEBUG] Fetched remote products: ${remoteProducts.map((p) => 'SKU: ${p.sku}, Img: ${p.imageUrl}, Thumb: ${p.thumbnailUrl}').toList()}');
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

  Future<String?> _copyImageToPermanentStorage(String? imagePath) async {
    if (imagePath == null) return null;

    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(imagePath);
      final newPath = p.join(appDir.path, 'product_images', fileName);

      final newFile = File(newPath);
      await newFile.create(recursive: true);
      await file.copy(newFile.path);

      return newPath;
    } catch (e) {
      // Handle exceptions, e.g., file system errors
      return null;
    }
  }

  @override
  Future<Either<Failure, OperationResult>> createProduct(
      {required String name, required String sku, String? location, String? imageUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final newProduct = await remoteDataSource.createProduct(
          name: name,
          sku: sku,
          location: location,
          imageUrl: imageUrl,
        );
        await localDataSource.saveProduct(newProduct);
        return const Right(OperationResult(isQueued: false));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e, st) {
        sl<Talker>().handle(e, st, '[InventoryRepository] Failed to create product');
        return Left(ServerFailure());
      }
    } else {
      // Offline creation
      try {
        final permanentImageUrl = await _copyImageToPermanentStorage(imageUrl);
        final localId = const Uuid().v4(); // Generate a temporary local ID
        final newProduct = ProductModel(id: localId, name: name, sku: sku, quantity: 0, location: location, imageUrl: permanentImageUrl);
        await localDataSource.saveProduct(newProduct);
        await localDataSource.addProductCreationToQueue(name, sku, location, permanentImageUrl, localId);
        return const Right(OperationResult(isQueued: true));
      } on Exception {
        return Left(CacheFailure());
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
    Product productToUpdate = product;

    // Check if the imageUrl is a new local file path that needs uploading
    // It should NOT be null, empty, start with 'http', or start with '/images/' (which is a server-relative path)
    if (product.imageUrl != null &&
        product.imageUrl!.isNotEmpty &&
        !product.imageUrl!.startsWith('http') &&
        !product.imageUrl!.startsWith('/images/')) {
      if (await networkInfo.isConnected) {
        try {
          final uploadedProduct = await remoteDataSource.uploadProductImage(product.id, product.imageUrl!);
          // Update the product instance with the new remote image URL
          productToUpdate = Product(
            id: product.id,
            name: product.name,
            sku: product.sku,
            quantity: product.quantity,
            location: product.location,
            imageUrl: uploadedProduct.imageUrl,
          );
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        // Cannot upload new image offline, but we can save the local path for later sync
        final permanentImageUrl = await _copyImageToPermanentStorage(product.imageUrl);
        productToUpdate = Product(
          id: product.id,
          name: product.name,
          sku: product.sku,
          quantity: product.quantity,
          location: product.location,
          imageUrl: permanentImageUrl,
        );
      }
    }

    final productModel = ProductModel(
      id: productToUpdate.id,
      name: productToUpdate.name,
      sku: productToUpdate.sku,
      quantity: productToUpdate.quantity,
      location: productToUpdate.location,
      imageUrl: productToUpdate.imageUrl,
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
      }
      on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Offline delete - queue it
      try {
        await localDataSource.addProductDeletionToQueue(id);
        await localDataSource.deleteProduct(id);
        return const Right(OperationResult(isQueued: true));
      }
      on Exception {
        return Left(CacheFailure());
      }
    }
  }

  Future<void> _syncPendingUpdates() async {
    // Sync product creations first
    final pendingCreations = await localDataSource.getQueuedProductCreations();
    if (pendingCreations.isNotEmpty) {
      for (final creation in pendingCreations) {
        final localImagePath = creation['image_url'] as String?;
        final remoteProduct = await remoteDataSource.createProduct(
          name: creation['name'],
          sku: creation['sku'],
          location: creation['location'],
          imageUrl: localImagePath,
        );
        // Instead of just updating the ID, we delete the old temp product
        // and save the new, complete product from the server.
        await localDataSource.deleteProduct(creation['local_id']);
        await localDataSource.saveProduct(remoteProduct);
      }
      await localDataSource.clearQueuedProductCreations();
    }

    // Sync stock updates
    final pendingStockUpdates = await localDataSource.getQueuedStockUpdates();
    if (pendingStockUpdates.isNotEmpty) {
      for (final update in pendingStockUpdates) {
        await remoteDataSource.addStock(update['sku'], update['quantity']);
      }
      await localDataSource.clearQueuedStockUpdates();
    }

    // Sync product updates
    final pendingUpdates = await localDataSource.getQueuedProductUpdates();
    if (pendingUpdates.isNotEmpty) {
      for (final update in pendingUpdates) {
        final productModel = ProductModel(
          id: update['product_id'],
          name: update['name'],
          sku: update['sku'],
          quantity: update['quantity'],
          location: update['location'],
          imageUrl: update['image_url'],
        );
        await remoteDataSource.updateProduct(productModel);
      }
      await localDataSource.clearQueuedProductUpdates();
    }

    // Sync product deletions
    final pendingDeletions = await localDataSource.getQueuedProductDeletions();
    if (pendingDeletions.isNotEmpty) {
      for (final deletion in pendingDeletions) {
        await remoteDataSource.deleteProduct(deletion['product_id']);
      }
      await localDataSource.clearQueuedProductDeletions();
    }
  }
}
