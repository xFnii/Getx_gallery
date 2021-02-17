import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class OpenFolderScreenController extends GetxController{
  final images = <File>[].obs;
  final Map<SortTypes, bool> _sortFlags = {SortTypes.name: false, SortTypes.date: false, SortTypes.size: false};

  @override
  void onInit() {
    for(final e in Get.arguments as List<String>){
      images.add(File(e));
    }
    super.onInit();
  }

  void shuffle(){
    images.shuffle();
  }

  void sort(SortTypes type){
    switch(type) {
      case SortTypes.date:
        if(_sortFlags[type]){
          images.sort((a,b)=> a.statSync().changed.compareTo(b.statSync().changed));
        } else {
          images.sort((b,a)=> a.statSync().changed.compareTo(b.statSync().changed));
        }
        _sortFlags[type]=!_sortFlags[type];
        break;
      case SortTypes.name:
        if(_sortFlags[type]){
          images.sort((a,b)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
        } else {
          images.sort((b,a)=> C.fullPathToFile(a.path).compareTo(C.fullPathToFile(b.path)));
        }
        _sortFlags[type]=!_sortFlags[type];
        break;
      case SortTypes.random:
        images.shuffle();
        break;
      case SortTypes.size:
        if(_sortFlags[type]){
          images.sort((a, b)=> a.statSync().size.compareTo(b.statSync().size));
        } else {
          images.sort((b, a)=> a.statSync().size.compareTo(b.statSync().size));
        }
        _sortFlags[type]=!_sortFlags[type];
        break;
    }
  }
}