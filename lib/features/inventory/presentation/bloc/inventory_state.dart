part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventorySuccess extends InventoryState {
  final List<Product> products;

  const InventorySuccess(this.products);

  @override
  List<Object> get props => [products];
}

class InventoryFailure extends InventoryState {
  final String message;

  const InventoryFailure(this.message);

  @override
  List<Object> get props => [message];
}