import 'package:easy_box/core/extensions/extensions.dart';
import 'package:easy_box/core/utils/utils.dart';
import 'package:easy_box/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.settingsPageTitle),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(AppDimensions.medium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.user.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppDimensions.small / 2),
                          Text(
                            authState.user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Return empty space if not logged in
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.medium),
                child: Text(
                  context.S.settingsThemeTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(8.0),
                    isSelected: [
                      settingsState.themeMode == ThemeMode.light,
                      settingsState.themeMode == ThemeMode.dark,
                      settingsState.themeMode == ThemeMode.system,
                    ],
                    onPressed: (index) {
                      final themeMode = [ThemeMode.light, ThemeMode.dark, ThemeMode.system][index];
                      context.read<SettingsBloc>().add(ThemeModeChanged(themeMode));
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.settingsThemeLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.settingsThemeDark),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.settingsThemeSystem),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.medium),
                child: Text(
                  context.S.settingsLanguageTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(8.0),
                    isSelected: [
                      settingsState.locale == const Locale('ru'),
                      settingsState.locale == const Locale('en'),
                      settingsState.locale == const Locale('de'),
                    ],
                    onPressed: (index) {
                      final locale = [const Locale('ru'), const Locale('en'), const Locale('de')][index];
                      context.read<SettingsBloc>().add(LocaleChanged(locale));
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.languageRussian),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.languageEnglish),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(context.S.languageGerman),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
