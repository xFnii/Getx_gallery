import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();

  var _showHidden = false;
  final folders = <Folder>[].obs;
  final _allOrders = <Folder>[];

  @override
  Future onInit() async{
    _allOrders.addAll(await _repo.getPaths());
    folders.addAll(_allOrders.where((element) => !element.hidden).toList());
    _listenPathStream();
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

  void toggleHidden(){
    _showHidden = !_showHidden;
    folders.clear();
    if(_showHidden){
      folders.addAll(_allOrders);
    } else {
      folders.addAll(_allOrders.where((element) => !element.hidden).toList());
    }
    sortByName();
  }

  void deleteAll(){
    folders.clear();
    _allOrders.clear();
    _repo.deleteAll();
  }

  void sortByName(){
    folders.sort((a,b) => C.fullPathToFile(a.name).toLowerCase().compareTo(C.fullPathToFile(b.name).toLowerCase()));
  }

  Future find() async => _repo.find();

  void _listenPathStream(){
    _repo.watchPaths().listen((event) {
      _allOrders.clear();
      _allOrders.addAll(event);
      folders.clear();
      if(_showHidden){
        folders.addAll(_allOrders);
      } else {
        folders.addAll(_allOrders.where((element) => !element.hidden).toList());
      }
      sortByName();
    },
        onDone: () {
          sortByName();
        }
    );
  }
}