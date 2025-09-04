part of 'product_creation_bloc.dart';

abstract class ProductCreationState extends Equatable {
  const ProductCreationState();

  @override
  List<Object> get props => [];
}

class ProductCreationInitial extends ProductCreationState {}

class ProductCreationLoading extends ProductCreationState {}

class ProductCreationSuccess extends ProductCreationState {
  final bool isQueued;

  const ProductCreationSuccess({this.isQueued = false});

  @override
  List<Object> get props => [isQueued];
}

class ProductCreationFailure extends ProductCreationState {
  final String message;

  const ProductCreationFailure({this.message = 'Failed to create product.'});

  @override
  List<Object> get props => [message];
}