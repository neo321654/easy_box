import 'dart:convert';

import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/features/order/data/datasources/order_local_data_source.dart';
import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/data/models/order_line_model.dart';
import 'package:easy_box/features/order/data/models/order_model.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        await _syncPendingUpdates();
        final remoteOrders = await remoteDataSource.getOrders();
        await localDataSource.cacheOrders(remoteOrders);
        return Right(remoteOrders);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localOrders = await localDataSource.getLastOrders();
        return Right(localOrders);
      } on Exception {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateOrder(Order order) async {
    final orderModel = OrderModel(
      id: order.id,
      customerName: order.customerName,
      status: order.status,
      lines: order.lines,
    );
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateOrder(orderModel);
        await localDataSource.updateOrder(orderModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.addOrderUpdateToQueue(orderModel);
        await localDataSource.updateOrder(orderModel);
        return const Right(null);
      } on Exception {
        return Left(CacheFailure());
      }
    }
  }

  Future<void> _syncPendingUpdates() async {
    final pendingUpdates = await localDataSource.getQueuedOrderUpdates();
    if (pendingUpdates.isNotEmpty) {
      // Fetch all local orders to find the customer name.
      final localOrders = await localDataSource.getLastOrders();
      final ordersMap = {for (var o in localOrders) o.id: o};

      for (final update in pendingUpdates) {
        final lines = (jsonDecode(update['lines']) as List)
            .map((line) => OrderLineModel.fromJson(line))
            .toList();
        
        final orderId = update['order_id'] as String;
        final existingOrder = ordersMap[orderId];

        final order = OrderModel(
          id: orderId,
          customerName: existingOrder?.customerName ?? 'N/A', // Use fetched name
          status: OrderStatus.values[update['status']],
          lines: lines,
        );
        await remoteDataSource.updateOrder(order);
      }
      await localDataSource.clearQueuedOrderUpdates();
    }
  }
}
