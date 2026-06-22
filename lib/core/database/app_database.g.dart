// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MetroLineDao? _metroLineDaoInstance;

  StationDao? _stationDaoInstance;

  ConnectionDao? _connectionDaoInstance;

  FavoriteRouteDao? _favoriteRouteDaoInstance;

  RecentSearchDao? _recentSearchDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `metro_lines` (`id` INTEGER NOT NULL, `name_ar` TEXT NOT NULL, `name_en` TEXT NOT NULL, `color` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `stations` (`id` INTEGER NOT NULL, `name_ar` TEXT NOT NULL, `name_en` TEXT NOT NULL, `lat` REAL NOT NULL, `lng` REAL NOT NULL, `line_id` INTEGER NOT NULL, `is_interchange` INTEGER NOT NULL, FOREIGN KEY (`line_id`) REFERENCES `metro_lines` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `connections` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `from_station_id` INTEGER NOT NULL, `to_station_id` INTEGER NOT NULL, `line_id` INTEGER NOT NULL, `travel_time` INTEGER NOT NULL, FOREIGN KEY (`from_station_id`) REFERENCES `stations` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`to_station_id`) REFERENCES `stations` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`line_id`) REFERENCES `metro_lines` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `favorite_routes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `from_station_id` INTEGER NOT NULL, `to_station_id` INTEGER NOT NULL, `created_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `recent_searches` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `from_station_id` INTEGER NOT NULL, `to_station_id` INTEGER NOT NULL, `searched_at` TEXT NOT NULL)');
        await database.execute(
            'CREATE INDEX `index_stations_line_id` ON `stations` (`line_id`)');
        await database.execute(
            'CREATE INDEX `index_connections_from_station_id` ON `connections` (`from_station_id`)');
        await database.execute(
            'CREATE INDEX `index_connections_to_station_id` ON `connections` (`to_station_id`)');
        await database.execute(
            'CREATE INDEX `index_connections_line_id` ON `connections` (`line_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MetroLineDao get metroLineDao {
    return _metroLineDaoInstance ??= _$MetroLineDao(database, changeListener);
  }

  @override
  StationDao get stationDao {
    return _stationDaoInstance ??= _$StationDao(database, changeListener);
  }

  @override
  ConnectionDao get connectionDao {
    return _connectionDaoInstance ??= _$ConnectionDao(database, changeListener);
  }

  @override
  FavoriteRouteDao get favoriteRouteDao {
    return _favoriteRouteDaoInstance ??=
        _$FavoriteRouteDao(database, changeListener);
  }

  @override
  RecentSearchDao get recentSearchDao {
    return _recentSearchDaoInstance ??=
        _$RecentSearchDao(database, changeListener);
  }
}

