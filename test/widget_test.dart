import 'package:flutter_test/flutter_test.dart';
import 'package:egy_metro/core/database/app_database.dart';
import 'package:egy_metro/core/database/database_seeder.dart';
import 'package:egy_metro/features/route_planner/domain/services/dijkstra_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite ffi for tests
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Metro Navigation and Dijkstra Service Tests', () {
    late AppDatabase database;
    late DatabaseSeeder seeder;
    late DijkstraService dijkstraService;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      seeder = DatabaseSeeder(database);
      await seeder.seedIfEmpty();
      dijkstraService = DijkstraService(database.stationDao, database.connectionDao);
    });

    tearDown(() async {
      await database.close();
    });

    test('Verify station seed count', () async {
      final stations = await database.stationDao.findAll();
      // Line 1: 35, Line 2: 20, Line 3: 34 = 89 stations total
      expect(stations.length, 89);
    });

    test('Verify connection seed count', () async {
      final connections = await database.connectionDao.findAll();
      expect(connections.isNotEmpty, true);
    });

    test('Dijkstra finds correct path on Line 1 (Helwan to New Marg)', () async {
      final result = await dijkstraService.findShortestPath(101, 135);
      expect(result, isNotNull);
      expect(result!.totalStops, 34);
      expect(result.stations.first.nameEn, 'Helwan');
      expect(result.stations.last.nameEn, 'New Marg');
    });

    test('Dijkstra finds correct path on Line 2 (Shubra El Kheima to El Mounib)', () async {
      final result = await dijkstraService.findShortestPath(201, 220);
      expect(result, isNotNull);
      expect(result!.totalStops, 19);
      expect(result.stations.first.nameEn, 'Shubra El Kheima');
      expect(result.stations.last.nameEn, 'El Mounib');
    });

    test('Dijkstra finds correct path on Line 3 (Adly Mansour to Cairo University)', () async {
      final result = await dijkstraService.findShortestPath(301, 334);
      expect(result, isNotNull);
      expect(result!.totalStops, 27); // 22 stops to Kit Kat, then 5 stops on branch
      expect(result.stations.first.nameEn, 'Adly Mansour');
      expect(result.stations.last.nameEn, 'Cairo University');
    });

    test('Dijkstra finds correct path with Line 1 -> Line 2 transfer (Helwan to Shubra El Kheima)', () async {
      final result = await dijkstraService.findShortestPath(101, 201);
      expect(result, isNotNull);
      // Transfer should happen at Sadat (119 <-> 211) or El Shohadaa (122 <-> 208)
      expect(result!.transfers.isNotEmpty, true);
    });
  });
}
