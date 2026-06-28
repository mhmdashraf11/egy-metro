import 'package:equatable/equatable.dart';
import '../../../metro_lines/data/models/station_entity.dart';
import '../../domain/entities/route_result.dart';
import '../../data/models/recent_search_entity.dart';

class RoutePlannerState extends Equatable {
  final List<StationEntity> stations;
  final List<RecentSearchEntity> recentSearches;
  final StationEntity? fromStation;
  final StationEntity? toStation;
  final StationEntity? nearestStation;
  final bool isLoadingGPS;
  final bool isLoadingStations;
  final RouteResult? routeResult;
  final bool isCurrentRouteFavorite;
  final String? statusMessage;
  final String? errorMessage;

  const RoutePlannerState({
    required this.stations,
    required this.recentSearches,
    this.fromStation,
    this.toStation,
    this.nearestStation,
    required this.isLoadingGPS,
    required this.isLoadingStations,
    this.routeResult,
    required this.isCurrentRouteFavorite,
    this.statusMessage,
    this.errorMessage,
  });

  factory RoutePlannerState.initial() {
    return const RoutePlannerState(
      stations: [],
      recentSearches: [],
      fromStation: null,
      toStation: null,
      nearestStation: null,
      isLoadingGPS: false,
      isLoadingStations: true,
      routeResult: null,
      isCurrentRouteFavorite: false,
      statusMessage: null,
      errorMessage: null,
    );
  }

  RoutePlannerState copyWith({
    List<StationEntity>? stations,
    List<RecentSearchEntity>? recentSearches,
    StationEntity? fromStation,
    StationEntity? toStation,
    StationEntity? nearestStation,
    bool? isLoadingGPS,
    bool? isLoadingStations,
    RouteResult? routeResult,
    bool? isCurrentRouteFavorite,
    String? statusMessage,
    String? errorMessage,
    bool clearFromStation = false,
    bool clearToStation = false,
    bool clearRouteResult = false,
    bool clearStatusMessage = false,
    bool clearErrorMessage = false,
  }) {
    return RoutePlannerState(
      stations: stations ?? this.stations,
      recentSearches: recentSearches ?? this.recentSearches,
      fromStation: clearFromStation ? null : (fromStation ?? this.fromStation),
      toStation: clearToStation ? null : (toStation ?? this.toStation),
      nearestStation: nearestStation ?? this.nearestStation,
      isLoadingGPS: isLoadingGPS ?? this.isLoadingGPS,
      isLoadingStations: isLoadingStations ?? this.isLoadingStations,
      routeResult: clearRouteResult ? null : (routeResult ?? this.routeResult),
      isCurrentRouteFavorite: isCurrentRouteFavorite ?? this.isCurrentRouteFavorite,
      statusMessage: clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        stations,
        recentSearches,
        fromStation,
        toStation,
        nearestStation,
        isLoadingGPS,
        isLoadingStations,
        routeResult,
        isCurrentRouteFavorite,
        statusMessage,
        errorMessage,
      ];
}
