import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class FindProductBySkuUseCase {
  final InventoryRepository repository;

  FindProductBySkuUseCase(this.repository);

  Future<Product?> call(String sku) {
    return repository.findProductBySku(sku);
  }
}
