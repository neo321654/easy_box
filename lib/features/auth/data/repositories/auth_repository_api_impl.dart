import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryApiImpl implements AuthRepository {
  final Dio dio;
  final SharedPreferences prefs;
  final String _baseUrl = 'http://38.244.208.106';
  static const _userTokenKey = 'user_token';

  AuthRepositoryApiImpl({required this.dio, required this.prefs});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$_baseUrl/api/auth/token/',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      await prefs.setString(_userTokenKey, token);
      final user = await getMe();
      return user != null ? Right(user) : Left(ServerFailure());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(LogInFailure('Invalid credentials'));
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<User?> getMe() async {
    final token = prefs.getString(_userTokenKey);
    if (token == null) return null;

    try {
      final response = await dio.get(
        '$_baseUrl/api/users/me/',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      final data = response.data;
      return User(
        id: data['id'].toString(),
        name: data['username'],
        email: data['email'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await prefs.remove(_userTokenKey);
  }

  @override
  Future<User> loginAnonymously() async {
    // This backend does not support anonymous login.
    // We can return a predefined guest user or handle as an error.
    // For now, returning a guest user without hitting API.
    return const User(
      id: 'anonymous',
      name: 'Guest',
      email: '',
      isAnonymous: true,
    );
  }
}
