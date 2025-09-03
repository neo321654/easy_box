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
  final ProductDetailSuccessType type;
  final Product? updatedProduct;
  final bool isQueued; // Added

  const ProductDetailSuccess({required this.type, this.updatedProduct, this.isQueued = false}); // Added

  @override
  List<Object> get props => [type, updatedProduct ?? 'null', isQueued]; // Added isQueued
}

abstract class ProductDetailFailure extends ProductDetailState {
  const ProductDetailFailure();

  @override
  List<Object> get props => [];
}

class ProductUpdateFailure extends ProductDetailFailure {
  const ProductUpdateFailure();
}

class ProductDeleteFailure extends ProductDetailFailure {
  const ProductDeleteFailure();
}