import 'dart:async';

import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/inventory/presentation/pages/inventory_page.dart';
import 'package:easy_box/features/receiving/presentation/pages/receiving_page.dart';
import 'package:easy_box/features/scanning/presentation/pages/scanning_page.dart';
import 'package:easy_box/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

late final GoRouter appRouter;

// The router now depends on the AuthBloc to make decisions.
void initializeRouter(AuthBloc authBloc) {
  appRouter = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/scanning',
        builder: (context, state) => const ScanningPage(),
      ),
      GoRoute(
        path: '/receiving',
        builder: (context, state) => const ReceivingPage(),
      ),
    ],
    redirect: (context, state) {
      // We use the bloc instance passed to the router, not the service locator.
      final authState = authBloc.state;
      final location = state.uri.toString();

      final onLoginPage = location == '/login';

      // While the bloc is initializing, show the splash screen.
      if (authState is AuthInitial) {
        return '/';
      }

      // If the user is not authenticated, redirect to the login page.
      if (authState is AuthUnauthenticated || authState is AuthFailure) {
        return onLoginPage ? null : '/login';
      }

      // If the user is authenticated, redirect to the home page from splash or login.
      if (authState is AuthSuccess) {
        return onLoginPage || location == '/' ? '/home' : null;
      }

      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
