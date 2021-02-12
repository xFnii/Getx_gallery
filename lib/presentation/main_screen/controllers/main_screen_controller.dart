import 'package:get/get.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();
  final paths = <String>[].obs;

  final folders = <String, List<String>>{}.obs;

  final keys = <String>[].obs;

  final _tmpFolders = <String, List<String>>{};
  final _bufferSize = 2000;


  @override
  Future onInit() async{
    _listenPathStream();
    folders.addAll(await _repo.getPaths());
    sortByName();
    super.onInit();
  }

  @override
  Future onReady() async {
    await Permission.storage.request();
    super.onReady();
  }

  void sortByName(){
    keys.replaceRange(0, keys.length, folders.keys.toList()..sort((a,b)=>a.substring(a.lastIndexOf('/')+1, a.length).compareTo(b.substring(b.lastIndexOf('/')+1, b.length))));
  }

  void find() => _repo.find();

  void _listenPathStream(){
    var buffer = 0;
    _repo.watchPaths().listen((event) {
      final folderPath = event.substring(0, event.lastIndexOf('/'));
      buffer++;
      if(_tmpFolders.containsKey(folderPath)){
        _tmpFolders[folderPath].add(event);
      } else {
        _tmpFolders[folderPath] = [event];
      }
      if(buffer>_bufferSize){
        for(final key in _tmpFolders.keys){
          if(folders.containsKey(key)){
            folders[key].addAll(_tmpFolders[key]);
          } else {
            folders[key] = _tmpFolders[key];
          }
        }
        sortByName();
        _tmpFolders.clear();
      }
    },
        onDone: () {
          for(final key in _tmpFolders.keys){
            if(folders.containsKey(key)){
              folders[key].addAll(_tmpFolders[key]);
            } else {
              folders[key] = _tmpFolders[key];
            }
          }
          sortByName();
          _tmpFolders.clear();
        }
    );
  }
}