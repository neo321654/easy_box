import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/usecases/add_stock_usecase.dart';

part 'receiving_event.dart';
part 'receiving_state.dart';

class ReceivingBloc extends Bloc<ReceivingEvent, ReceivingState> {
  final AddStockUseCase _addStockUseCase;

  ReceivingBloc({required AddStockUseCase addStockUseCase})
      : _addStockUseCase = addStockUseCase,
        super(ReceivingInitial()) {
    on<StockAdded>(_onStockAdded);
  }

  Future<void> _onStockAdded(
    StockAdded event,
    Emitter<ReceivingState> emit,
  ) async {
    emit(ReceivingLoading());

    final failureOrSuccess = await _addStockUseCase(
      sku: event.sku,
      quantity: event.quantity,
    );

    failureOrSuccess.fold(
      (failure) => emit(const ReceivingFailure('Failed to add stock.')), // TODO: Localize
      (_) => emit(ReceivingSuccess('Stock added successfully for SKU: ${event.sku}')), // TODO: Localize
    );
  }
}