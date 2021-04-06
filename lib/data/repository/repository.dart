
import 'package:getx_gallery/data/entities/folder.dart';

abstract class Repository {
  Future find();
  Stream<Folder> watchFolders();
  Future getFolders();
  void updateFolder(Folder folder);
  void deleteAll();
}