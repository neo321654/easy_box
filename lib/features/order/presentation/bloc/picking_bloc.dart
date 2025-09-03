import 'package:bloc/bloc.dart';
import 'package:easy_box/features/order/domain/entities/entities.dart';
import 'package:easy_box/features/order/domain/usecases/update_order_usecase.dart';
import 'package:equatable/equatable.dart';

part 'picking_event.dart';
part 'picking_state.dart';

class PickingBloc extends Bloc<PickingEvent, PickingState> {
  final UpdateOrderUseCase _updateOrderUseCase;

  PickingBloc({required UpdateOrderUseCase updateOrderUseCase})
      : _updateOrderUseCase = updateOrderUseCase,
        super(const PickingState()) {
    on<InitializePicking>(_onInitializePicking);
    on<LineItemPicked>(_onLineItemPicked);
    on<PickingCompleted>(_onPickingCompleted);
  }

  void _onInitializePicking(
    InitializePicking event,
    Emitter<PickingState> emit,
  ) {
    // Sort lines by location for an efficient picking path
    final sortedLines = List<OrderLine>.from(event.order.lines)
      ..sort((a, b) => (a.location ?? '').compareTo(b.location ?? ''));

    final sortedOrder = Order(
      id: event.order.id,
      customerName: event.order.customerName,
      status: event.order.status,
      lines: sortedLines,
    );

    emit(state.copyWith(order: sortedOrder));
  }

  void _onLineItemPicked(
    LineItemPicked event,
    Emitter<PickingState> emit,
  ) {
    if (state.order == null) return;

    final updatedLines = state.order!.lines.map((line) {
      if (line.productId == event.productId) {
        return OrderLine(
          productId: line.productId,
          productName: line.productName,
          sku: line.sku,
          location: line.location,
          quantityToPick: line.quantityToPick,
          quantityPicked: event.quantity, // Update picked quantity
        );
      }
      return line;
    }).toList();

    final updatedOrder = Order(
      id: state.order!.id,
      customerName: state.order!.customerName,
      status: OrderStatus.inProgress, // Update status
      lines: updatedLines,
    );

    emit(state.copyWith(order: updatedOrder));
  }

  Future<void> _onPickingCompleted(
    PickingCompleted event,
    Emitter<PickingState> emit,
  ) async {
    if (state.order == null) return;

    emit(state.copyWith(isLoading: true));

    final completedOrder = Order(
      id: state.order!.id,
      customerName: state.order!.customerName,
      status: OrderStatus.picked, // Set status to picked
      lines: state.order!.lines,
    );

    final result = await _updateOrderUseCase(completedOrder);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)), // TODO: Handle failure
      (_) => emit(state.copyWith(isLoading: false, isCompleted: true)),
    );
  }
}