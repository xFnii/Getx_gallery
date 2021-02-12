import 'package:get/get.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();
  final paths = <String>[].obs;

  final folders = <String, List<String>>{}.obs;

  final keys = <String>[].obs;


  @override
  Future onInit() async{
    _listenPathStream();
    folders.addAll(await _repo.getPaths());
    sortByName();
    super.onInit();
  }

  @override
  Future onReady() async {
    if (await Permission.storage.request().isGranted){
      find();
    }
    super.onReady();
  }

  void sortByName(){
    keys.replaceRange(0, keys.length, folders.keys.toList()..sort((a,b)=>a.substring(a.lastIndexOf('/')+1, a.length).toLowerCase().compareTo(b.substring(b.lastIndexOf('/')+1, b.length).toLowerCase())));
  }

  void find() async => _repo.find();

  void _listenPathStream(){
    _repo.watchPaths().listen((event) {
      for(final e in event){
        final folderPath = e.substring(0, e.lastIndexOf('/'));
        if(folders.containsKey(folderPath)){
          folders[folderPath].add(e);
        } else {
          folders[folderPath] = [e];
        }
      }
      sortByName();
    },
        onDone: () {
          sortByName();
        }
    );
  }
}