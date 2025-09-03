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
    on<SearchTermChanged>(_onSearchTermChanged);
  }

  Future<void> _onFetchProductsRequested(
    FetchProductsRequested event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    final failureOrProducts = await _getProductsUseCase();
    failureOrProducts.fold(
      (failure) => emit(const InventoryFailure()),
      (products) => emit(InventorySuccess(allProducts: products)),
    );
  }

  Future<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<InventoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is InventorySuccess) {
      emit(currentState.copyWith(searchTerm: event.searchTerm));
    }
  }
}