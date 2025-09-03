import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class UpdateProductUseCase {
  final InventoryRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.updateProduct(product);
  }
}
