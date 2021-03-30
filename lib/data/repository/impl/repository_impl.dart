import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_models;
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource;

  final _foldersStream = MiniStream<Folder>();
  List<Folder> _folders = [];

  RepositoryImpl({required LocalDataSource localDataSource}):
        _localDataSource=localDataSource;


  @override
  MiniStream<Folder> watchPaths() => _foldersStream;



  @override
  Future<List<Folder>> getPaths() async {
    return _folders = (await _localDataSource.getFolders()).map((e) => e.toEntities()).toList();
  }

  @override
  Future find() async {
    if(_folders.isEmpty) {
      await getPaths();
    }
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      findImageIsolate(
          rootDir: e.rootDir,
          callback: resultHandler
      );
    }
  }

  Future resultHandler(String data) async {
    final result = Folder.fromJson(jsonDecode(data));
    _foldersStream.add(result);
    _localDataSource.addFolder(db_models.Folder.fromEntity(result));
  }

  @override
  Future deleteAll() {
    return _localDataSource.deleteAll();
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
}