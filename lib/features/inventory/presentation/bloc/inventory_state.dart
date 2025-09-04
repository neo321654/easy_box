part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventorySuccess extends InventoryState {
  final List<Product> allProducts;
  final String? searchTerm;

  const InventorySuccess({required this.allProducts, this.searchTerm});

  List<Product> get filteredProducts {
    if (searchTerm == null || searchTerm!.isEmpty) {
      return allProducts;
    } else {
      return allProducts
          .where((product) =>
              product.name.toLowerCase().contains(searchTerm!.toLowerCase()) ||
              product.sku.toLowerCase().contains(searchTerm!.toLowerCase()) ||
              (product.location?.toLowerCase().contains(searchTerm!.toLowerCase()) ?? false))
          .toList();
    }
  }

  InventorySuccess copyWith({
    List<Product>? allProducts,
    String? searchTerm,
  }) {
    return InventorySuccess(
      allProducts: allProducts ?? this.allProducts,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object?> get props => [allProducts, searchTerm];
}

class InventoryFailure extends InventoryState {
  const InventoryFailure();

  @override
  List<Object> get props => [];
}

class InventoryProductNotFound extends InventoryState {
  final String sku;

  const InventoryProductNotFound({required this.sku});

  @override
  List<Object> get props => [sku];
}