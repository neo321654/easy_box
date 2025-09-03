import 'package:easy_box/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

const String _tableProducts = 'products';
const String _tableStockUpdatesQueue = 'stock_updates_queue';

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Database database;

  InventoryLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await database.transaction((txn) async {
      final batch = txn.batch();
      batch.delete(_tableProducts); // Clear old cache
      for (final product in products) {
        batch.insert(_tableProducts, product.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
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
}