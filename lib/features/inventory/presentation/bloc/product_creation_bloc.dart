import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/usecases/create_product_usecase.dart';
import 'package:easy_box/core/error/failures.dart';

part 'product_creation_event.dart';
part 'product_creation_state.dart';

class ProductCreationBloc
    extends Bloc<ProductCreationEvent, ProductCreationState> {
  final CreateProductUseCase _createProductUseCase;

  ProductCreationBloc({required CreateProductUseCase createProductUseCase})
    : _createProductUseCase = createProductUseCase,
      super(ProductCreationInitial()) {
    on<ProductCreateRequested>(_onCreateProductRequested);
  }

  Future<void> _onCreateProductRequested(
    ProductCreateRequested event,
    Emitter<ProductCreationState> emit,
  ) async {
    emit(ProductCreationLoading());
    final failureOrResult = await _createProductUseCase(
      name: event.name,
      sku: event.sku,
      location: event.location,
      imageUrl: event.imageUrl,
    );

    failureOrResult.fold((failure) {
      if (failure is SkuAlreadyExistsFailure) {
        emit(
          ProductCreationFailure(
            message: 'Product with SKU ${failure.sku} already exists.',
          ),
        );
      } else {
        emit(const ProductCreationFailure());
      }
    }, (result) => emit(ProductCreationSuccess(isQueued: result.isQueued)));
  }
}
