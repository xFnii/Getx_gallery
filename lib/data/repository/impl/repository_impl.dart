import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/converter.dart';
import 'file:///C:/Applications/android-projects/getx_gallery/lib/utils/buffers/buffer.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource = Get.find<LocalDataSource>();

  final _foldersStream = MiniStream<List<Folder>>();
  List<Folder> _folders = [];


  @override
  MiniStream<List<Folder>> watchPaths() => _foldersStream;



  @override
  Future<List<Folder>> getPaths() async {
    final folders = await _localDataSource.getFolders();
    final hiddenFolders = folders.where((element) => element.hide).toList();
    final paths = await _localDataSource.getPaths();
    return _folders = [
      for(final e in folders)
        Folder(name: e.path, paths: paths.where((element) => C.fullPathToFolder(element)==e.path).toList(), hidden: e.hide || hiddenFolders.indexWhere((element) => e.path.contains(element.path))!=-1)
    ];
  }

  @override
  Future find() async {
    if(_folders.isEmpty) {
      await getPaths();
    }
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      findImageIsolate(
          [for(final e in _folders) ...e.paths],
          _folders.where((element) => element.hidden).map((e) => e.name).toList(),
          e.rootDir,
          (data) => findHandler(data)
      );
    }
  }

  @override
  Future findHandler(Map<String, List<String>> data) async {
    addPaths(data['paths']);
    addHiddenFolders(data['folders']);
    await getPaths();
    _foldersStream.add(_folders);
  }


  // Future _addHiddenFolder(String path) async {
  //   final idx = _folders.indexWhere((element) => element.name==path);
  //   if(idx!=-1){
  //     _folders[idx] = _folders[idx].copyWith(hidden: true);
  //   } else {
  //     _folders.add(Folder(name: C.fullPathToFolder(path), paths: [], hidden: true));
  //
  //   }
  // }
  //
  // Future _addNewFolders(List<String> newPaths) async{
  //   final List<Folder> cache = [];
  //   outerLoop:
  //   for(final e in newPaths) {
  //     final fullPathToFolder = C.fullPathToFolder(e);
  //     ///Проверяем, есть ли ранее путь в ранее обработанных папках
  //     for (final sE in cache) {
  //       if (sE.name == fullPathToFolder) {
  //         sE.add(e);
  //         continue outerLoop;
  //       }
  //     }
  //     ///Если нет, то добавлем нужную папку в кеш
  //     final folder = _folders.firstWhere((element) => element.name == fullPathToFolder, orElse: () => null);
  //     if (folder != null) {
  //       cache.add(folder);
  //       folder.add(e);
  //     } else {
  //       final newFolder = Folder(name: fullPathToFolder, paths: [e], hidden: false);
  //       cache.add(newFolder);
  //       _folders.add(newFolder);
  //     }
  //   }
  //   _foldersStream.add(_folders);
  // }

  @override
  // ignore: missing_return
  Future addHiddenFolders(List<String> paths) {
    return _localDataSource.addHiddenFolders(paths);
  }

  @override
  // ignore: missing_return
  Future addPaths(List<String> paths) {
    return _localDataSource.addPaths(paths);
  }

  @override
  Future deleteAll() {
    return _localDataSource.deleteAll();
  }
}