import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class AddStockUseCase {
  final InventoryRepository repository;

  AddStockUseCase(this.repository);

  Future<void> call({
    required String sku,
    required int quantityToAdd,
  }) {
    return repository.addStock(sku, quantityToAdd);
  }
}