class _$MetroLineDao extends MetroLineDao {
  _$MetroLineDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _metroLineEntityInsertionAdapter = InsertionAdapter(
            database,
            'metro_lines',
            (MetroLineEntity item) => <String, Object?>{
                  'id': item.id,
                  'name_ar': item.nameAr,
                  'name_en': item.nameEn,
                  'color': item.color
                }),
        _metroLineEntityDeletionAdapter = DeletionAdapter(
            database,
            'metro_lines',
            ['id'],
            (MetroLineEntity item) => <String, Object?>{
                  'id': item.id,
                  'name_ar': item.nameAr,
                  'name_en': item.nameEn,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MetroLineEntity> _metroLineEntityInsertionAdapter;

  final DeletionAdapter<MetroLineEntity> _metroLineEntityDeletionAdapter;

  @override
  Future<List<MetroLineEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM metro_lines ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => MetroLineEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            color: row['color'] as String));
  }

  @override
  Future<MetroLineEntity?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM metro_lines WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MetroLineEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            color: row['color'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM metro_lines');
  }

  @override
  Future<void> insertLine(MetroLineEntity line) async {
    await _metroLineEntityInsertionAdapter.insert(
        line, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<MetroLineEntity> lines) async {
    await _metroLineEntityInsertionAdapter.insertList(
        lines, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteLine(MetroLineEntity line) async {
    await _metroLineEntityDeletionAdapter.delete(line);
  }
}

class _$StationDao extends StationDao {
  _$StationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stationEntityInsertionAdapter = InsertionAdapter(
            database,
            'stations',
            (StationEntity item) => <String, Object?>{
                  'id': item.id,
                  'name_ar': item.nameAr,
                  'name_en': item.nameEn,
                  'lat': item.lat,
                  'lng': item.lng,
                  'line_id': item.lineId,
                  'is_interchange': item.isInterchange ? 1 : 0
                }),
        _stationEntityDeletionAdapter = DeletionAdapter(
            database,
            'stations',
            ['id'],
            (StationEntity item) => <String, Object?>{
                  'id': item.id,
                  'name_ar': item.nameAr,
                  'name_en': item.nameEn,
                  'lat': item.lat,
                  'lng': item.lng,
                  'line_id': item.lineId,
                  'is_interchange': item.isInterchange ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StationEntity> _stationEntityInsertionAdapter;

  final DeletionAdapter<StationEntity> _stationEntityDeletionAdapter;

  @override
  Future<List<StationEntity>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM stations ORDER BY name_en ASC',
        mapper: (Map<String, Object?> row) => StationEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            lineId: row['line_id'] as int,
            isInterchange: (row['is_interchange'] as int) != 0));
  }

  @override
  Future<StationEntity?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM stations WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StationEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            lineId: row['line_id'] as int,
            isInterchange: (row['is_interchange'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<StationEntity>> findByLine(int lineId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM stations WHERE line_id = ?1 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => StationEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            lineId: row['line_id'] as int,
            isInterchange: (row['is_interchange'] as int) != 0),
        arguments: [lineId]);
  }

  @override
  Future<List<StationEntity>> findInterchanges() async {
    return _queryAdapter.queryList(
        'SELECT * FROM stations WHERE is_interchange = 1',
        mapper: (Map<String, Object?> row) => StationEntity(
            id: row['id'] as int,
            nameAr: row['name_ar'] as String,
            nameEn: row['name_en'] as String,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            lineId: row['line_id'] as int,
            isInterchange: (row['is_interchange'] as int) != 0));
  }

  @override
  Future<List<StationEntity>> search(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM stations WHERE LOWER(name_en) LIKE LOWER(?1) OR name_ar LIKE ?1 ORDER BY name_en ASC',
        mapper: (Map<String, Object?> row) => StationEntity(id: row['id'] as int, nameAr: row['name_ar'] as String, nameEn: row['name_en'] as String, lat: row['lat'] as double, lng: row['lng'] as double, lineId: row['line_id'] as int, isInterchange: (row['is_interchange'] as int) != 0),
        arguments: [query]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM stations');
  }

  @override
  Future<void> insertStation(StationEntity station) async {
    await _stationEntityInsertionAdapter.insert(
        station, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<StationEntity> stations) async {
    await _stationEntityInsertionAdapter.insertList(
        stations, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteStation(StationEntity station) async {
    await _stationEntityDeletionAdapter.delete(station);
  }
}

class _$ConnectionDao extends ConnectionDao {
  _$ConnectionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _connectionEntityInsertionAdapter = InsertionAdapter(
            database,
            'connections',
            (ConnectionEntity item) => <String, Object?>{
                  'id': item.id,
                  'from_station_id': item.fromStationId,
                  'to_station_id': item.toStationId,
                  'line_id': item.lineId,
                  'travel_time': item.travelTime
                }),
        _connectionEntityDeletionAdapter = DeletionAdapter(
            database,
            'connections',
            ['id'],
            (ConnectionEntity item) => <String, Object?>{
                  'id': item.id,
                  'from_station_id': item.fromStationId,
                  'to_station_id': item.toStationId,
                  'line_id': item.lineId,
                  'travel_time': item.travelTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ConnectionEntity> _connectionEntityInsertionAdapter;

  final DeletionAdapter<ConnectionEntity> _connectionEntityDeletionAdapter;

  @override
  Future<List<ConnectionEntity>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM connections',
        mapper: (Map<String, Object?> row) => ConnectionEntity(
            id: row['id'] as int?,
            fromStationId: row['from_station_id'] as int,
            toStationId: row['to_station_id'] as int,
            lineId: row['line_id'] as int,
            travelTime: row['travel_time'] as int));
  }

  @override
  Future<List<ConnectionEntity>> findNeighbours(int stationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM connections WHERE from_station_id = ?1',
        mapper: (Map<String, Object?> row) => ConnectionEntity(
            id: row['id'] as int?,
            fromStationId: row['from_station_id'] as int,
            toStationId: row['to_station_id'] as int,
            lineId: row['line_id'] as int,
            travelTime: row['travel_time'] as int),
        arguments: [stationId]);
  }

  @override
  Future<List<ConnectionEntity>> findByLine(int lineId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM connections WHERE line_id = ?1 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => ConnectionEntity(
            id: row['id'] as int?,
            fromStationId: row['from_station_id'] as int,
            toStationId: row['to_station_id'] as int,
            lineId: row['line_id'] as int,
            travelTime: row['travel_time'] as int),
        arguments: [lineId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM connections');
  }

  @override
  Future<void> insertConnection(ConnectionEntity connection) async {
    await _connectionEntityInsertionAdapter.insert(
        connection, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<ConnectionEntity> connections) async {
    await _connectionEntityInsertionAdapter.insertList(
        connections, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteConnection(ConnectionEntity connection) async {
    await _connectionEntityDeletionAdapter.delete(connection);
  }
}

class _$FavoriteRouteDao extends FavoriteRouteDao {
  _$FavoriteRouteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoriteRouteEntityInsertionAdapter = InsertionAdapter(
            database,
            'favorite_routes',
            (FavoriteRouteEntity item) => <String, Object?>{
                  'id': item.id,
                  'from_station_id': item.fromStationId,
                  'to_station_id': item.toStationId,
                  'created_at': item.createdAt
                }),
        _favoriteRouteEntityDeletionAdapter = DeletionAdapter(
            database,
            'favorite_routes',
            ['id'],
            (FavoriteRouteEntity item) => <String, Object?>{
                  'id': item.id,
                  'from_station_id': item.fromStationId,
                  'to_station_id': item.toStationId,
                  'created_at': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FavoriteRouteEntity>
      _favoriteRouteEntityInsertionAdapter;

  final DeletionAdapter<FavoriteRouteEntity>
      _favoriteRouteEntityDeletionAdapter;

  @override
  Future<List<FavoriteRouteEntity>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM favorite_routes ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => FavoriteRouteEntity(
            id: row['id'] as int?,
            fromStationId: row['from_station_id'] as int,
            toStationId: row['to_station_id'] as int,
            createdAt: row['created_at'] as String));
  }

  @override
  Future<FavoriteRouteEntity?> findByRoute(
    int fromId,
    int toId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM favorite_routes WHERE from_station_id = ?1 AND to_station_id = ?2 LIMIT 1',
        mapper: (Map<String, Object?> row) => FavoriteRouteEntity(id: row['id'] as int?, fromStationId: row['from_station_id'] as int, toStationId: row['to_station_id'] as int, createdAt: row['created_at'] as String),
        arguments: [fromId, toId]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM favorite_routes WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM favorite_routes');
  }

  @override
  Future<void> insertFavorite(FavoriteRouteEntity favorite) async {
    await _favoriteRouteEntityInsertionAdapter.insert(
        favorite, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteFavorite(FavoriteRouteEntity favorite) async {
    await _favoriteRouteEntityDeletionAdapter.delete(favorite);
  }
}

class _$RecentSearchDao extends RecentSearchDao {
  _$RecentSearchDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recentSearchEntityInsertionAdapter = InsertionAdapter(
            database,
            'recent_searches',
            (RecentSearchEntity item) => <String, Object?>{
                  'id': item.id,
                  'from_station_id': item.fromStationId,
                  'to_station_id': item.toStationId,
                  'searched_at': item.searchedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecentSearchEntity>
      _recentSearchEntityInsertionAdapter;

  @override
  Future<List<RecentSearchEntity>> findRecent() async {
    return _queryAdapter.queryList(
        'SELECT * FROM recent_searches ORDER BY searched_at DESC LIMIT 10',
        mapper: (Map<String, Object?> row) => RecentSearchEntity(
            id: row['id'] as int?,
            fromStationId: row['from_station_id'] as int,
            toStationId: row['to_station_id'] as int,
            searchedAt: row['searched_at'] as String));
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM recent_searches WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> clearAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM recent_searches');
  }

  @override
  Future<void> insertSearch(RecentSearchEntity search) async {
    await _recentSearchEntityInsertionAdapter.insert(
        search, OnConflictStrategy.replace);
  }
}
