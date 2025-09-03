import 'package:bloc/bloc.dart';
import 'package:easy_box/features/order/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

part 'picking_event.dart';
part 'picking_state.dart';

class PickingBloc extends Bloc<PickingEvent, PickingState> {
  PickingBloc() : super(const PickingState()) {
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
      status: state.order!.status,
      lines: updatedLines,
    );

    emit(state.copyWith(order: updatedOrder));
  }

  void _onPickingCompleted(
    PickingCompleted event,
    Emitter<PickingState> emit,
  ) {
    // Here you would typically call a use case to save the updated order status
    emit(state.copyWith(isCompleted: true));
  }
}