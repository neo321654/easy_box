import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/usecases/get_products_usecase.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetProductsUseCase _getProductsUseCase;

  InventoryBloc({required GetProductsUseCase getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase,
        super(InventoryInitial()) {
    on<FetchProductsRequested>(_onFetchProductsRequested);
  }

  Future<void> _onFetchProductsRequested(
    FetchProductsRequested event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final products = await _getProductsUseCase();
      emit(InventorySuccess(products));
    } catch (e) {
      emit(InventoryFailure(e.toString()));
    }
  }
}
