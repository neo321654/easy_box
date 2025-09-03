import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/domain/usecases/get_orders_usecase.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final GetOrdersUseCase _getOrdersUseCase;

  OrderListBloc({required GetOrdersUseCase getOrdersUseCase})
      : _getOrdersUseCase = getOrdersUseCase,
        super(OrderListInitial()) {
    on<FetchOrdersRequested>(_onFetchOrdersRequested);
  }

  Future<void> _onFetchOrdersRequested(
    FetchOrdersRequested event,
    Emitter<OrderListState> emit,
  ) async {
    emit(OrderListLoading());
    final failureOrOrders = await _getOrdersUseCase();
    failureOrOrders.fold(
      (failure) => emit(OrderListFailure()),
      (orders) => emit(OrderListSuccess(orders)),
    );
  }
}