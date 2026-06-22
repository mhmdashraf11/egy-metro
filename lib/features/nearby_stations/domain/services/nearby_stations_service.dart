import 'package:geolocator/geolocator.dart';
import '../../../metro_lines/data/datasources/station_dao.dart';
import '../entities/nearby_station.dart';

class NearbyStationsService {
  final StationDao _stationDao;

  NearbyStationsService(this._stationDao);

  /// Returns a list of stations sorted by distance from the user.
  /// Throws an exception if location services are disabled or permissions are denied.
  Future<List<NearbyStation>> getNearbyStations({int limit = 5}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    final Position position = await Geolocator.getCurrentPosition();

    // Fetch all stations
    final stations = await _stationDao.findAll();

    // Calculate distance for each station
    final List<NearbyStation> nearbyStations = stations.map((station) {
      final double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        station.lat,
        station.lng,
      );
      return NearbyStation(
        station: station,
        distanceInMeters: distance,
      );
    }).toList();

    // Sort by distance
    nearbyStations.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

    // Return the top N
    return nearbyStations.take(limit).toList();
  }
}
