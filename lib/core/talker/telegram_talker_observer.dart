import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TelegramTalkerObserver extends TalkerObserver {
  final Dio _dio = Dio();
  final String _url = 'http://38.244.208.106:8000/log-client-error';

  @override
  void onLog(TalkerLog log) {
    // We only want to send errors and critical logs to Telegram
    if (log.level == LogLevel.error || log.level == LogLevel.critical) {
      try {
        _dio.post(
          _url,
          data: {'message': log.generateTextMessage()},
        );
      } catch (e) {
        // Avoid loops, just print to console if sending fails
        // ignore: avoid_print
        print('Failed to send log to Telegram: $e');
      }
    }
  }
}
