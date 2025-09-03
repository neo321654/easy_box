part of 'receiving_bloc.dart';

abstract class ReceivingEvent extends Equatable {
  const ReceivingEvent();

  @override
  List<Object> get props => [];
}

class StockAdded extends ReceivingEvent {
  final String sku;
  final int quantity;

  const StockAdded({
    required this.sku,
    required this.quantity,
  });

  @override
  List<Object> get props => [sku, quantity];
}

class CreateProductAndAddStock extends ReceivingEvent {
  final String name;
  final String sku;
  final int quantity;
  final String? location;

  const CreateProductAndAddStock({
    required this.name,
    required this.sku,
    required this.quantity,
    this.location,
  });

  @override
  List<Object?> get props => [name, sku, quantity, location];
}
