import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/domain/usecases/find_product_by_sku_usecase.dart';

part 'scanning_event.dart';
part 'scanning_state.dart';

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final FindProductBySkuUseCase _findProductBySkuUseCase;

  ScanningBloc({required FindProductBySkuUseCase findProductBySkuUseCase})
      : _findProductBySkuUseCase = findProductBySkuUseCase,
        super(ScanningInitial()) {
    on<BarcodeDetected>(_onBarcodeDetected);
  }

  Future<void> _onBarcodeDetected(
    BarcodeDetected event,
    Emitter<ScanningState> emit,
  ) async {
    emit(ScanningLoading());
    final failureOrProduct = await _findProductBySkuUseCase(event.sku);

    failureOrProduct.fold(
      (failure) => emit(const ScanningFailure('Server Error')), // TODO: Localize
      (product) {
        if (product != null) {
          emit(ScanningProductFound(product));
        } else {
          emit(ScanningProductNotFound());
        }
      },
    );
  }
}