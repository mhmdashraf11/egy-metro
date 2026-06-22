import 'package:get_it/get_it.dart';
import 'core/database/app_database.dart';
import 'core/database/database_seeder.dart';
import 'features/nearby_stations/domain/services/nearby_stations_service.dart';
import 'features/route_planner/domain/services/dijkstra_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Database
  final db = await AppDatabase.create();
  sl.registerSingleton<AppDatabase>(db);

  // Seed metro data on first launch
  final seeder = DatabaseSeeder(db);
  await seeder.seedIfEmpty();

  //! DAOs (registered via the singleton database)
  sl.registerLazySingleton(() => sl<AppDatabase>().metroLineDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().stationDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().connectionDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().favoriteRouteDao);
  sl.registerLazySingleton(() => sl<AppDatabase>().recentSearchDao);

  //! Services
  sl.registerLazySingleton(() => DijkstraService(sl(), sl()));
  sl.registerLazySingleton(() => NearbyStationsService(sl()));

  //! Features - to be added per feature
  // Repositories
  // Use cases
  // Cubits
}
