import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'file:///C:/Applications/android-projects/getx_gallery/lib/utils/buffers/buffer.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource = Get.find<LocalDataSource>();

  final pathStream = MiniStream<List<String>>();
  List<String> _paths = [];


  @override
  MiniStream<List<String>> watchPaths() => pathStream;



  @override
  Future<Map<String, List<String>>> getPaths() async {
    _paths = await _localDataSource.getPaths();
    final Map<String, List<String>> folders = {};
    for(final e in _paths){
      final folderPath = e.substring(0, e.lastIndexOf('/'));
      if(folders.containsKey(folderPath)){
        folders[folderPath].add(e);
      } else {
        folders[folderPath] = [e];
      }
    }
    return folders;
  }

  @override
  Future find() async {
    if(_paths.isEmpty) {
      _paths = await _localDataSource.getPaths();
    }
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      findImageIsolate(_paths, e.rootDir, (data) {
        _paths.addAll(data);
        pathStream.add(data);
        addPaths(data);
      });
    }
  }

  @override
  // ignore: missing_return
  Future addPaths(List<String> paths) {
    if(paths.isNotEmpty) {
      return _localDataSource.addPaths(paths);
    }
  }
}