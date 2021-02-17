import 'package:getx_gallery/data/db/database.dart';

abstract class LocalDataSource{

  Future<List<String>> getPaths();
  Future<List<Folder>> getFolders();
  Future addPath(String path);
  Future addHiddenFolders(List<String> paths);
  Future addPaths(List<String> paths);
  Future deleteAll();
  Stream<String> watchPaths();
}