import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/isolates/sorting_isolate.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

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

  void sort(SortTypes type){
    if(!_sortFlags[type]) {
      sortIsolate(images, type, _sortHandler);
      _switchFlag(type);
    } else {
      final reverseType = SortTypes.values[type.index+1];
      sortIsolate(images, reverseType, _sortHandler);
      _switchFlag(type);
    }
  }

  void _switchFlag(SortTypes type){
    _sortFlags.forEach((key, value) {
      if(key!=type) {
        value = false;
      } else {
        value = !value;
      }
    });
  }

  void _sortHandler(List<File> files){
    images.clear();
    images.addAll(files);
  }
}