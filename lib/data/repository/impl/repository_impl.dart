import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_models;
import 'package:getx_gallery/data/executor/path_provider_ex.dart';
import 'package:getx_gallery/data/isolates/actualizer_isolate.dart';
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:getx_gallery/resources/sort_images.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource;

  RepositoryImpl({required LocalDataSource localDataSource}):
        _localDataSource = localDataSource;


  @override
  Stream<Folder> watchFolders() => _localDataSource.watchFolders().map((event) => event.toEntities());

  @override
  List<Folder> getFolders() => (_localDataSource.getFolders()).map((e) => e.toEntities()).toList();

  @override
  void actualizeFolders() {
    final folders = (_localDataSource.getFolders()).map((e) => e.toEntities()).toList();
    if(folders.isNotEmpty) {
      actualizerIsolate(folders, _actualizerHandler);
    } else {
      find();
    }
  }

  void _actualizerHandler(Folder? folder) {
    if(folder == null){
      find();
      return;
    }
    if (folder.images.isEmpty) {
      _localDataSource.deleteFolder(db_models.Folder.fromEntity(folder));
    } else {
      _localDataSource.actualizeFolder(db_models.Folder.fromEntity(folder));
    }
  }

  @override
  Future find() async {
    final storageInfo = await PathProviderEx.getStorageInfo();
    for(final e in storageInfo){
      findImageIsolate(
          rootDir: e.rootDir,
          callback: _findHandler
      );
    }
  }

  void _findHandler(String jsonFolder) {
    final newFolder = Folder.fromJson(jsonDecode(jsonFolder));
    final oldFolder = _localDataSource.getFolder(newFolder.path.hashCode);
    if(oldFolder.path.isEmpty) {
      _localDataSource.addFolder(db_models.Folder.fromEntity(newFolder));
    } else {
      if(!const ListEquality().equals(newFolder.images, oldFolder.images)) {
        final sortedImages = SortImages.sort(images: newFolder.images.toList(), type: oldFolder.sortType);
        _localDataSource.addFolder(db_models.Folder.fromEntity(newFolder.copyWith(sortType: oldFolder.sortType, images: sortedImages)));
      }
    }
  }

  @override
  void deleteAll() {
    return _localDataSource.deleteAll();
  }

  @override
  void updateFolder(Folder folder){
    _localDataSource.updateFolder(db_models.Folder.fromEntity(folder));
  }

}