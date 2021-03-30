
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';

abstract class Repository {
  Future find();
  MiniStream<Folder> watchPaths();
  Future<List<Folder>> getPaths();
  Future deleteAll();
}