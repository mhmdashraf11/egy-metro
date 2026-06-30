import 'package:egy_metro/core/services/local_storage_service.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(String mode);
  String? getThemeMode();
  Future<void> saveLocale(String langCode);
  String? getLocale();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final LocalStorageService localStorage;
  SettingsLocalDataSourceImpl(this.localStorage);

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  @override
  Future<void> saveThemeMode(String mode) =>
      localStorage.setString(_themeKey, mode);

  @override
  String? getThemeMode() => localStorage.getString(_themeKey);

  @override
  Future<void> saveLocale(String langCode) =>
      localStorage.setString(_localeKey, langCode);

  @override
  String? getLocale() => localStorage.getString(_localeKey);
}
