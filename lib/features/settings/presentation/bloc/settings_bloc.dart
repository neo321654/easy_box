import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/save_locale_usecase.dart';
import '../../domain/usecases/save_theme_mode_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SaveThemeModeUseCase _saveThemeModeUseCase;
  final SaveLocaleUseCase _saveLocaleUseCase;

  SettingsBloc({
    required SettingsState initialState,
    required SaveThemeModeUseCase saveThemeModeUseCase,
    required SaveLocaleUseCase saveLocaleUseCase,
    Locale? systemLocale,
  }) : _saveThemeModeUseCase = saveThemeModeUseCase,
       _saveLocaleUseCase = saveLocaleUseCase,
       super(
         initialState.copyWith(locale: initialState.locale ?? systemLocale),
       ) {
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<LocaleChanged>(_onLocaleChanged);
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    await _saveThemeModeUseCase(event.themeMode);
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(locale: event.locale));
    await _saveLocaleUseCase(event.locale);
  }
}
