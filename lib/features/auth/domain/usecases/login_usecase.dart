import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    // Here we could add more business logic,
    // like validating email format, checking password length, etc.
    // For now, we just delegate to the repository.
    return repository.login(email: email, password: password);
  }
}
