class ServerException implements Exception {}

class SkuAlreadyExistsException implements Exception {
  final String sku;

  SkuAlreadyExistsException(this.sku);

  @override
  String toString() => 'Product with SKU $sku already exists.';
}

class ProductNotFoundException implements Exception {
  final String sku;

  ProductNotFoundException(this.sku);

  @override
  String toString() => 'Product with SKU $sku not found.';
}
