part of 'product_creation_bloc.dart';

abstract class ProductCreationEvent extends Equatable {
  const ProductCreationEvent();

  @override
  List<Object?> get props => [];
}

class ProductCreateRequested extends ProductCreationEvent {
  final String name;
  final String sku;
  final String? location;
  final String? imageUrl;

  const ProductCreateRequested({
    required this.name,
    required this.sku,
    this.location,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, sku, location, imageUrl];
}