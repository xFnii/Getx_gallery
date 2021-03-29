
import 'package:hive/hive.dart';

part 'path.g.dart';

@HiveType(typeId: 1)
class Path{
  @HiveField(0)
  String fullPath;
}