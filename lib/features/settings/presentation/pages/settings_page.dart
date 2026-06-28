import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_shapes.dart';
import 'package:egy_metro/core/theme/app_spacing.dart';
import 'package:egy_metro/core/localization/app_translation.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppTranslation.translate(context, 'settings'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: isDark ? AppColors.darkOnSurface : Colors.black87,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme settings section
                _buildSectionHeader(
                  context,
                  AppTranslation.translate(context, 'theme_mode'),
                  Icons.palette_outlined,
                  isDark,
                ),
                const SizedBox(height: AppSpacing.stackMd),
                _buildThemeSelector(context, state.themeMode, cubit, isDark),
                const SizedBox(height: AppSpacing.stackLg),

                // Language settings section
                _buildSectionHeader(
                  context,
                  AppTranslation.translate(context, 'language'),
                  Icons.language,
                  isDark,
                ),
                const SizedBox(height: AppSpacing.stackMd),
                _buildLanguageSelector(context, state.locale, cubit, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkOnSurface : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    ThemeMode currentMode,
    SettingsCubit cubit,
    bool isDark,
  ) {
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFF5F5F5);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.borderLG,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              context: context,
              label: AppTranslation.translate(context, 'light_mode'),
              icon: Icons.light_mode,
              isActive: currentMode == ThemeMode.light || (currentMode == ThemeMode.system && !isDark),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
              onTap: () => cubit.setThemeMode(ThemeMode.light),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
              context: context,
              label: AppTranslation.translate(context, 'dark_mode'),
              icon: Icons.dark_mode,
              isActive: currentMode == ThemeMode.dark || (currentMode == ThemeMode.system && isDark),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
              onTap: () => cubit.setThemeMode(ThemeMode.dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    Locale currentLocale,
    SettingsCubit cubit,
    bool isDark,
  ) {
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkSurfaceContainerHigh : const Color(0xFFF5F5F5);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainerLow : Colors.white,
        borderRadius: AppShapes.borderLG,
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              context: context,
              label: AppTranslation.translate(context, 'english'),
              icon: Icons.abc,
              isActive: currentLocale.languageCode == 'en',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
              onTap: () => cubit.setLocale(const Locale('en')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
              context: context,
              label: AppTranslation.translate(context, 'arabic'),
              icon: Icons.translate,
              isActive: currentLocale.languageCode == 'ar',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isDark: isDark,
              onTap: () => cubit.setLocale(const Locale('ar')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: AppShapes.borderMD,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppShapes.borderMD,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? Colors.white
                      : (isDark ? AppColors.darkOnSurfaceVariant : Colors.black54),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Colors.white
                        : (isDark ? AppColors.darkOnSurface : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
