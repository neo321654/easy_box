import 'dart:async';
import 'dart:ui';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/router/app_router.dart';
import 'di/injection_container.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final systemLocale = PlatformDispatcher.instance.locale;
      await init(systemLocale: systemLocale);

      final talker = sl<Talker>();

      // Explicitly handle Flutter framework errors
      FlutterError.onError = (details) {
        talker.handle(details.exception, details.stack, "FlutterError");
      };

      // Initialize BLoC observer
      Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: const TalkerBlocLoggerSettings(
          printStateFullData: false,
          printEventFullData: false,
        ),
      );

      // Get the AuthBloc instance from the service locator
      final authBloc = sl<AuthBloc>();
      // Initialize the router with the bloc instance
      initializeRouter(authBloc);
      // Dispatch the initial event
      authBloc.add(AppStarted());

      runApp(MyApp(authBloc: authBloc));
    },
    (error, stack) => sl<Talker>().handle(error, stack, 'Uncaught app exception'),
  );
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
            builder: (context, child) {
              return TalkerWrapper(
                talker: sl<Talker>(),
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () => appRouter.push('/talker'),
                        child: const Icon(Icons.bug_report),
                      ),
                    ),
                  ],
                ),
              );
            },
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
