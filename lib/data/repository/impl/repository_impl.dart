import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_models;
import 'package:getx_gallery/data/isolates/actualizer_isolate.dart';
import 'package:getx_gallery/data/isolates/create_thumbnail_isolate.dart';
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
import 'package:getx_gallery/data/isolates/sorting_isolate_vanila.dart';
import 'package:getx_gallery/data/repository/local_datasource.dart';
import 'package:getx_gallery/data/repository/repository.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class RepositoryImpl implements Repository{
  final LocalDataSource _localDataSource;

  RepositoryImpl({required LocalDataSource localDataSource}):
        _localDataSource = localDataSource;


  @override
  Stream<Folder> watchFolders() => _localDataSource.watchFolders().map((event) => event.toEntities());

  @override
  Future getFolders() async {
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

  Future _findHandler(String jsonFolder) async {
    final newFolder = Folder.fromJson(jsonDecode(jsonFolder));
    final oldFolder = _localDataSource.getFolder(newFolder.path.hashCode);
    if(oldFolder.path.isEmpty) {
      _localDataSource.addFolder(db_models.Folder.fromEntity(newFolder));
    } else {
      if(!ListEquality().equals(newFolder.images, oldFolder.images)) {
        compute(sortIsolate, {'images': newFolder.images.toList(), 'type': oldFolder.sortType.index}).then((value) async {
          if(value[0].thumbnail.isEmpty != null){
            print('thumb created ' + value[0].path);
            compute(decodeIsolate, {'file': File(value[0].path), 'width': 540}).then((value) => value[0].thumbnail = value);
          }
          _localDataSource.addFolder(db_models.Folder.fromEntity(newFolder.copyWith(sortType: oldFolder.sortType, images: value)));
        });
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