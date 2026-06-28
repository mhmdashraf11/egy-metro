import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: nextMode));
  }

  void toggleLocale() {
    final nextLocale = state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    emit(state.copyWith(locale: nextLocale));
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }
}
