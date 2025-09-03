import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class AddStockUseCase {
  final InventoryRepository repository;

  AddStockUseCase(this.repository);

  Future<Either<Failure, OperationResult>> call({required String sku, required int quantity}) {
    return repository.addStock(sku, quantity);
  }
}
