import 'package:egy_metro/features/metro_lines/presentation/widgets/metro_map.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/home/presentation/pages/main_screen.dart';
import '../../features/route_planner/presentation/pages/route_planner_page.dart';
import '../../features/metro_lines/presentation/pages/metro_lines_page.dart';
import '../../features/nearby_stations/presentation/pages/nearby_stations_page.dart';
import '../../features/ticket_pricing/presentation/pages/ticket_pricing_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/metro_lines/presentation/pages/station_details_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case AppRoutes.routePlanner:
        return MaterialPageRoute(builder: (_) => const RoutePlannerPage());

      case AppRoutes.metroLines:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Metro Lines'),
            ),
            body: const MetroLinesPage(),
          ),
        );

      case AppRoutes.nearbyStations:
        return MaterialPageRoute(builder: (_) => const NearbyStationsPage());

      case AppRoutes.ticketPricing:
        return MaterialPageRoute(builder: (_) => const TicketPricingPage());

      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());

      case AppRoutes.stationDetails:
        final id = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => StationDetailsPage(stationId: id),
        );
      case AppRoutes.metroMap:
        return MaterialPageRoute(builder: (_) => const MetroMap());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
