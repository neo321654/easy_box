part of 'product_detail_bloc.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final String message;

  const ProductDetailSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ProductDetailFailure extends ProductDetailState {
  final String message;

  const ProductDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
