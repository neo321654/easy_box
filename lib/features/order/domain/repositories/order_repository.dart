import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
}