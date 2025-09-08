import 'package:easy_box/main.dart';
import 'package:flutter/material.dart';
import 'package:easy_box/di/injection_container.dart' as di;
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final authBloc = di.sl<AuthBloc>();
  initializeRouter(authBloc);
  authBloc.add(AppStarted());

  runApp(MyApp(authBloc: authBloc));
}
