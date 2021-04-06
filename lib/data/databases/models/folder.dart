import 'package:getx_gallery/data/databases/hive_db/models/models.dart' as hive;
import 'package:getx_gallery/data/entities/folder.dart' as entities;
import 'package:getx_gallery/resources/enums/sort_types.dart';

class Folder{
  final String name;
  final List<String> paths;
  final bool hidden;
  final SortTypes sortType;

  Folder({required this.name, required this.paths, required this.hidden, required this.sortType });

  Folder.fromHive(hive.Folder folder)
      :
        name = folder.name,
        paths = folder.paths,
        hidden = folder.hidden,
        sortType = folder.sortType;

  Folder.fromEntity(entities.Folder folder)
      :
        paths = folder.paths,
        hidden = folder.hidden,
        sortType = folder.sortType,
        name = folder.name;

  hive.Folder toHive({String? name, List<String>? paths , SortTypes? sortType, bool? hidden}) => hive.Folder(
      name: name ?? this.name,
      paths: paths ?? this.paths,
      sortType: sortType ?? this.sortType,
      hidden: hidden ?? this.hidden
  );

  entities.Folder toEntities() => entities.Folder(
      name: name,
      paths: paths,
      hidden: hidden,
      sortType: sortType
  );
}