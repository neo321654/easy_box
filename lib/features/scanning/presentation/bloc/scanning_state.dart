part of 'scanning_bloc.dart';

abstract class ScanningState extends Equatable {
  const ScanningState();

  @override
  List<Object> get props => [];
}

// The scanner is ready and waiting for a barcode
class ScanningInitial extends ScanningState {}

// We've detected a barcode and are looking for the product
class ScanningLoading extends ScanningState {}

// We found the product associated with the barcode
class ScanningProductFound extends ScanningState {
  final Product product;

  const ScanningProductFound(this.product);

  @override
  List<Object> get props => [product];
}

// We scanned a barcode, but no product was found with that SKU
class ScanningProductNotFound extends ScanningState {}

// An error occurred during the process
class ScanningFailure extends ScanningState {
  final String message;

  const ScanningFailure(this.message);

  @override
  List<Object> get props => [message];
}