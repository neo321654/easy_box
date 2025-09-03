import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class CreateProductUseCase {
  final InventoryRepository repository;

  CreateProductUseCase(this.repository);

  Future<Either<Failure, Product>> call({required String name, required String sku}) {
    return repository.createProduct(name: name, sku: sku);
  }
}
