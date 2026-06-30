import 'package:egy_metro/core/services/local_storage_service.dart';
import 'package:egy_metro/features/settings/data/datasources/local_storage_service.dart';
import 'package:egy_metro/features/settings/data/repositories/settings_repository.dart';
import 'package:get_it/get_it.dart';
import 'core/database/app_database.dart';
import 'core/database/database_seeder.dart';
import 'features/nearby_stations/domain/services/nearby_stations_service.dart';
import 'features/route_planner/domain/services/dijkstra_service.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/route_planner/presentation/cubit/route_planner_cubit.dart';
import 'package:egy_metro/features/favorites/data/repositories/favorites_repository.dart';
import 'package:egy_metro/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
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
  sl.registerLazySingleton(() => LocalStorageService(sl()));
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  ); //! Features - to be added per feature
  // Repositories
  sl.registerLazySingleton(() => SettingsRepository(sl()));
  sl.registerLazySingleton(() => FavoritesRepository(sl()));
  // Use cases
  // Cubits
  sl.registerLazySingleton(() => SettingsCubit(settingsRepository: sl())..loadSettings());
  sl.registerLazySingleton(() => FavoriteCubit(favoritesRepository: sl()));
  sl.registerFactory(
    () => RoutePlannerCubit(
      stationDao: sl(),
      recentSearchDao: sl(),
      favoriteRouteDao: sl(),
      dijkstraService: sl(),
      nearbyStationsService: sl(),
    ),
  );
}
