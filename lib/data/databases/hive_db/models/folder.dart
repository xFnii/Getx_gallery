import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> paths;
  @HiveField(2)
  bool hidden;
  @HiveField(3)
  SortTypes sortType;

  Folder({this.name ='', this.paths = const [], this.sortType = SortTypes.name, this.hidden = false});

  Folder copyWith({String? name, List<String>? paths , SortTypes? sortType, bool? hidden})=>Folder(
    name: name ?? this.name,
    paths: paths ?? this.paths,
    sortType: sortType ?? this.sortType,
    hidden: hidden ?? this.hidden
  );
}