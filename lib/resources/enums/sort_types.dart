import 'package:hive/hive.dart';

part 'sort_types.g.dart';

@HiveType(typeId : 1)
enum SortTypes{
  @HiveField(0)
  name,
  @HiveField(1)
  reverseName,
  @HiveField(2)
  date,
  @HiveField(3)
  reverseDate,
  @HiveField(4)
  size,
  @HiveField(5)
  reverseSize,
  @HiveField(6)
  random
}