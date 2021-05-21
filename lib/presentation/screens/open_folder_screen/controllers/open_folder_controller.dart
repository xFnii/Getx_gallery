import 'package:flutter/cupertino.dart';
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
  final gridSize = Constants.basicImageGridSize.obs;
  final Repository _repo = Get.find();
  final Settings _settings = Get.find();
  final FolderController folderController = Get.find();
  final ScrollController scrollController = ScrollController();

  int get _lastVisibleImageIndex => ((Get.size.height/Get.size.width*gridSize.value + 1)*gridSize.value).toInt();

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    folder.value = Get.arguments;
    folderController.openFolder(folder.value);
    gridSize.value = _settings.getImageGridSize();
    // ignore: cast_nullable_to_non_nullable
    ever(folderController.openedFolder, (_)=>folder.value= _ as Folder);
    _generateThumbnails(_lastVisibleImageIndex);
    super.onInit();
  }

  void nextGridSize(){
    _generateThumbnails(_lastVisibleImageIndex);
    gridSize.value = _settings.nextImageGridSize();
  }

  void setGridSize(int? size){
    if(size==null) return;
    _generateThumbnails(_lastVisibleImageIndex);
    gridSize.value = size;
    _settings.setImageGridSize(size);
  }

  void _generateThumbnails(int pos) {
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
    _generateThumbnails(_lastVisibleImageIndex);
  }

  void _generateThumbnail(String path, int index) {
    if(!_executedThumbnailsPaths.contains(path)) {
      ThumbnailCreator.create(path: path, size: 360, callback: (String th) {
        print('thumb created $path');
        folder.value.addThumbnail(index, th);
        _repo.updateFolder(folder.value);
      });
      _executedThumbnailsPaths.add(path);
    }
  }

  void scrollTo(int index){
    /// Get scroll offset by current element.
    final row = index ~/ gridSize.value;
    final offset = (Get.width/gridSize.value) * (row + 1) - scrollController.position.viewportDimension;
    if(offset>scrollController.offset) {
      scrollController.jumpTo(offset);
    }
  }

  void _scrollListener(){
    /// Correction of scroll offset change
    /// On initial scroll position equal 0, on last - maximum number of elements, that fit on one screen
    /// view*len*offset
    /// ───────────────
    ///     max^2
    final correction = scrollController.position.viewportDimension * folder.value.images.length * scrollController.offset/(scrollController.position.maxScrollExtent * scrollController.position.maxScrollExtent);

    /// Count last element on screen
    /// len*(offset+view)
    /// ───────────────     – [correction]
    ///     max
    final lastElement = folder.value.images.length*(scrollController.offset+scrollController.position.viewportDimension)/ scrollController.position.maxScrollExtent - correction;
    _generateThumbnails(lastElement.toInt());
  }
}