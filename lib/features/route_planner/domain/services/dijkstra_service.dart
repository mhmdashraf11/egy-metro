import '../../data/datasources/connection_dao.dart';
import '../../../metro_lines/data/datasources/station_dao.dart';
import '../../../metro_lines/data/models/station_entity.dart';
import '../../data/models/connection_entity.dart';
import '../entities/route_result.dart';

class DijkstraService {
  final StationDao _stationDao;
  final ConnectionDao _connectionDao;

  DijkstraService(this._stationDao, this._connectionDao);

  Future<RouteResult?> findShortestPath(int startId, int endId) async {
    if (startId == endId) return null;

    final allStations = await _stationDao.findAll();
    final allConnections = await _connectionDao.findAll();

    final Map<int, List<ConnectionEntity>> adjacencyList = {};
    for (var conn in allConnections) {
      adjacencyList.putIfAbsent(conn.fromStationId, () => []).add(conn);
    }

    final Map<int, int> distances = {};
    final Map<int, int?> previousStations = {};
    final Map<int, int?> connectionToPrevious = {}; // To track line changes
    final Set<int> unvisited = {};

    for (var station in allStations) {
      distances[station.id] = 999999; // Infinity
      previousStations[station.id] = null;
      unvisited.add(station.id);
    }

    distances[startId] = 0;

    while (unvisited.isNotEmpty) {
      // Find unvisited node with smallest distance
      int? u;
      int minDistance = 1000000;
      for (var node in unvisited) {
        if (distances[node]! < minDistance) {
          minDistance = distances[node]!;
          u = node;
        }
      }

      if (u == null || u == endId || distances[u] == 999999) break;

      unvisited.remove(u);

      final neighbors = adjacencyList[u] ?? [];
      for (var connection in neighbors) {
        final v = connection.toStationId;
        if (!unvisited.contains(v)) continue;

        final alt = distances[u]! + connection.travelTime;
        if (alt < distances[v]!) {
          distances[v] = alt;
          previousStations[v] = u;
          connectionToPrevious[v] = connection.lineId;
        }
      }
    }

    if (previousStations[endId] == null) return null;

    // Reconstruct path
    final List<StationEntity> pathStations = [];
    final List<RouteTransfer> transfers = [];
    int? currentId = endId;
    int? lastLineId;

    while (currentId != null) {
      final station = allStations.firstWhere((s) => s.id == currentId);
      pathStations.insert(0, station);

      final prevId = previousStations[currentId];
      if (prevId != null) {
        final lineId = connectionToPrevious[currentId];
        if (lastLineId != null && lastLineId != lineId) {
          transfers.insert(0, RouteTransfer(
            station: station,
            fromLineId: lineId!,
            toLineId: lastLineId,
          ));
        }
        lastLineId = lineId;
      }
      currentId = prevId;
    }

    return RouteResult(
      stations: pathStations,
      totalTime: distances[endId]!,
      totalStops: pathStations.length - 1,
      transfers: transfers,
    );
  }
}
