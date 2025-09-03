part of 'scanning_bloc.dart';

abstract class ScanningEvent extends Equatable {
  const ScanningEvent();

  @override
  List<Object> get props => [];
}

class BarcodeDetected extends ScanningEvent {
  final String sku;

  const BarcodeDetected(this.sku);

  @override
  List<Object> get props => [sku];
}
