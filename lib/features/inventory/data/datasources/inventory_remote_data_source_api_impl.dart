import 'package:dio/dio.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryRemoteDataSourceApiImpl implements InventoryRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;
  final String _baseUrl = 'http://38.244.208.106:8000';

  InventoryRemoteDataSourceApiImpl({required this.dio, required this.prefs});

  Future<Options> _getOptions() async {
    final token = prefs.getString('user_token');
    return Options(headers: {
      'Authorization': 'Bearer $token',
    });
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(
        '$_baseUrl/products/',
        options: await _getOptions(),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel?> findProductBySku(String sku) async {
    try {
      final response = await dio.get(
        '$_baseUrl/products/sku/$sku',
        options: await _getOptions(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ServerException();
    }
  }

  @override
  Future<void> addStock(String sku, int quantityToAdd) async {
    try {
      await dio.post(
        '$_baseUrl/products/$sku/add_stock?quantity=$quantityToAdd',
        options: await _getOptions(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFoundException(sku);
      }
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct({
    required String name,
    required String sku,
    String? location,
    String? imageUrl,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'sku': sku,
        'quantity': 0,
        if (location != null) 'location': location,
        if (imageUrl != null) 'file': await MultipartFile.fromFile(imageUrl),
      });

      final response = await dio.post(
        '$_baseUrl/products/',
        data: formData,
        options: await _getOptions(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await dio.put(
        '$_baseUrl/products/${product.id}',
        data: product.toJson(),
        options: await _getOptions(),
      );
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await dio.delete(
        '$_baseUrl/products/$id',
        options: await _getOptions(),
      );
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> uploadProductImage(String productId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
      });

      final response = await dio.post(
        '$_baseUrl/products/$productId/upload-image',
        data: formData,
        options: await _getOptions(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException {
      throw ServerException();
    }
  }
}
