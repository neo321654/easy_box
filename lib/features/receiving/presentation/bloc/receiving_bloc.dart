import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/usecases/add_stock_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/create_product_usecase.dart';
import 'package:easy_box/core/error/failures.dart';

part 'receiving_event.dart';
part 'receiving_state.dart';

class ReceivingBloc extends Bloc<ReceivingEvent, ReceivingState> {
  final AddStockUseCase _addStockUseCase;
  final CreateProductUseCase _createProductUseCase;

  ReceivingBloc({
    required AddStockUseCase addStockUseCase,
    required CreateProductUseCase createProductUseCase,
  })
      : _addStockUseCase = addStockUseCase,
        _createProductUseCase = createProductUseCase,
        super(ReceivingInitial()) {
    on<StockAdded>(_onStockAdded);
    on<CreateProductAndAddStock>(_onCreateProductAndAddStock);
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
      (failure) {
        if (failure is ProductNotFoundFailure) {
          emit(ReceivingProductNotFound(failure.sku));
        } else {
          emit(const ReceivingFailure('Failed to add stock.')); // TODO: Localize
        }
      },
      (_) => emit(ReceivingSuccess('Stock added successfully for SKU: ${event.sku}')), // TODO: Localize
    );
  }

  Future<void> _onCreateProductAndAddStock(
    CreateProductAndAddStock event,
    Emitter<ReceivingState> emit,
  ) async {
    emit(ReceivingLoading());

    final failureOrCreateProduct = await _createProductUseCase(
      name: event.name,
      sku: event.sku,
    );

    await failureOrCreateProduct.fold(
      (failure) async {
        emit(const ReceivingFailure('Failed to create product.')); // TODO: Localize
      },
      (product) async {
        final failureOrAddStock = await _addStockUseCase(
          sku: event.sku,
          quantity: event.quantity,
        );

        failureOrAddStock.fold(
          (failure) => emit(const ReceivingFailure('Failed to add stock after creating product.')), // TODO: Localize
          (_) => emit(ReceivingSuccess('Product created and stock added successfully for SKU: ${event.sku}')), // TODO: Localize
        );
      },
    );
  }
}
