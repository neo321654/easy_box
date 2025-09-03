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
              RadioListTile<ThemeMode>(
                title: Text(context.S.settingsThemeLight),
                value: ThemeMode.light,
                groupValue: settingsState.themeMode,
                onChanged: (themeMode) {
                  if (themeMode != null) {
                    context.read<SettingsBloc>().add(ThemeModeChanged(themeMode));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(context.S.settingsThemeDark),
                value: ThemeMode.dark,
                groupValue: settingsState.themeMode,
                onChanged: (themeMode) {
                  if (themeMode != null) {
                    context.read<SettingsBloc>().add(ThemeModeChanged(themeMode));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(context.S.settingsThemeSystem),
                value: ThemeMode.system,
                groupValue: settingsState.themeMode,
                onChanged: (themeMode) {
                  if (themeMode != null) {
                    context.read<SettingsBloc>().add(ThemeModeChanged(themeMode));
                  }
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.medium),
                child: Text(
                  context.S.settingsLanguageTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              RadioListTile<Locale>(
                title: Text(context.S.languageRussian),
                value: const Locale('ru'),
                groupValue: settingsState.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<SettingsBloc>().add(LocaleChanged(locale));
                  }
                },
              ),
              RadioListTile<Locale>(
                title: Text(context.S.languageEnglish),
                value: const Locale('en'),
                groupValue: settingsState.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<SettingsBloc>().add(LocaleChanged(locale));
                  }
                },
              ),
              RadioListTile<Locale>(
                title: Text(context.S.languageGerman),
                value: const Locale('de'),
                groupValue: settingsState.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<SettingsBloc>().add(LocaleChanged(locale));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
