import 'package:floor/floor.dart';
import '../models/favorite_route_entity.dart';

@dao
abstract class FavoriteRouteDao {
  // ─── Reads ───────────────────────────────────────────────────────────────

  @Query('SELECT * FROM favorite_routes ORDER BY created_at DESC')
  Future<List<FavoriteRouteEntity>> findAll();

  @Query(
    'SELECT * FROM favorite_routes '
    'WHERE from_station_id = :fromId AND to_station_id = :toId '
    'LIMIT 1',
  )
  Future<FavoriteRouteEntity?> findByRoute(int fromId, int toId);

  // ─── Writes ──────────────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFavorite(FavoriteRouteEntity favorite);

  @delete
  Future<void> deleteFavorite(FavoriteRouteEntity favorite);

  @Query('DELETE FROM favorite_routes WHERE id = :id')
  Future<void> deleteById(int id);

  @Query('DELETE FROM favorite_routes')
  Future<void> deleteAll();
}
