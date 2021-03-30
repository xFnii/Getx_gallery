import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();

  var _showHidden = false;
  final folders = <Folder>[].obs;
  final _allFolders = <Folder>[];

  @override
  Future onInit() async{
    _allFolders.addAll(await _repo.getPaths());
    final visibleFolders = _allFolders.where((element) => !element.hidden).toList();
    sortByName(list: visibleFolders);
    folders.addAll(visibleFolders);
    _listenPathStream();
    super.onInit();
  }

  @override
  Future onReady() async {
    if (await Permission.storage.request().isGranted){
      find();
    }
    super.onReady();
  }

  void toggleHidden(){
    _showHidden = !_showHidden;
    folders.clear();
    if(_showHidden){
      folders.addAll(_allFolders);
    } else {
      folders.addAll(_allFolders.where((element) => !element.hidden).toList());
    }
    sortByName();
  }

  void deleteAll(){
    folders.clear();
    _allFolders.clear();
    _repo.deleteAll();
  }

  void sortByName({List<Folder> list}){
    if (list == null){
      folders.sort((a,b) => C.fullPathToFile(a.name).toLowerCase().compareTo(C.fullPathToFile(b.name).toLowerCase()));
    } else {
      list.sort((a,b) => C.fullPathToFile(a.name).toLowerCase().compareTo(C.fullPathToFile(b.name).toLowerCase()));
    }
  }

  Future find() async => _repo.find();

  void _listenPathStream(){
    _repo.watchPaths().listen((event) {
      final folderPosition = _allFolders.indexWhere((element) => element.name==event.name);
      if(folderPosition!=-1){
        _allFolders.removeAt(folderPosition);
        folders.removeWhere((element) => element.name==event.name);
      }
      _allFolders.add(event);
      if(_showHidden){
        folders.add(event);
      } else if(!event.hidden) {
        folders.add(event);
      }
      sortByName();
    },
        onDone: () {
          sortByName();
        }
    );
  }
}