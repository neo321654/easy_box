import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class UpdateProductUseCase {
  final InventoryRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, OperationResult>> call(Product product) {
    return repository.updateProduct(product);
  }
}