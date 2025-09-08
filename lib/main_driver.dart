import 'package:easy_box/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_box/di/injection_container.dart' as di;
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/core/router/app_router.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final authBloc = di.sl<AuthBloc>();
  initializeRouter(authBloc);
  authBloc.add(AppStarted());

  runApp(MyApp(authBloc: authBloc));
}
