import 'package:floor/floor.dart';
import 'metro_line_entity.dart';

@Entity(
  tableName: 'stations',
  foreignKeys: [
    ForeignKey(
      childColumns: ['line_id'],
      parentColumns: ['id'],
      entity: MetroLineEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['line_id']),
  ],
)
class StationEntity {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'name_ar')
  final String nameAr;

  @ColumnInfo(name: 'name_en')
  final String nameEn;

  final double lat;
  final double lng;

  @ColumnInfo(name: 'line_id')
  final int lineId;

  @ColumnInfo(name: 'is_interchange')
  final bool isInterchange;

  const StationEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.lat,
    required this.lng,
    required this.lineId,
    this.isInterchange = false,
  });
}
