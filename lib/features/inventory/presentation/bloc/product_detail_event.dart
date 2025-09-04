part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class UpdateProductRequested extends ProductDetailEvent {
  final Product product;

  const UpdateProductRequested(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProductRequested extends ProductDetailEvent {
  final String id;

  const DeleteProductRequested(this.id);

  @override
  List<Object> get props => [id];
}
