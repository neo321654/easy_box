import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  static const _userTokenKey = 'user_token';
  static const _anonymousUserToken = 'anonymous_user';

  AuthRepositoryImpl(this._prefs);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@example.com' && password == 'password') {
      // In a real app, we would get a token from the server.
      // Here, we'll just use the user's ID as a mock token.
      const mockToken = 'user-id-1';
      await _prefs.setString(_userTokenKey, mockToken);
      return const User(
        id: '1',
        name: 'Admin User',
        email: 'admin@example.com',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<User> loginAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _prefs.setString(_userTokenKey, _anonymousUserToken);
    return const User(
      id: 'anonymous',
      name: 'Guest',
      email: '',
      isAnonymous: true,
    );
  }

  @override
  Future<User?> getMe() async {
    final token = _prefs.getString(_userTokenKey);

    if (token == null) {
      return null;
    }

    await Future.delayed(const Duration(milliseconds: 200)); // Simulate fetch

    if (token == _anonymousUserToken) {
      return const User(
        id: 'anonymous',
        name: 'Guest',
        email: '',
        isAnonymous: true,
      );
    }

    // In a real app, we would use the token to fetch user data.
    // For now, any other token is considered a real user.
    return const User(
      id: '1',
      name: 'Admin User',
      email: 'admin@example.com',
    );
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_userTokenKey);
  }
}
