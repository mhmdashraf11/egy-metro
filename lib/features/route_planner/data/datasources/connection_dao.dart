import 'package:floor/floor.dart';
import '../models/connection_entity.dart';

@dao
abstract class ConnectionDao {
  // ─── Reads ───────────────────────────────────────────────────────────────

  @Query('SELECT * FROM connections')
  Future<List<ConnectionEntity>> findAll();

  /// Returns all outgoing edges from a given station – used by BFS / Dijkstra.
  @Query(
    'SELECT * FROM connections WHERE from_station_id = :stationId',
  )
  Future<List<ConnectionEntity>> findNeighbours(int stationId);

  @Query('SELECT * FROM connections WHERE line_id = :lineId ORDER BY id ASC')
  Future<List<ConnectionEntity>> findByLine(int lineId);

  // ─── Writes ──────────────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertConnection(ConnectionEntity connection);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<ConnectionEntity> connections);

  @delete
  Future<void> deleteConnection(ConnectionEntity connection);

  @Query('DELETE FROM connections')
  Future<void> deleteAll();
}
