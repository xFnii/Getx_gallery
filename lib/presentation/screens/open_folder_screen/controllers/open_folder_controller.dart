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
    /// Получение offset скролла по текущему элементу.
    /// Обратная функция к написанным в _scrollListener
    /// max*(lastElement*max - len*v)
    /// ─────────────────────────────
    ///        len(max-view)
    final offset = scrollController.position.maxScrollExtent * (index * scrollController.position.maxScrollExtent - folder.value.images.length * scrollController.position.viewportDimension)/(folder.value.images.length * (scrollController.position.maxScrollExtent - scrollController.position.viewportDimension));
    scrollController.jumpTo(offset);
  }

  void _scrollListener(){
    print(scrollController.offset);
    /// Коррекция изменения offset скролла.
    /// При начальном положении скролла равно 0, при максимальном количеству элементов, которые поместятся на одном экране
    /// view*len*offset
    /// ───────────────
    ///     max^2
    final correction = scrollController.position.viewportDimension * folder.value.images.length * scrollController.offset/(scrollController.position.maxScrollExtent * scrollController.position.maxScrollExtent);

    /// Вычисление номер последнего элемента на экране.
    /// len*(offset+view)
    /// ───────────────     – [correction]
    ///     max
    final lastElement = folder.value.images.length*(scrollController.offset+scrollController.position.viewportDimension)/ scrollController.position.maxScrollExtent - correction;
    _generateThumbnails(lastElement.toInt());
  }
}