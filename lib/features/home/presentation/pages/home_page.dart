import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_shapes.dart';
import 'package:egy_metro/core/theme/app_spacing.dart';
import 'package:egy_metro/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:egy_metro/core/localization/app_translation.dart';
import 'package:egy_metro/features/nearby_stations/domain/services/nearby_stations_service.dart';
import 'package:egy_metro/features/nearby_stations/domain/entities/nearby_station.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:egy_metro/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:egy_metro/features/favorites/data/models/favorite_route_entity.dart';
import 'package:egy_metro/features/metro_lines/data/datasources/station_dao.dart';
import 'package:egy_metro/features/metro_lines/data/models/station_entity.dart';

class _GroupedStation {
  final String nameEn;
  final String nameAr;
  final List<int> lineIds;
  final double distanceInMeters;
  final double latitude;
  final double longitude;

  _GroupedStation({
    required this.nameEn,
    required this.nameAr,
    required this.lineIds,
    required this.distanceInMeters,
    required this.latitude,
    required this.longitude,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingNearby = true;
  List<_GroupedStation> _nearbyStations = [];
  String? _nearbyError;
  List<StationEntity> _stations = [];
  bool _isLoadingStations = true;

  @override
  void initState() {
    super.initState();
    _loadNearbyStations();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      final stations = await GetIt.I<StationDao>().findAll();
      if (mounted) {
        setState(() {
          _stations = stations;
          _isLoadingStations = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingStations = false;
        });
      }
    }
  }

  Future<void> _loadNearbyStations() async {
    if (!mounted) return;
    setState(() {
      _isLoadingNearby = true;
      _nearbyError = null;
    });

    try {
      final service = GetIt.I<NearbyStationsService>();
      final stations = await service.getNearbyStations(limit: 15);

      final Map<String, List<NearbyStation>> grouped = {};
      for (var ns in stations) {
        grouped.putIfAbsent(ns.station.nameEn, () => []).add(ns);
      }

      final List<_GroupedStation> uniqueStations = [];
      for (var entry in grouped.entries) {
        final list = entry.value;
        final first = list.first;
        final lineIds = list.map((ns) => ns.station.lineId).toSet().toList()
          ..sort();

        uniqueStations.add(
          _GroupedStation(
            nameEn: first.station.nameEn,
            nameAr: first.station.nameAr,
            lineIds: lineIds,
            distanceInMeters: first.distanceInMeters,
            latitude: first.station.lat,
            longitude: first.station.lng,
          ),
        );
      }

      uniqueStations.sort(
        (a, b) => a.distanceInMeters.compareTo(b.distanceInMeters),
      );

      if (mounted) {
        setState(() {
          _nearbyStations = uniqueStations.take(5).toList();
          _isLoadingNearby = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nearbyError = e.toString().replaceAll('Exception: ', '');
          _isLoadingNearby = false;
        });
      }
    }
  }

  String _formatDistance(double meters) {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatTime(double meters) {
    final minutes = (meters / 80).round();
    return '${minutes < 1 ? 1 : minutes} min';
  }

  String _formatLines(BuildContext context, List<int> lineIds) {
    if (lineIds.isEmpty) return '';
    if (lineIds.length == 1) {
      return '${AppTranslation.translate(context, 'line_label')} ${lineIds.first}';
    }
    lineIds.sort();
    return '${AppTranslation.translate(context, 'lines_label')} ${lineIds.join(' & ')}';
  }

  Color _getLineColor(int lineId, bool isDark) {
    switch (lineId) {
      case 1:
        return isDark ? AppColors.darkPrimary : AppColors.primary;
      case 2:
        return isDark ? AppColors.darkTertiaryContainer : AppColors.secondary;
      case 3:
        return isDark ? AppColors.darkSecondary : AppColors.tertiary;
      default:
        return Colors.grey;
    }
  }

  Color _getStationColor(List<int> lineIds, bool isDark) {
    if (lineIds.isEmpty) return Colors.grey;
    return _getLineColor(lineIds.first, isDark);
  }

  Widget _buildNearbySectionContent(BuildContext context, bool isDark) {
    if (_isLoadingNearby) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppTranslation.translate(context, 'finding_stations'),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_nearbyError != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
          borderRadius: AppShapes.borderLG,
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.1))
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_off_outlined,
                  color: isDark ? AppColors.darkError : AppColors.error,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _nearbyError!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkOnSurface : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  foregroundColor: isDark
                      ? AppColors.darkOnPrimary
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppShapes.borderMD,
                  ),
                ),
                onPressed: () async {
                  final permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    await Geolocator.requestPermission();
                  } else if (permission == LocationPermission.deniedForever) {
                    await Geolocator.openAppSettings();
                  }
                  _loadNearbyStations();
                },
                icon: Icon(
                  _nearbyError != null &&
                          _nearbyError!.toLowerCase().contains(
                            'permanently denied',
                          )
                      ? Icons.settings
                      : Icons.my_location,
                  size: 16,
                ),
                label: Text(
                  _nearbyError != null &&
                          _nearbyError!.toLowerCase().contains(
                            'permanently denied',
                          )
                      ? AppTranslation.translate(context, 'open_settings')
                      : AppTranslation.translate(context, 'allow_access'),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_nearbyStations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            AppTranslation.translate(context, 'no_stations'),
            style: TextStyle(
              color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
            ),
          ),
        ),
      );
    }

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      children: List.generate(_nearbyStations.length, (index) {
        final station = _nearbyStations[index];
        final distanceStr = _formatDistance(station.distanceInMeters);
        final timeStr = _formatTime(station.distanceInMeters);
        final linesStr = _formatLines(context, station.lineIds);
        final stationColor = _getStationColor(station.lineIds, isDark);
        final stationName = isArabic ? station.nameAr : station.nameEn;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _nearbyStations.length - 1
                ? 0
                : AppSpacing.stackSm,
          ),
          child: _buildNearbyStation(
            context,
            stationName,
            linesStr,
            distanceStr,
            timeStr,
            stationColor,
            isDark,
            station.latitude,
            station.longitude,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider<FavoriteCubit>.value(
      value: GetIt.I<FavoriteCubit>()..getAllFavoriteRoutes(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.stackMd),
            // Search Bar
            _buildSearchBar(context, isDark),
            const SizedBox(height: AppSpacing.stackLg),

            // Quick Actions
            _buildQuickActions(context, isDark),
            const SizedBox(height: AppSpacing.stackLg),

            // Saved Routes
            _buildSectionHeader(context, AppTranslation.translate(context, 'saved_routes'), null, isDark),
            const SizedBox(height: AppSpacing.stackMd),
            _buildSavedRoutes(context, isDark),
            const SizedBox(height: AppSpacing.stackLg),

            // Nearby
            _buildSectionHeader(
              context,
              AppTranslation.translate(context, 'nearby'),
              AppTranslation.translate(context, 'view_map'),
              isDark,
              onActionTap: () =>
                  Navigator.pushNamed(context, AppRoutes.nearbyStations),
            ),
            const SizedBox(height: AppSpacing.stackMd),
            _buildNearbySectionContent(context, isDark),
            const SizedBox(height: AppSpacing.stackLg),

            // Status Card
            _buildStatusCard(context, isDark),
            const SizedBox(height: AppSpacing.stackLg * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
        borderRadius: AppShapes.borderFull,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? AppColors.darkOutline : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppTranslation.translate(context, 'search_placeholder'),
              style: TextStyle(
                color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions,
              color: isDark ? AppColors.darkOnPrimary : Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
          Icons.alt_route,
          AppTranslation.translate(context, 'plan'),
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.routePlanner),
        ),
        _buildActionItem(
          Icons.map_outlined,
          AppTranslation.translate(context, 'map'),
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.metroMap),
        ),
        _buildActionItem(
          Icons.timeline,
          AppTranslation.translate(context, 'lines'),
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.metroLines),
        ),
        _buildActionItem(
          Icons.confirmation_number_outlined,
          AppTranslation.translate(context, 'tickets'),
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.ticketPricing),
        ),
      ],
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceContainerHigh
                  : const Color(0xFFF5F5F5),
              borderRadius: AppShapes.borderMD,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: AppShapes.borderMD,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkOnSurfaceVariant : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String? action,
    bool isDark, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkOnSurface : Colors.black87,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              action,
              style: TextStyle(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSavedRoutes(BuildContext context, bool isDark) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (_isLoadingStations) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FavoriteRouteEntity> favorites = [];
        if (state is FavoriteLoaded) {
          favorites = state.favorites;
        }

        if (favorites.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
              borderRadius: AppShapes.borderLG,
              border: isDark
                  ? Border.all(color: Colors.white.withOpacity(0.1))
                  : Border.all(color: Colors.grey.shade100),
            ),
            child: Center(
              child: Text(
                AppTranslation.translate(context, 'saved_route_empty'),
                style: TextStyle(
                  color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        final isArabic = Localizations.localeOf(context).languageCode == 'ar';

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            final fromStation = _stations.firstWhere(
              (s) => s.id == favorite.fromStationId,
              orElse: () => const StationEntity(id: -1, nameAr: 'Unknown', nameEn: 'Unknown', lat: 0, lng: 0, lineId: -1),
            );
            final toStation = _stations.firstWhere(
              (s) => s.id == favorite.toStationId,
              orElse: () => const StationEntity(id: -1, nameAr: 'Unknown', nameEn: 'Unknown', lat: 0, lng: 0, lineId: -1),
            );

            final fromName = isArabic ? fromStation.nameAr : fromStation.nameEn;
            final toName = isArabic ? toStation.nameAr : toStation.nameEn;

            final Color routeColor = _getLineColor(fromStation.lineId, isDark);

            return _buildSavedCard(
              Icons.star_border,
              '$fromName ➔',
              toName,
              routeColor,
              isDark,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.routePlanner,
                  arguments: {
                    'fromId': favorite.fromStationId,
                    'toId': favorite.toStationId,
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSavedCard(
    IconData icon,
    String title,
    String station,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
          borderRadius: AppShapes.borderLG,
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.1))
              : Border.all(color: Colors.grey.shade100),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppShapes.borderLG,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isDark ? AppColors.darkPrimary : AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkOnSurface : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        station,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkOnSurfaceVariant
                              : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyStation(
    BuildContext context,
    String name,
    String lines,
    String distance,
    String time,
    Color color,
    bool isDark,
    double latitude,
    double longitude,
  ) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
          borderRadius: AppShapes.borderLG,
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.1))
              : Border.all(color: Colors.grey.shade100),
        ),
        child: InkWell(
          borderRadius: AppShapes.borderLG,
          onTap: () async {
            final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
            if (await canLaunchUrl(googleMapsUrl)) {
              await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceContainerHigh
                            : const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.directions_train, size: 24),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkOnSurface : Colors.black87,
                        ),
                      ),
                      Text(
                        lines,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkOnSurfaceVariant
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      distance,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_walk,
                          size: 14,
                          color: Colors.grey,
                        ),
                        Text(
                          time,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer
            : const Color(0xFFF5F5F5),
        borderRadius: AppShapes.borderLG,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslation.translate(context, 'status_title'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkOnSurface : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppTranslation.translate(context, 'status_subtitle'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
