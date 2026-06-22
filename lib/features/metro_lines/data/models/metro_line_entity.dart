import 'package:floor/floor.dart';

@Entity(tableName: 'metro_lines')
class MetroLineEntity {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'name_ar')
  final String nameAr;

  @ColumnInfo(name: 'name_en')
  final String nameEn;

  /// Hex color string, e.g. "#1A5CA8"
  final String color;

  const MetroLineEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.color,
  });
}
