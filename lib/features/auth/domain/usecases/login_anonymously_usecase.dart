import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';

class LoginAnonymouslyUseCase {
  final AuthRepository repository;

  LoginAnonymouslyUseCase(this.repository);

  Future<User> call() {
    return repository.loginAnonymously();
  }
}
