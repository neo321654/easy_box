import 'package:equatable/equatable.dart';
import 'package:easy_box/features/order/domain/entities/order_line.dart';

enum OrderStatus { open, inProgress, picked, cancelled }

class Order extends Equatable {
  final String id;
  final String customerName;
  final OrderStatus status;
  final List<OrderLine> lines;

  const Order({
    required this.id,
    required this.customerName,
    required this.status,
    required this.lines,
  });

  @override
  List<Object> get props => [id, customerName, status, lines];
}