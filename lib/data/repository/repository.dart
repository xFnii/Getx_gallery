
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';

abstract class Repository {
  Future find();
  MiniStream<List<Folder>> watchPaths();
  Future<List<Folder>> getPaths();
  Future addPaths(List<String> paths);
  Future addHiddenFolders(List<String> paths);
  Future deleteAll();
  Future findHandler(Map<String, List<String>> data);
}