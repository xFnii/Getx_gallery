import 'dart:convert';
import 'dart:io';

import 'package:getx_gallery/data/entities/folder.dart';
import 'package:getx_gallery/data/databases/models/db_models.dart' as db_models;
import 'package:getx_gallery/data/isolates/actualizer_isolate.dart';
import 'package:getx_gallery/data/isolates/find_images_isolate.dart';
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
    folders.where((element) => element.name.contains('download'));
    await actualizerIsolate(folders, _actualizerHandler).then((value) => find());

  }

  Future _actualizerHandler(List<String> jsonFolder) async{
    final folders = jsonFolder.map((e) => Folder.fromJson(jsonDecode(e))).toList();
    for(final folder in folders) {
      if (folder.paths.isEmpty) {
        _localDataSource.deleteFolder(db_models.Folder.fromEntity(folder));
      } else {
        _localDataSource.actualizeFolder(db_models.Folder.fromEntity(folder));
      }
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
    final result = Folder.fromJson(jsonDecode(jsonFolder));
    _localDataSource.addFolder(db_models.Folder.fromEntity(result));
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