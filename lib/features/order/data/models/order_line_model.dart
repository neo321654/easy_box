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
    final productValue = json['product'];

    // Provide default values for quantities if they are null
    final quantityToPick = json['quantity_to_pick'] as int? ?? 0;
    final quantityPicked = json['quantity_picked'] as int? ?? 0;

    if (productValue is Map<String, dynamic>) {
      // Correct case (from spec or fixed local data source)
      final productData = productValue;
      return OrderLineModel(
        productId: productData['id'].toString(),
        productName: productData['name'],
        sku: productData['sku'],
        location: productData['location'],
        imageUrl: productData['image_url'],
        quantityToPick: quantityToPick,
        quantityPicked: quantityPicked,
      );
    } else if (productValue is int) {
      // Workaround for backend bug
      return OrderLineModel(
        productId: productValue.toString(),
        productName: 'Unknown Product (ID: $productValue)',
        sku: 'SKU-UNKNOWN',
        quantityToPick: quantityToPick,
        quantityPicked: quantityPicked,
      );
    } else {
      // If product is null or some other type, or doesn't exist.
      throw FormatException('Invalid format for product data in OrderLine: $json');
    }
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

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'product': int.tryParse(productId),
      'quantity_to_pick': quantityToPick,
      'quantity_picked': quantityPicked,
    };
  }
}
