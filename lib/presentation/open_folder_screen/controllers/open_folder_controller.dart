import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class OpenFolderScreenController extends GetxController{
  final images = <File>[].obs;
  bool _dateSortFlag = false;

  void shuffle(){
    images.shuffle();
  }

  void sort(SortTypes type){
    switch(type) {
      case SortTypes.date:
        if(_dateSortFlag){
          images.sort((a,b)=> a.statSync().changed.compareTo(b.statSync().changed));
        } else {
          images.sort((b,a)=> a.statSync().changed.compareTo(b.statSync().changed));
        }
        _dateSortFlag=!_dateSortFlag;
        break;
      case SortTypes.name:
        images.sort((a,b)=> a.path.substring(a.path.lastIndexOf('/'), a.path.length).compareTo(b.path.substring(b.path.lastIndexOf('/'), b.path.length)));
        break;
      case SortTypes.random:
        images.shuffle();
        break;
    }
  }

  void convertStringsToFiles(List<String> list){
    for(final e in list){
      images.add(File(e));
    }
  }
}