import 'package:dio/dio.dart';
import 'package:easy_box/core/config/env_config.dart';
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/data/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRemoteDataSourceApiImpl implements OrderRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;
  final String _baseUrl = '${EnvConfig.baseUrl}/api';

  OrderRemoteDataSourceApiImpl({required this.dio, required this.prefs});

  Future<Options> _getOptions() async {
    final token = prefs.getString('user_token');
    return Options(headers: {'Authorization': 'Token $token'});
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await dio.get(
        '$_baseUrl/orders/',
        options: await _getOptions(),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    try {
      await dio.put(
        '$_baseUrl/orders/${order.id}/',
        data: order.toJson(),
        options: await _getOptions(),
      );
    } on DioException {
      throw ServerException();
    }
  }
}
