import 'package:floor/floor.dart';

@Entity(tableName: 'favorite_routes')
class FavoriteRouteEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'from_station_id')
  final int fromStationId;

  @ColumnInfo(name: 'to_station_id')
  final int toStationId;

  /// ISO8601 timestamp string
  @ColumnInfo(name: 'created_at')
  final String createdAt;

  const FavoriteRouteEntity({
    this.id,
    required this.fromStationId,
    required this.toStationId,
    required this.createdAt,
  });
}
