import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product?>> findProductBySku(String sku);
  Future<Either<Failure, void>> addStock(String sku, int quantityToAdd);
  Future<Either<Failure, Product>> createProduct({required String name, required String sku});
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}
