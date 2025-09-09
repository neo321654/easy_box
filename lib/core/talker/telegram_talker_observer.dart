import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:easy_box/core/config/env_config.dart';

class TelegramTalkerObserver extends TalkerObserver {
  TelegramTalkerObserver(this._dio);
  final Dio _dio;

  final String _url = '${EnvConfig.baseUrl}/log-client-error';

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
        await _dio.post(_url, data: {'message': fullMessage});
      } catch (e) {
        // ignore: avoid_print
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
