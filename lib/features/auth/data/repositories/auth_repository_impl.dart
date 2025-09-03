import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@example.com' && password == 'password') {
      return const User(
        id: '1',
        name: 'Admin User',
        email: 'admin@example.com',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
