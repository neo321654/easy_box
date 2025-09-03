import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/data/models/order_line_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.customerName,
    required super.status,
    required super.lines,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, List<OrderLineModel> lines) {
    return OrderModel(
      id: json['id'],
      customerName: json['customer_name'],
      status: OrderStatus.values[json['status']],
      lines: lines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'status': status.index,
    };
  }
}