import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class CreateProductUseCase {
  final InventoryRepository repository;

  CreateProductUseCase(this.repository);

  Future<Either<Failure, OperationResult>> call({
    required String name,
    required String sku,
    String? location,
    String? imageUrl,
  }) {
    return repository.createProduct(
      name: name,
      sku: sku,
      location: location,
      imageUrl: imageUrl,
    );
  }
}
