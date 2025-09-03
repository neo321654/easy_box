import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String sku;
  final int quantity;
  final String? location;

  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    this.location,
  });

  @override
  List<Object?> get props => [id, name, sku, quantity, location];
}
