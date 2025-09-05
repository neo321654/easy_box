import 'dart:convert';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:easy_box/features/inventory/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryRemoteDataSourceApiImpl implements InventoryRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String _baseUrl = 'http://38.244.208.106:8000';

  InventoryRemoteDataSourceApiImpl({required this.client, required this.prefs});

  Future<Map<String, String>> _getHeaders() async {
    final token = prefs.getString('user_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel?> findProductBySku(String sku) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/sku/$sku'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> addStock(String sku, int quantityToAdd) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/products/$sku/add_stock?quantity=$quantityToAdd'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
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
    final uri = Uri.parse('$_baseUrl/products/');
    final request = http.MultipartRequest('POST', uri);
    final headers = await _getHeaders();
    request.headers['Authorization'] = headers['Authorization']!;

    request.fields['name'] = name;
    request.fields['sku'] = sku;
    request.fields['quantity'] = '0';
    if (location != null) {
      request.fields['location'] = location;
    }

    if (imageUrl != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageUrl));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return ProductModel.fromJson(json.decode(responseBody));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/products/${product.id}'),
      headers: await _getHeaders(),
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> uploadProductImage(String productId, String imagePath) async {
    final uri = Uri.parse('$_baseUrl/products/$productId/upload-image');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _getHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return ProductModel.fromJson(json.decode(responseBody));
    } else {
      throw ServerException();
    }
  }
}
