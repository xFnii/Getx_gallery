import 'package:get/get.dart';
import 'package:getx_gallery/data/db/database.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';

class LocalDataSourceImpl implements LocalDataSource{

  final Database _db = Get.find<Database>();

  @override
  Future addPath(String path) => _db.pathDao.addItem(path);

  @override
  Future<List<String>> getPaths() async => (await _db.pathDao.getAll()).map((e) => e.fullPath).toList();

  @override
  Future<List<Folder>> getFolders() async => _db.folderDao.getAll();

  @override
  Stream<String> watchPaths() => _db.pathDao.watch().map((event) => event.fullPath);

  @override
  Future addPaths(List<String> paths) => _db.pathDao.addItems(paths);

  @override
  Future addHiddenFolders(List<String> paths) => _db.folderDao.addHiddenFolders(paths);

  @override
  Future deleteAll() => _db.deleteAll();
}