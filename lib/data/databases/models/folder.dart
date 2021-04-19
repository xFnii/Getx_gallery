import 'package:getx_gallery/data/databases/hive_db/models/models.dart' as hive;
import 'package:getx_gallery/data/databases/models/db_models.dart';
import 'package:getx_gallery/data/entities/entities.dart' as entities;
import 'package:getx_gallery/resources/enums/sort_types.dart';

class Folder{
  final String path;
  final List<Image> images;
  final bool hidden;
  final SortTypes sortType;

  Folder({required this.path, required this.images, required this.hidden, required this.sortType });

  Folder.fromHive(hive.Folder folder)
      :
        path = folder.path,
        images = folder.images.map((e) => Image.fromHive(e)).toList(),
        hidden = folder.hidden,
        sortType = folder.sortType;

  Folder.fromEntity(entities.Folder folder)
      :
        path = folder.path,
        images = folder.images.map((e) => Image.fromEntity(e)).toList(),
        hidden = folder.hidden,
        sortType = folder.sortType;

  hive.Folder toHive({String? name, List<Image>? images , SortTypes? sortType, bool? hidden}) => hive.Folder(
      path: name ?? this.path,
      images: (images ?? this.images).map((e) => e.toHive()).toList(),
      sortType: sortType ?? this.sortType,
      hidden: hidden ?? this.hidden
  );

  entities.Folder toEntities() => entities.Folder(
      path: path,
      images: images.map((e) => e.toEntities()).toList(),
      hidden: hidden,
      sortType: sortType
  );
}