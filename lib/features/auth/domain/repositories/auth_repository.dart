import 'package:dartz/dartz.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<User> loginAnonymously();

  Future<User?> getMe();

  Future<void> logout();
}
