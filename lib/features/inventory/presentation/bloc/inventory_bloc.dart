import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/usecases/get_products_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/find_product_by_sku_usecase.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetProductsUseCase _getProductsUseCase;
  final FindProductBySkuUseCase _findProductBySkuUseCase;

  InventoryBloc({
    required GetProductsUseCase getProductsUseCase,
    required FindProductBySkuUseCase findProductBySkuUseCase,
  })
      : _getProductsUseCase = getProductsUseCase,
        _findProductBySkuUseCase = findProductBySkuUseCase,
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
      final filteredProducts = currentState.allProducts.where((product) {
        final lowerCaseSearchTerm = event.searchTerm.toLowerCase();
        return product.name.toLowerCase().contains(lowerCaseSearchTerm) ||
            product.sku.toLowerCase().contains(lowerCaseSearchTerm) ||
            (product.location?.toLowerCase().contains(lowerCaseSearchTerm) ?? false);
      }).toList();

      if (event.searchTerm.isNotEmpty && filteredProducts.isEmpty) {
        // If no local product found, try to find it by SKU remotely
        final failureOrProduct = await _findProductBySkuUseCase(event.searchTerm);
        failureOrProduct.fold(
          (failure) => emit(const InventoryFailure()), // Handle failure to find remotely
          (product) {
            if (product == null) {
              emit(InventoryProductNotFound(sku: event.searchTerm));
            } else {
              // Product found remotely, but not in local cache. Refresh local cache.
              // This might be an edge case, but good to handle.
              emit(currentState.copyWith(searchTerm: event.searchTerm)); // Re-filter with existing products
              add(FetchProductsRequested()); // Then fetch all products to update cache
            }
          },
        );
      } else {
        emit(currentState.copyWith(searchTerm: event.searchTerm));
      }
    }
  }
}