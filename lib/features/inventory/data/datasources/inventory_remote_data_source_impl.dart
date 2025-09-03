import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final Database database;

  InventoryRemoteDataSourceImpl({required this.database});

  @override
  Future<List<ProductModel>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    final List<Map<String, dynamic>> maps = await database.query('products');
    return List.generate(maps.length, (i) {
      return ProductModel.fromJson(maps[i]);
    });
  }

  @override
  Future<ProductModel?> findProductBySku(String sku) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'sku = ?',
      whereArgs: [sku],
    );
    if (maps.isNotEmpty) {
      return ProductModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> addStock(String sku, int quantityToAdd) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'sku = ?',
      whereArgs: [sku],
    );

    if (maps.isNotEmpty) {
      final oldProduct = ProductModel.fromJson(maps.first);
      final newQuantity = oldProduct.quantity + quantityToAdd;
      await database.update(
        'products',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [oldProduct.id],
      );
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
    await database.insert('products', newProduct.toJson());
    return newProduct;
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final rowsAffected = await database.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
    if (rowsAffected == 0) {
      throw ServerException(); // Product not found on remote
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final rowsAffected = await database.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rowsAffected == 0) {
      throw ServerException(); // Product not found on remote
    }
  }
}