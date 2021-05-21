
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/presentation/common/controller/folder_controller.dart';

abstract class Repository {
  void find();
  Stream<Folder> watchFolders();
  void actualizeFolders();
  List<Folder> getFolders();
  void updateFolder(Folder folder);
  void deleteAll();
}