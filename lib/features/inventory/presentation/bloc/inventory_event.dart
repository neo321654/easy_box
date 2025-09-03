part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsRequested extends InventoryEvent {}

class SearchTermChanged extends InventoryEvent {
  final String searchTerm;

  const SearchTermChanged(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}