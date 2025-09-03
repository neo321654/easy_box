part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Dispatched when the app starts to check the current auth status
class AppStarted extends AuthEvent {}

// Dispatched when the user presses the login button
class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// Dispatched when the user logs out
class LoggedOut extends AuthEvent {}