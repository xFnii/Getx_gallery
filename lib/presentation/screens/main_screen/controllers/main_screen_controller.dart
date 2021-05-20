import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/executor/thumbnail_creator.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/data/repository/settings.dart';
import 'package:getx_gallery/presentation/common/controller/folder_controller.dart';
import 'package:getx_gallery/resources/constants.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreenController extends GetxController{


  final Repository _repo = Get.find();

  final gridSize = Constants.basicFolderGridSize.obs;
  final showHidden = false.obs;
  final folders = <Folder>[].obs;
  final _executedThumbnailsPaths = <String>[];
  final Settings _settings = Get.find();
  final FolderController folderController = Get.find();
  final ScrollController scrollController = ScrollController();


  @override
  Future onInit() async{
    ever(folderController.folders, (_)=> _listenFolders());
    super.onInit();
  }
  @override
  Future onReady() async {
    if (!await Permission.storage.request().isGranted){
      Get.snackbar('permission_declined'.tr, 'next_time_accept'.tr, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } else {
      _repo.getFolders();
    }
    super.onReady();
  }

  void _listenFolders(){
    if(showHidden.value){
      folders.value = folderController.folders;
    } else {
      folders.value = folderController.visibleFolders;
    }
  }

  void toggleHidden(){
    showHidden.value = !showHidden.value;
    Get.snackbar(showHidden.value? 'hidden'.tr: 'shown'.tr, showHidden.value? 'folders_are_visible'.tr: 'folders_are_invisible'.tr, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1, milliseconds: 500));
    if(showHidden.value){
      folders.value = folderController.folders;
    } else {
      folders.value = folderController.visibleFolders;
    }
  }

  void deleteAll(){
    folders.clear();
    folderController.clear();
    _executedThumbnailsPaths.clear();
    _repo.deleteAll();
  }

  String getThumbnail(int index) {
    final folder = folders[index];
    final image = folder.images[0];
    if(image.thumbnailPath.isEmpty && !_executedThumbnailsPaths.contains(image.path)){
      _generateThumbnail(folder);
      _executedThumbnailsPaths.add(image.path);
      return '';
    } else {
      return image.thumbnailPath;
    }
  }

  Future _generateThumbnail(Folder folder) async {
    ThumbnailCreator.create(path: folder.images[0].path, size: 540, callback: (String th){
      print('thumb created ${folder.path}');
      folder.addThumbnail(0, th);
      _repo.updateFolder(folder);
    });
  }

  Future find() async => _repo.find();

  String getScrollText(double offset){
    final pos = offset ~/ (Get.width/gridSize.value)*gridSize.value;
    if(pos == folders.length) {
      return C.fullPathToFile(folders.last.path);
    } else {
      return C.fullPathToFile(folders[pos].path);
    }
  }

  void nextGridSize(){
    gridSize.value = _settings.nextFolderGridSize();
  }
}