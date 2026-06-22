import '../../../metro_lines/data/models/station_entity.dart';

class NearbyStation {
  final StationEntity station;
  final double distanceInMeters;

  const NearbyStation({
    required this.station,
    required this.distanceInMeters,
  });
}
