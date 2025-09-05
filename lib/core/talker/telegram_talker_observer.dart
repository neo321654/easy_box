import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TelegramTalkerObserver extends TalkerObserver {
  final Dio _dio = Dio();
  final String _url = 'http://38.244.208.106:8000/log-client-error';

  void _sendToTelegram(String logMessage) {
    // Get user info from AuthBloc via GetIt
    final authState = sl<AuthBloc>().state;
    String userInfo = 'User: Not Authenticated';
    if (authState is AuthSuccess) {
      final user = authState.user;
      userInfo = 'User: ${user.name} (ID: ${user.id}, Email: ${user.email})';
    }

    final fullMessage = '👤 **$userInfo**\n\n$logMessage';

    Future(() async {
      try {
        await _dio.post(
          _url,
          data: {'message': fullMessage},
        );
      } catch (e) {
        // ignore: avoid_print
        print('Failed to send log to Telegram: $e');
      }
    });
  }

  @override
  void onLog(TalkerData log) {
    if (log is TalkerLog && log.title == 'http-error') {
      _sendToTelegram(log.generateTextMessage());
    }
  }

  @override
  void onError(TalkerError err) {
    _sendToTelegram(err.generateTextMessage());
  }

  @override
  void onException(TalkerException err) {
    _sendToTelegram(err.generateTextMessage());
  }
}