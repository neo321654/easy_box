part of 'receiving_bloc.dart';

abstract class ReceivingState extends Equatable {
  const ReceivingState();

  @override
  List<Object> get props => [];
}

class ReceivingInitial extends ReceivingState {}

class ReceivingLoading extends ReceivingState {}

class ReceivingSuccess extends ReceivingState {
  final String successMessage;
  final bool isQueued; // Added

  const ReceivingSuccess(this.successMessage, {this.isQueued = false}); // Added

  @override
  List<Object> get props => [successMessage, isQueued]; // Added isQueued
}

class ReceivingFailure extends ReceivingState {
  final String errorMessage;

  const ReceivingFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ReceivingProductNotFound extends ReceivingState {
  final String sku;

  const ReceivingProductNotFound(this.sku);

  @override
  List<Object> get props => [sku];
}