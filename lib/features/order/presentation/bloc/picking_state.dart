part of 'picking_bloc.dart';

class PickingState extends Equatable {
  final Order? order;
  final bool isLoading;
  final bool isCompleted;

  const PickingState({
    this.order,
    this.isLoading = false,
    this.isCompleted = false,
  });

  PickingState copyWith({
    Order? order,
    bool? isLoading,
    bool? isCompleted,
  }) {
    return PickingState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [order, isLoading, isCompleted];
}