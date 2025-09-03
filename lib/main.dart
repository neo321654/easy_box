import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'di/injection_container.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  // Get the AuthBloc instance from the service locator
  final authBloc = sl<AuthBloc>();
  // Initialize the router with the bloc instance
  initializeRouter(authBloc);
  // Dispatch the initial event
  authBloc.add(AppStarted());

  runApp(MyApp(authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;

  const MyApp({
    super.key,
    required this.authBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SettingsBloc>()),
        // Provide the existing bloc instance to the widget tree
        BlocProvider.value(value: authBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'Easy Box',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
            ),
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}