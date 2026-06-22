import '../../../metro_lines/data/models/station_entity.dart';

class RouteResult {
  final List<StationEntity> stations;
  final int totalTime;
  final int totalStops;
  final List<RouteTransfer> transfers;

  const RouteResult({
    required this.stations,
    required this.totalTime,
    required this.totalStops,
    required this.transfers,
  });
}

class RouteTransfer {
  final StationEntity station;
  final int fromLineId;
  final int toLineId;

  const RouteTransfer({
    required this.station,
    required this.fromLineId,
    required this.toLineId,
  });
}
