part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class ProductUpdated extends ProductDetailEvent {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object> get props => [product];
}

class ProductDeleted extends ProductDetailEvent {
  final String id;

  const ProductDeleted(this.id);

  @override
  List<Object> get props => [id];
}
