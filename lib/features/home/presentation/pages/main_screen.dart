import 'package:egy_metro/core/theme/app_colors.dart';
import 'package:egy_metro/core/theme/app_typography.dart';
import 'package:egy_metro/features/home/presentation/pages/home_page.dart';
import 'package:egy_metro/features/metro_lines/presentation/pages/metro_lines_page.dart';
import 'package:egy_metro/features/route_planner/presentation/pages/route_planner_page.dart';
import 'package:egy_metro/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    MetroLinesPage(),
    const RoutePlannerPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text(
          'Cairo Metro',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkOnSurface : AppColors.primary,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.translate), onPressed: () {}),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? AppColors.darkOnSurface : AppColors.primary,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        selectedItemColor: isDark ? AppColors.darkPrimary : AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train_outlined),
            activeIcon: Icon(Icons.train),
            label: 'Lines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Route',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
