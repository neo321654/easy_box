import 'package:easy_box/features/order/domain/entities/order_line.dart';

class OrderLineModel extends OrderLine {
  const OrderLineModel({
    required super.productId,
    required super.productName,
    required super.sku,
    super.location,
    required super.quantityToPick,
    super.quantityPicked,
    super.imageUrl,
  });

  factory OrderLineModel.fromJson(Map<String, dynamic> json) {
    // The backend sends a nested product object. We need to parse it.
    final productData = json['product'] as Map<String, dynamic>;

    return OrderLineModel(
      // Get the ID from the nested product object and convert it to a string.
      productId: productData['id'].toString(),

      // Get product details from the nested object.
      productName: productData['name'],
      sku: productData['sku'],
      location: productData['location'],
      imageUrl: productData['image_url'],

      // Get quantities from the top-level line item object.
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
      'image_url': imageUrl,
    };
  }
}
