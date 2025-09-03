import 'package:easy_box/core/extensions/extensions.dart';
import 'package:easy_box/core/utils/utils.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'admin@example.com');
    _passwordController = TextEditingController(text: 'password');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthBloc>().add(
          LoginButtonPressed(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _loginAnonymously() {
    context.read<AuthBloc>().add(AnonymousLoginButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.loginPageTitle),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          }
          if (state is AuthSuccess) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.medium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: context.S.loginEmailLabel,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppDimensions.medium),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: context.S.loginPasswordLabel,
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: AppDimensions.large),
                    PrimaryButton(
                      onPressed: state is AuthLoading ? null : _login,
                      text: context.S.loginButtonText,
                    ),
                    const SizedBox(height: AppDimensions.small),
                    TextButton(
                      onPressed: state is AuthLoading ? null : _loginAnonymously,
                      child: Text(context.S.loginAnonymousButtonText),
                    ),
                  ],
                ),
              ),
              if (state is AuthLoading)
                const LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }
}