part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale, // Make it nullable
  });

  final ThemeMode themeMode;
  final Locale? locale; // Make it nullable

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
