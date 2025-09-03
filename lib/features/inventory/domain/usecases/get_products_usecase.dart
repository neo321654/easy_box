import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class GetProductsUseCase {
  final InventoryRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}