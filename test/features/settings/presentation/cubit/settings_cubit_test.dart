import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_metro/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:egy_metro/features/settings/data/repositories/settings_repository.dart';
import 'package:egy_metro/features/settings/data/datasources/local_storage_service.dart';

class MockSettingsRepository implements SettingsRepository {
  @override
  SettingsLocalDataSource get settingsLocalDataSource =>
      throw UnimplementedError();

  String? themeMode;
  String? locale;

  @override
  Future<void> saveThemeMode(String mode) async {
    themeMode = mode;
  }

  @override
  String? getThemeMode() {
    return themeMode;
  }

  @override
  Future<void> saveLocale(String langCode) async {
    locale = langCode;
  }

  @override
  String? getLocale() {
    return locale;
  }
}

void main() {
  group('SettingsCubit Tests', () {
    late SettingsCubit settingsCubit;
    late MockSettingsRepository mockSettingsRepository;

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      settingsCubit = SettingsCubit(settingsRepository: mockSettingsRepository);
    });

    tearDown(() {
      settingsCubit.close();
    });

    test('initial state is system theme and english locale', () {
      expect(settingsCubit.state.themeMode, ThemeMode.system);
      expect(settingsCubit.state.locale, const Locale('en'));
    });

    test('loadSettings loads saved values from repository', () async {
      mockSettingsRepository.themeMode = 'dark';
      mockSettingsRepository.locale = 'ar';

      await settingsCubit.loadSettings();

      expect(settingsCubit.state.themeMode, ThemeMode.dark);
      expect(settingsCubit.state.locale, const Locale('ar'));
    });

    test(
      'toggleTheme switches system/light to dark and dark to light',
      () async {
        await settingsCubit.toggleTheme();
        expect(settingsCubit.state.themeMode, ThemeMode.dark);
        expect(settingsCubit.state.locale, const Locale('en'));
        expect(mockSettingsRepository.themeMode, 'dark');

        await settingsCubit.toggleTheme();
        expect(settingsCubit.state.themeMode, ThemeMode.light);
        expect(mockSettingsRepository.themeMode, 'light');

        await settingsCubit.toggleTheme();
        expect(settingsCubit.state.themeMode, ThemeMode.dark);
        expect(mockSettingsRepository.themeMode, 'dark');
      },
    );

    test(
      'toggleLocale switches english to arabic and arabic to english',
      () async {
        await settingsCubit.toggleLocale();
        expect(settingsCubit.state.locale, const Locale('ar'));
        expect(settingsCubit.state.themeMode, ThemeMode.system);
        expect(mockSettingsRepository.locale, 'ar');

        await settingsCubit.toggleLocale();
        expect(settingsCubit.state.locale, const Locale('en'));
        expect(mockSettingsRepository.locale, 'en');
      },
    );

    test('setLocale sets custom locale', () async {
      await settingsCubit.setLocale(const Locale('fr'));
      expect(settingsCubit.state.locale, const Locale('fr'));
      expect(mockSettingsRepository.locale, 'fr');
    });

    test('setThemeMode sets custom theme mode', () async {
      await settingsCubit.setThemeMode(ThemeMode.light);
      expect(settingsCubit.state.themeMode, ThemeMode.light);
      expect(mockSettingsRepository.themeMode, 'light');
    });
  });
}
