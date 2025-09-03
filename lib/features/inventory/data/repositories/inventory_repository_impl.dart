import 'package:collection/collection.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  // Mock database table
  final _products = const [
    Product(id: '1', name: 'Red T-Shirt, Size L', sku: 'SKU-TS-RED-L', quantity: 150),
    Product(id: '2', name: 'Blue Jeans, Size 32', sku: 'SKU-JN-BLU-32', quantity: 85),
    Product(id: '3', name: 'Green Hoodie, Size M', sku: 'SKU-HD-GRN-M', quantity: 110),
    Product(id: '4', name: 'Black Sneakers, Size 42', sku: 'SKU-SN-BLK-42', quantity: 200),
    Product(id: '5', name: 'White Socks (3-pack)', sku: 'SKU-SK-WHT-3P', quantity: 350),
  ];

  @override
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  @override
  Future<Product?> findProductBySku(String sku) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // Find the product in the mock list
    return _products.firstWhereOrNull((product) => product.sku == sku);
  }
}