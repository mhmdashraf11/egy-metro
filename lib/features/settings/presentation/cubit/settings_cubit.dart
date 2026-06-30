import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'settings_state.dart';
import 'package:egy_metro/features/settings/data/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsCubit({required this.settingsRepository})
    : super(SettingsState.initial());

  Future<void> loadSettings() async {
    final themeName = settingsRepository.getThemeMode();
    final langCode = settingsRepository.getLocale();

    final themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );

    final locale = (langCode != null && langCode.isNotEmpty)
        ? Locale(langCode)
        : const Locale('en');

    emit(state.copyWith(themeMode: themeMode, locale: locale));
  }

  Future<void> toggleLocale() async {
    final nextLocale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    await settingsRepository.saveLocale(nextLocale.languageCode);
    emit(state.copyWith(locale: nextLocale));
  }

  Future<void> toggleTheme() async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await settingsRepository.saveThemeMode(nextMode.name);
    emit(state.copyWith(themeMode: nextMode));
  }

  Future<void> setLocale(Locale locale) async {
    await settingsRepository.saveLocale(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await settingsRepository.saveThemeMode(mode.name);
    emit(state.copyWith(themeMode: mode));
  }
}
