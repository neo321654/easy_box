import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product?>> findProductBySku(String sku);
  Future<Either<Failure, OperationResult>> addStock(
    String sku,
    int quantityToAdd,
  );
  Future<Either<Failure, OperationResult>> createProduct({
    required String name,
    required String sku,
    String? location,
    String? imageUrl,
  });
  Future<Either<Failure, OperationResult>> updateProduct(Product product);
  Future<Either<Failure, OperationResult>> deleteProduct(String id);
}
