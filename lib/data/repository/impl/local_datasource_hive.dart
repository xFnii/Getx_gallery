import 'package:getx_gallery/data/databases/hive_db/database.dart';
import 'package:getx_gallery/data/databases/models/folder.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';

class LocalDataSourceHive extends LocalDataSource{

  final HiveDB _hiveDB;

  LocalDataSourceHive(this._hiveDB);

  @override
  Future<List<Folder>> getFolders() {
    return _hiveDB.getFolders();
  }

  @override
  Future addFolders(List<Folder> folders) {
    return _hiveDB.addFolders(folders);
  }

  @override
  Future deleteAll() {
    return _hiveDB.deleteAll();
  }

  @override
  Future addHiddenFolders(List<String> paths) {
    // TODO: implement addHiddenFolders
    throw UnimplementedError();
  }

  @override
  Future addPath(String path) {
    // TODO: implement addPath
    throw UnimplementedError();
  }

  @override
  Future addPaths(List<String> paths) {
    // TODO: implement addPaths
    throw UnimplementedError();
  }


  @override
  Future<List<String>> getPaths() {
    // TODO: implement getPaths
    throw UnimplementedError();
  }

  @override
  Stream<String> watchPaths() {
    // TODO: implement watchPaths
    throw UnimplementedError();
  }


}