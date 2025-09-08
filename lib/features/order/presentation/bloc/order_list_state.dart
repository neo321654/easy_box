part of 'order_list_bloc.dart';

abstract class OrderListState extends Equatable {
  const OrderListState();

  @override
  List<Object> get props => [];
}

class OrderListInitial extends OrderListState {}

class OrderListLoading extends OrderListState {}

class OrderListSuccess extends OrderListState {
  final List<Order> orders;

  const OrderListSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderListFailure extends OrderListState {}
