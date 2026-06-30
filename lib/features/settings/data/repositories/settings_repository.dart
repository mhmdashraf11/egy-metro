import 'package:egy_metro/features/settings/data/datasources/local_storage_service.dart';

class SettingsRepository {
  final SettingsLocalDataSource settingsLocalDataSource;
  SettingsRepository(this.settingsLocalDataSource);

  Future<void> saveThemeMode(String mode) {
    return settingsLocalDataSource.saveThemeMode(mode);
  }

  String? getThemeMode() {
    return settingsLocalDataSource.getThemeMode();
  }

  Future<void> saveLocale(String langCode) {
    return settingsLocalDataSource.saveLocale(langCode);
  }

  String? getLocale() {
    return settingsLocalDataSource.getLocale();
  }
}
