import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../metro_lines/data/datasources/station_dao.dart';
import '../../data/datasources/recent_search_dao.dart';
import '../../data/models/recent_search_entity.dart';
import '../../../favorites/data/datasources/favorite_route_dao.dart';
import '../../../favorites/data/models/favorite_route_entity.dart';
import '../../domain/services/dijkstra_service.dart';
import '../../../nearby_stations/domain/services/nearby_stations_service.dart';
import '../../../metro_lines/data/models/station_entity.dart';
import 'route_planner_state.dart';

class RoutePlannerCubit extends Cubit<RoutePlannerState> {
  final StationDao _stationDao;
  final RecentSearchDao _recentSearchDao;
  final FavoriteRouteDao _favoriteRouteDao;
  final DijkstraService _dijkstraService;
  final NearbyStationsService _nearbyStationsService;

  RoutePlannerCubit({
    required StationDao stationDao,
    required RecentSearchDao recentSearchDao,
    required FavoriteRouteDao favoriteRouteDao,
    required DijkstraService dijkstraService,
    required NearbyStationsService nearbyStationsService,
  })  : _stationDao = stationDao,
        _recentSearchDao = recentSearchDao,
        _favoriteRouteDao = favoriteRouteDao,
        _dijkstraService = dijkstraService,
        _nearbyStationsService = nearbyStationsService,
        super(RoutePlannerState.initial());

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoadingStations: true));
    try {
      final stations = await _stationDao.findAll();
      final recent = await _recentSearchDao.findRecent();
      emit(state.copyWith(
        stations: stations,
        recentSearches: recent,
        isLoadingStations: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingStations: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> detectNearestStation() async {
    emit(state.copyWith(isLoadingGPS: true, clearErrorMessage: true));
    try {
      final nearby = await _nearbyStationsService.getNearbyStations(limit: 1);
      if (nearby.isNotEmpty) {
        emit(state.copyWith(
          nearestStation: nearby.first.station,
          isLoadingGPS: false,
        ));
      } else {
        emit(state.copyWith(isLoadingGPS: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoadingGPS: false,
        errorMessage: 'gps_error',
      ));
    }
  }

  void selectNearestAsFrom() {
    if (state.nearestStation != null) {
      emit(state.copyWith(
        fromStation: state.nearestStation,
        clearRouteResult: true,
        statusMessage: 'nearest_station_detected',
      ));
      checkFavoriteStatus();
    }
  }

  void setFromStation(StationEntity station) {
    emit(state.copyWith(
      fromStation: station,
      clearRouteResult: true,
    ));
    checkFavoriteStatus();
  }

  void setToStation(StationEntity station) {
    emit(state.copyWith(
      toStation: station,
      clearRouteResult: true,
    ));
    checkFavoriteStatus();
  }

  void swapStations() {
    final temp = state.fromStation;
    emit(state.copyWith(
      fromStation: state.toStation,
      toStation: temp,
      clearRouteResult: true,
    ));
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    if (state.fromStation == null || state.toStation == null) return;
    try {
      final fav = await _favoriteRouteDao.findByRoute(
        state.fromStation!.id,
        state.toStation!.id,
      );
      emit(state.copyWith(isCurrentRouteFavorite: fav != null));
    } catch (_) {}
  }

  Future<void> toggleFavorite() async {
    if (state.fromStation == null || state.toStation == null) return;
    try {
      if (state.isCurrentRouteFavorite) {
        final fav = await _favoriteRouteDao.findByRoute(
          state.fromStation!.id,
          state.toStation!.id,
        );
        if (fav != null && fav.id != null) {
          await _favoriteRouteDao.deleteById(fav.id!);
        }
        emit(state.copyWith(
          isCurrentRouteFavorite: false,
          statusMessage: 'route_removed',
        ));
      } else {
        await _favoriteRouteDao.insertFavorite(FavoriteRouteEntity(
          fromStationId: state.fromStation!.id,
          toStationId: state.toStation!.id,
          createdAt: DateTime.now().toIso8601String(),
        ));
        emit(state.copyWith(
          isCurrentRouteFavorite: true,
          statusMessage: 'route_saved',
        ));
      }
    } catch (_) {}
  }

  Future<void> calculateRoute() async {
    if (state.fromStation == null || state.toStation == null) return;
    emit(state.copyWith(clearErrorMessage: true, clearStatusMessage: true));
    try {
      final result = await _dijkstraService.findShortestPath(
        state.fromStation!.id,
        state.toStation!.id,
      );
      if (result != null) {
        // Save to search history
        final now = DateTime.now().toIso8601String();
        await _recentSearchDao.insertSearch(RecentSearchEntity(
          fromStationId: state.fromStation!.id,
          toStationId: state.toStation!.id,
          searchedAt: now,
        ));

        final recent = await _recentSearchDao.findRecent();
        emit(state.copyWith(
          routeResult: result,
          recentSearches: recent,
        ));
        await checkFavoriteStatus();
      } else {
        emit(state.copyWith(
          clearRouteResult: true,
          errorMessage: 'no_route_found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> selectRecentSearch(RecentSearchEntity search) async {
    try {
      final from = state.stations.firstWhere((s) => s.id == search.fromStationId);
      final to = state.stations.firstWhere((s) => s.id == search.toStationId);
      emit(state.copyWith(
        fromStation: from,
        toStation: to,
      ));
      await calculateRoute();
    } catch (_) {}
  }

  Future<void> deleteRecentSearch(int id) async {
    try {
      await _recentSearchDao.deleteById(id);
      final recent = await _recentSearchDao.findRecent();
      emit(state.copyWith(recentSearches: recent));
    } catch (_) {}
  }

  Future<void> clearRecentHistory() async {
    try {
      await _recentSearchDao.clearAll();
      emit(state.copyWith(recentSearches: []));
    } catch (_) {}
  }

  void clearMessages() {
    emit(state.copyWith(
      clearStatusMessage: true,
      clearErrorMessage: true,
    ));
  }
}
