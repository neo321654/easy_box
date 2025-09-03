import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository repository;

  GetMeUseCase(this.repository);

  Future<User?> call() {
    return repository.getMe();
  }
}
