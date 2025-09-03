import 'package:easy_box/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> loginAnonymously();

  Future<User?> getMe();

  Future<void> logout();
}
