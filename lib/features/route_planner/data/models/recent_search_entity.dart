import 'package:floor/floor.dart';

@Entity(tableName: 'recent_searches')
class RecentSearchEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'from_station_id')
  final int fromStationId;

  @ColumnInfo(name: 'to_station_id')
  final int toStationId;

  /// ISO8601 timestamp string
  @ColumnInfo(name: 'searched_at')
  final String searchedAt;

  const RecentSearchEntity({
    this.id,
    required this.fromStationId,
    required this.toStationId,
    required this.searchedAt,
  });
}
