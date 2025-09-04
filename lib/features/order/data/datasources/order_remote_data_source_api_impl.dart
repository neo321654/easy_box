import 'dart:convert';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/data/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderRemoteDataSourceApiImpl implements OrderRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final String _baseUrl = 'http://38.244.208.106:8000';

  OrderRemoteDataSourceApiImpl({required this.client, required this.prefs});

  Future<Map<String, String>> _getHeaders() async {
    final token = prefs.getString('user_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/orders/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // The backend returns Order with lines, but the OrderModel.fromJson expects lines separately.
      // We need to adapt this. Let's assume the backend returns the full order object.
            return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/orders/${order.id}'),
      headers: await _getHeaders(),
      body: json.encode(order.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
