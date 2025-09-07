import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/data/models/order_line_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.customerName,
    required super.status,
    required super.lines,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var linesList = json['lines'] as List? ?? [];
    List<OrderLineModel> lines = linesList.map((i) => OrderLineModel.fromJson(i)).toList();

    return OrderModel(
      id: json['id'].toString(),
      customerName: json['customer_name'],
      status: OrderStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => OrderStatus.open),
      lines: lines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'status': status.name,
      'lines': lines.map((line) => (line as OrderLineModel).toJson()).toList(),
    };
  }

  Map<String, dynamic> toJsonForDb() {
    return {
      'id': id,
      'customer_name': customerName,
      'status': status.index, // Save status as integer index for DB
    };
  }
}