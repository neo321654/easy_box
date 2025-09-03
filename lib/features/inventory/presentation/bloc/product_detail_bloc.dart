import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/usecases/update_product_usecase.dart';
import 'package:easy_box/features/inventory/domain/usecases/delete_product_usecase.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/usecases/operation_result.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductDetailBloc({
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })
      : _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        super(ProductDetailInitial()) {
    on<ProductUpdated>(_onProductUpdated);
    on<ProductDeleted>(_onProductDeleted);
  }

  Future<void> _onProductUpdated(
    ProductUpdated event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());
    final failureOrResult = await _updateProductUseCase(event.product);
    failureOrResult.fold(
      (failure) => emit(const ProductDetailFailure('Failed to update product.')), // This will be localized in UI
      (result) => emit(ProductDetailSuccess('Product updated successfully.', type: ProductDetailSuccessType.updated, updatedProduct: event.product, isQueued: result.isQueued)), // Pass updated product and isQueued
    );
  }

  Future<void> _onProductDeleted(
    ProductDeleted event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());
    final failureOrResult = await _deleteProductUseCase(event.id);
    failureOrResult.fold(
      (failure) => emit(const ProductDetailFailure('Failed to delete product.')), // This will be localized in UI
      (result) => emit(ProductDetailSuccess('Product deleted successfully.', type: ProductDetailSuccessType.deleted, isQueued: result.isQueued)), // No product to pass for delete
    );
  }
}
