import 'package:easy_box/features/inventory/domain/entities/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();
  Future<Product?> findProductBySku(String sku);
  Future<void> addStock(String sku, int quantityToAdd);
}
