// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build --delete-conflicting-outputs

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../features/metro_lines/data/datasources/metro_line_dao.dart';
import '../../features/metro_lines/data/datasources/station_dao.dart';
import '../../features/metro_lines/data/models/metro_line_entity.dart';
import '../../features/metro_lines/data/models/station_entity.dart';
import '../../features/route_planner/data/datasources/connection_dao.dart';
import '../../features/route_planner/data/datasources/recent_search_dao.dart';
import '../../features/route_planner/data/models/connection_entity.dart';
import '../../features/route_planner/data/models/recent_search_entity.dart';
import '../../features/favorites/data/datasources/favorite_route_dao.dart';
import '../../features/favorites/data/models/favorite_route_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [
  MetroLineEntity,
  StationEntity,
  ConnectionEntity,
  FavoriteRouteEntity,
  RecentSearchEntity,
])
abstract class AppDatabase extends FloorDatabase {
  MetroLineDao get metroLineDao;
  StationDao get stationDao;
  ConnectionDao get connectionDao;
  FavoriteRouteDao get favoriteRouteDao;
  RecentSearchDao get recentSearchDao;

  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase
        .databaseBuilder('egy_metro.db')
        .addCallback(_migrationCallback)
        .build();
  }

  /// Called on first database creation – seeds all metro data.
  static final _migrationCallback = Callback(
    onCreate: (db, version) async {
      // Foreign keys must be enabled explicitly for SQLite on Android.
      await db.execute('PRAGMA foreign_keys = ON');
    },
  );
}
