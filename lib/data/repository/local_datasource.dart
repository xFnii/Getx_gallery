import 'package:getx_gallery/data/db/database.dart';

abstract class LocalDataSource{

  Future<List<String>> getPaths();
  Future<List<Folder>> getFolders();
  Future addPath(String path);
  Future addHiddenPath(String path);
  Future addPaths(List<String> paths);
  Stream<String> watchPaths();
}