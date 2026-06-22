import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_shapes.dart';
import 'package:egy_metro/core/theme/app_spacing.dart';
import 'package:egy_metro/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class TicketPricingPage extends StatefulWidget {
  const TicketPricingPage({super.key});

  @override
  State<TicketPricingPage> createState() => _TicketPricingPageState();
}

class _TicketPricingPageState extends State<TicketPricingPage> {
  // Calculator state
  double _stationsCount = 5.0;

  // Pricing configuration
  final List<TicketTier> _tiers = [
    TicketTier(
      zoneNumber: 1,
      price: 10,
      stationsRange: 'Up to 9 Stations',
      minStations: 1,
      maxStations: 9,
      color: const Color(0xFFFF8A65), // Coral / Salmon
    ),
    TicketTier(
      zoneNumber: 2,
      price: 12,
      stationsRange: '10 to 16 Stations',
      minStations: 10,
      maxStations: 16,
      color: const Color(0xFF64B5F6), // Sky Blue
    ),
    TicketTier(
      zoneNumber: 3,
      price: 15,
      stationsRange: '17 to 23 Stations',
      minStations: 17,
      maxStations: 23,
      color: const Color(0xFF81C784), // Light Green
    ),
    TicketTier(
      zoneNumber: 4,
      price: 20,
      stationsRange: '24 to 39 Stations',
      minStations: 24,
      maxStations: 39,
      color: const Color(0xFFBA68C8), // Violet / Amethyst
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine current active tier
    int activeZoneIndex = 0;
    for (int i = 0; i < _tiers.length; i++) {
      if (_stationsCount >= _tiers[i].minStations &&
          _stationsCount <= _tiers[i].maxStations) {
        activeZoneIndex = i;
        break;
      }
    }

    final activeTier = _tiers[activeZoneIndex];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.surface,
      appBar: AppBar(
        title: const Text('Tickets & Fares'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? AppColors.darkOnSurface : AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.stackSm),
              // Interactive Calculator Section
              _buildCalculatorSection(
                context: context,
                isDark: isDark,
                activeTier: activeTier,
              ),

              const SizedBox(height: AppSpacing.stackLg),
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Zone Pricing',
                    style:
                        (isDark
                                ? AppTypography.darkHeadlineMedium
                                : AppTypography.headlineMedium)
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : Colors.black87,
                            ),
                  ),
                  Text(
                    'STANDARD FARES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant.withOpacity(0.7)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.stackLg),

              // Dynamic cards list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tiers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.stackMd),
                itemBuilder: (context, index) {
                  final tier = _tiers[index];
                  final isSelected = index == activeZoneIndex;

                  return _buildZoneCard(
                    context: context,
                    tier: tier,
                    isSelected: isSelected,
                    isDark: isDark,
                  );
                },
              ),

              const SizedBox(height: AppSpacing.stackLg * 1.5),

              // Informative Banner
              _buildInfoBanner(isDark),

              const SizedBox(height: AppSpacing.stackLg * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoneCard({
    required BuildContext context,
    required TicketTier tier,
    required bool isSelected,
    required bool isDark,
  }) {
    final containerBg = isDark
        ? AppColors.darkSurfaceContainerLow
        : AppColors.surfaceContainerLow;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: AppShapes.borderLG,
        border: Border.all(
          color: isSelected
              ? tier.color
              : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.shade300),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: tier.color.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tier.color.withOpacity(0.12),
                  border: Border.all(
                    color: tier.color.withOpacity(0.6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${tier.zoneNumber}',
                    style: TextStyle(
                      color: tier.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tier.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Current Selection',
                    style: TextStyle(
                      color: tier.color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),

          // Price Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${tier.price}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'EGP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Subtitle (Stations range)
          Text(
            tier.stationsRange,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection({
    required BuildContext context,
    required bool isDark,
    required TicketTier activeTier,
  }) {
    final cardBg = isDark
        ? AppColors.darkSurfaceContainer
        : AppColors.surfaceContainer;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppShapes.borderLG,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                'Fare Estimator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Drag the slider to select the number of stations you plan to travel and estimate your fare dynamically.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Slider and displays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stations:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : Colors.black87,
                ),
              ),
              Text(
                '${_stationsCount.round()} Stations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: activeTier.color,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeTier.color,
              inactiveTrackColor: isDark
                  ? Colors.white10
                  : Colors.grey.shade200,
              thumbColor: activeTier.color,
              overlayColor: activeTier.color.withOpacity(0.12),
              valueIndicatorColor: activeTier.color,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _stationsCount,
              min: 1.0,
              max: 39.0,
              divisions: 38,
              label: '${_stationsCount.round()}',
              onChanged: (value) {
                setState(() {
                  _stationsCount = value;
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          // Result Summary Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: activeTier.color.withOpacity(0.08),
              borderRadius: AppShapes.borderMD,
              border: Border.all(color: activeTier.color.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMATED FARE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant.withOpacity(0.8)
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Zone ${activeTier.zoneNumber} Ticket',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${activeTier.price} EGP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: activeTier.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainerLow
            : AppColors.surfaceContainerLow,
        borderRadius: AppShapes.borderLG,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fare Policies',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prices shown are for standard single-use yellow tickets. Special discounts apply for senior citizens, students, and people with determination. Monthly/annual subscriptions offer significant savings for daily commuters.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
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

class TicketTier {
  final int zoneNumber;
  final int price;
  final String stationsRange;
  final int minStations;
  final int maxStations;
  final Color color;

  const TicketTier({
    required this.zoneNumber,
    required this.price,
    required this.stationsRange,
    required this.minStations,
    required this.maxStations,
    required this.color,
  });
}
