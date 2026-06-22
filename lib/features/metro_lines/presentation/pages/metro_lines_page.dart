import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/features/metro_lines/data/datasources/station_dao.dart';
import 'package:egy_metro/features/metro_lines/data/models/station_entity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../widgets/metro_map.dart';

class MetroLinesPage extends StatefulWidget {
  const MetroLinesPage({super.key});

  @override
  State<MetroLinesPage> createState() => _MetroLinesPageState();
}

class _MetroLinesPageState extends State<MetroLinesPage> {
  final TextEditingController lineController = TextEditingController();
  List<StationEntity> _stations = [];
  int? _selectedLineId;
  bool _isLoading = false;

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

  Future<void> _onLineSelected(int? lineId) async {
    if (lineId == null) return;

    setState(() {
      _selectedLineId = lineId;
      _isLoading = true;
    });

    final stations = await GetIt.I<StationDao>().findByLine(lineId);

    setState(() {
      _stations = stations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metro Map',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const MetroMap(),
          const SizedBox(height: 24),

          DropdownMenu<int>(
            width: double.infinity,
            label: const Text('Choose a line'),
            controller: lineController,
            onSelected: _onLineSelected,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 1, label: 'Line 1 (Helwan - El Marg)'),
              DropdownMenuEntry(value: 2, label: 'Line 2 (Shubra - El Mounib)'),
              DropdownMenuEntry(
                value: 3,
                label: 'Line 3 (Adly Mansour - Rod El Farag)',
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_stations.isNotEmpty)
            _buildStationList(isDark)
          else
            Center(
              child: Text(
                'Select a line to view stations',
                style: TextStyle(
                  color: isDark ? AppColors.darkOnSurfaceVariant : Colors.grey,
                ),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStationList(bool isDark) {
    final lineColor = _getLineColor(_selectedLineId ?? 0, isDark);

    return Column(
      children: List.generate(_stations.length, (index) {
        final station = _stations[index];
        final isFirst = index == 0;
        final isLast = index == _stations.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              // Timeline part
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 4,
                        color: isFirst ? Colors.transparent : lineColor,
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: station.isInterchange
                            ? (isDark ? Colors.white : Colors.black)
                            : lineColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 4,
                        color: isLast ? Colors.transparent : lineColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Station name
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.nameEn,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: station.isInterchange
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        station.nameAr,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkOnSurfaceVariant
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (station.isInterchange)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainerHigh
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Interchange',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
