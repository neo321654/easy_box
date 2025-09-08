import 'package:easy_box/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> updateOrder(OrderModel order);
}
