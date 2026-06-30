import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:egy_metro/core/localization/app_translation.dart';
import 'package:egy_metro/core/theme/app_colors.dart';

class MetroMapPage extends StatelessWidget {
  const MetroMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final mapAsset = isArabic ? 'assets/images/metro_map_ar.jpg' : 'assets/images/metro_map_en.jpg';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      appBar: AppBar(
        title: Text(
          AppTranslation.translate(context, 'metro_map'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? AppColors.darkOnSurface : Colors.black87,
      ),
      body: Container(
        color: isDark ? AppColors.darkSurface : Colors.white,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
          ),
          imageProvider: AssetImage(mapAsset),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 4,
        ),
      ),
    );
  }
}
