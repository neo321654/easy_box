part of 'product_detail_bloc.dart';

enum ProductDetailSuccessType {
  updated,
  deleted,
}

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  final String message;
  final ProductDetailSuccessType type;
  final Product? updatedProduct;
  final bool isQueued; // Added

  const ProductDetailSuccess(this.message, {required this.type, this.updatedProduct, this.isQueued = false}); // Added

  @override
  List<Object> get props => [message, type, updatedProduct ?? 'null', isQueued]; // Added isQueued
}

class ProductDetailFailure extends ProductDetailState {
  final String message;

  const ProductDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}