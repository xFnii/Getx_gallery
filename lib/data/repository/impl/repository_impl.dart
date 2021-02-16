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

  final foldersStream = MiniStream<List<Folder>>();
  List<Folder> _folders = [];


  @override
  MiniStream<List<Folder>> watchPaths() => foldersStream;



  @override
  Future<List<Folder>> getPaths() async {
    final folders = await _localDataSource.getFolders();
    final paths = await _localDataSource.getPaths();
    return _folders = [
      for(final e in folders)
        Folder(name: e.path, paths: paths.where((element) => C.fullPathToFolder(element.path)==e.path).toList(), hidden: e.hidden)
    ];
  }

  @override
  Future find() async {
    if(_folders.isEmpty) {
      await getPaths();
    }
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      findImageIsolate([
        for(final e in _folders) ...e.paths
      ],
          e.rootDir,
              (data) {
        if(data is List) {
          addPathsHandle(data);
        } else if(data is String) {
          hiddenPathHandler(data);
        }
      });
    }
  }

  void hiddenPathHandler(String data){
  }

  void addPathsHandle(List<String> data){
    _addNewFolders(data);
    pathStream.add(data);
    addPaths(data);
  }

  void _addNewFolders(List<String> newPaths){
    final List<Folder> cache = [];
    outerLoop:
    for(final e in newPaths) {
      for (final sE in cache) {
        if (sE.name == C.fullPathToFolder(e)) {
          sE.add(e);
          continue outerLoop;
        }
      }
      final folder = _folders.firstWhere((element) => element.name == C.fullPathToFolder(e), orElse: () => null);
      if (folder != null) {
        cache.add(folder);
        folder.add(e);
      }
    }
  }

  @override
  // ignore: missing_return
  Future addPaths(paths) {
    if(paths is List){
      if(paths.isNotEmpty) {
        return _localDataSource.addPaths(paths);
      }
    } else {
      return _localDataSource.addHiddenPath(paths);
    }
  }
}