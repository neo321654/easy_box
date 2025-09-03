import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class DeleteProductUseCase {
  final InventoryRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, OperationResult>> call(String id) {
    return repository.deleteProduct(id);
  }
}