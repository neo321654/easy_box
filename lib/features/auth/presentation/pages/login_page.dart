import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/utils/app_dimensions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.loginPageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.medium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: context.S.loginEmailLabel,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppDimensions.medium),
            TextFormField(
              decoration: InputDecoration(
                labelText: context.S.loginPasswordLabel,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppDimensions.large),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login logic
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, AppDimensions.buttonHeight), // full width
              ),
              child: Text(context.S.loginButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
