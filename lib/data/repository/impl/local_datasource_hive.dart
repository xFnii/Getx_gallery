import 'package:getx_gallery/data/databases/hive_db/database.dart';
import 'package:getx_gallery/data/databases/models/folder.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';

class LocalDataSourceHive extends LocalDataSource{

  final HiveDB _hiveDB;

  LocalDataSourceHive(this._hiveDB);

  @override
  List<Folder> getFolders() {
    return _hiveDB.getFolders();
  }

  @override
  Folder getFolder(int name) {
    return _hiveDB.getFolder(name);
  }

  @override
  void addFolders(List<Folder> folders) {
    return _hiveDB.addFolders(folders);
  }

  @override
  void addFolder(Folder folder) {
    return _hiveDB.addFolder(folder);
  }

  @override
  void updateFolder(Folder folder) {
    return _hiveDB.addFolder(folder);
  }

  @override
  void actualizeFolder(Folder folder) {
    return _hiveDB.addFolder(folder);
  }

  @override
  void deleteFolder(Folder folder) {
    return _hiveDB.deleteFolder(folder.path.hashCode);
  }

  @override
  Future deleteAll() {
    return _hiveDB.deleteAll();
  }

  @override
  Stream<Folder> watchFolders() {
    return _hiveDB.watchFolder().map((event) => Folder.fromHive(event));
  }
}