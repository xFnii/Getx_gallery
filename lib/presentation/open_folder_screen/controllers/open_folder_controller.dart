import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/entities/image.dart';
import 'package:getx_gallery/data/isolates/create_thumbnail_isolate.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/presentation/common/controller/folder_controller.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

class OpenFolderScreenController extends GetxController{
  final folder = Folder.dummy().obs;
  final Repository _repo = Get.find();
  final _executedThumbnailsPaths = <String>[];
  final FolderController fc = Get.find();

  @override
  void onInit() {
    folder.value = Get.arguments;
    fc.openFolder(folder.value);
    ever(fc.openedFolder, (_)=> _listenFolder());
    super.onInit();
  }

  void _listenFolder(){
    folder.value = fc.openedFolder.value;
  }

  Future sort(SortTypes type) async {
    final sortedFolder = await folder.value.switchStatus(type);
    folder.value = sortedFolder;
    _repo.updateFolder(sortedFolder);
  }

  Uint8List getThumbnail(int index) {
    final image = folder.value.images[index];
    if(image.thumbnail.isEmpty && !_executedThumbnailsPaths.contains(image.path)){
      _generateThumbnail(image, index);
      _executedThumbnailsPaths.add(image.path);
      return Uint8List(0);
    } else {
      return image.thumbnail;
    }
  }
  //
  Future _generateThumbnail(Image image, int index) async {
    compute(decodeIsolate, {'file':File(image.path), 'width': 360}).then((value) {
      print('thumb created ' + image.path);
      folder.value.addThumbnail(index, value);
      _repo.updateFolder(folder.value);
    });
  }
}