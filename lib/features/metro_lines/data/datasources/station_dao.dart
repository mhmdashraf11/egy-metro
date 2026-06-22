import 'package:floor/floor.dart';
import '../models/station_entity.dart';

@dao
abstract class StationDao {
  // ─── Reads ───────────────────────────────────────────────────────────────

  @Query('SELECT * FROM stations ORDER BY name_en ASC')
  Future<List<StationEntity>> findAll();

  @Query('SELECT * FROM stations WHERE id = :id')
  Future<StationEntity?> findById(int id);

  @Query('SELECT * FROM stations WHERE line_id = :lineId ORDER BY id ASC')
  Future<List<StationEntity>> findByLine(int lineId);

  @Query('SELECT * FROM stations WHERE is_interchange = 1')
  Future<List<StationEntity>> findInterchanges();

  /// Case-insensitive search across both Arabic and English names.
  @Query(
    'SELECT * FROM stations '
    'WHERE LOWER(name_en) LIKE LOWER(:query) '
    'OR name_ar LIKE :query '
    'ORDER BY name_en ASC',
  )
  Future<List<StationEntity>> search(String query);

  // ─── Writes ──────────────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStation(StationEntity station);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StationEntity> stations);

  @delete
  Future<void> deleteStation(StationEntity station);

  @Query('DELETE FROM stations')
  Future<void> deleteAll();
}
