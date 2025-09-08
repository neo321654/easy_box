import 'dart:convert';

import 'package:easy_box/features/order/data/datasources/order_local_data_source.dart';
import 'package:easy_box/features/order/data/models/order_line_model.dart';
import 'package:easy_box/features/order/data/models/order_model.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:sqflite/sqflite.dart';

const String _tableOrders = 'orders';
const String _tableOrderLines = 'order_lines';
const String _tableOrderUpdatesQueue = 'order_updates_queue';

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Database database;

  OrderLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    await database.transaction((txn) async {
      final batch = txn.batch();
      batch.delete(_tableOrders);
      batch.delete(_tableOrderLines);
      for (final order in orders) {
        // Use toJsonForDb which excludes lines and uses int for status
        batch.insert(
          _tableOrders,
          order.toJsonForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        for (final line in order.lines) {
          final lineModel = line as OrderLineModel;
          batch.insert(_tableOrderLines, {
            'order_id': order.id,
            ...lineModel.toJson(),
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<List<OrderModel>> getLastOrders() async {
    final List<Map<String, dynamic>> orderMaps = await database.query(
      _tableOrders,
    );
    final List<OrderModel> orders = [];
    for (final orderMap in orderMaps) {
      final List<Map<String, dynamic>> lineMaps = await database.query(
        _tableOrderLines,
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );

      final fullOrderMap = Map<String, dynamic>.from(orderMap);
      // Convert integer status from DB back to String for the fromJson factory
      final statusIndex = fullOrderMap['status'] as int;
      fullOrderMap['status'] = OrderStatus.values[statusIndex].name;

      // The fromJson method on OrderModel expects the lines to be in the map.
      // The local database stores them separately, so we add them to the map here.
      fullOrderMap['lines'] = lineMaps;
      orders.add(OrderModel.fromJson(fullOrderMap));
    }
    return orders;
  }

  @override
  Future<void> addOrderUpdateToQueue(OrderModel order) async {
    await database.insert(_tableOrderUpdatesQueue, {
      'order_id': order.id,
      'status': order.status.index,
      'lines': jsonEncode(
        order.lines.map((line) => (line as OrderLineModel).toJson()).toList(),
      ),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getQueuedOrderUpdates() async {
    return await database.query(
      _tableOrderUpdatesQueue,
      orderBy: 'timestamp ASC',
    );
  }

  @override
  Future<void> clearQueuedOrderUpdates() async {
    await database.delete(_tableOrderUpdatesQueue);
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    await database.transaction((txn) async {
      final batch = txn.batch();
      // Use toJsonForDb to correctly update the status as an integer
      batch.update(
        _tableOrders,
        order.toJsonForDb(),
        where: 'id = ?',
        whereArgs: [order.id],
      );
      batch.delete(
        _tableOrderLines,
        where: 'order_id = ?',
        whereArgs: [order.id],
      );
      for (final line in order.lines) {
        // Robustly handle both OrderLine and OrderLineModel types
        final lineJson = (line is OrderLineModel)
            ? line.toJson()
            : OrderLineModel(
                productId: line.productId,
                productName: line.productName,
                sku: line.sku,
                location: line.location,
                quantityToPick: line.quantityToPick,
                quantityPicked: line.quantityPicked,
                imageUrl: line.imageUrl,
              ).toJson();

        batch.insert(_tableOrderLines, {
          'order_id': order.id,
          ...lineJson,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }
}
