import 'package:easy_box/features/inventory/data/models/product_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> findProductBySku(String sku);
  Future<void> addStock(String sku, int quantityToAdd);
  Future<ProductModel> createProduct({required String name, required String sku});
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}