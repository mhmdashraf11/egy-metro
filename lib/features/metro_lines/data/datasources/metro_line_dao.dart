import 'package:floor/floor.dart';
import '../models/metro_line_entity.dart';

@dao
abstract class MetroLineDao {
  // ─── Reads ───────────────────────────────────────────────────────────────

  @Query('SELECT * FROM metro_lines ORDER BY id ASC')
  Future<List<MetroLineEntity>> findAll();

  @Query('SELECT * FROM metro_lines WHERE id = :id')
  Future<MetroLineEntity?> findById(int id);

  // ─── Writes ──────────────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertLine(MetroLineEntity line);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<MetroLineEntity> lines);

  @delete
  Future<void> deleteLine(MetroLineEntity line);

  @Query('DELETE FROM metro_lines')
  Future<void> deleteAll();
}
