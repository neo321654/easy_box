import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryApiImpl implements AuthRepository {
  final http.Client client;
  final SharedPreferences prefs;
  final String _baseUrl = 'http://38.244.208.106:8000';
  static const _userTokenKey = 'user_token';

  AuthRepositoryApiImpl({required this.client, required this.prefs});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['access_token'];
      await prefs.setString(_userTokenKey, token);
      return await getMe().then((user) => user != null 
          ? Right(user) 
          : Left(ServerFailure())); // Should not happen if token is valid
    } else {
      return Left(LogInFailure('Invalid credentials'));
    }
  }

  @override
  Future<User?> getMe() async {
    final token = prefs.getString(_userTokenKey);
    if (token == null) return null;

    final response = await client.get(
      Uri.parse('$_baseUrl/auth/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User(
        id: data['id'].toString(),
        name: data['name'],
        email: data['email'],
      );
    } else {
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
