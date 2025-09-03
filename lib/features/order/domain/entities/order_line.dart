import 'package:equatable/equatable.dart';

class OrderLine extends Equatable {
  final String productId;
  final String productName;
  final String sku;
  final String? location;
  final int quantityToPick;
  final int quantityPicked;

  const OrderLine({
    required this.productId,
    required this.productName,
    required this.sku,
    this.location,
    required this.quantityToPick,
    this.quantityPicked = 0,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        sku,
        location,
        quantityToPick,
        quantityPicked,
      ];
}