import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_shapes.dart';
import 'package:egy_metro/core/theme/app_spacing.dart';
import 'package:egy_metro/core/router/app_routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
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
          _buildSectionHeader(context, 'Saved Routes', null, isDark),
          const SizedBox(height: AppSpacing.stackMd),
          _buildSavedRoutes(context, isDark),
          const SizedBox(height: AppSpacing.stackLg),

          // Nearby
          _buildSectionHeader(context, 'Nearby', 'View Map', isDark),
          const SizedBox(height: AppSpacing.stackMd),
          _buildNearbyStation(
            context,
            'Sadat',
            'Lines 1 & 2',
            '0.4 km',
            '5 min',
            Colors.red,
            isDark,
          ),
          const SizedBox(height: AppSpacing.stackSm),
          _buildNearbyStation(
            context,
            'Nasser',
            'Lines 1 & 3',
            '1.2 km',
            '15 min',
            Colors.blue,
            isDark,
          ),
          const SizedBox(height: AppSpacing.stackLg),

          // Status Card
          _buildStatusCard(context, isDark),
          const SizedBox(height: AppSpacing.stackLg * 2),
        ],
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
              'Where to?',
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
          'Plan',
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.routePlanner),
        ),
        _buildActionItem(
          Icons.map_outlined,
          'Map',
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.metroMap),
        ),
        _buildActionItem(
          Icons.timeline,
          'Lines',
          isDark,
          onTap: () => Navigator.pushNamed(context, AppRoutes.metroLines),
        ),
        _buildActionItem(
          Icons.confirmation_number_outlined,
          'Tickets',
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
    bool isDark,
  ) {
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
            onPressed: () {},
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
    return Row(
      children: [
        Expanded(
          child: _buildSavedCard(
            Icons.home_outlined,
            'Home',
            'Al Shohadaa',
            Colors.red,
            isDark,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSavedCard(
            Icons.work_outline,
            'Work',
            'Attaba',
            Colors.green,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedCard(
    IconData icon,
    String title,
    String station,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.borderLG,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isDark ? AppColors.darkPrimary : AppColors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkOnSurface : Colors.black87,
            ),
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
              Text(
                station,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
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
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.borderLG,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.grey.shade100),
      ),
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
                  'All Lines Running Normally',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkOnSurface : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last updated 2 mins ago',
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
