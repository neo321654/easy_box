import 'package:easy_box/features/inventory/data/models/product_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}
