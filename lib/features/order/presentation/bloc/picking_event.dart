part of 'picking_bloc.dart';

abstract class PickingEvent extends Equatable {
  const PickingEvent();

  @override
  List<Object> get props => [];
}

class InitializePicking extends PickingEvent {
  final Order order;

  const InitializePicking(this.order);

  @override
  List<Object> get props => [order];
}

class LineItemPicked extends PickingEvent {
  final String productId;
  final int quantity;

  const LineItemPicked({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class PickingCompleted extends PickingEvent {}

class BarcodeScanned extends PickingEvent {
  final String sku;

  const BarcodeScanned(this.sku);

  @override
  List<Object> get props => [sku];
}
