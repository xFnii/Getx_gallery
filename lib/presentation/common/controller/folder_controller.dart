import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';

class FolderController extends GetxController {
  final folders = <Folder>[].obs;
  final visibleFolders = <Folder>[].obs;
  final openedFolder = Folder.dummy().obs;
  final Repository _repo;

  FolderController({required Repository repository}):_repo = repository;


  @override
  void onInit() {
    _listenFolderStream();
    super.onInit();
  }

  void _listenFolderStream(){
    _repo.watchFolders().listen((event) {
      final folderPosition = folders.indexWhere((element) => element.path==event.path);
      if(event.path==openedFolder.value.path){
        openedFolder.value = event;
      }
      if(folderPosition!=-1){
        folders.removeAt(folderPosition);
        visibleFolders.removeWhere((element) => element.path==event.path);
      }
      if(!event.hidden){
        visibleFolders.add(event);
      }
      folders.add(event);
      sortByName();
    },
        onDone: () {
          sortByName();
        }
    );
  }

  // ignore: use_setters_to_change_properties
  void openFolder(Folder folder) => openedFolder.value = folder;

  void sortByName({List<Folder>? list}){
    if (list == null){
      visibleFolders.sort((a,b) => C.fullPathToFile(a.path).toLowerCase().compareTo(C.fullPathToFile(b.path).toLowerCase()));
      folders.sort((a,b) => C.fullPathToFile(a.path).toLowerCase().compareTo(C.fullPathToFile(b.path).toLowerCase()));
    } else {
      list.sort((a,b) => C.fullPathToFile(a.path).toLowerCase().compareTo(C.fullPathToFile(b.path).toLowerCase()));
    }
  }
}