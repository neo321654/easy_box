class ServerException implements Exception {}

class ProductNotFoundException implements Exception {
  final String sku;

  ProductNotFoundException(this.sku);

  @override
  String toString() => 'Product with SKU $sku not found.';
}
