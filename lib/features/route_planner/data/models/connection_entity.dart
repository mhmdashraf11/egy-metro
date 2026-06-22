import 'package:floor/floor.dart';
import 'package:egy_metro/features/metro_lines/data/models/metro_line_entity.dart';
import 'package:egy_metro/features/metro_lines/data/models/station_entity.dart';

@Entity(
  tableName: 'connections',
  foreignKeys: [
    ForeignKey(
      childColumns: ['from_station_id'],
      parentColumns: ['id'],
      entity: StationEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['to_station_id'],
      parentColumns: ['id'],
      entity: StationEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['line_id'],
      parentColumns: ['id'],
      entity: MetroLineEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['from_station_id']),
    Index(value: ['to_station_id']),
    Index(value: ['line_id']),
  ],
)
class ConnectionEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'from_station_id')
  final int fromStationId;

  @ColumnInfo(name: 'to_station_id')
  final int toStationId;

  @ColumnInfo(name: 'line_id')
  final int lineId;

  /// Travel time in minutes
  @ColumnInfo(name: 'travel_time')
  final int travelTime;

  const ConnectionEntity({
    this.id,
    required this.fromStationId,
    required this.toStationId,
    required this.lineId,
    required this.travelTime,
  });
}
