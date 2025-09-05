import 'package:easy_box/core/talker/telegram_talker_observer.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

// Global Talker instance
final talker = TalkerFlutter.init(
  observer: TelegramTalkerObserver(authBloc: sl<AuthBloc>()),
);