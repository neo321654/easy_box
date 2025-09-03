import 'package:collection/collection.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  // Mock database table.
  static final List<ProductModel> _products = [
    const ProductModel(id: '1', name: 'Red T-Shirt, Size L', sku: 'SKU-TS-RED-L', quantity: 150),
    const ProductModel(id: '2', name: 'Blue Jeans, Size 32', sku: 'SKU-JN-BLU-32', quantity: 85),
    const ProductModel(id: '3', name: 'Green Hoodie, Size M', sku: 'SKU-HD-GRN-M', quantity: 110),
    const ProductModel(id: '4', name: 'Black Sneakers, Size 42', sku: 'SKU-SN-BLK-42', quantity: 200),
    const ProductModel(id: '5', name: 'White Socks (3-pack)', sku: 'SKU-SK-WHT-3P', quantity: 350),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  @override
  Future<ProductModel?> findProductBySku(String sku) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.firstWhereOrNull((product) => product.sku == sku);
  }

  @override
  Future<void> addStock(String sku, int quantityToAdd) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final productIndex = _products.indexWhere((p) => p.sku == sku);

    if (productIndex != -1) {
      final oldProduct = _products[productIndex];
      final newProduct = ProductModel(
        id: oldProduct.id,
        name: oldProduct.name,
        sku: oldProduct.sku,
        quantity: oldProduct.quantity + quantityToAdd,
      );
      _products[productIndex] = newProduct;
    } else {
      throw ProductNotFoundException(sku);
    }
  }

  @override
  Future<ProductModel> createProduct({required String name, required String sku}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID
      name: name,
      sku: sku,
      quantity: 0, // Initial quantity is 0
    );
    _products.add(newProduct);
    return newProduct;
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      throw ServerException(); // Product not found on remote
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    if (_products.length == initialLength) {
      throw ServerException(); // Product not found on remote
    }
  }
}