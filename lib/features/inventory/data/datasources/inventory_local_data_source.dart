import 'package:easy_box/features/inventory/data/models/product_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> addStockToQueue(String sku, int quantity);
  Future<List<Map<String, dynamic>>> getQueuedStockUpdates();
  Future<void> clearQueuedStockUpdates();
  Future<void> updateLocalProductStock(String sku, int quantity);
  Future<void> saveProduct(ProductModel product);

  // New methods for product creation queue
  Future<void> addProductCreationToQueue(String name, String sku, String localId);
  Future<List<Map<String, dynamic>>> getQueuedProductCreations();
  Future<void> clearQueuedProductCreations();
  Future<void> updateProductId(String oldId, String newId);
}
