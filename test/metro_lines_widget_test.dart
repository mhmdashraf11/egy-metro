import 'package:egy_metro/core/database/app_database.dart';
import 'package:egy_metro/core/database/database_seeder.dart';
import 'package:egy_metro/features/metro_lines/presentation/pages/metro_lines_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() async {
    final database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    final seeder = DatabaseSeeder(database);
    await seeder.seedIfEmpty();
    
    final sl = GetIt.instance;
    if (!sl.isRegistered<AppDatabase>()) {
      sl.registerSingleton<AppDatabase>(database);
      sl.registerLazySingleton(() => database.stationDao);
    }
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('MetroLinesPage renders correctly inside Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MetroLinesPage(),
        ),
      ),
    );
    expect(find.text('Metro Map'), findsOneWidget);
    expect(find.text('Choose a line'), findsWidgets);
  });
}
