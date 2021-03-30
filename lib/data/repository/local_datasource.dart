

import 'package:getx_gallery/data/databases/models/db_models.dart';

abstract class LocalDataSource{

  Future<List<String>> getPaths();
  Future<List<Folder>> getFolders();
  Future addFolders(List<Folder> folders);
  Future addFolder(Folder folder);
  Future addPath(String path);
  Future addHiddenFolders(List<String> paths);
  Future addPaths(List<String> paths);
  Future deleteAll();
  Stream<String> watchPaths();
}