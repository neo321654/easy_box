import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String sku;
  final int quantity;
  final String? location;
  final String? imageUrl;
  final String? thumbnailUrl;

  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    this.location,
    this.imageUrl,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    quantity,
    location,
    imageUrl,
    thumbnailUrl,
  ];
}
