import 'dart:async';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TelegramTalkerObserver extends TalkerObserver {
  final Dio _dio = Dio();
  final String _url = 'http://38.244.208.106:8000/log-client-error';

  void _sendToTelegram(String message) {
    // We wrap the async call in a Future to ensure it's scheduled
    // on the event loop from a synchronous observer.
    Future(() async {
      try {
        await _dio.post(
          _url,
          data: {'message': message},
        );
      } catch (e) {
        // Avoid loops, just print to console if sending fails
        // ignore: avoid_print
        print('Failed to send log to Telegram: $e');
      }
    });
  }

  @override
  void onLog(TalkerData log) {
    // The TalkerDioLogger logs 4xx and 5xx errors as a TalkerLog
    // with a specific title. We check for that title here.
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