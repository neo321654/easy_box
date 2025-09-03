import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/features/auth/domain/entities/user.dart';
import 'package:easy_box/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:easy_box/features/auth/domain/usecases/login_usecase.dart';
import 'package:easy_box/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final GetMeUseCase _getMeUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required GetMeUseCase getMeUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _getMeUseCase = getMeUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Wait for both a minimum delay and the user check to complete.
      final results = await Future.wait([
        Future.delayed(const Duration(seconds: 1)),
        _getMeUseCase(),
      ]);

      // The result of the use case is the second item in the list.
      final user = results[1] as User?;

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoggedOut(
    LoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase();
    emit(AuthUnauthenticated());
  }
}