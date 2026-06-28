import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_shapes.dart';
import 'package:egy_metro/core/theme/app_spacing.dart';
import 'package:egy_metro/core/localization/app_translation.dart';
import 'package:egy_metro/features/metro_lines/data/models/station_entity.dart';
import 'package:egy_metro/features/route_planner/domain/entities/route_result.dart';
import 'package:egy_metro/features/route_planner/data/models/recent_search_entity.dart';
import 'package:egy_metro/features/route_planner/presentation/cubit/route_planner_cubit.dart';
import 'package:egy_metro/features/route_planner/presentation/cubit/route_planner_state.dart';

class RoutePlannerPage extends StatelessWidget {
  const RoutePlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<RoutePlannerCubit>()
        ..loadInitialData()
        ..detectNearestStation(),
      child: const RoutePlannerView(),
    );
  }
}

class RoutePlannerView extends StatefulWidget {
  const RoutePlannerView({super.key});

  @override
  State<RoutePlannerView> createState() => _RoutePlannerViewState();
}

class _RoutePlannerViewState extends State<RoutePlannerView> {
  final Set<int> _expandedSegments = {};

  void _showStationSelector(
    BuildContext context,
    bool isFrom,
    List<StationEntity> stations,
    StationEntity? initialSelection,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _StationSearchBottomSheet(
          stations: stations,
          initialSelection: initialSelection,
          onSelected: (station) {
            final cubit = context.read<RoutePlannerCubit>();
            if (isFrom) {
              cubit.setFromStation(station);
            } else {
              cubit.setToStation(station);
            }
          },
        );
      },
    );
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

  String _getLineName(BuildContext context, int lineId) {
    switch (lineId) {
      case 1:
        return AppTranslation.translate(context, 'line_1_desc');
      case 2:
        return AppTranslation.translate(context, 'line_2_desc');
      case 3:
        return AppTranslation.translate(context, 'line_3_desc');
      default:
        return '${AppTranslation.translate(context, 'line_label')} $lineId';
    }
  }

  Widget _buildGoogleMapsIcon() {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.location_on,
            size: 28,
            color: Colors.red,
          ),
          Positioned(
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getKeyIndices(RouteResult result) {
    List<int> keyIndices = [0];
    for (var transfer in result.transfers) {
      final idx = result.stations.indexWhere((s) => s.id == transfer.station.id);
      if (idx != -1 && !keyIndices.contains(idx)) {
        keyIndices.add(idx);
      }
    }
    final lastIdx = result.stations.length - 1;
    if (!keyIndices.contains(lastIdx)) {
      keyIndices.add(lastIdx);
    }
    keyIndices.sort();
    return keyIndices;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<RoutePlannerCubit, RoutePlannerState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null || current.statusMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppTranslation.translate(context, state.errorMessage!)),
            behavior: SnackBarBehavior.floating,
          ));
        } else if (state.statusMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppTranslation.translate(context, state.statusMessage!)),
            behavior: SnackBarBehavior.floating,
          ));
        }
        context.read<RoutePlannerCubit>().clearMessages();
      },
      child: BlocBuilder<RoutePlannerCubit, RoutePlannerState>(
        builder: (context, state) {
          if (state.isLoadingStations) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
                vertical: AppSpacing.stackMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Nearest metro station
                  Text(
                    AppTranslation.translate(context, 'nearest_metro_station'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkOnSurface : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (state.nearestStation != null) {
                              context.read<RoutePlannerCubit>().selectNearestAsFrom();
                            } else {
                              context.read<RoutePlannerCubit>().detectNearestStation();
                            }
                          },
                          borderRadius: AppShapes.borderLG,
                          child: Container(
                            height: 58,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
                              borderRadius: AppShapes.borderLG,
                              border: isDark
                                  ? Border.all(color: Colors.white.withOpacity(0.08))
                                  : Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                state.isLoadingGPS
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Icon(
                                        Icons.gps_fixed,
                                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.nearestStation != null
                                            ? (isArabic ? state.nearestStation!.nameAr : state.nearestStation!.nameEn)
                                            : AppTranslation.translate(context, 'please_open_gps'),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: state.nearestStation != null ? FontWeight.bold : FontWeight.normal,
                                          color: isDark ? AppColors.darkOnSurface : Colors.black87,
                                        ),
                                      ),
                                      if (state.nearestStation != null)
                                        Text(
                                          AppTranslation.translate(context, 'nearest_station_detected'),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () async {
                          if (state.nearestStation != null) {
                            final Uri googleMapsUrl = Uri.parse(
                                "https://www.google.com/maps/search/?api=1&query=${state.nearestStation!.lat},${state.nearestStation!.lng}");
                            if (await canLaunchUrl(googleMapsUrl)) {
                              await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                            }
                          } else {
                            context.read<RoutePlannerCubit>().detectNearestStation();
                          }
                        },
                        borderRadius: AppShapes.borderLG,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
                            borderRadius: AppShapes.borderLG,
                            border: isDark
                                ? Border.all(color: Colors.white.withOpacity(0.08))
                                : Border.all(color: Colors.grey.shade200),
                          ),
                          child: Center(
                            child: _buildGoogleMapsIcon(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 2: Get trip details ready Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                      borderRadius: AppShapes.borderLG,
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                      border: isDark
                          ? Border.all(color: Colors.white.withOpacity(0.06))
                          : Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            isArabic ? "✨ تجهيز تفاصيل الرحلة ✨" : "✨ Get trip details ready ✨",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            AppTranslation.translate(context, 'enter_station_prompt'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Inputs Stack with Swap Button
                        Stack(
                          children: [
                            Column(
                              children: [
                                // From Selector
                                InkWell(
                                  onTap: () => _showStationSelector(context, true, state.stations, state.fromStation),
                                  borderRadius: AppShapes.borderMD,
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurfaceContainerLow : const Color(0xFFF8F9FA),
                                      borderRadius: AppShapes.borderMD,
                                      border: Border.all(
                                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.radio_button_checked,
                                          color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppTranslation.translate(context, 'from'),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade500,
                                                ),
                                              ),
                                              Text(
                                                state.fromStation != null
                                                    ? (isArabic ? state.fromStation!.nameAr : state.fromStation!.nameEn)
                                                    : AppTranslation.translate(context, 'select_station'),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: state.fromStation != null ? FontWeight.bold : FontWeight.normal,
                                                  color: isDark
                                                      ? (state.fromStation != null ? Colors.white : AppColors.darkOnSurfaceVariant)
                                                      : (state.fromStation != null ? Colors.black87 : Colors.grey.shade600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: isDark ? AppColors.darkOutline : Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // To Selector
                                InkWell(
                                  onTap: () => _showStationSelector(context, false, state.stations, state.toStation),
                                  borderRadius: AppShapes.borderMD,
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurfaceContainerLow : const Color(0xFFF8F9FA),
                                      borderRadius: AppShapes.borderMD,
                                      border: Border.all(
                                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppTranslation.translate(context, 'to'),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade500,
                                                ),
                                              ),
                                              Text(
                                                state.toStation != null
                                                    ? (isArabic ? state.toStation!.nameAr : state.toStation!.nameEn)
                                                    : AppTranslation.translate(context, 'select_station'),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: state.toStation != null ? FontWeight.bold : FontWeight.normal,
                                                  color: isDark
                                                      ? (state.toStation != null ? Colors.white : AppColors.darkOnSurfaceVariant)
                                                      : (state.toStation != null ? Colors.black87 : Colors.grey.shade600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: isDark ? AppColors.darkOutline : Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Swap Button
                            Positioned(
                              right: isArabic ? null : 16,
                              left: isArabic ? 16 : null,
                              top: 40, // Middle of 56 height + 12 gap + 56 height
                              child: Material(
                                color: Colors.transparent,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceContainerHigh : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? Colors.white.withOpacity(0.12) : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    boxShadow: isDark
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => context.read<RoutePlannerCubit>().swapStations(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.swap_vert,
                                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Get Details Button
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: (state.fromStation != null && state.toStation != null)
                                ? () => context.read<RoutePlannerCubit>().calculateRoute()
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                              foregroundColor: isDark ? AppColors.darkOnPrimary : Colors.white,
                              disabledBackgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
                              disabledForegroundColor: isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppShapes.borderMD,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(
                              AppTranslation.translate(context, 'get_details'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Route Result or Recent Searches
                  if (state.routeResult != null)
                    _buildRouteDetails(context, state.routeResult!, state.isCurrentRouteFavorite, isDark, isArabic)
                  else
                    _buildRecentSearchesSection(context, state.recentSearches, state.stations, isDark, isArabic),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteDetails(
    BuildContext context,
    RouteResult result,
    bool isFavorite,
    bool isDark,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTranslation.translate(context, 'route_details'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkOnSurface : Colors.black87,
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : (isDark ? AppColors.darkOutline : Colors.grey),
              ),
              onPressed: () => context.read<RoutePlannerCubit>().toggleFavorite(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Metrics Grid
        Row(
          children: [
            // Time
            Expanded(
              child: _buildMetricCard(
                context,
                Icons.access_time,
                AppTranslation.translate(context, 'total_time'),
                '${result.totalTime} ${AppTranslation.translate(context, 'minutes')}',
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            // Stops
            Expanded(
              child: _buildMetricCard(
                context,
                Icons.directions_transit,
                AppTranslation.translate(context, 'total_stops'),
                '${result.totalStops} ${AppTranslation.translate(context, 'stops')}',
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            // Transfers
            Expanded(
              child: _buildMetricCard(
                context,
                Icons.swap_calls,
                AppTranslation.translate(context, 'transfers'),
                '${result.transfers.length}',
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Path Timeline
        _buildTimeline(context, result, isDark, isArabic),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, IconData icon, String title, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.borderMD,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.08))
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkOnSurface : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, RouteResult result, bool isDark, bool isArabic) {
    final keyIndices = _getKeyIndices(result);
    final List<Widget> timelineItems = [];

    for (int i = 0; i < keyIndices.length; i++) {
      final currentKeyIndex = keyIndices[i];
      final currentStation = result.stations[currentKeyIndex];
      final isFirstKey = i == 0;
      final isLastKey = i == keyIndices.length - 1;

      // Determine top and bottom line colors
      final Color? topColor = isFirstKey ? null : _getLineColor(result.stations[currentKeyIndex - 1].lineId, isDark);
      final Color? bottomColor = isLastKey ? null : _getLineColor(currentStation.lineId, isDark);

      // Check if this station is a transfer point
      final RouteTransfer transfer = result.transfers.firstWhere(
        (t) => t.station.id == currentStation.id,
        orElse: () => const RouteTransfer(station: StationEntity(id: -1, nameAr: '', nameEn: '', lat: 0, lng: 0, lineId: -1), fromLineId: -1, toLineId: -1),
      );

      final hasTransfer = transfer.station.id != -1;

      timelineItems.add(
        _buildKeyStationRow(
          context,
          currentStation,
          isFirstKey,
          isLastKey,
          topColor,
          bottomColor,
          hasTransfer ? transfer : null,
          isDark,
          isArabic,
        ),
      );

      // Add collapsible intermediate segment
      if (i < keyIndices.length - 1) {
        final nextKeyIndex = keyIndices[i + 1];
        final intermediateCount = nextKeyIndex - currentKeyIndex - 1;
        
        if (intermediateCount > 0) {
          final isExpanded = _expandedSegments.contains(i);
          timelineItems.add(
            _buildIntermediateSegment(
              context,
              result.stations.sublist(currentKeyIndex + 1, nextKeyIndex),
              i,
              isExpanded,
              _getLineColor(currentStation.lineId, isDark),
              isDark,
              isArabic,
            ),
          );
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
        borderRadius: AppShapes.borderLG,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.06))
            : Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: timelineItems,
      ),
    );
  }

  Widget _buildKeyStationRow(
    BuildContext context,
    StationEntity station,
    bool isFirst,
    bool isLast,
    Color? topColor,
    Color? bottomColor,
    RouteTransfer? transfer,
    bool isDark,
    bool isArabic,
  ) {
    final stationName = isArabic ? station.nameAr : station.nameEn;
    final secondaryName = isArabic ? station.nameEn : station.nameAr;
    final lineColor = _getLineColor(station.lineId, isDark);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 4,
                    color: isFirst ? Colors.transparent : (topColor ?? lineColor),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isFirst || isLast || transfer != null ? Colors.white : lineColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: transfer != null
                          ? Colors.orange
                          : (isFirst ? Colors.green : (isLast ? Colors.red : lineColor)),
                      width: 4,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 4,
                    color: isLast ? Colors.transparent : (bottomColor ?? lineColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Station details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stationName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkOnSurface : Colors.black87,
                          ),
                        ),
                      ),
                      if (isFirst || isLast)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isFirst ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isFirst
                                ? AppTranslation.translate(context, 'start_station')
                                : AppTranslation.translate(context, 'end_station'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isFirst ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    secondaryName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                    ),
                  ),
                  if (transfer != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: AppShapes.borderXS,
                        border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_horiz, color: Colors.orange, size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              isArabic
                                  ? 'انتقل إلى ${_getLineName(context, transfer.toLineId)}'
                                  : 'Transfer to ${_getLineName(context, transfer.toLineId)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntermediateSegment(
    BuildContext context,
    List<StationEntity> stations,
    int segmentIndex,
    bool isExpanded,
    Color lineColor,
    bool isDark,
    bool isArabic,
  ) {
    return Column(
      children: [
        // Expand/Collapse controller row
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Center(
                  child: Container(
                    width: 4,
                    color: lineColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedSegments.remove(segmentIndex);
                        } else {
                          _expandedSegments.add(segmentIndex);
                        }
                      });
                    },
                    borderRadius: AppShapes.borderMD,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFF8F9FA),
                        borderRadius: AppShapes.borderMD,
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 18,
                            color: isDark ? AppColors.darkOutline : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isExpanded
                                ? (isArabic ? 'إخفاء المحطات' : 'Hide stations')
                                : '${stations.length} ${AppTranslation.translate(context, 'stops')}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Intermediate list
        if (isExpanded)
          ...List.generate(stations.length, (idx) {
            final st = stations[idx];
            final name = isArabic ? st.nameAr : st.nameEn;
            
            return IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 4,
                            color: lineColor,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: lineColor,
                              width: 2.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 4,
                            color: lineColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildRecentSearchesSection(
    BuildContext context,
    List<RecentSearchEntity> recentSearches,
    List<StationEntity> stations,
    bool isDark,
    bool isArabic,
  ) {
    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTranslation.translate(context, 'recent_searches'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkOnSurface : Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => context.read<RoutePlannerCubit>().clearRecentHistory(),
              child: Text(
                AppTranslation.translate(context, 'clear_history'),
                style: TextStyle(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            final from = stations.firstWhere(
              (s) => s.id == search.fromStationId,
              orElse: () => const StationEntity(id: -1, nameAr: '', nameEn: '', lat: 0, lng: 0, lineId: -1),
            );
            final to = stations.firstWhere(
              (s) => s.id == search.toStationId,
              orElse: () => const StationEntity(id: -1, nameAr: '', nameEn: '', lat: 0, lng: 0, lineId: -1),
            );

            if (from.id == -1 || to.id == -1) return const SizedBox.shrink();

            final fromName = isArabic ? from.nameAr : from.nameEn;
            final toName = isArabic ? to.nameAr : to.nameEn;

            return InkWell(
              onTap: () => context.read<RoutePlannerCubit>().selectRecentSearch(search),
              borderRadius: AppShapes.borderMD,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
                  borderRadius: AppShapes.borderMD,
                  border: isDark
                      ? Border.all(color: Colors.white.withOpacity(0.06))
                      : Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: isDark ? AppColors.darkOutline : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              fromName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkOnSurface : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              isArabic ? Icons.arrow_back : Icons.arrow_forward,
                              size: 14,
                              color: isDark ? AppColors.darkOutline : Colors.grey,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              toName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkOnSurface : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        if (search.id != null) {
                          context.read<RoutePlannerCubit>().deleteRecentSearch(search.id!);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StationSearchBottomSheet extends StatefulWidget {
  final List<StationEntity> stations;
  final StationEntity? initialSelection;
  final ValueChanged<StationEntity> onSelected;

  const _StationSearchBottomSheet({
    required this.stations,
    required this.initialSelection,
    required this.onSelected,
  });

  @override
  State<_StationSearchBottomSheet> createState() => _StationSearchBottomSheetState();
}

class _StationSearchBottomSheetState extends State<_StationSearchBottomSheet> {
  late List<StationEntity> _filteredStations;

  @override
  void initState() {
    super.initState();
    _filteredStations = widget.stations;
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = widget.stations;
      } else {
        _filteredStations = widget.stations.where((station) {
          return station.nameEn.toLowerCase().contains(query.toLowerCase()) ||
              station.nameAr.contains(query);
        }).toList();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.bottomSheetBorder,
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppTranslation.translate(context, 'select_station'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkOnSurface : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: AppTranslation.translate(context, 'search_station'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: AppShapes.borderMD,
                borderSide: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppShapes.borderMD,
                borderSide: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppShapes.borderMD,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFF5F5F5),
            ),
            onChanged: _filterStations,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: _filteredStations.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        AppTranslation.translate(context, 'no_stations'),
                        style: TextStyle(
                          color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredStations.length,
                    itemBuilder: (context, index) {
                      final station = _filteredStations[index];
                      final name = isArabic ? station.nameAr : station.nameEn;
                      final secondaryName = isArabic ? station.nameEn : station.nameAr;
                      final lineColor = _getLineColor(station.lineId, isDark);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: lineColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkOnSurface : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          secondaryName,
                          style: TextStyle(
                            color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        trailing: station.isInterchange
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceContainerHigh
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppTranslation.translate(context, 'interchange'),
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () {
                          widget.onSelected(station);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
