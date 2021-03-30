import 'package:getx_gallery/data/databases/hive_db/models/models.dart' as hive;
import 'package:getx_gallery/data/entities/folder.dart' as entities;
import 'package:getx_gallery/resources/enums/sort_types.dart';

class Folder{
  final String name;
  final List<String> paths;
  final bool hidden;
  final SortTypes sortType;

  Folder({required this.name, required this.paths, required this.hidden, this.sortType = SortTypes.name});

  Folder.fromHive(hive.Folder folder, this.name)
      :
        paths = folder.paths,
        hidden = folder.hidden,
        sortType = folder.sortType;

  Folder.fromEntity(entities.Folder folder)
      :
        paths = folder.paths,
        hidden = folder.hidden,
        sortType = SortTypes.name,
        name = folder.name;

  hive.Folder toHive() => hive.Folder(
    paths: paths,
    hidden: hidden,
    sortType: sortType
  );

  entities.Folder toEntities() => entities.Folder(
      name: name,
      paths: paths,
      hidden: hidden,
  );
}