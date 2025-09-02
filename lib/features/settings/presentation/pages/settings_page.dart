import 'package:easy_box/core/extensions/extensions.dart';
import 'package:easy_box/core/utils/utils.dart';
import 'package:easy_box/features/settings/data/repositories/settings_repository.dart';
import 'package:easy_box/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        // Save the settings whenever the state changes
        final repository = context.read<SettingsRepository>();
        repository.saveThemeMode(state.themeMode);
        repository.saveLocale(state.locale);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.S.settingsPageTitle),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: [
                SwitchListTile(
                  title: Text(context.S.settingsThemeTitle),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
                    context
                        .read<SettingsBloc>()
                        .add(ThemeModeChanged(themeMode));
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
                  groupValue: state.locale,
                  onChanged: (locale) {
                    if (locale != null) {
                      context.read<SettingsBloc>().add(LocaleChanged(locale));
                    }
                  },
                ),
                RadioListTile<Locale>(
                  title: Text(context.S.languageEnglish),
                  value: const Locale('en'),
                  groupValue: state.locale,
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
      ),
    );
  }
}
