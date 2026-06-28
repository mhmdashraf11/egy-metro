import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_metro/features/settings/presentation/cubit/settings_cubit.dart';

void main() {
  group('SettingsCubit Tests', () {
    late SettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = SettingsCubit();
    });

    tearDown(() {
      settingsCubit.close();
    });

    test('initial state is system theme and english locale', () {
      expect(settingsCubit.state.themeMode, ThemeMode.system);
      expect(settingsCubit.state.locale, const Locale('en'));
    });

    test('toggleTheme switches system/light to dark and dark to light', () {
      settingsCubit.toggleTheme();
      expect(settingsCubit.state.themeMode, ThemeMode.dark);
      expect(settingsCubit.state.locale, const Locale('en'));

      settingsCubit.toggleTheme();
      expect(settingsCubit.state.themeMode, ThemeMode.light);

      settingsCubit.toggleTheme();
      expect(settingsCubit.state.themeMode, ThemeMode.dark);
    });

    test('toggleLocale switches english to arabic and arabic to english', () {
      settingsCubit.toggleLocale();
      expect(settingsCubit.state.locale, const Locale('ar'));
      expect(settingsCubit.state.themeMode, ThemeMode.system);

      settingsCubit.toggleLocale();
      expect(settingsCubit.state.locale, const Locale('en'));
    });
  });
}
