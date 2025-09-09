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
  }) : _addStockUseCase = addStockUseCase,
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

    final failureOrResult = await _addStockUseCase(
      sku: event.sku,
      quantity: event.quantity,
    );

    failureOrResult.fold(
      (failure) {
        // Explicitly check for the exact type
        if (failure is ProductNotFoundFailure) {
          emit(ReceivingProductNotFound((failure).sku));
        } else {
          emit(const AddStockFailure());
        }
      },
      (result) =>
          emit(ReceivingSuccess(sku: event.sku, isQueued: result.isQueued)),
    );
  }

  Future<void> _onCreateProductAndAddStock(
    CreateProductAndAddStock event,
    Emitter<ReceivingState> emit,
  ) async {
    emit(ReceivingLoading());

    final failureOrCreateResult = await _createProductUseCase(
      name: event.name,
      sku: event.sku,
      location: event.location,
      imageUrl: event.imageUrl,
    );

    await failureOrCreateResult.fold(
      (failure) async {
        if (failure is SkuAlreadyExistsFailure) {
          emit(CreateProductFailure(sku: failure.sku));
        } else {
          emit(const CreateProductFailure());
        }
      },
      (createResult) async {
        final failureOrAddStockResult = await _addStockUseCase(
          sku: event.sku,
          quantity: event.quantity,
        );

        failureOrAddStockResult.fold(
          (failure) => emit(const AddStockAfterCreateFailure()),
          (addStockResult) => emit(
            ReceivingSuccess(
              sku: event.sku,
              isQueued: createResult.isQueued || addStockResult.isQueued,
              productCreated: true,
            ),
          ),
        );
      },
    );
  }
}
