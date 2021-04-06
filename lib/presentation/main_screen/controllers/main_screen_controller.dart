import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();

  final showHidden = false.obs;
  final folders = <Folder>[].obs;
  final _allFolders = <Folder>[];

  @override
  Future onInit() async{
    _listenPathStream();
    _repo.getFolders();
    //_allFolders.addAll(await _repo.getFolders());
    //final visibleFolders = _allFolders.where((element) => !element.hidden).toList();
    //sortByName(list: visibleFolders);
    //folders.addAll(visibleFolders);
    super.onInit();
  }
  @override
  Future onReady() async {
    if (!await Permission.storage.request().isGranted){
      Get.snackbar('permission_declined'.tr, 'next_time_accept'.tr, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
    super.onReady();
  }

  void toggleHidden(){
    showHidden.value = !showHidden.value;
    Get.snackbar(showHidden.value? 'hidden'.tr: 'shown'.tr, showHidden.value? 'folders_are_visible'.tr: 'folders_are_invisible'.tr, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1, milliseconds: 500));
    folders.clear();
    if(showHidden.value){
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

  void sortByName({List<Folder>? list}){
    if (list == null){
      folders.sort((a,b) => C.fullPathToFile(a.name).toLowerCase().compareTo(C.fullPathToFile(b.name).toLowerCase()));
    } else {
      list.sort((a,b) => C.fullPathToFile(a.name).toLowerCase().compareTo(C.fullPathToFile(b.name).toLowerCase()));
    }
  }

  Future find() async => _repo.find();

  void _listenPathStream(){
    _repo.watchFolders().listen((event) {
      final folderPosition = _allFolders.indexWhere((element) => element.name==event.name);
      if(folderPosition!=-1){
        _allFolders.removeAt(folderPosition);
        folders.removeWhere((element) => element.name==event.name);
      }
      _allFolders.add(event);
      if(showHidden.value){
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

  String getScrollText(double offset){
    final pos = offset ~/ 100;
    if(pos == folders.length) {
      return C.fullPathToFile(folders.last.name);
    } else {
      return C.fullPathToFile(folders[pos].name);
    }
  }
}