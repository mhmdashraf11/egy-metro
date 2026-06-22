import 'app_database.dart';
import 'metro_seed_data.dart';

/// Checks whether the database is empty and, if so, seeds all metro data.
/// Call this once at app startup after [AppDatabase.create()].
class DatabaseSeeder {
  final AppDatabase _db;

  const DatabaseSeeder(this._db);

  Future<void> seedIfEmpty() async {
    final checkStation = await _db.stationDao.findById(320);
    if (checkStation != null && checkStation.nameEn == 'Nasser') {
      return; // Already seeded with the correct Cairo metro data schema
    }

    await forceReseed();
  }

  Future<void> _seedLines() async {
    await _db.metroLineDao.insertAll(MetroSeedData.lines);
  }

  Future<void> _seedStations() async {
    await _db.stationDao.insertAll(MetroSeedData.stations);
  }

  Future<void> _seedConnections() async {
    await _db.connectionDao.insertAll(MetroSeedData.connections);
  }

  /// Force-reseed: wipes all data and reseeds from scratch.
  /// Useful during development or after a data update.
  Future<void> forceReseed() async {
    await _db.connectionDao.deleteAll();
    await _db.stationDao.deleteAll();
    await _db.metroLineDao.deleteAll();

    await _seedLines();
    await _seedStations();
    await _seedConnections();
  }
}
