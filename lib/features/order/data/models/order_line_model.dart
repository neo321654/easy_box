import 'package:easy_box/features/order/domain/entities/order_line.dart';

class OrderLineModel extends OrderLine {
  const OrderLineModel({
    required super.productId,
    required super.productName,
    required super.sku,
    super.location,
    required super.quantityToPick,
    super.quantityPicked,
  });

  factory OrderLineModel.fromJson(Map<String, dynamic> json) {
    return OrderLineModel(
      productId: json['product_id'],
      productName: json['product_name'],
      sku: json['sku'],
      location: json['location'],
      quantityToPick: json['quantity_to_pick'],
      quantityPicked: json['quantity_picked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'location': location,
      'quantity_to_pick': quantityToPick,
      'quantity_picked': quantityPicked,
    };
  }
}