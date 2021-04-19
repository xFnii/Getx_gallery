import 'package:getx_gallery/data/databases/models/db_models.dart';

abstract class LocalDataSource{

  List<Folder> getFolders();
  Folder getFolder(int name);
  void addFolders(List<Folder> folders);
  void addFolder(Folder folder);
  void updateFolder(Folder folder);
  void actualizeFolder(Folder folder);
  void deleteFolder(Folder folder);
  void deleteAll();
  Stream<Folder> watchFolders();
}