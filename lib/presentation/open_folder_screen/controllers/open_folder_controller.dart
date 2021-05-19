import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/executor/thumbnail_creator.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/data/repository/settings.dart';
import 'package:getx_gallery/presentation/common/controller/folder_controller.dart';
import 'package:getx_gallery/resources/constants.dart';
import 'package:getx_gallery/resources/enums/sort_types.dart';

class OpenFolderScreenController extends GetxController{
  final folder = Folder.dummy().obs;
  final _executedThumbnailsPaths = <String>[];
  final gridSize = Constants.basicGridSize.obs;
  final Repository _repo = Get.find();
  final Settings _settings = Get.find();
  final FolderController fc = Get.find();

  @override
  void onInit() {
    folder.value = Get.arguments;
    fc.openFolder(folder.value);
    gridSize.value = _settings.getGridSize();
    // ignore: cast_nullable_to_non_nullable
    ever(fc.openedFolder, (_)=>folder.value= _ as Folder);
    generateThumbnails(((Get.size.height/Get.size.width*gridSize.value + 1)*gridSize.value).toInt());
    super.onInit();
  }

  void nextGridSize(){
    generateThumbnails(((Get.size.height/Get.size.width*gridSize.value + 1)*gridSize.value).toInt());
    gridSize.value = _settings.nextGridSize();
  }

  Future generateThumbnails(int pos) async {
    final wishToGenerate = pos+gridSize.value*2;
    final lastToGenerate = (wishToGenerate>folder.value.images.length)?folder.value.images.length: wishToGenerate;
    for(int i=0; i < lastToGenerate; i++) {
      if(folder.value.images[i].thumbnailPath.isEmpty){
        _generateThumbnail(folder.value.images[i].path, i);
      }
    }
  }

  Future sort(SortTypes type) async {
    final sortedFolder = await folder.value.switchStatus(type);
    folder.value = sortedFolder;
    _repo.updateFolder(sortedFolder);
  }

  Future _generateThumbnail(String path, int index) async {
    if(!_executedThumbnailsPaths.contains(path)) {
      await Future.delayed(Duration(milliseconds: 10));
      ThumbnailCreator.create(path: path, size: 360, callback: (String th) {
        print('thumb created $path');
        folder.value.addThumbnail(index, th);
        _repo.updateFolder(folder.value);
      });
      _executedThumbnailsPaths.add(path);
    }
  }
}