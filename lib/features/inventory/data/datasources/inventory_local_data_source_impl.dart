import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

const String _tableProducts = 'products';
const String _tableStockUpdatesQueue = 'stock_updates_queue';
const String _tableProductCreationsQueue = 'product_creations_queue';
const String _tableProductUpdatesQueue = 'product_updates_queue';
const String _tableProductDeletionsQueue = 'product_deletions_queue';

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Database database;

  InventoryLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await database.transaction((txn) async {
      final batch = txn.batch();
      batch.delete(_tableProducts); // Clear old cache
      for (final product in products) {
        batch.insert(_tableProducts, product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final List<Map<String, dynamic>> maps = await database.query(_tableProducts);
    return List.generate(maps.length, (i) {
      return ProductModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> addStockToQueue(String sku, int quantity) async {
    await database.insert(_tableStockUpdatesQueue, {
      'sku': sku,
      'quantity': quantity,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getQueuedStockUpdates() async {
    return await database.query(_tableStockUpdatesQueue, orderBy: 'timestamp ASC');
  }

  @override
  Future<void> clearQueuedStockUpdates() async {
    await database.delete(_tableStockUpdatesQueue);
  }

  @override
  Future<void> updateLocalProductStock(String sku, int quantity) async {
    await database.rawUpdate(
      'UPDATE $_tableProducts SET quantity = quantity + ? WHERE sku = ?',
      [quantity, sku],
    );
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    await database.insert(
      _tableProducts,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> addProductCreationToQueue(String name, String sku, String? location, String localId) async {
    await database.insert(_tableProductCreationsQueue, {
      'name': name,
      'sku': sku,
      'location': location,
      'local_id': localId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getQueuedProductCreations() async {
    return await database.query(_tableProductCreationsQueue, orderBy: 'timestamp ASC');
  }

  @override
  Future<void> clearQueuedProductCreations() async {
    await database.delete(_tableProductCreationsQueue);
  }

  @override
  Future<void> updateProductId(String oldId, String newId) async {
    await database.rawUpdate(
      'UPDATE $_tableProducts SET id = ? WHERE id = ?',
      [newId, oldId],
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await database.update(
      _tableProducts,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await database.delete(
      _tableProducts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> addProductUpdateToQueue(ProductModel product) async {
    await database.insert(_tableProductUpdatesQueue, {
      'product_id': product.id,
      'name': product.name,
      'sku': product.sku,
      'quantity': product.quantity,
      'location': product.location,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getQueuedProductUpdates() async {
    return await database.query(_tableProductUpdatesQueue, orderBy: 'timestamp ASC');
  }

  @override
  Future<void> clearQueuedProductUpdates() async {
    await database.delete(_tableProductUpdatesQueue);
  }

  @override
  Future<void> addProductDeletionToQueue(String id) async {
    await database.insert(_tableProductDeletionsQueue, {
      'product_id': id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getQueuedProductDeletions() async {
    return await database.query(_tableProductDeletionsQueue, orderBy: 'timestamp ASC');
  }

  @override
  Future<void> clearQueuedProductDeletions() async {
    await database.delete(_tableProductDeletionsQueue);
  }
}
