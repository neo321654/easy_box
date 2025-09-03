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