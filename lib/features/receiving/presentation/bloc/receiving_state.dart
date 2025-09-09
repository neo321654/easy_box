part of 'receiving_bloc.dart';

abstract class ReceivingState extends Equatable {
  const ReceivingState();

  @override
  List<Object?> get props => [];
}

class ReceivingInitial extends ReceivingState {}

class ReceivingLoading extends ReceivingState {}

class ReceivingSuccess extends ReceivingState {
  final String sku;
  final bool isQueued;
  final bool productCreated;

  const ReceivingSuccess({
    required this.sku,
    this.isQueued = false,
    this.productCreated = false,
  });

  @override
  List<Object> get props => [sku, isQueued, productCreated];
}

abstract class ReceivingFailure extends ReceivingState {
  const ReceivingFailure();

  @override
  List<Object?> get props => [];
}

class AddStockFailure extends ReceivingFailure {
  const AddStockFailure();
}

class CreateProductFailure extends ReceivingFailure {
  final String? message;
  final String? sku;

  const CreateProductFailure({this.message, this.sku});

  @override
  List<Object?> get props => [message, sku];
}

class AddStockAfterCreateFailure extends ReceivingFailure {
  const AddStockAfterCreateFailure();
}

class ReceivingProductNotFound extends ReceivingState {
  final String sku;

  const ReceivingProductNotFound(this.sku);

  @override
  List<Object> get props => [sku];
}
