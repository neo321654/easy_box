import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class FindProductBySkuUseCase {
  final InventoryRepository repository;

  FindProductBySkuUseCase(this.repository);

  Future<Either<Failure, Product?>> call(String sku) {
    return repository.findProductBySku(sku);
  }
}