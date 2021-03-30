import 'package:getx_gallery/data/databases/hive_db/models/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_model;
import 'package:hive/hive.dart';


class HiveDB {
  final _folderTag = 'folders';

  Future addFolders(List<db_model.Folder> folders) async {
    final foldersBox = await Hive.openBox<Folder>(_folderTag);
    for(final folder in folders){
      foldersBox.put(folder.name, folder.toHive());
    }
    foldersBox.close();
  }

  Future addFolder(db_model.Folder folder) async {
    final foldersBox = await Hive.openBox<Folder>(_folderTag);
    foldersBox.put(folder.name, folder.toHive());
    foldersBox.close();
  }

  Future<List<db_model.Folder>> getFolders() async {
    final foldersBox = await Hive.openBox<Folder>(_folderTag);
    final keys = foldersBox.keys;
    return [
      for(final key in keys)
        db_model.Folder.fromHive(foldersBox.get(key) ?? Folder(paths: []), key as String)
    ];
  }

  Future deleteAll() async {
    await Hive.box(_folderTag).deleteFromDisk();
  }

}