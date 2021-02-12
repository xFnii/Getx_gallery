import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'file:///C:/Applications/android-projects/getx_gallery/lib/utils/buffers/buffer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource = Get.find<LocalDataSource>();

  final pathStream = MiniStream<String>();
  List<String> _paths = [];


  @override
  MiniStream<String> watchPaths() => pathStream;



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
    final buffer = Buffer(size: 2000, data: <String>[], onOverflow: (data) => addPaths(data as List<String>));
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      Directory(e.rootDir).list(recursive: true, followLinks: false).listen((event) {
        if(event.path.contains(RegExp(r'\.(gif|jpe?g|tiff?|png|webp|bmp)$'))){
          if(!_paths.contains(event.path)) {
            _paths.add(event.path);
            pathStream.add(event.path);
            buffer.add(event.path);
          }
        }
      },
          onDone: () {
        addPaths(buffer.data as List<String>);
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