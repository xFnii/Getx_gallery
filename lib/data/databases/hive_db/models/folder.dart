import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:hive/hive.dart';
import 'image.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder{
  @HiveField(0)
  final String path;
  @HiveField(1)
  final List<Image> images;
  @HiveField(2)
  final bool hidden;
  @HiveField(3)
  final SortTypes sortType;

  Folder({this.path ='', this.images = const [], this.sortType = SortTypes.name, this.hidden = false});

  Folder copyWith({String? name, List<Image>? images , SortTypes? sortType, bool? hidden})=>Folder(
    path: name ?? this.path,
      images: images ?? this.images,
    sortType: sortType ?? this.sortType,
    hidden: hidden ?? this.hidden
  );
}