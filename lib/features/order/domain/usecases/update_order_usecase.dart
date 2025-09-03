import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/domain/repositories/order_repository.dart';

class UpdateOrderUseCase {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(Order order) {
    return repository.updateOrder(order);
  }
}