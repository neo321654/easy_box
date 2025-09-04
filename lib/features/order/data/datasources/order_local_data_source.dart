import 'package:easy_box/features/order/data/models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getLastOrders();
  Future<void> cacheOrders(List<OrderModel> orders);
  Future<void> addOrderUpdateToQueue(OrderModel order);
  Future<List<Map<String, dynamic>>> getQueuedOrderUpdates();
  Future<void> clearQueuedOrderUpdates();
  Future<void> updateOrder(OrderModel order);
}
