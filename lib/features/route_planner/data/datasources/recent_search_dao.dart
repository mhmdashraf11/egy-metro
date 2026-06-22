import 'package:floor/floor.dart';
import '../models/recent_search_entity.dart';

@dao
abstract class RecentSearchDao {
  // ─── Reads ───────────────────────────────────────────────────────────────

  /// Returns up to 10 most recent searches, newest first.
  @Query(
    'SELECT * FROM recent_searches ORDER BY searched_at DESC LIMIT 10',
  )
  Future<List<RecentSearchEntity>> findRecent();

  // ─── Writes ──────────────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSearch(RecentSearchEntity search);

  @Query('DELETE FROM recent_searches WHERE id = :id')
  Future<void> deleteById(int id);

  @Query('DELETE FROM recent_searches')
  Future<void> clearAll();
}
