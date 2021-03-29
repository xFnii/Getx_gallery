import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder{
  @HiveField(0)
  List<String> paths;
  @HiveField(1)
  bool hidden;
  @HiveField(2)
  SortTypes sortType;

  Folder({this.paths, this.hidden, this.sortType});
}